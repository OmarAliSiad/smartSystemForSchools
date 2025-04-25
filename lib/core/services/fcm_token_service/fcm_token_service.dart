import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static const String username = 'username';
}

class FCMTokenService {
  // Singleton instance
  static final FCMTokenService _instance = FCMTokenService._internal();
  factory FCMTokenService() => _instance;
  FCMTokenService._internal();

  // Firebase instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Collection reference
  final CollectionReference _parentsCollection =
      FirebaseFirestore.instance.collection('parents');

  // Save token to Firestore
  Future<void> saveToken() async {
    try {
      // Get current token
      String? token = await _messaging.getToken();

      if (token == null) {
        log('Failed to get FCM token');
        return;
      }

      // Get parent username from SharedPreferences
      final sharedPreferences = await SharedPreferences.getInstance();
      String? username = sharedPreferences.getString(Constants.username);

      if (username == null) {
        log('Failed to get username from SharedPreferences');
        return;
      }

      log('Saving token for parent: $username');

      // Reference to the parent's document
      final parentDoc = _parentsCollection.doc(username);

      // Check if parent document exists
      final parentSnapshot = await parentDoc.get();

      if (!parentSnapshot.exists) {
        // Create parent document if it doesn't exist
        await parentDoc.set({
          'username': username,
          'createdAt': FieldValue.serverTimestamp(),
          'lastActive': FieldValue.serverTimestamp(),
        });
      }

      // Reference to tokens subcollection for this parent
      final tokensCollection = parentDoc.collection('fcm_tokens');

      // Check if this token already exists for this parent
      final tokenQuerySnapshot = await tokensCollection
          .where('token', isEqualTo: token)
          .limit(1)
          .get();

      if (tokenQuerySnapshot.docs.isEmpty) {
        // Token doesn't exist for this parent, add it
        await tokensCollection.add({
          'token': token,
          'createdAt': FieldValue.serverTimestamp(),
          'lastActive': FieldValue.serverTimestamp(),
          'isValid': true,
          'deviceInfo': {
            // Optional: You could add device info here
            // 'platform': Platform.operatingSystem,
            // 'deviceModel': deviceInfo.model,
          }
        });

        log('New FCM Token saved for parent $username: $token');
      } else {
        // Token exists, just update lastActive
        final tokenDoc = tokenQuerySnapshot.docs.first;
        await tokenDoc.reference.update(
            {'lastActive': FieldValue.serverTimestamp(), 'isValid': true});

        log('Existing FCM Token updated for parent $username: $token');
      }

      // Save locally
      await sharedPreferences.setString('fcm_token', token);

      // Set up token refresh listener
      // _setupTokenRefreshListener();

      // Log all valid tokens for debugging
      List<String> tokens = await getAllValidTokensForParent(username);
      log('Found ${tokens.length} valid FCM tokens for parent $username');
    } catch (e) {
      log('Error saving FCM token: $e');
    }
  }

  // Set up token refresh listener
  void _setupTokenRefreshListener() {
    _messaging.onTokenRefresh.listen((String newToken) async {
      log('FCM Token refreshed: $newToken');

      // Get parent username and old token
      final prefs = await SharedPreferences.getInstance();
      final oldToken = prefs.getString('fcm_token');
      final username = prefs.getString(Constants.username);

      if (username == null) {
        log('No username found in SharedPreferences for token refresh');
        return;
      }

      log('Token refresh for parent: $username');

      // Mark old token as invalid if it exists
      if (oldToken != null && oldToken != newToken) {
        await invalidateToken(username, oldToken, newToken);
      }

      // Save the new token
      await saveToken();
    });
  }

  // Invalidate a specific token
  Future<void> invalidateToken(String username, String token,
      [String? replacedBy]) async {
    try {
      final parentDoc = _parentsCollection.doc(username);
      final tokensCollection = parentDoc.collection('fcm_tokens');

      // Find the token document
      final snapshot = await tokensCollection
          .where('token', isEqualTo: token)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final tokenDoc = snapshot.docs.first;
        final updateData = {
          'isValid': false,
          'invalidatedAt': FieldValue.serverTimestamp(),
          'invalidationReason': 'Token refreshed'
        };

        if (replacedBy != null) {
          updateData['replacedBy'] = replacedBy;
          updateData['replacedAt'] = FieldValue.serverTimestamp();
        }

        await tokenDoc.reference.update(updateData);
        log('Token invalidated for parent $username: $token');
      }
    } catch (e) {
      log('Error invalidating token: $e');
    }
  }

  // Get all valid tokens for a specific parent
  Future<List<String>> getAllValidTokensForParent(String username) async {
    try {
      final parentDoc = _parentsCollection.doc(username);
      final tokensCollection = parentDoc.collection('fcm_tokens');

      final snapshot =
          await tokensCollection.where('isValid', isEqualTo: true).get();

      List<String> tokens = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        tokens.add(data['token']);
      }

      log('Found ${tokens.length} valid tokens for parent $username');
      return tokens;
    } catch (e) {
      log('Error getting valid tokens for parent: $e');
      return [];
    }
  }

  // Get all valid tokens across all parents (for admin operations)
  Future<Map<String, List<String>>> getAllValidTokens() async {
    try {
      final Map<String, List<String>> allTokens = {};

      final parentsSnapshot = await _parentsCollection.get();

      for (var parentDoc in parentsSnapshot.docs) {
        final parentUsername = parentDoc.id;
        final tokensCollection = parentDoc.reference.collection('fcm_tokens');

        final tokensSnapshot =
            await tokensCollection.where('isValid', isEqualTo: true).get();

        List<String> parentTokens = [];
        for (var tokenDoc in tokensSnapshot.docs) {
          final data = tokenDoc.data();
          parentTokens.add(data['token']);
        }

        if (parentTokens.isNotEmpty) {
          allTokens[parentUsername] = parentTokens;
        }
      }

      int totalTokens = 0;
      allTokens.forEach((_, tokens) => totalTokens += tokens.length);
      log('Found $totalTokens valid tokens across ${allTokens.length} parents');

      return allTokens;
    } catch (e) {
      log('Error getting all valid tokens: $e');
      return {};
    }
  }

  // Mark token as invalid for a specific parent
  Future<void> markTokenAsInvalid(String username, String token) async {
    try {
      await invalidateToken(username, token);
      log('Token marked as invalid for parent $username: $token');
    } catch (e) {
      log('Error marking token as invalid: $e');
    }
  }

  // Update last active timestamp for a parent and their token
  Future<void> updateTokenLastActive(String username, String token) async {
    try {
      final parentDoc = _parentsCollection.doc(username);

      // Update parent's lastActive
      await parentDoc.update({'lastActive': FieldValue.serverTimestamp()});

      // Find and update token's lastActive
      final tokensCollection = parentDoc.collection('fcm_tokens');
      final snapshot = await tokensCollection
          .where('token', isEqualTo: token)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference
            .update({'lastActive': FieldValue.serverTimestamp()});
      }

      log('Updated lastActive for parent $username and token');
    } catch (e) {
      log('Error updating token last active: $e');
    }
  }

  // Clean up invalid tokens (call this periodically, e.g., once a day)
  Future<void> cleanupInvalidTokens() async {
    try {
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      final parentsSnapshot = await _parentsCollection.get();

      int totalTokensDeleted = 0;

      for (var parentDoc in parentsSnapshot.docs) {
        final tokensCollection = parentDoc.reference.collection('fcm_tokens');

        final snapshot = await tokensCollection
            .where('isValid', isEqualTo: false)
            .where('invalidatedAt',
                isLessThan: Timestamp.fromDate(thirtyDaysAgo))
            .get();

        // Delete invalid tokens
        WriteBatch batch = _firestore.batch();
        for (var doc in snapshot.docs) {
          batch.delete(doc.reference);
        }

        if (snapshot.docs.isNotEmpty) {
          await batch.commit();
          totalTokensDeleted += snapshot.docs.length;
        }
      }

      log('Cleaned up $totalTokensDeleted invalid tokens');
    } catch (e) {
      log('Error cleaning up invalid tokens: $e');
    }
  }
}

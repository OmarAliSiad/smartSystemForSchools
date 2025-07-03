import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'connectivity_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity connectivity;
  StreamSubscription? connectivityStreamSubscription;

  InternetCubit({required this.connectivity}) : super(InternetLoading()) {
    // Initialize with try-catch for production mode safety
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    try {
      // Check the initial connectivity state when the cubit is created
      await checkInternetConnection();

      // Set up the stream subscription to monitor changes
      connectivityStreamSubscription =
          connectivity.onConnectivityChanged.listen(
        (connectivityResult) {
          _handleConnectivityChange(connectivityResult);
        },
        onError: (error) {
          debugPrint('Connectivity stream error: $error');
          emit(InternetDisconnected());
        },
      );
    } catch (e) {
      debugPrint('Error initializing connectivity: $e');
      emit(InternetDisconnected());
    }
  }

  void _handleConnectivityChange(ConnectivityResult connectivityResult) {
    try {
      if (connectivityResult == ConnectivityResult.wifi) {
        emitInternetConnected(ConnectionType.wifi);
      } else if (connectivityResult == ConnectivityResult.mobile) {
        emitInternetConnected(ConnectionType.mobile);
      } else if (connectivityResult == ConnectivityResult.none) {
        emitInternetDisconnected();
      } else {
        // Handle other connectivity types
        emitInternetConnected(ConnectionType.other);
      }
    } catch (e) {
      debugPrint('Error handling connectivity change: $e');
      emit(InternetDisconnected());
    }
  }

  Future<void> checkInternetConnection() async {
    try {
      var connectivityResult = await connectivity.checkConnectivity();
      _handleConnectivityChange(connectivityResult);
    } catch (e) {
      debugPrint('Error checking internet connection: $e');
      emit(InternetDisconnected());
    }
  }

  void emitInternetConnected(ConnectionType connectionType) =>
      emit(InternetConnected(connectionType: connectionType));

  void emitInternetDisconnected() => emit(InternetDisconnected());

  @override
  Future<void> close() {
    connectivityStreamSubscription?.cancel();
    return super.close();
  }
}

import 'package:flutter/material.dart';
import 'package:smartsystemforschools/core/utils/app_styles.dart';
import 'package:smartsystemforschools/core/utils/assets.dart';
import 'package:easy_localization/easy_localization.dart';

class ModernErrorScreen extends StatefulWidget {
  final FlutterErrorDetails errorDetails;
  final String? customTitle;
  final String? customMessage;
  final VoidCallback? onRetry;
  final VoidCallback? onGoHome;
  final bool showDebugInfo;

  const ModernErrorScreen({
    super.key,
    required this.errorDetails,
    this.customTitle,
    this.customMessage,
    this.onRetry,
    this.onGoHome,
    this.showDebugInfo = false,
  });

  @override
  State<ModernErrorScreen> createState() => _ModernErrorScreenState();
}

class _ModernErrorScreenState extends State<ModernErrorScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _fadeController.forward();
    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  String _getErrorTitle() {
    if (widget.customTitle != null) return widget.customTitle!;

    final exception = widget.errorDetails.exception;
    if (exception is FlutterError) {
      return "App Error Occurred";
    } else if (exception is NetworkException) {
      return "Connection Problem";
    } else if (exception is FormatException) {
      return "Data Format Error";
    } else if (exception is TimeoutException) {
      return "Request Timeout";
    } else {
      return "Something Went Wrong";
    }
  }

  String _getErrorMessage() {
    if (widget.customMessage != null) return widget.customMessage!;

    final exception = widget.errorDetails.exception;
    if (exception is FlutterError) {
      return "We encountered an unexpected error. Don't worry, our team has been notified and we're working on a fix.";
    } else if (exception is NetworkException) {
      return "We're having trouble connecting to our servers. Please check your internet connection and try again.";
    } else if (exception is FormatException) {
      return "We received some unexpected data. Please try refreshing or contact support if this continues.";
    } else if (exception is TimeoutException) {
      return "The request is taking longer than expected. Please try again or check your connection.";
    } else {
      return "Don't worry, it happens to the best of us. Let's get you back on track!";
    }
  }

  String _getErrorCode() {
    final exception = widget.errorDetails.exception;
    final library = widget.errorDetails.library ?? 'flutter';
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    return '$library-${exception.runtimeType.toString().toLowerCase()}-$timestamp';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme.copyWith(
      primary: Colors.blue.shade700,
      secondary: Colors.blue.shade800,
      tertiary: Colors.blue.shade900,
    );

    return KeyedSubtree(
      key: ValueKey(context.locale.toString()),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
                colorScheme.primary.withOpacity(0.8),
                colorScheme.secondary.withOpacity(0.6),
                colorScheme.tertiary.withOpacity(0.4),
              ],
            ),
          ),
          child: SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Image Container with Glassmorphism
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.2),
                                    Colors.white.withOpacity(0.1),
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.asset(
                                  Assets.imagesShy,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            colorScheme.primary,
                                            colorScheme.secondary,
                                          ],
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.sentiment_dissatisfied,
                                        size: 80,
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 40),

                      // Glass Card Container
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.25),
                              Colors.white.withOpacity(0.15),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Title
                            Text(
                              _getErrorTitle(),
                              style: AppStyles.styleMedium20().copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 16),

                            // Message
                            Text(
                              _getErrorMessage(),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            // Debug Info (only in debug mode or when enabled)
                            if (widget.showDebugInfo ||
                                (widget.errorDetails.context != null)) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.black.withOpacity(0.2),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Debug Information:',
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.white.withOpacity(0.8),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.errorDetails.exception.toString(),
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            const SizedBox(height: 32),

                            // Action Buttons
                            Column(
                              children: [
                                // Retry Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton.icon(
                                    onPressed: widget.onRetry ??
                                        () {
                                          Navigator.of(context).pop();
                                        },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: colorScheme.primary,
                                      elevation: 8,
                                      shadowColor:
                                          Colors.black.withOpacity(0.3),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    icon: const Icon(Icons.refresh_rounded),
                                    label: const Text(
                                      'Try Again',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Home Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: OutlinedButton.icon(
                                    onPressed: widget.onGoHome ??
                                        () {
                                          Navigator.of(context).pop();
                                        },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side: BorderSide(
                                        color: Colors.white.withOpacity(0.5),
                                        width: 1.5,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    icon: const Icon(Icons.home_rounded),
                                    label: const Text(
                                      'Go Home',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Bottom Info
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.1),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: Colors.white.withOpacity(0.8),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Error Code: ${_getErrorCode()}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withOpacity(0.8),
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Exception Classes for better error handling
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => 'TimeoutException: $message';
}

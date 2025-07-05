import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/generated/locale_keys.g.dart';
import '../../methods/show_scaffold_messanger.dart';
import '../../utils/app_styles.dart';
import 'notification_service.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';

class ConfirmationRequestScreen extends StatefulWidget {
  static String id = 'confirmation_request';

  const ConfirmationRequestScreen({super.key});

  @override
  State<ConfirmationRequestScreen> createState() =>
      _ConfirmationRequestScreenState();
}

class _ConfirmationRequestScreenState extends State<ConfirmationRequestScreen> {
  late Timer _timeoutTimer;
  late Timer _countdownTimer;
  int _remainingSeconds = 120;
  late StreamSubscription _statusSubscription;

  // Added properties to store arguments
  late String pendingTransactionId;
  late String studentId;
  late String studentName;
  late String amountOfMoney;
  late List<dynamic> products;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Extract arguments from route with null safety
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      pendingTransactionId = args['pendingTransactionId'] ?? '';
      studentId = args['studentId'] ?? '';
      studentName = args['studentName'] ?? '';
      amountOfMoney = args['amountOfMoney'] ?? '';
      products = args['products'] ?? [];
    } else {
      // Show error message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        dispalySnackBar(context,
            title: 'Required arguments not provided', color: Colors.red);
      });
      Navigator.of(context).pop();
    }
  }

  @override
  initState() {
    super.initState();
    _timeoutTimer = Timer.periodic(const Duration(seconds: 120), (timer) {
      Navigator.pop(context, false);
    });
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _countdownTimer.cancel();
        _respondToRequest(context, 'denied');
      }
    });
  }

  @override
  void dispose() {
    _timeoutTimer.cancel();
    _statusSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: ValueKey(context.locale.toString()),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            LocaleKeys.fireBaseConfirmationAndNotification_PurchaseConfirmation
                .tr(),
            style: AppStyles.styleBold20(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTimerDisplay(
                  context,
                  context.read<ThemeModeCubit>().currentTheme == ThemeMode.dark,
                ),
                const SizedBox(height: 16),
                _buildConfirmationHeader(context),
                const SizedBox(height: 24),
                Text(
                  LocaleKeys
                      .fireBaseConfirmationAndNotification_ProductsToPurchase
                      .tr(),
                  style: AppStyles.styleBold20(),
                ),
                const SizedBox(height: 16),
                ...products
                    .map((product) => _buildProductCard(context, product)),
                const SizedBox(height: 32),
                _buildTotalAmount(context),
                const SizedBox(height: 32),
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmationHeader(BuildContext context) {
    return Card(
      color: context.read<ThemeModeCubit>().currentTheme == ThemeMode.dark
          ? Colors.black
          : Colors.white,
      shadowColor: Colors.grey,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.fireBaseConfirmationAndNotification_ConfirmationRequest
                  .tr(),
              style: AppStyles.styleBold20(),
            ),
            const SizedBox(height: 8),
            Text(
              '$studentName ${LocaleKeys.fireBaseConfirmationAndNotification_isRequestingToMakeaPurchase.tr()}',
              style: AppStyles.styleMedium16(),
            ),
            const SizedBox(height: 4),
            Text(
              '${LocaleKeys.fireBaseConfirmationAndNotification_StudentID.tr()}: $studentId',
              style: AppStyles.styleMedium13(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, dynamic product) {
    return Card(
      color: context.read<ThemeModeCubit>().currentTheme == ThemeMode.dark
          ? Colors.black
          : Colors.white,
      shadowColor: Colors.grey,
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: AppStyles.styleBold16(),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${LocaleKeys.fireBaseConfirmationAndNotification_Quantity.tr()}: ${product['quantity']}',
                    style: AppStyles.styleMedium13(),
                  ),
                ],
              ),
            ),
            Text(
              '${product['price']} ${LocaleKeys.fireBaseConfirmationAndNotification_EGP.tr()}',
              style: AppStyles.styleBold16(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalAmount(BuildContext context) {
    return Card(
      color: context.read<ThemeModeCubit>().currentTheme == ThemeMode.dark
          ? Colors.black
          : Colors.white,
      shadowColor: Colors.grey,
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleKeys.fireBaseConfirmationAndNotification_TotalAmount.tr(),
              style: AppStyles.styleBold16(),
            ),
            Text(
              '$amountOfMoney ${LocaleKeys.fireBaseConfirmationAndNotification_EGP.tr()}',
              style: AppStyles.styleBold20().copyWith(
                color: Colors.blue.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _respondToRequest(context, "denied"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              LocaleKeys.fireBaseConfirmationAndNotification_Deny.tr(),
              style: AppStyles.styleBold16().copyWith(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _respondToRequest(context, "approved"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              LocaleKeys.fireBaseConfirmationAndNotification_Approve.tr(),
              style: AppStyles.styleBold16().copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void _respondToRequest(BuildContext context, String status) async {
    try {
      // Update transaction status in shared location
      await NotificationService()
          .updatePendingTransactionStatus(
        pendingTransactionId: pendingTransactionId,
        status: status,
      )
          .then((value) {
        if (context.mounted) {}
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      });
      // Show confirmation
      if (context.mounted) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.clearSnackBars();
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              status == "approved"
                  ? LocaleKeys
                      .fireBaseConfirmationAndNotification_PurchaseApproved
                  : LocaleKeys
                      .fireBaseConfirmationAndNotification_PurchaseDenied,
              style: AppStyles.styleMedium13(),
            ),
            backgroundColor: status == "approved" ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.clearSnackBars();
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              '${LocaleKeys.fireBaseConfirmationAndNotification_Error.tr()}: $e',
              style: AppStyles.styleMedium13(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildTimerDisplay(BuildContext context, bool isDarkMode) {
    Color timerColor = _remainingSeconds < 30
        ? Colors.red
        : (_remainingSeconds < 60 ? Colors.orange : Colors.blue.shade700);

    return Card(
      color: isDarkMode ? Colors.black : Colors.white,
      shadowColor: Colors.grey,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.timer_outlined,
                  color: timerColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  LocaleKeys.fireBaseConfirmationAndNotification_TimeRemaining
                      .tr(),
                  style: AppStyles.styleBold16().copyWith(
                    color: timerColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _countdownTimer != null
                  ? '${(_remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}'
                  : '00:00',
              style: AppStyles.styleBold24().copyWith(
                color: timerColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: _countdownTimer != null ? _remainingSeconds / 120 : 0,
              backgroundColor:
                  isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(timerColor),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              LocaleKeys
                  .fireBaseConfirmationAndNotification_ThisRequestWillAutomaticallyExpireAfterTheTimerEnds
                  .tr(),
              style: AppStyles.styleMedium13().copyWith(
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

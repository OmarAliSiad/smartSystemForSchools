import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/notification_service/messaging_config.dart';
import '../../../Attendance/presentation/views/attendance_view.dart';
import '../../../chatbot/presentation/chat_bot_screen.dart';
import '../../../food_ai_view/screens/food_ai_screen.dart';
import '../../../payment/presentation/views/payment_view.dart';
import '../../../settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import '../../../../core/utils/assets.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../family/presentation/views/family_view.dart';
import '../../../home/presentation/views/home_screen.dart';

class MainScreen extends StatefulWidget {
  static String id = "/MainScreen";
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int currentPage = 0;
  final List<Widget> screens = [
    HomeView(key: UniqueKey()),
    FamilyView(key: UniqueKey()),
    AttendanceView(key: UniqueKey()),
    // PaymentView(key: UniqueKey()),
    FoodAiScreen(key: UniqueKey()),
    ChatbotScreen(key: UniqueKey()),
    // TrackingView(
    //     onLocationSelected: (p0) {},
    //     initialLocations: const [],
    //     key: UniqueKey()),
  ];

  // Animation controllers for the tab indicators
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    // Initialize animation controllers for each tab
    _animationControllers = List.generate(
      5,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );

    // Initialize animations for each tab
    _animations = _animationControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
      );
    }).toList();

    // Start animation for the initial tab
    _animationControllers[currentPage].forward();
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        final themeMode = context.read<ThemeModeCubit>().currentTheme;
        return Scaffold(
          backgroundColor: themeMode == ThemeMode.dark
              ? const Color(0xFF121212)
              : Colors.white,
          body: IndexedStack(
            index: currentPage,
            children: screens,
          ),
          bottomNavigationBar: _buildAnimatedBottomNavigationBar(themeMode),
        );
      },
    );
  }

  Widget _buildAnimatedBottomNavigationBar(ThemeMode themeMode) {
    final isDarkMode = themeMode == ThemeMode.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    const primaryColor = Color(0xff1A0F91);
    final secondaryColor = isDarkMode ? Colors.white : Colors.grey;
    final shadowColor = isDarkMode ? Colors.white12 : Colors.white;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor.withOpacity(0.1),
                  primaryColor,
                  primaryColor.withOpacity(0.1),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  iconPath: Assets.imagesHome,
                  label: LocaleKeys.bottomNavigationBar_home.tr(),
                  primaryColor: primaryColor,
                  secondaryColor: secondaryColor,
                ),
                _buildNavItem(
                  index: 1,
                  iconPath: Assets.imagesFamily,
                  label: LocaleKeys.bottomNavigationBar_family.tr(),
                  primaryColor: primaryColor,
                  secondaryColor: secondaryColor,
                ),
                _buildNavItem(
                  index: 2,
                  iconPath: Assets.imagesAttendence,
                  label: LocaleKeys.bottomNavigationBar_attendance.tr(),
                  primaryColor: primaryColor,
                  secondaryColor: secondaryColor,
                ),
                // _buildNavItem(
                //   index: 3,
                //   iconPath: Assets.imagesWallet,
                //   label: LocaleKeys.bottomNavigationBar_wallet.tr(),
                //   primaryColor: primaryColor,
                //   secondaryColor: secondaryColor,
                // ),
                _buildNavItem(
                  index: 3,
                  iconPath: Assets.imagesHelp,
                  label: 'AI',
                  primaryColor: primaryColor,
                  secondaryColor: secondaryColor,
                ),
                _buildNavItem(
                  index: 4,
                  iconPath: Assets.imagesChatbot,
                  label: 'ChatBot',
                  primaryColor: primaryColor,
                  secondaryColor: secondaryColor,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    String? iconPath,
    Icon? icon,
    required String label,
    required Color primaryColor,
    required Color secondaryColor,
  }) {
    final isSelected = currentPage == index;

    return GestureDetector(
      onTap: () {
        if (currentPage != index) {
          setState(() {
            // Reset previous animation
            _animationControllers[currentPage].reverse();
            currentPage = index;
            // Start new animation
            _animationControllers[currentPage].forward();
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 65,
        decoration: BoxDecoration(
          color:
              isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _animations[index],
              builder: (context, child) {
                return Transform.scale(
                  scale:
                      isSelected ? 1.0 + (_animations[index].value * 0.2) : 1.0,
                  child: icon ??
                      Image.asset(
                        iconPath!,
                        color: isSelected ? primaryColor : secondaryColor,
                        width: 24,
                        height: 24,
                      ),
                );
              },
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: isSelected ? primaryColor : secondaryColor,
                fontSize: isSelected ? 12 : 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              AnimatedBuilder(
                animation: _animations[index],
                builder: (context, child) {
                  return Container(
                    margin: const EdgeInsets.only(top: 4),
                    height: 3,
                    width: 20 * _animations[index].value,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

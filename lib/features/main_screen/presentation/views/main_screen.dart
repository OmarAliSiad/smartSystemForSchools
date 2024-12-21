import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';

import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/widgets/custom_bottom_container.dart';
import '../../../family/presentation/views/family_view.dart';
import '../../../home/presentation/views/home_screen.dart';

class MainScreen extends StatefulWidget {
  static String id = "MainScreen";
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPage = 0;
  List<Widget> screens = [
    HomeView(
      key: UniqueKey(),
    ),
    FamilyView(
      key: UniqueKey(),
    ),
    HomeView(
      key: UniqueKey(),
    ),
    ProductView(
      key: UniqueKey(),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        final themeMode = context.read<ThemeModeCubit>().currentTheme;
        return Scaffold(
          backgroundColor:
              themeMode == ThemeMode.dark ? Colors.black : Colors.white,
          body: screens[currentPage],
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(
                thickness: 1,
                color: themeMode == ThemeMode.dark
                    ? Colors.white.withOpacity(.50)
                    : Colors.black.withOpacity(.30),
              ),
              BottomNavigationBar(
                landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
                selectedLabelStyle:
                    AppStyles.styleMedium16().copyWith(fontSize: 14),
                elevation: 0,
                backgroundColor:
                    themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                selectedIconTheme:
                    const IconThemeData(color: Color(0xff1A0F91)),
                iconSize: 24,
                type: BottomNavigationBarType.fixed,
                currentIndex: currentPage,
                selectedItemColor: const Color(0xff1A0F91),
                onTap: (i) async {
                  setState(() {
                    currentPage = i;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      Assets.imagesHome,
                      color: (currentPage == 0)
                          ? const Color(0xff1A0F91)
                          : Colors.grey,
                      width: 24.5,
                      height: 24.5,
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      color: (currentPage == 1)
                          ? const Color(0xff1A0F91)
                          : Colors.grey,
                      Assets.imagesFamily,
                      width: 24.5,
                      height: 24.5,
                    ),
                    label: 'Family',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      color: (currentPage == 2)
                          ? const Color(0xff1A0F91)
                          : Colors.grey,
                      Assets.imagesAttendence,
                      width: 24.5,
                      height: 24.5,
                    ),
                    label: 'Attendance',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      color: (currentPage == 3)
                          ? const Color(0xff1A0F91)
                          : Colors.grey,
                      Assets.imagesWallet,
                      width: 24.5,
                      height: 24.5,
                    ),
                    label: 'Wallet',
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              const CustomBottomContainer(color: Colors.black)
            ],
          ),
        );
      },
    );
  }
}

class ProductView extends StatelessWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/core/methods/show_scaffold_messanger.dart';
import 'package:smartsystemforschools/core/utils/animated_app_bar.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';

class LanguageSelectionPage extends StatefulWidget {
  static const String id = '/LanguageSelectionPage';
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  static const String _languageKey = 'selected_language';
  String selectedLanguage = 'en'; // Default language is English
  String _tempSelectedLanguage = 'en'; // Temporary selection before saving
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Map of language codes to language info
  final Map<String, Map<String, String>> _languageOptions = {
    'en': {'name': 'English', 'countryCode': 'US'},
    'ar': {'name': 'العربية', 'countryCode': 'SA'},
    'es': {'name': 'Español', 'countryCode': 'ES'},
    'fr': {'name': 'Français', 'countryCode': 'FR'},
  };

  List<String> get _filteredLanguages {
    if (_searchQuery.isEmpty) {
      return _languageOptions.keys.toList();
    }
    return _languageOptions.keys.where((code) {
      final name = _languageOptions[code]?['name'] ?? '';
      return name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          code.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage =
          prefs.getString(_languageKey) ?? context.locale.languageCode;
      _tempSelectedLanguage = selectedLanguage;
    });
  }

  Future<void> _saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);

    // Update both selected and temp
    setState(() {
      selectedLanguage = languageCode;
      _tempSelectedLanguage = languageCode;
    });

    // Apply the language change
    if (mounted) {
      context.setLocale(Locale(languageCode));
    }
    // Show success message
    if (mounted) {
      dispalySnackBar(
        context,
        title: LocaleKeys.Settings_saveLanguage.tr(),
        color: Colors.green,
        duration: 2000,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AnimatedCustomAppBar(
        title: LocaleKeys.Settings_language.tr(),
        textStyle: AppStyles.styleSemiBold20(),
        thereIsIcon: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocBuilder<ThemeModeCubit, ThemeModeState>(
        builder: (context, state) {
          final theme = context.read<ThemeModeCubit>().currentTheme;
          final isDarkMode = theme == ThemeMode.dark;

          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search bar
                      Container(
                        decoration: BoxDecoration(
                          color:
                              isDarkMode ? Colors.grey[800] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          cursorColor: Colors.black,
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: LocaleKeys.Settings_searchLanguages.tr(),
                            prefixIcon: const Icon(Icons.search),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                            hintStyle: TextStyle(
                              color: isDarkMode
                                  ? Colors.white60
                                  : Colors.grey[600],
                            ),
                          ),
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Language list
                      Expanded(
                        child: _filteredLanguages.isEmpty
                            ? Center(
                                child: Text(
                                  LocaleKeys.Settings_noLanguagesFound.tr(),
                                  style: AppStyles.styleRegular16().copyWith(
                                    color: isDarkMode
                                        ? Colors.white70
                                        : Colors.grey[700],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: _filteredLanguages.length,
                                itemBuilder: (context, index) {
                                  final languageCode =
                                      _filteredLanguages[index];
                                  final languageInfo =
                                      _languageOptions[languageCode]!;
                                  return _buildLanguageOption(
                                    languageCode: languageCode,
                                    languageName: languageInfo['name']!,
                                    countryCode: languageInfo['countryCode']!,
                                    isDarkMode: isDarkMode,
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              // Save button at bottom
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[900] : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _tempSelectedLanguage != selectedLanguage
                      ? () => _saveLanguage(_tempSelectedLanguage)
                      : () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff1A0F91),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    LocaleKeys.Settings_save.tr(),
                    style:
                        AppStyles.styleMedium16().copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLanguageOption({
    required String languageCode,
    required String languageName,
    required String countryCode,
    required bool isDarkMode,
  }) {
    final isSelected = _tempSelectedLanguage == languageCode;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        setState(() {
          _tempSelectedLanguage = languageCode;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? isDarkMode
                  ? Colors.blueGrey[700]
                  : Colors.blue[50]
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? isDarkMode
                    ? Colors.blueAccent
                    : Colors.blue
                : isDarkMode
                    ? Colors.grey[700]!
                    : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            CountryFlag.fromCountryCode(
              countryCode,
              height: 24,
              width: 32,
            ),
            const SizedBox(width: 16),
            Text(
              languageName,
              style: AppStyles.styleMedium16().copyWith(
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: isDarkMode ? Colors.blueAccent : Colors.blue,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

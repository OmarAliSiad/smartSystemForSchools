import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/custom_app_bar.dart';
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
    });
    context.setLocale(Locale(selectedLanguage));
  }

  Future<void> _saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
    context.setLocale(Locale(languageCode));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocaleKeys.Settings_language.tr(),
        textStyle: AppStyles.styleSemiBold20(),
        ThereIsicon: false,
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
      body: BlocBuilder<ThemeModeCubit, ThemeModeState>(
        builder: (context, state) {
          final theme = context.read<ThemeModeCubit>().currentTheme;
          final isDarkMode = theme == ThemeMode.dark;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    cursorColor: Colors.black,
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search languages',
                      prefixIcon: const Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      hintStyle: TextStyle(
                        color: isDarkMode ? Colors.white60 : Colors.grey[600],
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
                            'No languages found',
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
                            final languageCode = _filteredLanguages[index];
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
    final isSelected = selectedLanguage == languageCode;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        setState(() {
          selectedLanguage = languageCode;
        });
        _saveLanguage(languageCode);
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

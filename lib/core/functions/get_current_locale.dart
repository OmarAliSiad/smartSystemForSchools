import 'package:intl/intl.dart';

bool isArabic() {
  return Intl.getCurrentLocale() == 'ar';
}

bool isEnglish() {
  return Intl.getCurrentLocale() == 'en';
}

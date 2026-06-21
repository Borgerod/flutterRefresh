import 'package:phone_numbers_parser/phone_numbers_parser.dart';

String formatPhone(String raw) {
  final phone = PhoneNumber.parse(raw);
  return '+${phone.countryCode} ${phone.formatNsn()}';
}

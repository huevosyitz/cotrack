// ignore_for_file: non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static final String SUPABASE_URL = dotenv.env['SUPABASE_URL']!;
  static final String SUPABASE_ANON_KEY = dotenv.env['SUPABASE_ANON_KEY']!;
  static final String API_BASEURL = dotenv.env['API_BASEURL']!;

  static Future init() async {
    await dotenv.load(fileName: ".env");
  }
}

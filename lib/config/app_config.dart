// ignore_for_file: non_constant_identifier_names

// import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static final String SUPABASE_URL = const String.fromEnvironment('SUPABASE_URL');
  static final String SUPABASE_ANON_KEY =
      const String.fromEnvironment('SUPABASE_ANON_KEY');
  static final String API_BASEURL = const String.fromEnvironment('API_BASEURL');

  static Future init() async {
    // await dotenv.load(fileName: ".env");
  }
}

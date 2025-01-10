import 'package:cotrack/config/app_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseSetup {
  static Future<void> init() async {
    // Initialize the database

    await Supabase.initialize(
      url: AppConfig.SUPABASE_URL,
      anonKey: AppConfig.SUPABASE_ANON_KEY,
    );
  }
}

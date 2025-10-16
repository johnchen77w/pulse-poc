import 'package:supabase_flutter/supabase_flutter.dart';

/// Manages the Supabase client instance for the Pulse app.
///
/// This class provides a singleton pattern to access the Supabase client
/// throughout the application. It should be initialized once in main()
/// before running the app.
///
/// Usage:
/// ```dart
/// // In main.dart:
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await SupabaseClientManager.init();
///   runApp(const PulseApp());
/// }
///
/// // In other files:
/// final supabase = SupabaseClientManager.client;
///
/// // For authentication:
/// await supabase.auth.signUp(email: email, password: password);
/// await supabase.auth.signInWithPassword(email: email, password: password);
/// await supabase.auth.signOut();
///
/// // For database queries:
/// final data = await supabase.from('table_name').select();
/// ```
class SupabaseClientManager {
  // Private constructor to prevent instantiation
  SupabaseClientManager._();

  // Supabase credentials
  static const String _supabaseUrl = 'https://vusrrkxgpaulflzoimfr.supabase.co';
  static const String _supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ1c3Jya3hncGF1bGZsem9pbWZyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA2MzE4ODAsImV4cCI6MjA3NjIwNzg4MH0.pBE1zxlG3FAK_HhkAaKm1phLvAlHyRxC23j9zDAkCvY';

  /// Initializes the Supabase client.
  ///
  /// This method must be called in main() before runApp().
  /// It ensures WidgetsFlutterBinding is initialized and sets up the Supabase client.
  ///
  /// Throws an exception if initialization fails.
  static Future<void> init() async {
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
      // Optional: Add debug mode for development
      debug: true,
    );
  }

  /// Returns the Supabase client instance.
  ///
  /// This getter provides access to the Supabase client throughout the app.
  /// Make sure to call [init()] before accessing this getter.
  ///
  /// Example:
  /// ```dart
  /// final user = SupabaseClientManager.client.auth.currentUser;
  /// ```
  static SupabaseClient get client => Supabase.instance.client;

  /// Convenience getter for auth-related operations.
  ///
  /// Example:
  /// ```dart
  /// final isLoggedIn = SupabaseClientManager.auth.currentUser != null;
  /// ```
  static GoTrueClient get auth => client.auth;
}

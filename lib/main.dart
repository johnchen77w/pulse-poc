import 'package:flutter/material.dart';
import 'app.dart';
import 'services/supabase_client_manager.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await SupabaseClientManager.init();

  runApp(const PulseApp());
}
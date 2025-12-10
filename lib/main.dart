import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/bindings/initial_binding.dart';
import 'src/routes/app_pages.dart';
import 'src/routes/app_routes.dart';

// Supabase Credentials
const String supabaseUrl = 'https://twlzfafkhgzezfzdhlev.supabase.co';
const String supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR3bHpmYWZraGd6ZXpmemRobGV2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ5MDcyNjgsImV4cCI6MjA4MDQ4MzI2OH0._sCSbx-sn2ISBXF3cyw6ar0JDQcBGOR1ekEnPWXL-Dg';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);


  // supaya currentSession SELALU null saat start
  await Supabase.instance.client.auth.signOut();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Absensi QR Wali Murid',
      debugShowCheckedModeBanner: false,

      initialBinding: InitialBinding(),

      // Selalu mulai dari LOGIN
      initialRoute: AppRoutes.login,

      getPages: AppPages.pages,

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
      ),
    );
  }
}

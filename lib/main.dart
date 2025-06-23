import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perplexity_clone/auth/auth_gate.dart';
import 'package:perplexity_clone/theme/colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // load .env
  await dotenv.load(fileName: ".env");
  // setup supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'perplexity_clone',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.submitButton),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.lexendDecaTextTheme(
          ThemeData.dark().textTheme.copyWith(
                bodyMedium:
                    const TextStyle(fontSize: 16, color: AppColors.whiteColor),
              ),
        ),
      ),
      home: AuthGate(),
    );
  }
}

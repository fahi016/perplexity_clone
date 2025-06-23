/*
AUTH GATE -- Cuntinously listen for auth state changes
*/

import 'package:flutter/material.dart';
import 'package:perplexity_clone/pages/home_page.dart';
import 'package:perplexity_clone/pages/login_page.dart';
import 'package:perplexity_clone/theme/colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        // Listen to auth state changes
        stream: Supabase.instance.client.auth.onAuthStateChange,
        // Build appropriate page based on auth state
        builder: (context, snapshot) {
          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: AppColors.searchBarBorder,
                ),
              ),
            );
          }
          // check if there is a valid session currently
          final session = snapshot.hasData ? snapshot.data!.session : null;
          if (session != null) {
            return HomePage();
          } else {
            return LoginPage();
          }
        });
  }
}

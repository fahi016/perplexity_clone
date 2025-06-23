import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:perplexity_clone/auth/auth_service.dart';
import 'package:perplexity_clone/services/chat_web_service.dart';
import 'package:perplexity_clone/widgets/status_bar.dart';
import 'package:perplexity_clone/widgets/search_section.dart';
import 'package:perplexity_clone/widgets/side_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // get auth service
  final authService = AuthService();

  @override
  void initState() {
    super.initState();
    ChatWebService().connect();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            // SideNavBar
            kIsWeb ? SideBar() : SizedBox(),
            Expanded(
                child: Padding(
              padding: kIsWeb ? EdgeInsets.all(8) : EdgeInsets.zero,
              child: Column(
                children: [
                  // Search Section
                  Expanded(
                    child: SearchSection(),
                  ),

                  // Footer
                  StatusBar()
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

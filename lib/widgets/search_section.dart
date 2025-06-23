import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perplexity_clone/pages/chat_page.dart';
import 'package:perplexity_clone/services/chat_web_service.dart';
import 'package:perplexity_clone/theme/colors.dart';
import 'package:perplexity_clone/widgets/search_bar_button.dart';

class SearchSection extends StatefulWidget {
  const SearchSection({super.key});

  @override
  _SearchSectionState createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection>
    with TickerProviderStateMixin {
  final queryController = TextEditingController();
  final _scrollController = ScrollController();
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    queryController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Ask Anything",
          style: GoogleFonts.lexend(
            fontSize: 40,
            fontWeight: FontWeight.w400,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 32),
        AnimatedBuilder(
          animation: _shimmerAnimation,
          builder: (context, child) {
            return Container(
              width: 700,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: _isFocused
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue.withOpacity(0.3),
                          Colors.purple.withOpacity(0.3),
                          Colors.pink.withOpacity(0.3),
                          Colors.blue.withOpacity(0.3),
                        ],
                        stops: [
                          _shimmerAnimation.value - 0.3,
                          _shimmerAnimation.value - 0.1,
                          _shimmerAnimation.value + 0.1,
                          _shimmerAnimation.value + 0.3,
                        ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
                      )
                    : null,
              ),
              child: Container(
                margin: EdgeInsets.all(_isFocused ? 2 : 0),
                decoration: BoxDecoration(
                  color: AppColors.textFieldColor,
                  borderRadius: BorderRadius.circular(12),
                  border: _isFocused
                      ? null
                      : Border.all(
                          color: AppColors.searchBarBorder, width: 1.5),
                  boxShadow: _isFocused
                      ? [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.1),
                            blurRadius: 30,
                            spreadRadius: 1,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: kIsWeb ? 150 : 90,
                        ),
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          reverse: true,
                          child: Focus(
                            onFocusChange: (focused) {
                              setState(() {
                                _isFocused = focused;
                              });
                            },
                            child: TextField(
                              controller: queryController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              scrollController: _scrollController,
                              style: GoogleFonts.lexend(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                                letterSpacing: -0.2,
                              ),
                              decoration: InputDecoration(
                                hintText: "What's on your mind?",
                                hintStyle: GoogleFonts.lexend(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  height: 1.4,
                                  letterSpacing: -0.2,
                                  color: Colors.grey.withOpacity(0.7),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Row(
                        children: [
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              if (queryController.text.trim().isNotEmpty) {
                                ChatWebService()
                                    .chat(queryController.text.trim());
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                            question:
                                                queryController.text.trim())));
                              }
                            },
                            behavior: HitTestBehavior.opaque,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.submitButton,
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppColors.submitButton.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

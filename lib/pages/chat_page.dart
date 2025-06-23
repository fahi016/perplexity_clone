import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perplexity_clone/theme/colors.dart';
import 'package:perplexity_clone/widgets/answer_section.dart';
import 'package:perplexity_clone/widgets/side_bar.dart';
import 'package:perplexity_clone/widgets/sources_section.dart';
import 'package:perplexity_clone/widgets/youtube_section.dart';

class ChatPage extends StatelessWidget {
  final String question;
  const ChatPage({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 1100;
            final isMedium = constraints.maxWidth > 768;
            final isMobile = constraints.maxWidth <= 768;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sidebar - only show on web and medium+ screens
                if (kIsWeb && isMedium) const SideBar(),
                if (kIsWeb && isMedium) SizedBox(width: isMobile ? 20 : 60),

                /// Main Content
                Expanded(
                  flex: 3,
                  child: CustomScrollView(
                    slivers: [
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _StickyQuestionHeader(
                          question: question,
                          isMobile: isMobile,
                          isMedium: isMedium,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: isMobile ? double.infinity : 900,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 16 : 24,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: isMobile ? 20 : 32),

                                  /// Web Sources
                                  const SourcesSection(),
                                  SizedBox(height: isMobile ? 20 : 32),

                                  /// AI Answer
                                  const AnswerSection(),

                                  /// YouTube Section for mobile/tablet (moved below main content)
                                  if (!isWide) ...[
                                    SizedBox(height: isMobile ? 20 : 32),
                                    const YouTubeSection(),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// YouTube Section - only show on wide screens as sidebar
                if (kIsWeb && isWide)
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: double.infinity,
                      padding: const EdgeInsets.only(top: 48, right: 24),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            SizedBox(height: 60),
                            YouTubeSection(),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StickyQuestionHeader extends SliverPersistentHeaderDelegate {
  final String question;
  final bool isMobile;
  final bool isMedium;

  _StickyQuestionHeader({
    required this.question,
    required this.isMobile,
    required this.isMedium,
  });

  @override
  double get minExtent => isMobile ? 60 : (isMedium ? 80 : 100);
  @override
  double get maxExtent => isMobile ? 80 : (isMedium ? 110 : 140);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.background.withOpacity(0.98),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: isMobile ? 10 : 18,
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        question,
        style: GoogleFonts.inter(
          fontSize: isMobile ? 20 : (isMedium ? 28 : 32),
          fontWeight: FontWeight.bold,
          color: Colors.white,
          height: 1.3,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

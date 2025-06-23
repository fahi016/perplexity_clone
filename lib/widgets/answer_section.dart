import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perplexity_clone/services/chat_web_service.dart';
import 'package:perplexity_clone/theme/colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AnswerSection extends StatefulWidget {
  const AnswerSection({super.key});

  @override
  State<AnswerSection> createState() => _AnswerSectionState();
}

class _AnswerSectionState extends State<AnswerSection> {
  bool isLoading = true;
  String fullResponse = """
    Certainly! Here's a detailed explanation of the recent cricket matches between India and Australia, covering both the **ICC Champions Trophy 2025 semi-final** and the **India tour of Australia Test series**.

## ICC Champions Trophy 2025 Semi-Final

### Match Details:
- **Date**: March 4, 2025
- **Location**: Dubai International Cricket Stadium
- **Teams**: India vs. Australia

### Scorecard:
- **Australia**: 264/10 (49.3 overs)
- **India**: 267/6 (48.1 overs)

### Key Performances:
- **Virat Kohli**: Scored 84 runs, playing a crucial role in India's chase.
- **KL Rahul**: Contributed an unbeaten 42 runs, helping India secure the win.
- **Australian Bowling**: Mitchell Starc and Pat Cummins were among the notable bowlers, but India's batting depth proved too strong.

### Match Summary:
India won the toss and chose to bowl first. Australia's innings was marked by a strong start but wobbled in the middle overs. Despite a late surge, they were bowled out for 264. India's chase was steady, with Kohli and Rahul playing key roles. The win secured India's spot in the final of the Champions Trophy.

## India Tour of Australia Test Series

### Series Overview:
The series consisted of five Test matches, with Australia aiming to assert dominance on home soil and India seeking to make a strong statement abroad.

  
  
  """;

  @override
  void initState() {
    super.initState();
    ChatWebService().contentStream.listen((data) {
      if (isLoading) {
        fullResponse = "";
      }
      setState(() {
        fullResponse += data["data"];
        isLoading = false;
      });
    });
  }

  void stripQuestionIfPresent(String question) {
    // Remove the question if it appears at the start of the response
    if (fullResponse
        .trimLeft()
        .toLowerCase()
        .startsWith(question.trimLeft().toLowerCase())) {
      fullResponse = fullResponse
          .trimLeft()
          .substring(question.trimLeft().length)
          .trimLeft();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Try to get the question from the sticky header (if available)
    final ModalRoute? route = ModalRoute.of(context);
    String? question;
    if (route != null && route.settings.arguments is String) {
      question = route.settings.arguments as String;
    }
    // If question is available, strip it from the response
    if (question != null && fullResponse.isNotEmpty) {
      stripQuestionIfPresent(question);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header section
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isLoading
                      ? Icons.psychology_outlined
                      : Icons.auto_awesome_outlined,
                  color:
                      isLoading ? AppColors.textGrey : AppColors.submitButton,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: isLoading
                    ? Shimmer.fromColors(
                        baseColor: AppColors.textGrey,
                        highlightColor: AppColors.submitButton.withOpacity(0.4),
                        period: const Duration(seconds: 1),
                        child: const Text(
                          "AI is thinking...",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        "Answer",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Content section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.searchBarBorder.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Skeletonizer(
            enabled: isLoading,
            effect: const ShimmerEffect(
              baseColor: AppColors.cardColor,
              highlightColor: AppColors.searchBarBorder,
              duration: Duration(seconds: 1),
            ),
            child: Markdown(
              data: fullResponse,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              styleSheet:
                  MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                // Headers
                h1: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                h2: TextStyle(
                  color: AppColors.submitButton,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                h3: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                // Body text
                p: TextStyle(
                  color: AppColors.whiteColor.withOpacity(0.9),
                  fontSize: 14,
                  height: 1.5,
                ),
                // Lists
                listBullet: TextStyle(
                  color: AppColors.submitButton,
                ),
                // Code blocks
                codeblockDecoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.searchBarBorder.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                code: GoogleFonts.jetBrainsMono(
                  fontSize: 13,
                  color: AppColors.submitButton,
                ),
                codeblockPadding: const EdgeInsets.all(12),
                // Strong/bold text
                strong: TextStyle(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

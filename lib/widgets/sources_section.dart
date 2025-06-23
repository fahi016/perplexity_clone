import 'package:flutter/material.dart';
import 'package:perplexity_clone/services/chat_web_service.dart';
import 'package:perplexity_clone/theme/colors.dart';
import 'package:perplexity_clone/widgets/source_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SourcesSection extends StatefulWidget {
  const SourcesSection({super.key});

  @override
  State<SourcesSection> createState() => _SourcesSectionState();
}

class _SourcesSectionState extends State<SourcesSection> {
  bool isLoading = true;

  List searchResults = [
    {
      "title": "The New York Times",
      "url": "https://www.nytimes.com",
    },
    {
      "title": "Flutter",
      "url": "https://flutter.dev",
    },
    {
      "title": "GitHub",
      "url": "https://github.com",
    },
  ];

  @override
  void initState() {
    super.initState();
    ChatWebService().searchResultStream.listen((data) {
      setState(() {
        searchResults = data["data"];
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                !isLoading ? Icons.source_outlined : Icons.search_outlined,
                color: isLoading ? AppColors.textGrey : AppColors.submitButton,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: isLoading
                  ? Shimmer.fromColors(
                      period: const Duration(seconds: 1),
                      baseColor: AppColors.textGrey,
                      highlightColor: AppColors.submitButton.withOpacity(0.4),
                      child: const Text(
                        "Searching web...",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : const Text(
                      "Sources",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Skeletonizer(
          enabled: isLoading,
          effect: const ShimmerEffect(
            baseColor: AppColors.cardColor,
            highlightColor: AppColors.searchBarBorder,
            duration: Duration(seconds: 1),
          ),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: searchResults.asMap().entries.map((entry) {
              final index = entry.key + 1; // 1-based index
              final res = entry.value;

              return SourceCard(
                title: res['title'],
                url: res['url'],
                index: index,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

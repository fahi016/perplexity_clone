import 'package:flutter/material.dart';
import 'package:perplexity_clone/services/chat_web_service.dart';
import 'package:perplexity_clone/theme/colors.dart';
import 'package:perplexity_clone/widgets/video_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:skeletonizer/skeletonizer.dart';

class YouTubeSection extends StatefulWidget {
  const YouTubeSection({super.key});

  @override
  State<YouTubeSection> createState() => _YouTubeSectionState();
}

class _YouTubeSectionState extends State<YouTubeSection> {
  bool isLoading = true;
  List<Map<String, dynamic>> youtubeResults = [
    {
      "title": "Flutter UI Tutorial - Netflix Clone",
      "thumbnail": "https://img.youtube.com/vi/fq4N0hgOWzU/hqdefault.jpg",
      "url": "https://www.youtube.com/watch?v=fq4N0hgOWzU",
      "channelTitle": "Flutter Dev",
    },
    {
      "title": "What is FastAPI? Full Python API Guide",
      "thumbnail": "https://img.youtube.com/vi/0rsilnpU1DU/hqdefault.jpg",
      "url": "https://www.youtube.com/watch?v=0rsilnpU1DU",
      "channelTitle": "Python Engineer",
    },
    {
      "title": "Build Your Own ChatGPT App",
      "thumbnail": "https://img.youtube.com/vi/uqXVAo7dVRU/hqdefault.jpg",
      "url": "https://www.youtube.com/watch?v=uqXVAo7dVRU",
      "channelTitle": "CodeWithChris",
    },
  ];

  @override
  void initState() {
    super.initState();
    ChatWebService().youtubeResultStream.listen((data) {
      final videos = data["data"];
      if (videos is List) {
        setState(() {
          youtubeResults = videos.cast<Map<String, dynamic>>();
          isLoading = false;
        });
      }
    });
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (youtubeResults.isEmpty && !isLoading) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                      ? Icons.search_outlined
                      : Icons.video_library_outlined,
                  color: isLoading ? AppColors.textGrey : Colors.red,
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
                          "Searching YouTube...",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        "Related Videos",
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
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            // Responsive: 1 column for <500, 2 for <900, 3+ for wider
            int crossAxisCount = 1;
            double width = constraints.maxWidth;
            if (width > 900) {
              crossAxisCount = 3;
            } else if (width > 500) {
              crossAxisCount = 2;
            }
            return SizedBox(
              height: 650,
              child: Skeletonizer(
                enabled: isLoading,
                effect: const ShimmerEffect(
                  baseColor: AppColors.cardColor,
                  highlightColor: AppColors.searchBarBorder,
                  duration: Duration(seconds: 1),
                ),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: youtubeResults.length,
                  itemBuilder: (context, index) {
                    final video = youtubeResults[index];
                    final title = video["title"] ?? "No title";
                    final thumbnailUrl = video["thumbnail"] ??
                        "https://via.placeholder.com/480x360";
                    final videoUrl = video["url"] ?? "#";
                    final channelTitle =
                        video["channelTitle"] ?? "Unknown channel";
                    return VideoCard(
                      title: title,
                      thumbnailUrl: thumbnailUrl,
                      videoUrl: videoUrl,
                      channelTitle: channelTitle,
                      onTap: () => _launchURL(videoUrl),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

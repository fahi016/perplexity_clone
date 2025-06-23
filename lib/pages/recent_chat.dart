import 'package:flutter/material.dart';
import 'package:perplexity_clone/models/chat_model.dart';
import 'package:perplexity_clone/theme/colors.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class RecentChatPage extends StatelessWidget {
  final ChatModel chat;
  const RecentChatPage({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Apple-style large title app bar
          SliverAppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            pinned: true,
            expandedHeight: 120,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.sideNav,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.chevron_left,
                    color: AppColors.whiteColor, size: 24),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(
                left: isWide ? 80 : 24,
                bottom: 16,
                right: 24,
              ),
              title: const Text(
                'Recent Chat',
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide
                    ? (screenWidth > 1200 ? (screenWidth - 800) / 2 : 40)
                    : 20,
                vertical: 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),

                  // Question Section
                  _QuestionSection(
                    question: chat.question,
                    isWide: isWide,
                  ),

                  const SizedBox(height: 48),

                  // Sources Section
                  if (chat.sources != null && chat.sources!.isNotEmpty) ...[
                    _SourcesSection(
                      sources: chat.sources!,
                      isWide: isWide,
                    ),
                    const SizedBox(height: 48),
                  ],

                  // AI Response Section
                  if (chat.answerFull != null &&
                      chat.answerFull!.isNotEmpty) ...[
                    _ResponseSection(
                      answer: chat.answerFull!,
                      isWide: isWide,
                    ),
                    const SizedBox(height: 48),
                  ],

                  // YouTube Section
                  if (chat.youtube != null && chat.youtube!.isNotEmpty) ...[
                    _YouTubeSection(
                      videos: chat.youtube!,
                      isWide: isWide,
                    ),
                    const SizedBox(height: 32),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionSection extends StatelessWidget {
  final String question;
  final bool isWide;

  const _QuestionSection({
    required this.question,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isWide ? 32 : 24),
      decoration: BoxDecoration(
        color: AppColors.sideNav,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.submitButton.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: AppColors.submitButton,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Your Question',
                style: TextStyle(
                  color: AppColors.submitButton,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            question,
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: isWide ? 24 : 20,
              fontWeight: FontWeight.w600,
              height: 1.4,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _SourcesSection extends StatelessWidget {
  final List sources;
  final bool isWide;

  const _SourcesSection({
    required this.sources,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.public_rounded,
          title: 'Sources',
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: sources.map((src) => _SourceChip(source: src)).toList(),
        ),
      ],
    );
  }
}

class _ResponseSection extends StatelessWidget {
  final String answer;
  final bool isWide;

  const _ResponseSection({
    required this.answer,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.psychology_rounded,
          title: 'AI Response',
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(isWide ? 32 : 24),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.searchBarBorder.withOpacity(0.3),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 16,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: MarkdownBody(
            data: answer,
            styleSheet: MarkdownStyleSheet(
              p: const TextStyle(
                color: AppColors.whiteColor,
                fontSize: 16,
                height: 1.6,
                fontWeight: FontWeight.w400,
              ),
              h1: const TextStyle(
                color: AppColors.whiteColor,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
              h2: const TextStyle(
                color: AppColors.whiteColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
              h3: const TextStyle(
                color: AppColors.whiteColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
              code: TextStyle(
                color: AppColors.submitButton,
                fontSize: 14,
                fontFamily: 'SF Mono',
                backgroundColor: AppColors.searchBar,
              ),
              codeblockDecoration: BoxDecoration(
                color: AppColors.searchBar,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _YouTubeSection extends StatelessWidget {
  final List videos;
  final bool isWide;

  const _YouTubeSection({
    required this.videos,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.play_circle_outline_rounded,
          title: 'Related Videos',
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 240, // Increased height to accommodate content
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: videos.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) => _VideoCard(video: videos[index]),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.submitButton.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.submitButton,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.whiteColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}

class _SourceChip extends StatelessWidget {
  final Map source;

  const _SourceChip({required this.source});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final url = source['url'] ?? '';
          if (url.isNotEmpty && await canLaunchUrl(Uri.parse(url))) {
            launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
          }
        },
        child: Container(
          constraints: const BoxConstraints(maxWidth: 280),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.sideNav,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.searchBarBorder.withOpacity(0.3),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.submitButton.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.link_rounded,
                  color: AppColors.submitButton,
                  size: 12,
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  source['title'] ?? 'Untitled',
                  style: const TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VideoCard extends StatelessWidget {
  final Map video;

  const _VideoCard({required this.video});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          final url = video['url'] ?? '';
          if (url.isNotEmpty && await canLaunchUrl(Uri.parse(url))) {
            launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
          }
        },
        child: Container(
          width: 280,
          height: 240, // Fixed height to match container
          decoration: BoxDecoration(
            color: AppColors.sideNav,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.searchBarBorder.withOpacity(0.3),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      video['thumbnail'] ?? '',
                      width: 280,
                      height: 140, // Adjusted thumbnail height
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 280,
                        height: 140,
                        color: AppColors.searchBar,
                        child: const Icon(
                          Icons.video_library_outlined,
                          color: AppColors.iconGrey,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.1),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: AppColors.whiteColor,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          video['title'] ?? 'Untitled Video',
                          style: const TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                          maxLines: 3, // Allow more lines for title
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        video['channelTitle'] ?? 'Unknown Channel',
                        style: const TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

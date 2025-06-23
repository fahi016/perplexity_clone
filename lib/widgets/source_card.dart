import 'package:flutter/material.dart';
import 'package:perplexity_clone/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class SourceCard extends StatefulWidget {
  final String title;
  final String url;
  final int index;

  const SourceCard({
    required this.title,
    required this.url,
    required this.index,
    super.key,
  });

  @override
  State<SourceCard> createState() => _SourceCardState();
}

class _SourceCardState extends State<SourceCard> {
  bool isHovered = false;

  String get _displayUrl {
    try {
      final uri = Uri.parse(widget.url);
      return uri.host.replaceFirst('www.', '');
    } catch (e) {
      return widget.url;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: () async {
          final url = Uri.parse(widget.url);
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          } else {
            print('Could not launch ${widget.url}');
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          constraints: const BoxConstraints(maxWidth: 160),
          decoration: BoxDecoration(
            color: isHovered ? AppColors.searchBarBorder : AppColors.cardColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isHovered
                  ? AppColors.submitButton.withOpacity(0.3)
                  : AppColors.searchBarBorder.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Number
              Text(
                "${widget.index}.",
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.submitButton,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),

              // Title
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.whiteColor,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // URL with icon
              Row(
                children: [
                  Icon(
                    Icons.link,
                    size: 12,
                    color: AppColors.textGrey,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      _displayUrl,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textGrey,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

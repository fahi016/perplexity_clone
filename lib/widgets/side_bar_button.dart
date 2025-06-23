import 'package:flutter/material.dart';
import 'package:perplexity_clone/theme/colors.dart';

class SideBarButton extends StatefulWidget {
  const SideBarButton(
      {super.key,
      required this.isCollapsed,
      required this.icon,
      required this.text});
  final bool isCollapsed;
  final IconData icon;
  final String text;

  @override
  State<SideBarButton> createState() => _SideBarButtonState();
}

class _SideBarButtonState extends State<SideBarButton> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: isHovered ? AppColors.background : AppColors.sideNav,
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: widget.isCollapsed
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              child: Icon(widget.icon, size: 22, color: AppColors.iconGrey),
            ),
            widget.isCollapsed
                ? const SizedBox()
                : Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.iconGrey,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

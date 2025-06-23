import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perplexity_clone/pages/history_page.dart';
import 'package:perplexity_clone/pages/home_page.dart';
import 'package:perplexity_clone/pages/profile_page.dart';
import 'package:perplexity_clone/theme/colors.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  bool isCollapsed = true;
  int? _hoveredIndex;

  void _toggleSidebar() {
    setState(() {
      isCollapsed = !isCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCollapsed ? 70 : 160,
      decoration: BoxDecoration(
        color: AppColors.sideNav,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          CircleAvatar(
            radius: isCollapsed ? 16 : 24,
            backgroundImage: const AssetImage('assets/images/logo.png'),
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Column(
              children: [
                _buildNavItem(
                  icon: Icons.add_rounded,
                  text: 'New Chat',
                  index: 0,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomePage()),
                    );
                  },
                ),
                const SizedBox(height: 8),
                _buildNavItem(
                  icon: Icons.history_rounded,
                  text: 'History',
                  index: 1,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HistoryPage()),
                    );
                  },
                ),
                const SizedBox(height: 8),
                _buildNavItem(
                  icon: Icons.person_outline_rounded,
                  text: 'Profile',
                  index: 2,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfilePage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.proButton,
              borderRadius: BorderRadius.circular(16),
            ),
            child: GestureDetector(
              onTap: _toggleSidebar,
              child: Icon(
                isCollapsed
                    ? Icons.keyboard_arrow_right_rounded
                    : Icons.keyboard_arrow_left_rounded,
                size: 20,
                color: AppColors.iconGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String text,
    required int index,
    required VoidCallback onPressed,
  }) {
    final isHovered = _hoveredIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: EdgeInsets.symmetric(
            vertical: 12,
            horizontal: isCollapsed ? 8 : 16,
          ),
          decoration: BoxDecoration(
            color: isHovered ? Colors.white.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: isCollapsed
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 18,
                color: isHovered ? Colors.white : AppColors.iconGrey,
              ),
              if (!isCollapsed) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    text,
                    style: GoogleFonts.lexend(
                      fontSize: 13,
                      color: isHovered ? Colors.white : AppColors.iconGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

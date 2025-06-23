import 'package:flutter/material.dart';
import 'package:perplexity_clone/theme/colors.dart';

class SearchBarButton extends StatefulWidget {
  final String text;
  final IconData icon;
  const SearchBarButton({super.key,required this.text,required this.icon});

  @override
  State<SearchBarButton> createState() => _SearchBarButtonState();
}

class _SearchBarButtonState extends State<SearchBarButton> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => isHover = true),
      onExit: (event) => setState(() => isHover = false),
      child: Container(
      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color:isHover ? AppColors.proButton : Colors.transparent
      ),
      child: Row(
        children: [
          Icon(widget.icon,color: AppColors.iconGrey,size: 20,),
          const SizedBox(width: 8,),
          Text(widget.text,style: TextStyle(color: AppColors.textGrey),)
        ],
      ),
    ),
    );
  }
}
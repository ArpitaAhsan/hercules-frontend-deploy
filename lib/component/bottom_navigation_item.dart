import 'package:flutter/material.dart';
import 'package:hercules/location_page.dart';

class BottomNavigationItem extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon; // FIX: Change type from String to IconData
  final Menus current;
  final Menus name;

  const BottomNavigationItem({
    super.key,
    required this.onPressed,
    required this.icon, // Fix applied here
    required this.current,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = current == name;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: (isActive && name != Menus.add) ? const Color(0xFFE3F2FD) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: 28, // Adjust size to avoid clipping
                color: isActive ? Colors.black87 : Colors.black38,
              ),
            ),

            const SizedBox(height: 4),
            Container(
              height: 4,
              width: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? Colors.black87 : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
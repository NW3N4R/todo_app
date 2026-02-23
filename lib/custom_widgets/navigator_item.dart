import 'package:flutter/material.dart';
import 'package:todo_app/themes.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final int index;
  final int currentIndex;
  const ButtonWidget({
    required this.text,
    required this.icon,
    required this.onPressed,
    required this.index,
    required this.currentIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: FittedBox(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: currentIndex == index
                ? AppThemes.getPrimaryColor(context).withAlpha(50)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: currentIndex != index
                    ? const Color.fromARGB(255, 105, 104, 104)
                    : AppThemes.getPrimaryColor(context),
              ),
              // Text(
              //   text,
              //   style: const TextStyle(fontSize: 16, color: Colors.white),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:todo_app/themes.dart';

enum Severity { error, warning, info }

class BannerToast {
  static OverlayEntry? _currentEntry;
  static void showbanner({
    required BuildContext context,
    required String message,
    required Severity severity,
  }) {
    _currentEntry?.remove();
    _currentEntry = null;
    final color = switch (severity) {
      Severity.error => AppThemes.getOrange(context),
      Severity.warning => AppThemes.getBlue(context),
      Severity.info => AppThemes.getGreen(context),
    };

    final icon = switch (severity) {
      Severity.error => Icons.error,
      Severity.warning => Icons.warning,
      Severity.info => Icons.done,
    };
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top, // below status bar
        left: 8,
        right: 8,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withAlpha(120),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color),
            ),
            child: Row(
              children: [
                Icon(icon),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    _currentEntry = entry;
    Future.delayed(Duration(seconds: 2), () {
      if (entry.mounted) entry.remove();
      if (_currentEntry == entry) _currentEntry = null;
    });
  }
}

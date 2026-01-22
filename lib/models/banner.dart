import 'package:flutter/material.dart';

enum Severity { error, warning, info }

class banner {
  static OverlayEntry? _currentEntry;

  static void showbanner({
    required BuildContext context,
    required String message,
    required Severity severity,
  }) {
    _currentEntry?.remove();
    _currentEntry = null;
    final color = switch (severity) {
      Severity.error => Colors.red.withValues(alpha: 0.8),
      Severity.warning => Colors.orange,
      Severity.info => Colors.greenAccent,
    };

    final icon = switch (severity) {
      Severity.error => Icons.error,
      Severity.warning => Icons.warning,
      Severity.info => Icons.info,
    };
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 8, // below status bar
        left: 8,
        right: 8,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.white, fontSize: 17),
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
    Future.delayed(Duration(seconds: 3), () {
      if (entry.mounted) entry.remove();
      if (_currentEntry == entry) _currentEntry = null;
    });
  }
}

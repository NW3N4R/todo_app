import 'package:flutter/material.dart';

class SharedAppbar {
  static AppBar myAppBar(ValueChanged<String> func) {
    return AppBar(
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  maxLength: 25,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: func,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

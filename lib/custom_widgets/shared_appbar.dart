import 'package:flutter/material.dart';
import 'package:todo_app/pages/new_todo.dart';

class SharedAppbar {
  static AppBar myAppBar(ValueChanged<String> func, BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      title: Row(
        children: [
          Expanded(
            child: TextField(
              maxLength: 25,
              onChanged: func,
              decoration: InputDecoration(
                hintText: 'گەڕان',
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: false,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewTodo()),
            ),
            child: Text(
              'ئەرکی نوێ',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}

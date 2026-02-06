import 'package:flutter/material.dart';
import 'package:todo_app/pages/new_todo.dart';

class SharedAppbar {
  static AppBar myAppBar(ValueChanged<String> func, BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewTodo()),
            ),
          ),

          Expanded(
            child: TextField(
              maxLength: 25,
              decoration: InputDecoration(
                hintText: 'گەڕان',
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

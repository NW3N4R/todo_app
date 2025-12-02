import 'package:flutter/material.dart';
import 'package:todo_app/custom_widgets/navigator_item.dart';
import 'package:todo_app/pages/home.dart';
import 'package:todo_app/pages/new_todo.dart';

//Kalar Techincal Insitute
//Department of Information Technology
//Mobile Application Development Lecture
//Supervisor: Mr. Nahro Nooraldin
//Developed By :
//Nwenar Ismael Abbas
//Hanan Ayad Osman
//Mariam Ali Hussein
//‌Hedy Qadir Ahmad
//project Repository on Github:
//https://github.com/NW3N4R/todo_app.git
void main() {
  runApp(MaterialApp(home: const MainScreen()));
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

int currentIndex = 0;

class _MainScreenState extends State<MainScreen> {
  void onNavTap(int index) {
    setState(() {
      currentIndex = index;
      print(index);
    });
  }

  List<Widget> pages = [
    Home(key: ValueKey('active')),
    Home(key: ValueKey('completed')),
    const NewTodo(),
  ];
  String? selectedValue = 'accending';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[currentIndex],
      bottomNavigationBar: SafeArea(
        child: Row(
          mainAxisSize: MainAxisSize.min, // Shrinks the Row to fit its children
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly, // Centers the buttons
          children: [
            ButtonWidget(
              text: 'Home',
              icon: Icons.home,
              onPressed: () => onNavTap(0),
              index: 0,
              currentIndex: currentIndex,
            ),
            ButtonWidget(
              text: 'Completed',
              icon: Icons.done,
              onPressed: () => onNavTap(1),
              index: 1,
              currentIndex: currentIndex,
            ),
            ButtonWidget(
              text: 'Profile',
              icon: Icons.add,
              onPressed: () => onNavTap(2),
              index: 2,
              currentIndex: currentIndex,
            ),
          ],
        ),
      ),
    );
  }
}

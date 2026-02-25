import 'package:flutter/material.dart';
import 'package:todo_app/models/homemodel.dart';
import 'package:todo_app/services/todoservice.dart';
import 'package:todo_app/themes.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with HomeModel {
  @override
  void initState() {
    initiateDb();
    super.initState();
  }

  var filteredTodos = [];

  void initiateDb() async {
    await TodoService.openDB();
    await load();
    setState(() {
      filteredTodos = todosOfThisWeek();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Text('داشبۆرد', style: Theme.of(context).textTheme.bodyLarge),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.wrap_text_rounded)),
          ],
        ),
        body: Container(
          margin: EdgeInsets.only(top: 40),
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              progressCard(),
              SizedBox(
                height: 160,
                child: GridView(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 1.2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  children: [
                    detailsCard('ئەرکە تەواو بووەکان', completedTodos()),
                    detailsCard('ئەرکە تەواو نە بووەکان', activeTodos()),
                    detailsCard('ئەرکە بەسەر چووەکان', overDueTodos()),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'ئەرکەکانی ئەم هەفتەیە',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: filteredTodos.length,
                  itemBuilder: (context, index) {
                    final todo = filteredTodos[index];
                    return latestCard(todo.title, todo.description);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget progressCard() {
    return Container(
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
      decoration: BoxDecoration(
        color: AppThemes.getYellow(context),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ئەرکە ماوەکان',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppThemes.getPrimaryBg(context).withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.timer_sharp, color: Colors.black),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.today_outlined, color: Colors.black, size: 54),
                SizedBox(width: 20),
                Text(
                  activeTodos().toString(),
                  style: TextStyle(
                    fontSize: 54,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
            Text(
              '${activeTodos()} ئەر ماوە لە ${allTodos.length}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            SizedBox(
              height: 10,
              child: LinearProgressIndicator(
                value: remainingTodos(),
                minHeight: 3,
                borderRadius: BorderRadius.circular(8),
                backgroundColor: AppThemes.getPrimaryBg(context).withAlpha(50),
                valueColor: AlwaysStoppedAnimation(Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detailsCard(String label, Object no) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppThemes.getSecondaryBg(context),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacer(),
          Center(
            child: Text(
              no.toString(),
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontSize: 42),
            ),
          ),
          Spacer(),
          Text(
            label,
            softWrap: true,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget latestCard(String label, String caption) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: AppThemes.getSecondaryBg(context),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(fontSize: 20),
          ),
          Text(
            caption,
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

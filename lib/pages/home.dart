import 'package:flutter/material.dart';
import 'package:todo_app/pages/new_todo.dart';
import 'package:todo_app/themes.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewTodo()),
              ),
              icon: Icon(Icons.mode),
            ),
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
                    detailsCard('ئەرکە تەواو بووەکان', 8),
                    detailsCard('ئەرکە تەواو نە بووەکان', 4.3),
                    detailsCard('ئەرکە تەواو بەسەر چووەکان', 12),
                    detailsCard('ئەرکە تەواو بەسەر چووەکان', 18),
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
                child: GridView(
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 4.2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 0,
                  ),
                  children: [
                    latestCard('ناونیشانی ئەرک', 'پێناسەی ئەرک'),
                    latestCard('ناونیشانی ئەرک', 'پێناسەی ئەرک'),
                    latestCard('ناونیشانی ئەرک', 'پێناسەی ئەرک'),
                  ],
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
                  '4',
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
              '4 ئەرک ماوە لە8 دانە',
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
                value: 0.45,
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

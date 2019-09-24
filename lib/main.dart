import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_todo/pages/tasks_page.dart';
import 'package:quick_todo/providers/task_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (_) => TaskProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: Colors.green,
          buttonColor: Colors.green,
        ),
        home: TasksPage(),
      ),
    );
  }
}

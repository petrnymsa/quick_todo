import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:quick_todo/models/task.dart';

enum TaskFilter {
  All,
  Completed,
  UnCompleted,
}

class TaskProvider with ChangeNotifier {
  int _lastId = 3;
  TaskFilter _filter;

  List<Task> _items = [
    Task(id: 1, title: 'Prepare demo', completed: true),
    Task(id: 2, title: 'Present demo'),
    Task(id: 3, title: 'Get feedback'),
  ];

  UnmodifiableListView<Task> get tasks => _filterItems();

  UnmodifiableListView<Task> _filterItems() {
    if (_filter == TaskFilter.Completed)
      return UnmodifiableListView(_items.where((x) => x.completed));
    else if (_filter == TaskFilter.UnCompleted)
      return UnmodifiableListView(_items.where((x) => !x.completed));

    return UnmodifiableListView(_items);
  }

  void setFilter(TaskFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  void addTask(String title) {
    _items.add(Task(id: _lastId + 1, title: title));
    _lastId++;
    notifyListeners();
  }

  void toggleTask(int id) {
    final task = _items.firstWhere((t) => t.id == id);
    task.completed = !task.completed;

    notifyListeners();
  }
}

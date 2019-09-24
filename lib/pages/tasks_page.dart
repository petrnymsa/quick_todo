import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_todo/models/task.dart';
import 'package:quick_todo/providers/task_provider.dart';

class TasksPage extends StatelessWidget {
  _onFilterSelected(BuildContext context, TaskFilter filter) {
    Provider.of<TaskProvider>(context, listen: false)
        .setFilter(filter); //! will not rebuild widget, just provides access
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your tasks'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.filter_list),
            onSelected: (value) => _onFilterSelected(context, value),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('All'),
                value: TaskFilter.All,
              ),
              PopupMenuItem(
                child: Text('Completed'),
                value: TaskFilter.Completed,
              ),
              PopupMenuItem(
                child: Text('Not completed'),
                value: TaskFilter.UnCompleted,
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Consumer<TaskProvider>(
            builder: (ctx, taskProvider, ch) => Expanded(
              child: ListView.builder(
                itemCount: taskProvider.tasks.length,
                itemBuilder: (_, i) => _TaskItem(taskProvider.tasks[i]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AddTask(),
          ),
        ],
      ),
    );
  }
}

class _TaskItem extends StatelessWidget {
  final Task _task;

  _TaskItem(this._task);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_task.title),
      trailing: IconButton(
        icon: Icon(
            _task.completed ? Icons.check_box : Icons.check_box_outline_blank),
        color: Theme.of(context).primaryColor,
        onPressed: () {
          Provider.of<TaskProvider>(context, listen: false)
              .toggleTask(_task.id);
        },
      ),
    );
  }
}

class AddTask extends StatefulWidget {
  AddTask({Key key}) : super(key: key);

  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  String _title;
  final _formKey = GlobalKey<FormState>();

  void _onSubmitted() {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();

    // save it
    Provider.of<TaskProvider>(context, listen: false).addTask(_title);

    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Task added',
          textAlign: TextAlign.center,
        ),
        duration: const Duration(microseconds: 800),
      ),
    );

    _formKey.currentState.reset();
    // hide keyboard
    FocusScope.of(context).unfocus();
  }

  String _validateTitle(String newValue) {
    if (newValue.isEmpty) return 'Title can not be empty';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(labelText: 'Task'),
              textInputAction: TextInputAction.send,
              onSaved: (value) => _title = value,
              onFieldSubmitted: (_) => _onSubmitted(),
              validator: _validateTitle,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _onSubmitted,
          )
        ],
      ),
    );
  }
}

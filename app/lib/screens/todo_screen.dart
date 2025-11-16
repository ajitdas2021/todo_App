
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import '../model/todo.dart';
import '../service/api_service.dart';
import 'pomodro_screen.dart'; // Focus/Pomodoro screen

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _controller = TextEditingController();
  String rawData = '';

  void fetchRawData() async {
    try {
      final data = await ApiService().fetchTodos();
      setState(() {
        rawData = data.map((e) => e.toJson().toString()).join('\n');
      });
    } catch (e) {
      setState(() {
        rawData = 'Error fetching data: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TodoBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO BLoC App'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Add Todo Input
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration:
                        const InputDecoration(labelText: 'Enter a task'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      bloc.add(AddTodo(_controller.text));
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),

          // Raw API Data Button
          ElevatedButton(
            onPressed: fetchRawData,
            child: const Text('View Raw API Data'),
          ),

          // Display Raw API Data
          if (rawData.isNotEmpty)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: Text(rawData, style: const TextStyle(fontSize: 14)),
              ),
            ),

          // Display Todos
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                if (state is TodoLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TodoLoaded) {
                  // Split into ongoing and completed tasks
                  final ongoing = state.todos.where((t) => !t.completed).toList();
                  final done = state.todos.where((t) => t.completed).toList();

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ongoing Tasks
                        if (ongoing.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Ongoing Tasks",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: ongoing.length,
                            itemBuilder: (context, index) {
                              final Todo todo = ongoing[index];
                              return ListTile(
                                title: Text(todo.title),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.timer, color: Colors.green),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => PomodoroScreen(
                                              taskId: todo.id, 
                                              taskTitle: todo.title),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => bloc.add(DeleteTodo(todo.id)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],

                        // Completed Tasks
                        if (done.isNotEmpty) ...[
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Completed Tasks",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: Colors.green),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: done.length,
                            itemBuilder: (context, index) {
                              final Todo todo = done[index];
                              return ListTile(
                                title: Text(
                                  todo.title,
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => bloc.add(DeleteTodo(todo.id)),
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  );
                } else if (state is TodoError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text('No tasks found.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

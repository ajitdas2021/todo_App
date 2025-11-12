// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import '../bloc/todo_bloc.dart';
// // import '../bloc/todo_event.dart';
// // import '../bloc/todo_state.dart';

// // class TodoScreen extends StatelessWidget {
// //   const TodoScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     context.read<TodoBloc>().add(LoadTodos());

// //     final TextEditingController controller = TextEditingController();

// //     return Scaffold(
// //       appBar: AppBar(title: const Text('TODO App - BLoC + Dio')),
// //       body: BlocBuilder<TodoBloc, TodoState>(
// //         builder: (context, state) {
// //           if (state is TodoLoading) return const Center(child: CircularProgressIndicator());
// //           if (state is TodoError) return Center(child: Text(state.message));
// //           if (state is TodoLoaded) {
// //             return Column(
// //               children: [
// //                 Expanded(
// //                   child: ListView.builder(
// //                     itemCount: state.todos.length,
// //                     itemBuilder: (context, index) {
// //                       final todo = state.todos[index];
// //                       return ListTile(
// //                         title: Text(todo.title),
// //                         trailing: IconButton(
// //                           icon: const Icon(Icons.delete),
// //                           onPressed: () => context.read<TodoBloc>().add(DeleteTodo(todo.id)),
// //                         ),
// //                       );
// //                     },
// //                   ),
// //                 ),
// //                 Padding(
// //                   padding: const EdgeInsets.all(8.0),
// //                   child: Row(
// //                     children: [
// //                       Expanded(
// //                         child: TextField(controller: controller, decoration: const InputDecoration(hintText: 'New Task')),
// //                       ),
// //                       IconButton(
// //                         icon: const Icon(Icons.add),
// //                         onPressed: () {
// //                           if (controller.text.isNotEmpty) {
// //                             context.read<TodoBloc>().add(AddTodo(controller.text));
// //                             controller.clear();
// //                           }
// //                         },
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             );
// //           }
// //           return const SizedBox();
// //         },
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../bloc/todo_bloc.dart';
// import '../bloc/todo_event.dart';
// import '../bloc/todo_state.dart';
// import '../model/todo.dart';

// class TodoScreen extends StatefulWidget {
//   const TodoScreen({super.key});

//   @override
//   State<TodoScreen> createState() => _TodoScreenState();
// }

// class _TodoScreenState extends State<TodoScreen> {
//   final TextEditingController _controller = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     // Load initial todos from API
//     context.read<TodoBloc>().add(LoadTodos());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('BLoC + Dio TODO App'),
//         backgroundColor: Colors.blueAccent,
//         centerTitle: true,
//       ),
//       body: BlocBuilder<TodoBloc, TodoState>(
//         builder: (context, state) {
//           if (state is TodoLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is TodoLoaded) {
//             final todos = state.todos;
//             return Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: _controller,
//                           decoration: const InputDecoration(
//                             hintText: 'Enter a task...',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       ElevatedButton(
//                         onPressed: () {
//                           if (_controller.text.trim().isNotEmpty) {
//                             context
//                                 .read<TodoBloc>()
//                                 .add(AddTodo(_controller.text.trim()));
//                             _controller.clear();
//                           }
//                         },
//                         child: const Text('Add'),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: todos.length,
//                     itemBuilder: (context, index) {
//                       final todo = todos[index];
//                       return Card(
//                         margin:
//                             const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                         child: ListTile(
//                           title: Text(todo.title),
//                           trailing: IconButton(
//                             icon: const Icon(Icons.delete, color: Colors.red),
//                             onPressed: () {
//                               context.read<TodoBloc>().add(DeleteTodo(todo.id));
//                             },
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             );
//           } else if (state is TodoError) {
//             return Center(
//               child: Text(
//                 state.message,
//                 style: const TextStyle(color: Colors.red),
//               ),
//             );
//           } else {
//             return const Center(child: Text('No tasks available.'));
//           }
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import '../model/todo.dart';
import '../service/api_service.dart';

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
                  return ListView.builder(
                    itemCount: state.todos.length,
                    itemBuilder: (context, index) {
                      final Todo todo = state.todos[index];
                      return ListTile(
                        title: Text(todo.title),
                        trailing: IconButton(
                          icon:
                              const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => bloc.add(DeleteTodo(todo.id)),
                        ),
                      );
                    },
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

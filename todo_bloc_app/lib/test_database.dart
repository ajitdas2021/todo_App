// Create this as lib/test_database.dart temporarily
import 'package:flutter/material.dart';
import 'di/service_locator.dart';
import 'data/repository/todo_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const TestDatabaseApp());
}

class TestDatabaseApp extends StatelessWidget {
  const TestDatabaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Database Test')),
        body: const TestDatabaseScreen(),
      ),
    );
  }
}

class TestDatabaseScreen extends StatefulWidget {
  const TestDatabaseScreen({super.key});

  @override
  State<TestDatabaseScreen> createState() => _TestDatabaseScreenState();
}

class _TestDatabaseScreenState extends State<TestDatabaseScreen> {
  String status = 'Testing...';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    testDatabase();
  }

  Future<void> testDatabase() async {
    try {
      setState(() {
        status = 'Step 1: Setting up locator...';
      });
      
      await setupLocator();
      
      setState(() {
        status = 'Step 2: Getting repository...';
      });
      
      final repo = getIt<TodoRepository>();
      
      setState(() {
        status = 'Step 3: Adding test todo...';
      });
      
      await repo.addTodo('Test Todo ${DateTime.now().millisecond}');
      
      setState(() {
        status = 'Step 4: Fetching todos...';
      });
      
      final todos = await repo.fetchTodos();
      
      setState(() {
        status = '✅ SUCCESS!\nFound ${todos.length} todos';
        isLoading = false;
      });
    } catch (e, stackTrace) {
      setState(() {
        status = '❌ ERROR:\n$e\n\nStack:\n$stackTrace';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const CircularProgressIndicator()
            else
              const Icon(
                Icons.check_circle,
                size: 64,
                color: Colors.green,
              ),
            const SizedBox(height: 20),
            Text(
              status,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
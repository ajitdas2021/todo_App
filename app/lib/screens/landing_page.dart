
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'todo_screen.dart';
import '../bloc/theme_bloc.dart';
import '../bloc/theme_event.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeBloc = context.read<ThemeBloc>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Welcome'),
        actions: [
          // Three-dot menu
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'toggle_theme') {
                themeBloc.add(ToggleTheme());
              } else if (value == 'toggle_font') {
                themeBloc.add(ToggleFont());
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'toggle_theme',
                child: Text('Toggle Light/Dark Mode'),
              ),
              const PopupMenuItem(
                value: 'toggle_font',
                child: Text('Toggle Font'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to ToDo App',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Built by Ajit Das',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TodoScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text(
                  'Go to Home Page',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

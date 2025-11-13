import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';

class PomodoroScreen extends StatefulWidget {
  final int taskId;
  final String taskTitle;

  const PomodoroScreen({
    super.key,
    required this.taskId,
    required this.taskTitle,
  });

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isRunning = false;

  // Start the timer with given minutes
  void _startFocusTimer(int minutes) {
    setState(() {
      _remainingSeconds = minutes * 60;
      _isRunning = true;
    });

    _timer?.cancel(); // cancel any existing timer

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        _showCompletionDialog();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  // Dialog to ask user if task is done or needs more time
  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Focus Time Ended"),
        content: const Text("Did you complete this task or need more time?"),
        actions: [
          TextButton(
            onPressed: () {
              context.read<TodoBloc>().add(MarkTodoDone(widget.taskId));
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // back to main screen
            },
            child: const Text("✅ Completed"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickNewTime();
            },
            child: const Text("⏱️ More Time"),
          ),
        ],
      ),
    );
  }

  // Show dialog to pick new focus time
  void _pickNewTime() async {
    final minutes = await showDialog<int>(
      context: context,
      builder: (_) => const FocusTimePickerDialog(),
    );
    if (minutes != null) {
      _startFocusTimer(minutes);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(title: Text("Focus: ${widget.taskTitle}")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isRunning)
              ElevatedButton(
                onPressed: _pickNewTime,
                child: const Text("Start Focus Session"),
              ),
            if (_isRunning) ...[
              Text(
                "$minutes:$seconds",
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _timer?.cancel();
                  setState(() => _isRunning = false);
                },
                child: const Text("Cancel"),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

// Dialog to pick focus time
class FocusTimePickerDialog extends StatefulWidget {
  const FocusTimePickerDialog({super.key});

  @override
  State<FocusTimePickerDialog> createState() => _FocusTimePickerDialogState();
}

class _FocusTimePickerDialogState extends State<FocusTimePickerDialog> {
  int _selectedMinutes = 25;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Focus Time'),
      content: DropdownButton<int>(
        value: _selectedMinutes,
        items: [1, 10, 15, 20, 25, 30, 45, 60]
            .map((m) => DropdownMenuItem(value: m, child: Text('$m minutes')))
            .toList(),
        onChanged: (value) => setState(() => _selectedMinutes = value!),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, _selectedMinutes),
          child: const Text('Start'),
        ),
      ],
    );
  }
}

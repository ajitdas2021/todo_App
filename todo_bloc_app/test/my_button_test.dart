// test/my_button_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:todo_bloc_app/my_button.dart';


void main() {
  testWidgets('MyButton displays correct label and triggers callback',
      (WidgetTester tester) async {
    bool pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: MyButton(
          label: 'Press Me',
          onPressed: () {
            pressed = true;
          },
        ),
      ),
    );

    // Check if label is shown
    expect(find.text('Press Me'), findsOneWidget);

    // Tap the button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify callback triggered
    expect(pressed, isTrue);
  });
}


// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'bloc/theme_bloc.dart';
// import 'bloc/theme_state.dart';
// import 'bloc/todo_bloc.dart';
// import 'bloc/todo_event.dart';
// import 'service/api_service.dart';
// import 'screens/landing_page.dart';

// void main() {
//   final apiService = ApiService();
//   runApp(MyApp(apiService: apiService));
// }

// class MyApp extends StatelessWidget {
//   final ApiService apiService;
//   const MyApp({super.key, required this.apiService});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (_) => ThemeBloc()),
//         BlocProvider(create: (_) => TodoBloc(apiService)..add(LoadTodos())),
//       ],
//       child: BlocBuilder<ThemeBloc, ThemeState>(
//         builder: (context, themeState) {
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             theme: themeState.themeData.copyWith(
//               elevatedButtonTheme: ElevatedButtonThemeData(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: themeState.buttonColor,
//                   textStyle: TextStyle(
//                     fontFamily:
//                         themeState.isCustomFont ? 'Courier' : 'Roboto',
//                   ),
//                 ),
//               ),
//             ),
//             home: const LandingPage(),
//           );
//         },
//       ),
//     );
//   }
// }


// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/theme_bloc.dart';
import 'bloc/theme_state.dart';
import 'bloc/todo_bloc.dart';
import 'bloc/todo_event.dart';
import 'screens/landing_page.dart';
import 'di/service_locator.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup dependency injection
  await setupLocator();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()),
        // Get TodoBloc from GetIt service locator
        BlocProvider(
          create: (_) => getIt<TodoBloc>()..add(LoadTodos()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeState.themeData.copyWith(
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeState.buttonColor,
                  textStyle: TextStyle(
                    fontFamily:
                        themeState.isCustomFont ? 'Courier' : 'Roboto',
                  ),
                ),
              ),
            ),
            home: const LandingPage(),
          );
        },
      ),
    );
  }
}
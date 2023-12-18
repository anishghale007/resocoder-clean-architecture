import 'package:flutter/material.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const NumberTriviaPage(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green.shade800,
        ),
        primaryColor: Colors.green.shade800,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.green.shade600),
      ),
    );
  }
}

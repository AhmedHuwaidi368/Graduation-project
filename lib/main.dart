import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'تطبيق أمل',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFE0F7F5), // تركوازي فاتح للخلفية
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00897B), // تركوازي داكن أنيق
          foregroundColor: Colors.white, // لون نص العنوان بالأبيض
          centerTitle: true,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const MyHomePage(title: 'تطبيق أمل'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const SizedBox.expand(), // صفحة فارغة بدون عناصر
    );
  }
}

import 'package:example/lite_forms_page.dart';
import 'package:flutter/material.dart';
import 'package:lite_forms/utils/controller_initializer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    /// Must be called in the beginning. 
    /// Basically that's all you need 
    /// to start using Lite Forms
    initializeLiteForms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lite Forms Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LiteFormsPage(),
    );
  }
}


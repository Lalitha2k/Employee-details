import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'employee_screen.dart'; // Import the EmployeeScreen file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Display App',
      debugShowCheckedModeBanner: false,
      home: EmployeeScreen(),
    );
  }
}

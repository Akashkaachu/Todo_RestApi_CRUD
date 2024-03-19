import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tudoput/presentations/tudo_page_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      home: const TodoPageList(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white, textTheme: TextTheme()),
    );
  }
}


import 'package:flutter/material.dart';

import '../chart_view.dart';

class LocalApp extends StatelessWidget {
  const LocalApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ChartView(name: "50_panel", ticker: "AAPL", theme: "dark",),
    );
  }
}

void runTheApp() {
  runApp(const LocalApp());
}
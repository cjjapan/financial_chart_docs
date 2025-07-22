import 'dart:js_interop';
import 'dart:ui_web';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'chart_view.dart';
import 'multi_view_app.dart';

extension type ChartViewParam._(JSObject _) implements JSObject {
  external ChartViewParam(String name, String ticker, String theme);
  external factory ChartViewParam.onlyName(String name);

  external String name;
  external String ticker;
  external String theme;
}

void main() {
  if (kIsWeb) {
    runWidget(
      MultiViewApp(
        viewBuilder: (BuildContext context) {
          final int viewId = View.of(context).viewId;
          final data = views.getInitialData(viewId) as ChartViewParam?;
          if (data != null) {
            // Use the initial data to set up the view.
            print(
              "Chart view $viewId: ticker: ${data.ticker}, name: ${data.name}, theme: ${data.theme}",
            );
          }
          return MaterialApp(
            title: null,
            home: ChartView(
              ticker: data?.ticker ?? "AAPL",
              theme: data?.theme ?? "light",
            ),
          );
        },
      ),
    );
  } else {
    runApp(const LocalApp());
  }
}

class LocalApp extends StatelessWidget {
  const LocalApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ChartView(ticker: "AAPL"),
    );
  }
}


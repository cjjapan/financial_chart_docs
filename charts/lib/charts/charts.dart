import 'dart:math';

import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/rendering.dart';

part '10_start.dart';
part '20_graph.dart';
part '30_tooltip.dart';
part '40_markers.dart';
part '50_panel.dart';

GChart buildChart(String name, GDataSource dataSource, String theme) {
  switch (name) {
    case "10_start":
      return chart_10(dataSource, theme);
    case "20_graph":
      return chart_20(dataSource, theme);
    case "30_tooltip":
      return chart_30(dataSource, theme);
    case "40_markers":
      return chart_40(dataSource, theme);
    case "50_panel":
      return chart_50(dataSource, theme);
    default:
      throw Exception("Chart '$name' is not implemented.");
  }
}

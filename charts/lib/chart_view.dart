import 'dart:convert';

import 'package:charts/yahoo_finance_candle_data.dart';
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<YahooFinanceResponse> loadYahooFinanceData(String ticker) async {
  Map<String, dynamic> json = {};
  String fileName = "$ticker.json";
  final content = await rootBundle.loadString('assets/$fileName');
  json = jsonDecode(content);
  return YahooFinanceResponse.fromJson(json);
}

class ChartView extends StatefulWidget {
  final String ticker;
  final String theme;

  const ChartView({super.key, required this.ticker, this.theme= "dark"});

  @override
  State<ChartView> createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> with TickerProviderStateMixin {
  late Future<YahooFinanceResponse> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = loadYahooFinanceData(widget.ticker);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _dataFuture,
      builder:
          (BuildContext context, AsyncSnapshot<YahooFinanceResponse> data) {
        if (data.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (data.hasError) {
          return Center(child: Text('Error: ${data.error}'));
        } else if (!data.hasData || data.data == null) {
          return const Center(child: Text('No data available'));
        }
        final response = data.data!;
        final dataSource = GDataSource<int, GData<int>>(
          dataList: response.candlesData.map((candle) {
            return GData<int>(
              pointValue: candle.date.millisecondsSinceEpoch,
              seriesValues: [
                candle.open,
                candle.high,
                candle.low,
                candle.close,
              ],
            );
          }).toList(),
          seriesProperties: [
            GDataSeriesProperty(key: "open", label: "Open", precision: 2),
            GDataSeriesProperty(key: "high", label: "High", precision: 2),
            GDataSeriesProperty(key: "low", label: "Low", precision: 2),
            GDataSeriesProperty(key: "close", label: "Close", precision: 2),
          ],
        );
        final chart = GChart(
          dataSource: dataSource,
          theme: widget.theme == "dark" ? GThemeDark() : GThemeLight(),
          panels: [
            GPanel(
              pointAxes: [GPointAxis()],
              valueAxes: [GValueAxis()],
              valueViewPorts: [
                GValueViewPort(
                  valuePrecision: 2,
                  autoScaleStrategy: GValueViewPortAutoScaleStrategyMinMax(
                    dataKeys: ["high", "low"],
                    marginStart: GSize.viewHeightRatio(0.3),
                  ),
                ),
              ],
              graphs: [
                GGraphGrids(),
                GGraphOhlc(
                  ohlcValueKeys: const ["open", "high", "low", "close"],
                ),
              ],
            ),
          ],
        );
        return GChartWidget(chart: chart, tickerProvider: this);
      },
    );
  }
}


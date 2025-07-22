---
title: Getting started
---

## Installing

Go to your flutter application project directory and run this command to install the latest version.
```bash
flutter pub add financial_chart
```

Or add the library directly to `dependencies` section in `pubspec.yaml` and run `flutter pub get`.

```yaml
dependencies:
  flutter:
    sdk: flutter
  # add this line with version no.
  financial_chart: ^latest_version
```

## Importing

```dart
import 'package:financial_chart/financial_chart.dart'
```


## Preparing chart data

Load your chart data from remote API, assets or anywhere.

```dart
final response = await loadChartData();
```

Convert your data to chart dataSource.

```dart
final dataSource = GDataSource<int, GData<int>>(
    // list of series data which each is a GData object.
    dataList: response.candlesData.map((candle) {
        return GData<int>(
            // pointValue decides the value on X axis. usually it is a timestamp.
            pointValue: candle.date.millisecondsSinceEpoch,
            // seriesValues decides values on Y axes.
            seriesValues: [
                candle.open,
                candle.high,
                candle.low,
                candle.close,
            ],
        );
    }).toList(),
    // properties of series data. 
    // It is mapped to seriesValues by index so the length should be exact same as seriesValues.
    seriesProperties: const [
        GDataSeriesProperty(key: 'open', label: 'Open', precision: 2),
        GDataSeriesProperty(key: 'high', label: 'High', precision: 2),
        GDataSeriesProperty(key: 'low', label: 'Low', precision: 2),
        GDataSeriesProperty(key: 'close', label: 'Close', precision: 2),
    ],
);

```

## Setup the chart

```dart
final chart = GChart(
    // the data source for the chart.
    dataSource: dataSource,
    // the theme.
    theme: GThemeDark(),
    // One or more panels.
    panels: [
        GPanel(
            valueViewPorts: [
                // A value viewport controls visible range along Y axis.
                // It is being used by axes and graphs to render on canvas correctly.
                GValueViewPort(
                    id: "price",
                    valuePrecision: 2,
                    autoScaleStrategy: GValueViewPortAutoScaleStrategyMinMax(
                        dataKeys: ["high", "low"],
                    ),
                ),
            ],
            // Y Axes
            valueAxes: [GValueAxis()],
            // X Axes
            pointAxes: [GPointAxis()],
            graphs: [
                // valuesKeys should be valid keys defined in dataSource seriesProperties.
                GGraphOhlc(ohlcValueKeys: const ["open", "high", "low", "close"]),
            ],
        ),
    ],
);

```

## Add the chart widget


```dart

class ChartDemoPage extends StatefulWidget {
  const ChartDemoPage({super.key});

  @override
  ChartDemoPageState createState() => ChartDemoPageState();
}

class ChartDemoPageState extends State<ChartDemoPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chart demo"), centerTitle: true),
      body: Container(
        padding: const EdgeInsets.all(10),
        // the chart widget
        child: GChartWidget(chart: chart, tickerProvider: this),
      );
  }
}
```

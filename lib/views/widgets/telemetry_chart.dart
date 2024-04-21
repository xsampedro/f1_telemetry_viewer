import 'package:f1_telemetry_viewer/services/car_data.dart';
import 'package:f1_telemetry_viewer/services/driver.dart';
import 'package:f1_telemetry_viewer/services/session.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math';

class TelemetryChart extends StatelessWidget {
  final Map<int, List<CarData>> dataByDriver;
  final String title;
  final num Function(CarData) valueExtractor;
  final Session session;
  final List<Driver> selectedDrivers;
  final List<DateTimeAxisController> axisControllers;

  const TelemetryChart({super.key,
    required this.dataByDriver,
    required this.title,
    required this.valueExtractor,
    required this.session,
    required this.selectedDrivers,
    required this.axisControllers,
  });

  @override
  Widget build(BuildContext context) {
    List<LineSeries<CarData, DateTime>> seriesList =
    dataByDriver.entries.map((entry) {
      var driver = selectedDrivers
          .firstWhere((driver) => driver.driverNumber == entry.key);
      int? colorValue = int.tryParse('0xFF${driver.teamColour}');
      Color parsedColor = colorValue != null ? Color(colorValue) : Colors.grey;
      return LineSeries<CarData, DateTime>(
        dataSource: entry.value,
        name: driver.nameAcronym,
        color: parsedColor,
        xValueMapper: (CarData data, _) => data.date,
        yValueMapper: (CarData data, _) => valueExtractor(data),
        enableTooltip: true,
      );
    }).toList();

    double maxValue = seriesList
        .map((series) => series.dataSource!.map(valueExtractor).reduce(max))
        .reduce(max)
        .toDouble();
    double minValue = seriesList
        .map((series) => series.dataSource!.map(valueExtractor).reduce(min))
        .reduce(min)
        .toDouble();

    return SfCartesianChart(
      title: ChartTitle(text: title),
      legend: const Legend(
          isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      primaryXAxis: DateTimeAxis(
        initialVisibleMinimum: session.dateStart,
        initialVisibleMaximum:
        session.dateStart.add(const Duration(minutes: 1)),
        minimum: session.dateStart,
        maximum: session.dateEnd,
        onRendererCreated: (args) {
          axisControllers.add(args);
        },
      ),
      primaryYAxis: NumericAxis(minimum: minValue, maximum: maxValue),
      onZooming: (args) {
        if (args.axis!.name == 'primaryXAxis') {
          for (var controller in axisControllers) {
            if (controller.zoomPosition != args.currentZoomPosition) {
              controller.zoomPosition = args.currentZoomPosition;
            }
            if (controller.zoomFactor != args.currentZoomFactor) {
              controller.zoomFactor = args.currentZoomFactor;
            }
          }
        }
      },
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
        enablePanning: true,
        zoomMode: ZoomMode.x,
      ),
      series: seriesList,
      tooltipBehavior: TooltipBehavior(
        enable: true,
        builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
          return DefaultTextStyle(
            style: const TextStyle(color: Colors.white),
            child: Text('${point.y}'),
          );
        },
      ),
    );
  }
}
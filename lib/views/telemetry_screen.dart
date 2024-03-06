import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:f1_telemetry_viewer/services/meeting.dart';
import 'package:f1_telemetry_viewer/services/api_service.dart';
import 'package:f1_telemetry_viewer/services/car_data.dart';
import 'package:f1_telemetry_viewer/services/session.dart';
import 'package:f1_telemetry_viewer/services/driver.dart';

class TelemetryScreen extends StatefulWidget {
  final Meeting meeting;
  final Session session;
  final List<Driver> selectedDrivers;

  const TelemetryScreen(
      {super.key,
      required this.meeting,
      required this.session,
      required this.selectedDrivers});

  @override
  State<TelemetryScreen> createState() => _TelemetryScreenState();
}

class _TelemetryScreenState extends State<TelemetryScreen> {
  late Future<void> initialLoadFuture;
  Map<int, List<CarData>> allData = {};
  double progress = 0.0;
  static const int chunkSizeInMinutes = 10;
  List<DateTimeAxisController> axisControllers =
      []; // Reintegrated for synchronized chart control

  @override
  void initState() {
    super.initState();
    initialLoadFuture = fetchInitialCarDataForDrivers();
  }

  Future<void> fetchInitialCarDataForDrivers() async {
    DateTime sessionStart = widget.session.dateStart;
    DateTime sessionEnd = widget.session.dateEnd;
    int totalChunks =
        ((sessionEnd.difference(sessionStart).inMinutes) / chunkSizeInMinutes)
            .ceil();

    for (var driver in widget.selectedDrivers) {
      allData[driver.driverNumber] = [];
    }

    // Load initial chunk of data
    for (int i = 0; i < totalChunks; i++) {
      DateTime chunkStart =
          sessionStart.add(Duration(minutes: i * chunkSizeInMinutes));
      DateTime chunkEnd = i < totalChunks - 1
          ? sessionStart.add(Duration(minutes: (i + 1) * chunkSizeInMinutes))
          : sessionEnd;

      for (var driver in widget.selectedDrivers) {
        List<CarData> newData = await ApiService().getCarData(
          sessionKey: widget.session.sessionKey,
          driverNumber: driver.driverNumber,
          startDate: chunkStart.toIso8601String(),
          endDate: chunkEnd.toIso8601String(),
        );
        setState(() {
          allData[driver.driverNumber]?.addAll(newData);
          progress = (i + 1) / totalChunks;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    axisControllers.clear(); // Clear existing controllers

    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.meeting.meetingName} - ${widget.session.sessionName} Telemetry'),
      ),
      body: FutureBuilder<void>(
        future: initialLoadFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              progress < 1.0) {
            return Column(
              children: [
                LinearProgressIndicator(value: progress),
                const Expanded(child: Center(child: Text('Loading data...'))),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  buildChart(allData, 'Speed', (CarData data) => data.speed),
                  buildChart(allData, 'RPM', (CarData data) => data.rpm),
                  buildChart(allData, 'Gear', (CarData data) => data.nGear),
                  buildChart(
                      allData, 'Throttle', (CarData data) => data.throttle),
                  buildChart(allData, 'Brake', (CarData data) => data.brake),
                  buildChart(allData, 'DRS', (CarData data) => data.drs),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  SfCartesianChart buildChart(Map<int, List<CarData>> dataByDriver,
      String title, num Function(CarData) valueExtractor) {
    List<LineSeries<CarData, DateTime>> seriesList =
        dataByDriver.entries.map((entry) {
      var driver = widget.selectedDrivers
          .firstWhere((driver) => driver.driverNumber == entry.key);
      int? colorValue = int.tryParse('0xFF${driver.teamColour}');
      Color parsedColor = colorValue != null ? Color(colorValue) : Colors.grey;
      return LineSeries<CarData, DateTime>(
        dataSource: entry.value,
        name: driver.nameAcronym,
        color: parsedColor,
        xValueMapper: (CarData data, _) => data.date,
        yValueMapper: (CarData data, _) => valueExtractor(data),
      );
    }).toList();

    return SfCartesianChart(
      title: ChartTitle(text: title),
      legend: const Legend(
          isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      primaryXAxis: DateTimeAxis(
        initialVisibleMinimum: widget.session.dateStart,
        initialVisibleMaximum:
            widget.session.dateStart.add(const Duration(minutes: 1)),
        minimum: widget.session.dateStart,
        maximum: widget.session.dateEnd,
        onRendererCreated: (args) {
          axisControllers.add(args);
        },
      ),
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
    );
  }
}

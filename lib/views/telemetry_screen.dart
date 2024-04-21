import 'package:f1_telemetry_viewer/views/widgets/telemetry_chart.dart';
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
  String loadingDriver = "";

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
        setState(() {
          loadingDriver = driver.fullName;
        });
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
                Expanded(child: Center(child: Text('Loading data for $loadingDriver...'))),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  TelemetryChart(
                    dataByDriver: allData,
                    title: 'Speed',
                    valueExtractor: (CarData data) => data.speed,
                    session: widget.session,
                    selectedDrivers: widget.selectedDrivers,
                    axisControllers: axisControllers,
                  ),
                  TelemetryChart(
                    dataByDriver: allData,
                    title: 'RPM',
                    valueExtractor: (CarData data) => data.rpm,
                    session: widget.session,
                    selectedDrivers: widget.selectedDrivers,
                    axisControllers: axisControllers,
                  ),
                  TelemetryChart(
                    dataByDriver: allData,
                    title: 'Gear',
                    valueExtractor: (CarData data) => data.nGear,
                    session: widget.session,
                    selectedDrivers: widget.selectedDrivers,
                    axisControllers: axisControllers,
                  ),
                  TelemetryChart(
                    dataByDriver: allData,
                    title: 'Throttle',
                    valueExtractor: (CarData data) => data.throttle,
                    session: widget.session,
                    selectedDrivers: widget.selectedDrivers,
                    axisControllers: axisControllers,
                  ),
                  TelemetryChart(
                    dataByDriver: allData,
                    title: 'Brake',
                    valueExtractor: (CarData data) => data.brake,
                    session: widget.session,
                    selectedDrivers: widget.selectedDrivers,
                    axisControllers: axisControllers,
                  ),
                  TelemetryChart(
                    dataByDriver: allData,
                    title: 'DRS',
                    valueExtractor: (CarData data) => data.drs,
                    session: widget.session,
                    selectedDrivers: widget.selectedDrivers,
                    axisControllers: axisControllers,
                  ),                ],
              ),
            );
          }
        },
      ),
    );
  }
}
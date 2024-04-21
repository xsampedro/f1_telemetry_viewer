import 'package:f1_telemetry_viewer/views/widgets/telemetry_chart.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:f1_telemetry_viewer/services/meeting.dart';
import 'package:f1_telemetry_viewer/services/api_service.dart';
import 'package:f1_telemetry_viewer/services/car_data.dart';
import 'package:f1_telemetry_viewer/services/session.dart';
import 'package:f1_telemetry_viewer/services/driver.dart';
import 'package:dropdown_button2/dropdown_button2.dart';


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
  List<String> selectedTelemetryDataTypes = [];

  @override
  void initState() {
    super.initState();
    selectedTelemetryDataTypes = ['Speed', 'RPM'];
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
    //axisControllers.clear(); // Clear existing controllers

    // List of telemetry data types
    final List<String> telemetryDataTypes = [
      'Speed',
      'RPM',
      'Gear',
      'Throttle',
      'Brake',
      'DRS',
    ];


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
            return Column(
              children: [
                // Dropdown menu for selecting telemetry data types
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: Text(
                      'Select Telemetry Data Types',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: telemetryDataTypes.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        //disable default onTap to avoid closing menu when selecting an item
                        enabled: false,
                        child: StatefulBuilder(
                          builder: (context, menuSetState) {
                            final isSelected = selectedTelemetryDataTypes.contains(item);
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  isSelected
                                      ? selectedTelemetryDataTypes.remove(item)
                                      : selectedTelemetryDataTypes.add(item);
                                });
                                //This rebuilds the dropdownMenu Widget to update the check mark
                                menuSetState(() {});
                              },
                              child: Container(
                                height: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Row(
                                  children: [
                                    if (isSelected)
                                      const Icon(Icons.check_box_outlined)
                                    else
                                      const Icon(Icons.check_box_outline_blank),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                    //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                    value: selectedTelemetryDataTypes.isEmpty ? null : selectedTelemetryDataTypes.last,
                    onChanged: (value) {},
                    selectedItemBuilder: (context) {
                      return telemetryDataTypes.map(
                            (item) {
                          return Container(
                            alignment: AlignmentDirectional.center,
                            child: Text(
                              selectedTelemetryDataTypes.join(', '),
                              style: const TextStyle(
                                fontSize: 14,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                          );
                        },
                      ).toList();
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.only(left: 16, right: 8),
                      height: 40,
                      width: 140,
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
                // Display the selected telemetry charts
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: selectedTelemetryDataTypes.map((selectedTelemetryDataType) {
                        return TelemetryChart(
                          dataByDriver: allData,
                          title: selectedTelemetryDataType,
                          valueExtractor: (CarData data) {
                            switch (selectedTelemetryDataType) {
                              case 'Speed':
                                return data.speed;
                              case 'RPM':
                                return data.rpm;
                              case 'Gear':
                                return data.nGear;
                              case 'Throttle':
                                return data.throttle;
                              case 'Brake':
                                return data.brake;
                              case 'DRS':
                                return data.drs;
                              default:
                                return data.speed;
                            }
                          },
                          session: widget.session,
                          selectedDrivers: widget.selectedDrivers,
                          axisControllers: axisControllers,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:f1_telemetry_viewer/services/meeting.dart';
import 'package:f1_telemetry_viewer/services/api_service.dart';
import 'package:f1_telemetry_viewer/services/driver.dart';
import 'package:f1_telemetry_viewer/services/session.dart';
import 'package:f1_telemetry_viewer/views/telemetry_screen.dart';

class DriversScreen extends StatefulWidget {
  final Meeting meeting;
  final Session session;

  const DriversScreen(
      {super.key, required this.meeting, required this.session});

  @override
  State<DriversScreen> createState() => _DriversScreenState();
}

class _DriversScreenState extends State<DriversScreen> {
  final List<Driver> selectedDrivers = [];
  late Future<List<Driver>> driversFuture;

  @override
  void initState() {
    super.initState();
    driversFuture =
        ApiService().getDrivers(sessionKey: widget.session.sessionKey);
  }

  void _goToTelemetryScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelemetryScreen(
          meeting: widget.meeting,
          session: widget.session,
          selectedDrivers: selectedDrivers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.meeting.meetingName} - ${widget.session.sessionName} Drivers'),
      ),
      body: FutureBuilder<List<Driver>>(
        future: driversFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Driver> drivers = snapshot.data!;
            return ListView.builder(
              itemCount: drivers.length,
              itemBuilder: (context, index) {
                Driver driver = drivers[index];
                bool isSelected = selectedDrivers.contains(driver);
                return Card(
                  color: isSelected ? Colors.green[100] : null,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          driver.headshotUrl), // Use driver's headshot
                      backgroundColor: Colors.transparent,
                    ),
                    title: Text(driver.fullName),
                    subtitle:
                        Text('${driver.teamName} - ${driver.countryCode}'),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.check_circle_outline),
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedDrivers.remove(driver);
                        } else {
                          selectedDrivers.add(driver);
                        }
                      });
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No drivers found'));
          }
        },
      ),
      floatingActionButton: selectedDrivers.isNotEmpty
          ? FloatingActionButton.extended(
              icon: const Icon(Icons.arrow_forward),
              label: Text('${selectedDrivers.length} Selected'),
              onPressed: _goToTelemetryScreen,
            )
          : null,
    );
  }
}

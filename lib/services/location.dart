class Location {
  final DateTime date;
  final int driverNumber;
  final int meetingKey;
  final int sessionKey;
  final double x;
  final double y;
  final double z;

  Location({
    required this.date,
    required this.driverNumber,
    required this.meetingKey,
    required this.sessionKey,
    required this.x,
    required this.y,
    required this.z,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        date: DateTime.parse(json['date'] as String),
        driverNumber: json['driver_number'] as int,
        meetingKey: json['meeting_key'] as int,
        sessionKey: json['session_key'] as int,
        x: json['x'] as double,
        y: json['y'] as double,
        z: json['z'] as double,
      );

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'driver_number': driverNumber,
        'meeting_key': meetingKey,
        'session_key': sessionKey,
        'x': x,
        'y': y,
        'z': z,
      };
}

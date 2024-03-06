class PitStop {
  final DateTime date;
  final int driverNumber;
  final int lapNumber;
  final int meetingKey;
  final double pitDuration;
  final int sessionKey;

  PitStop({
    required this.date,
    required this.driverNumber,
    required this.lapNumber,
    required this.meetingKey,
    required this.pitDuration,
    required this.sessionKey,
  });

  factory PitStop.fromJson(Map<String, dynamic> json) => PitStop(
        date: DateTime.parse(json['date'] as String),
        driverNumber: json['driver_number'] as int,
        lapNumber: json['lap_number'] as int,
        meetingKey: json['meeting_key'] as int,
        pitDuration: json['pit_duration'] as double,
        sessionKey: json['session_key'] as int,
      );

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'driver_number': driverNumber,
        'lap_number': lapNumber,
        'meeting_key': meetingKey,
        'pit_duration': pitDuration,
        'session_key': sessionKey,
      };
}

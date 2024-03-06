class PositionUpdate {
  final DateTime date;
  final int driverNumber;
  final int meetingKey;
  final int position;
  final int sessionKey;

  PositionUpdate({
    required this.date,
    required this.driverNumber,
    required this.meetingKey,
    required this.position,
    required this.sessionKey,
  });

  factory PositionUpdate.fromJson(Map<String, dynamic> json) => PositionUpdate(
        date: DateTime.parse(json['date'] as String),
        driverNumber: json['driver_number'] as int,
        meetingKey: json['meeting_key'] as int,
        position: json['position'] as int,
        sessionKey: json['session_key'] as int,
      );

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'driver_number': driverNumber,
        'meeting_key': meetingKey,
        'position': position,
        'session_key': sessionKey,
      };
}

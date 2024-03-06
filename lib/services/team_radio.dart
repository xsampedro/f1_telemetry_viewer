class TeamRadio {
  final DateTime date;
  final int driverNumber;
  final int meetingKey;
  final String recordingUrl;
  final int sessionKey;

  TeamRadio({
    required this.date,
    required this.driverNumber,
    required this.meetingKey,
    required this.recordingUrl,
    required this.sessionKey,
  });

  factory TeamRadio.fromJson(Map<String, dynamic> json) => TeamRadio(
        date: DateTime.parse(json['date'] as String),
        driverNumber: json['driver_number'] as int,
        meetingKey: json['meeting_key'] as int,
        recordingUrl: json['recording_url'] as String,
        sessionKey: json['session_key'] as int,
      );

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'driver_number': driverNumber,
        'meeting_key': meetingKey,
        'recording_url': recordingUrl,
        'session_key': sessionKey,
      };
}

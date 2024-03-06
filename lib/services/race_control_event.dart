class RaceControlEvent {
  final String category;
  final DateTime date;
  final int driverNumber;
  final String? flag;
  final int lapNumber;
  final int meetingKey;
  final String message;
  final String scope;
  final int? sector;
  final int sessionKey;

  RaceControlEvent({
    required this.category,
    required this.date,
    required this.driverNumber,
    this.flag,
    required this.lapNumber,
    required this.meetingKey,
    required this.message,
    required this.scope,
    this.sector,
    required this.sessionKey,
  });

  factory RaceControlEvent.fromJson(Map<String, dynamic> json) =>
      RaceControlEvent(
        category: json['category'] as String,
        date: DateTime.parse(json['date'] as String),
        driverNumber: json['driver_number'] as int,
        flag: json['flag'] as String?,
        lapNumber: json['lap_number'] as int,
        meetingKey: json['meeting_key'] as int,
        message: json['message'] as String,
        scope: json['scope'] as String,
        sector: json['sector'] as int?,
        sessionKey: json['session_key'] as int,
      );

  Map<String, dynamic> toJson() => {
        'category': category,
        'date': date.toIso8601String(),
        'driver_number': driverNumber,
        'flag': flag,
        'lap_number': lapNumber,
        'meeting_key': meetingKey,
        'message': message,
        'scope': scope,
        'sector': sector,
        'session_key': sessionKey,
      };
}

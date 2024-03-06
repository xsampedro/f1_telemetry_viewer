class Interval {
  final DateTime date;
  final int driverNumber;
  final double? gapToLeader;
  final double? interval;
  final int meetingKey;
  final int sessionKey;

  Interval({
    required this.date,
    required this.driverNumber,
    this.gapToLeader,
    this.interval,
    required this.meetingKey,
    required this.sessionKey,
  });

  factory Interval.fromJson(Map<String, dynamic> json) => Interval(
        date: DateTime.parse(json['date'] as String),
        driverNumber: json['driver_number'] as int,
        gapToLeader: json['gap_to_leader'] as double?,
        interval: json['interval'] as double?,
        meetingKey: json['meeting_key'] as int,
        sessionKey: json['session_key'] as int,
      );

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'driver_number': driverNumber,
        'gap_to_leader': gapToLeader,
        'interval': interval,
        'meeting_key': meetingKey,
        'session_key': sessionKey,
      };
}

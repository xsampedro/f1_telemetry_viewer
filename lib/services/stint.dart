class Stint {
  final String compound;
  final int driverNumber;
  final int lapEnd;
  final int lapStart;
  final int meetingKey;
  final int sessionKey;
  final int stintNumber;
  final int tyreAgeAtStart;

  Stint({
    required this.compound,
    required this.driverNumber,
    required this.lapEnd,
    required this.lapStart,
    required this.meetingKey,
    required this.sessionKey,
    required this.stintNumber,
    required this.tyreAgeAtStart,
  });

  factory Stint.fromJson(Map<String, dynamic> json) => Stint(
        compound: json['compound'] as String,
        driverNumber: json['driver_number'] as int,
        lapEnd: json['lap_end'] as int,
        lapStart: json['lap_start'] as int,
        meetingKey: json['meeting_key'] as int,
        sessionKey: json['session_key'] as int,
        stintNumber: json['stint_number'] as int,
        tyreAgeAtStart: json['tyre_age_at_start'] as int,
      );

  Map<String, dynamic> toJson() => {
        'compound': compound,
        'driver_number': driverNumber,
        'lap_end': lapEnd,
        'lap_start': lapStart,
        'meeting_key': meetingKey,
        'session_key': sessionKey,
        'stint_number': stintNumber,
        'tyre_age_at_start': tyreAgeAtStart,
      };
}

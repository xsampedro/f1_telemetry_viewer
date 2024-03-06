class Session {
  final int circuitKey;
  final String circuitShortName;
  final String countryCode;
  final int countryKey;
  final String countryName;
  final DateTime dateEnd;
  final DateTime dateStart;
  final Duration gmtOffset;
  final String location;
  final int meetingKey;
  final int sessionKey;
  final String sessionName;
  final String sessionType;
  final int year;

  Session({
    required this.circuitKey,
    required this.circuitShortName,
    required this.countryCode,
    required this.countryKey,
    required this.countryName,
    required this.dateEnd,
    required this.dateStart,
    required this.gmtOffset,
    required this.location,
    required this.meetingKey,
    required this.sessionKey,
    required this.sessionName,
    required this.sessionType,
    required this.year,
  });

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        circuitKey: json['circuit_key'] as int,
        circuitShortName: json['circuit_short_name'] as String,
        countryCode: json['country_code'] as String,
        countryKey: json['country_key'] as int,
        countryName: json['country_name'] as String,
        dateEnd: DateTime.parse(json['date_end'] as String),
        dateStart: DateTime.parse(json['date_start'] as String),
        gmtOffset: Duration(
            hours: int.parse(json['gmt_offset'].split(':')[0]),
            minutes: int.parse(json['gmt_offset'].split(':')[1])),
        location: json['location'] as String,
        meetingKey: json['meeting_key'] as int,
        sessionKey: json['session_key'] as int,
        sessionName: json['session_name'] as String,
        sessionType: json['session_type'] as String,
        year: json['year'] as int,
      );

  Map<String, dynamic> toJson() => {
        'circuit_key': circuitKey,
        'circuit_short_name': circuitShortName,
        'country_code': countryCode,
        'country_key': countryKey,
        'country_name': countryName,
        'date_end': dateEnd.toIso8601String(),
        'date_start': dateStart.toIso8601String(),
        'gmt_offset': gmtOffset.toString(),
        'location': location,
        'meeting_key': meetingKey,
        'session_key': sessionKey,
        'session_name': sessionName,
        'session_type': sessionType,
        'year': year,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Session &&
          runtimeType == other.runtimeType &&
          circuitKey == other.circuitKey &&
          sessionKey == other.sessionKey;

  @override
  int get hashCode => circuitKey.hashCode ^ sessionKey.hashCode;
}

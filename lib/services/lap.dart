class Lap {
  final DateTime dateStart;
  final int driverNumber;
  final double durationSector1;
  final double durationSector2;
  final double durationSector3;
  final int i1Speed;
  final int i2Speed;
  final bool isPitOutLap;
  final double lapDuration;
  final int lapNumber;
  final int meetingKey;
  final List<int> segmentsSector1;
  final List<int> segmentsSector2;
  final List<int> segmentsSector3;
  final int sessionKey;
  final int stSpeed;

  Lap({
    required this.dateStart,
    required this.driverNumber,
    required this.durationSector1,
    required this.durationSector2,
    required this.durationSector3,
    required this.i1Speed,
    required this.i2Speed,
    required this.isPitOutLap,
    required this.lapDuration,
    required this.lapNumber,
    required this.meetingKey,
    required this.segmentsSector1,
    required this.segmentsSector2,
    required this.segmentsSector3,
    required this.sessionKey,
    required this.stSpeed,
  });

  factory Lap.fromJson(Map<String, dynamic> json) => Lap(
        dateStart: DateTime.parse(json['date_start'] as String),
        driverNumber: json['driver_number'] as int,
        durationSector1: json['duration_sector_1'] as double,
        durationSector2: json['duration_sector_2'] as double,
        durationSector3: json['duration_sector_3'] as double,
        i1Speed: json['i1_speed'] as int,
        i2Speed: json['i2_speed'] as int,
        isPitOutLap: json['is_pit_out_lap'] as bool,
        lapDuration: json['lap_duration'] as double,
        lapNumber: json['lap_number'] as int,
        meetingKey: json['meeting_key'] as int,
        segmentsSector1:
            (json['segments_sector_1'] as List).map((i) => i as int).toList(),
        segmentsSector2:
            (json['segments_sector_2'] as List).map((i) => i as int).toList(),
        segmentsSector3:
            (json['segments_sector_3'] as List).map((i) => i as int).toList(),
        sessionKey: json['session_key'] as int,
        stSpeed: json['st_speed'] as int,
      );

  Map<String, dynamic> toJson() => {
        'date_start': dateStart.toIso8601String(),
        'driver_number': driverNumber,
        'duration_sector_1': durationSector1,
        'duration_sector_2': durationSector2,
        'duration_sector_3': durationSector3,
        'i1_speed': i1Speed,
        'i2_speed': i2Speed,
        'is_pit_out_lap': isPitOutLap,
        'lap_duration': lapDuration,
        'lap_number': lapNumber,
        'meeting_key': meetingKey,
        'segments_sector_1': segmentsSector1.map((i) => i).toList(),
        'segments_sector_2': segmentsSector2.map((i) => i).toList(),
        'segments_sector_3': segmentsSector3.map((i) => i).toList(),
        'session_key': sessionKey,
        'st_speed': stSpeed,
      };
}

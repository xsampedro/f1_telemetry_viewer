class CarData {
  final int brake;
  final DateTime date;
  final int driverNumber;
  final int drs;
  final int meetingKey;
  final int nGear;
  final int rpm;
  final int sessionKey;
  final int speed;
  final int throttle;

  CarData({
    required this.brake,
    required this.date,
    required this.driverNumber,
    required this.drs,
    required this.meetingKey,
    required this.nGear,
    required this.rpm,
    required this.sessionKey,
    required this.speed,
    required this.throttle,
  });

  CarData.placeholder({
    required this.driverNumber,
    required this.date,
  })  : brake = 0,
        drs = 0,
        meetingKey = 0,
        nGear = 0,
        rpm = 0,
        sessionKey = 0,
        speed = 0,
        throttle = 0;

  factory CarData.fromJson(Map<String, dynamic> json) {
    return CarData(
      brake: json['brake'],
      date: DateTime.parse(json['date']),
      driverNumber: json['driver_number'],
      drs: json['drs'],
      meetingKey: json['meeting_key'],
      nGear: json['n_gear'],
      rpm: json['rpm'],
      sessionKey: json['session_key'],
      speed: json['speed'],
      throttle: json['throttle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brake': brake,
      'date': date.toIso8601String(),
      'driver_number': driverNumber,
      'drs': drs,
      'meeting_key': meetingKey,
      'n_gear': nGear,
      'rpm': rpm,
      'session_key': sessionKey,
      'speed': speed,
      'throttle': throttle,
    };
  }

  @override
  int get hashCode {
    return Object.hash(
      brake,
      date,
      driverNumber,
      drs,
      meetingKey,
      nGear,
      rpm,
      sessionKey,
      speed,
      throttle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CarData &&
        other.brake == brake &&
        other.date == date &&
        other.driverNumber == driverNumber &&
        other.drs == drs &&
        other.meetingKey == meetingKey &&
        other.nGear == nGear &&
        other.rpm == rpm &&
        other.sessionKey == sessionKey &&
        other.speed == speed &&
        other.throttle == throttle;
  }
}

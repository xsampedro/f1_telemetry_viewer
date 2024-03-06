class Weather {
  final double airTemperature;
  final DateTime date;
  final int humidity;
  final int meetingKey;
  final double pressure;
  final bool rainfall;
  final int sessionKey;
  final double trackTemperature;
  final int windDirection;
  final double windSpeed;

  Weather({
    required this.airTemperature,
    required this.date,
    required this.humidity,
    required this.meetingKey,
    required this.pressure,
    required this.rainfall,
    required this.sessionKey,
    required this.trackTemperature,
    required this.windDirection,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        airTemperature: json['air_temperature'] as double,
        date: DateTime.parse(json['date'] as String),
        humidity: json['humidity'] as int,
        meetingKey: json['meeting_key'] as int,
        pressure: json['pressure'] as double,
        rainfall: json['rainfall'] as bool,
        sessionKey: json['session_key'] as int,
        trackTemperature: json['track_temperature'] as double,
        windDirection: json['wind_direction'] as int,
        windSpeed: json['wind_speed'] as double,
      );

  Map<String, dynamic> toJson() => {
        'air_temperature': airTemperature,
        'date': date.toIso8601String(),
        'humidity': humidity,
        'meeting_key': meetingKey,
        'pressure': pressure,
        'rainfall': rainfall,
        'session_key': sessionKey,
        'track_temperature': trackTemperature,
        'wind_direction': windDirection,
        'wind_speed': windSpeed,
      };
}

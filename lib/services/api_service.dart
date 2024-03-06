import 'package:http/http.dart' as http;
import 'dart:convert';
import 'meeting.dart';
import 'car_data.dart';
import 'driver.dart';
import 'interval.dart';
import 'lap.dart';
import 'location.dart';
import 'pit_stop.dart';
import 'position_update.dart';
import 'race_control_event.dart';
import 'session.dart';
import 'stint.dart';
import 'team_radio.dart';
import 'weather.dart';

class ApiService {
  final String baseUrl = 'https://api.openf1.org/v1';

  Future<List<T>> _fetchData<T>({
    required Uri uri,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    print(uri);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      //print(response.body);
      final body = json.decode(utf8.decode(response.bodyBytes)) as List;
      return body
          .map((dynamic item) => fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  Future<List<Meeting>> getMeetings({
    int? year,
    String? circuitKeyName,
    String? circuitShortName,
    String? countryCode,
    int? countryKey,
    String? countryName,
    String? dateStart,
    String? gmtOffset,
    String? location,
    int? meetingKey,
    String? meetingName,
    String? meetingOfficialName,
  }) async {
    final queryParams = <String, dynamic>{
      if (year != null) 'year': year.toString(),
      if (circuitKeyName != null) 'circuit_key': circuitKeyName,
      if (circuitShortName != null) 'circuit_short_name': circuitShortName,
      if (countryCode != null) 'country_code': countryCode,
      if (countryKey != null) 'country_key': countryKey.toString(),
      if (countryName != null) 'country_name': countryName,
      if (dateStart != null) 'date_start': dateStart,
      if (gmtOffset != null) 'gmt_offset': gmtOffset,
      if (location != null) 'location': location,
      if (meetingKey != null) 'meeting_key': meetingKey.toString(),
      if (meetingName != null) 'meeting_name': meetingName,
      if (meetingOfficialName != null)
        'meeting_official_name': meetingOfficialName,
    };
    Uri uri =
        Uri.parse('$baseUrl/meetings').replace(queryParameters: queryParams);
    return _fetchData<Meeting>(uri: uri, fromJson: Meeting.fromJson);
  }

  Future<List<CarData>> getCarData({
    int? driverNumber,
    int? sessionKey,
    int? meetingKey,
    String? startDate,
    String? endDate,
    int? drs,
    int? nGear,
    int? rpm,
    int? speed,
    int? throttle,
  }) async {
    // Exclude startDate and endDate from the initial queryParams map
    final queryParams = <String, dynamic>{
      if (driverNumber != null) 'driver_number': driverNumber.toString(),
      if (sessionKey != null) 'session_key': sessionKey.toString(),
      if (meetingKey != null) 'meeting_key': meetingKey.toString(),
      if (drs != null) 'drs': drs.toString(),
      if (nGear != null) 'n_gear': nGear.toString(),
      if (rpm != null) 'rpm': rpm.toString(),
      if (speed != null) 'speed': speed.toString(),
      if (throttle != null) 'throttle': throttle.toString(),
    };

    Uri uri =
        Uri.parse('$baseUrl/car_data').replace(queryParameters: queryParams);

    // Manually append startDate and endDate, ensuring no %3D encoding
    String finalUriStr = uri.toString();
    if (startDate != null) {
      finalUriStr += '&date>=$startDate';
    }
    if (endDate != null) {
      finalUriStr += '&date<=$endDate';
    }

    Uri finalUri = Uri.parse(finalUriStr);

    return _fetchData<CarData>(uri: finalUri, fromJson: CarData.fromJson);
  }

  Future<List<Driver>> getDrivers({
    int? driverNumber,
    int? sessionKey,
  }) async {
    final queryParams = <String, dynamic>{
      if (driverNumber != null) 'driver_number': driverNumber.toString(),
      if (sessionKey != null) 'session_key': sessionKey.toString(),
    };
    Uri uri =
        Uri.parse('$baseUrl/drivers').replace(queryParameters: queryParams);
    return _fetchData<Driver>(uri: uri, fromJson: Driver.fromJson);
  }

  Future<List<Interval>> getIntervals({
    required int sessionKey,
    double? interval, // Optional filter
  }) async {
    final queryParams = <String, dynamic>{
      'session_key': sessionKey.toString(),
      if (interval != null) 'interval': interval.toString(),
    };
    Uri uri =
        Uri.parse('$baseUrl/intervals').replace(queryParameters: queryParams);
    return _fetchData<Interval>(uri: uri, fromJson: Interval.fromJson);
  }

  Future<List<Lap>> getLaps({
    required int sessionKey,
    int? driverNumber,
    int? lapNumber,
  }) async {
    final queryParams = <String, dynamic>{
      'session_key': sessionKey.toString(),
      if (driverNumber != null) 'driver_number': driverNumber.toString(),
      if (lapNumber != null) 'lap_number': lapNumber.toString(),
    };
    Uri uri = Uri.parse('$baseUrl/laps').replace(queryParameters: queryParams);
    return _fetchData<Lap>(uri: uri, fromJson: Lap.fromJson);
  }

  Future<List<Location>> getLocation({
    required int sessionKey,
    required int driverNumber,
    required DateTime after,
    required DateTime before,
  }) async {
    final queryParams = <String, dynamic>{
      'session_key': sessionKey.toString(),
      'driver_number': driverNumber.toString(),
      'date>': after.toIso8601String(),
      'date<': before.toIso8601String(),
    };
    Uri uri =
        Uri.parse('$baseUrl/location').replace(queryParameters: queryParams);
    return _fetchData<Location>(uri: uri, fromJson: Location.fromJson);
  }

  Future<List<PitStop>> getPitStops({
    required int sessionKey,
    double? pitDurationLessThan, // Optional filter
  }) async {
    final queryParams = <String, dynamic>{
      'session_key': sessionKey.toString(),
      if (pitDurationLessThan != null)
        'pit_duration<': pitDurationLessThan.toString(),
    };
    Uri uri = Uri.parse('$baseUrl/pit').replace(queryParameters: queryParams);
    return _fetchData<PitStop>(uri: uri, fromJson: PitStop.fromJson);
  }

  Future<List<PositionUpdate>> getPosition({
    required int meetingKey,
    required int driverNumber,
    int? positionLessThan, // Optional filter
  }) async {
    final queryParams = <String, dynamic>{
      'meeting_key': meetingKey.toString(),
      'driver_number': driverNumber.toString(),
      if (positionLessThan != null) 'position<=': positionLessThan.toString(),
    };
    Uri uri =
        Uri.parse('$baseUrl/position').replace(queryParameters: queryParams);
    return _fetchData<PositionUpdate>(
        uri: uri, fromJson: PositionUpdate.fromJson);
  }

  Future<List<RaceControlEvent>> getRaceControlEvents({
    String? flag,
    int? driverNumber,
    required DateTime after,
    required DateTime before,
  }) async {
    final queryParams = <String, dynamic>{
      'date>': after.toIso8601String(),
      'date<': before.toIso8601String(),
      if (flag != null) 'flag': flag,
      if (driverNumber != null) 'driver_number': driverNumber.toString(),
    };
    Uri uri = Uri.parse('$baseUrl/race_control')
        .replace(queryParameters: queryParams);
    return _fetchData<RaceControlEvent>(
        uri: uri, fromJson: RaceControlEvent.fromJson);
  }

  Future<List<Session>> getSessions({
    int? meetingKey,
    String? countryName,
    String? sessionName,
    int? year,
  }) async {
    final queryParams = <String, dynamic>{
      if (meetingKey != null) 'meeting_key': meetingKey.toString(),
      if (countryName != null) 'country_name': countryName,
      if (sessionName != null) 'session_name': sessionName,
      if (year != null) 'year': year.toString(),
    };

    try {
      Uri uri = Uri.parse('$baseUrl/sessions');
      uri = uri.replace(queryParameters: queryParams);
      return _fetchData<Session>(uri: uri, fromJson: Session.fromJson);
    } catch (e) {
      //print(e);
      return [];
    }
  }

  Future<List<Stint>> getStints({
    required int sessionKey,
    int? tyreAgeAtStartFrom, // Optional filter
  }) async {
    final queryParams = <String, dynamic>{
      'session_key': sessionKey.toString(),
      if (tyreAgeAtStartFrom != null)
        'tyre_age_at_start>=': tyreAgeAtStartFrom.toString(),
    };
    Uri uri =
        Uri.parse('$baseUrl/stints').replace(queryParameters: queryParams);
    return _fetchData<Stint>(uri: uri, fromJson: Stint.fromJson);
  }

  Future<List<TeamRadio>> getTeamRadio({
    required int sessionKey,
    int? driverNumber,
  }) async {
    final queryParams = <String, dynamic>{
      'session_key': sessionKey.toString(),
      if (driverNumber != null) 'driver_number': driverNumber.toString(),
    };
    Uri uri =
        Uri.parse('$baseUrl/team_radio').replace(queryParameters: queryParams);
    return _fetchData<TeamRadio>(uri: uri, fromJson: TeamRadio.fromJson);
  }

  Future<List<Weather>> getWeather({
    required int meetingKey,
    double? airTemperatureFrom,
    double? humidityFrom,
    double? pressureFrom,
    bool? rainfall,
    int? sessionKey,
    double? trackTemperatureFrom,
    int? windDirectionFrom,
    double? windSpeedFrom,
  }) async {
    final queryParams = <String, dynamic>{
      'meeting_key': meetingKey.toString(),
      if (airTemperatureFrom != null)
        'air_temperature>=': airTemperatureFrom.toString(),
      if (humidityFrom != null) 'humidity>=': humidityFrom.toString(),
      if (pressureFrom != null) 'pressure>=': pressureFrom.toString(),
      if (rainfall != null) 'rainfall': rainfall.toString(),
      if (sessionKey != null) 'session_key': sessionKey.toString(),
      if (trackTemperatureFrom != null)
        'track_temperature>=': trackTemperatureFrom.toString(),
      if (windDirectionFrom != null)
        'wind_direction>=': windDirectionFrom.toString(),
      if (windSpeedFrom != null) 'wind_speed>=': windSpeedFrom.toString(),
    };
    Uri uri =
        Uri.parse('$baseUrl/weather').replace(queryParameters: queryParams);
    return _fetchData<Weather>(uri: uri, fromJson: Weather.fromJson);
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String responseBody;

  ApiException(this.statusCode, this.responseBody);

  @override
  String toString() =>
      'ApiException: StatusCode: $statusCode, Body: $responseBody';
}

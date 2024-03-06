class Driver {
  final String broadcastName;
  final String countryCode;
  final int driverNumber;
  final String firstName;
  final String fullName;
  final String headshotUrl;
  final String lastName;
  final int meetingKey;
  final String nameAcronym;
  final int sessionKey;
  final String teamColour;
  final String teamName;

  Driver({
    required this.broadcastName,
    required this.countryCode,
    required this.driverNumber,
    required this.firstName,
    required this.fullName,
    required this.headshotUrl,
    required this.lastName,
    required this.meetingKey,
    required this.nameAcronym,
    required this.sessionKey,
    required this.teamColour,
    required this.teamName,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {

    String parseTeamColour(dynamic value) {
      if (value is String) {
        return value;
      } else if (value is int) {
        // Convert the integer to a string or handle it according to your application's needs
        // This example assumes you want to convert the integer to its hexadecimal string representation
        return value.toRadixString(16).padLeft(6, '0'); // Convert to a hex color code
      } else {
        return 'N/A'; // Default case if the value is neither String nor int
      }
    }

    return Driver(
        broadcastName: json['broadcast_name'] as String? ?? 'N/A',
        countryCode: json['country_code'] as String? ?? 'N/A',
        driverNumber: json['driver_number'] as int? ?? 0,
        firstName: json['first_name'] as String? ?? 'N/A',
        fullName: json['full_name'] as String? ?? 'N/A',
        headshotUrl: json['headshot_url'] as String? ?? 'N/A',
        lastName: json['last_name'] as String? ?? 'N/A',
        meetingKey: json['meeting_key'] as int? ?? 0,
        nameAcronym: json['name_acronym'] as String? ?? 'N/A',
        sessionKey: json['session_key'] as int? ?? 0,
        teamColour: parseTeamColour(json['team_colour']),
        teamName: json['team_name'] as String? ?? 'N/A',
      );
  }

  Map<String, dynamic> toJson() => {
        'broadcast_name': broadcastName,
        'country_code': countryCode,
        'driver_number': driverNumber,
        'first_name': firstName,
        'full_name': fullName,
        'headshot_url': headshotUrl,
        'last_name': lastName,
        'meeting_key': meetingKey,
        'name_acronym': nameAcronym,
        'session_key': sessionKey,
        'team_colour': teamColour,
        'team_name': teamName,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Driver &&
          runtimeType == other.runtimeType &&
          driverNumber == other.driverNumber;

  @override
  int get hashCode => driverNumber.hashCode;
}

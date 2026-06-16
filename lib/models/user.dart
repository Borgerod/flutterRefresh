class UserData {
  final String userName;
  final String email;
  final String phone;
  final String firstName;
  final String middleName;
  final String lastName;
  final DateTime birthdate;

  const UserData({
    required this.userName,
    required this.email,
    required this.phone,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.birthdate,
  });

  Map<String, dynamic> toMap() => {
    'userName': userName,
    'email': email,
    'phone': phone,
    'firstName': firstName,
    'middleName': middleName,
    'lastName': lastName,
    'birthdate': birthdate.toIso8601String(), // convert DateTime to String
  };

  factory UserData.fromMap(Map<String, dynamic> map) => UserData(
    userName: map['userName'],
    email: map['email'],
    phone: map['phone'],
    firstName: map['firstName'],
    middleName: map['middleName'],
    lastName: map['lastName'],
    birthdate: DateTime.parse(
      map['birthdate'],
    ), // parse String back to DateTime
  );
}

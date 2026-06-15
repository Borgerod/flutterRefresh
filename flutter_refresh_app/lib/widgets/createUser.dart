import 'package:flutter/material.dart';

class UserData {
  final String userName;
  final String email;
  final String phone;
  final String firstName;
  final String middleName;
  final String lastName;
  final String birthdate;

  const UserData({
    required this.userName,
    required this.email,
    required this.phone,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.birthdate,
  });
  Map<String, String> toMap() => {
    'Username': userName,
    'Email': email,
    'Phone': phone,
    'First Name': firstName,
    'Middle Name': middleName,
    'Last Name': lastName,
    'Birthdate': birthdate,
  };
}

class CreatUserButton extends StatelessWidget {
  final VoidCallback onPressed;
  final UserData profile;

  const CreatUserButton({
    Key? key,
    required this.onPressed,
    required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(profile.userName),
          Text(profile.email),
          Text(profile.phone),
          Text(profile.firstName),
          Text(profile.middleName),
          Text(profile.lastName),
          Text(profile.birthdate),
        ],
      ),
    );
  }
}

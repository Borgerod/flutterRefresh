import 'package:flutter/material.dart';
import 'package:flutter_refresh_app/models/user.dart';

class CreatUserButton extends StatelessWidget {
  final VoidCallback onPressed;
  final UserData profile;

  const CreatUserButton({
    super.key,
    required this.onPressed,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('Register'),
      // child: ,
    );
  }
}

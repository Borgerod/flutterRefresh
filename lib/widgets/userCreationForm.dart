import 'package:flutter/cupertino.dart';
import 'package:flutter_refresh_app/widgets/createUser.dart';

import 'package:flutter/material.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key, required this.profile, required this.onSubmit});

  final ValueChanged<UserData> onSubmit;
  final UserData profile;

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (final entry in widget.profile.toMap().entries)
        entry.key: TextEditingController(text: entry.value),
    };
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // @override
  UserData _readFormValues() {
    return UserData(
      userName: _controllers['Username']!.text,
      email: _controllers['Email']!.text,
      phone: _controllers['Phone']!.text,
      firstName: _controllers['First Name']!.text,
      middleName: _controllers['Middle Name']!.text,
      lastName: _controllers['Last Name']!.text,
      birthdate: _controllers['Birthdate']!.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    // iterate schema and generate fields.
    final fields = _controllers.entries.map((entry) {
      return TextFormField(
        controller: entry.value,
        decoration: InputDecoration(labelText: entry.key),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
      );
    }).toList();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ...fields,
          Padding(
            padding: const .symmetric(vertical: 16.0),
            child: CreatUserButton(
              profile: widget.profile,

              onPressed: () {
                print('button pressed');
                if (_formKey.currentState!.validate()) {
                  print('valid');
                  final updatedProfile = _readFormValues();
                  widget.onSubmit(updatedProfile);
                } else {
                  print('invalid');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_refresh_app/models/user.dart';
import 'package:flutter_refresh_app/widgets/create_user.dart';
import 'package:email_validator/email_validator.dart';
import 'package:phone_form_field/phone_form_field.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key, required this.profile, required this.onSubmit});

  final ValueChanged<UserData> onSubmit;
  final UserData profile;

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final PhoneController _phoneController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _middleNameController;
  late final TextEditingController _lastNameController;
  late DateTime _birthdate;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.profile.userName);
    _emailController = TextEditingController(text: widget.profile.email);
    _firstNameController = TextEditingController(
      text: widget.profile.firstName,
    );
    _middleNameController = TextEditingController(
      text: widget.profile.middleName,
    );
    _lastNameController = TextEditingController(text: widget.profile.lastName);
    _birthdate = widget.profile.birthdate;

    final rawPhone = widget.profile.phone;
    _phoneController = PhoneController(
      initialValue: rawPhone.startsWith('+')
          ? PhoneNumber.parse(rawPhone)
          : const PhoneNumber(isoCode: IsoCode.NO, nsn: ''),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  UserData _readFormValues() {
    return UserData(
      userName: _usernameController.text,
      firstName: _firstNameController.text,
      middleName: _middleNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      phone: _phoneController.value.international,
      birthdate: _birthdate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Username'),
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Please enter a username' : null,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _middleNameController,
                  decoration: const InputDecoration(labelText: 'Middle Name'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required' : null,
                ),
              ),
            ],
          ),
          InputDecorator(
            decoration: const InputDecoration(),
            child: Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: const InputDecorationTheme(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
              child: InputDatePickerFormField(
                fieldLabelText: 'Birthdate',
                firstDate: DateTime(1900, 1, 1),
                lastDate: DateTime.now(),
                onDateSubmitted: (d) => setState(() => _birthdate = d),
              ),
            ),
          ),

          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please enter an email';
              if (!EmailValidator.validate(v)) return 'Invalid email';
              return null;
            },
          ),
          PhoneFormField(
            controller: _phoneController,
            validator: PhoneValidator.compose([
              PhoneValidator.required(
                context,
                errorText: 'Please enter a phone number',
              ),
              PhoneValidator.validMobile(context),
            ]),
            countrySelectorNavigator: const CountrySelectorNavigator.page(),
            enabled: true,
            isCountrySelectionEnabled: true,
            isCountryButtonPersistent: true,
            countryButtonStyle: const CountryButtonStyle(
              showDialCode: true,
              showIsoCode: true,
              showFlag: true,
              flagSize: 16,
            ),
          ),

          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: CreatUserButton(
              profile: _readFormValues(),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSubmit(_readFormValues());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

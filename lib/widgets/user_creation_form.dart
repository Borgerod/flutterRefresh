import 'package:flutter/material.dart';
import 'package:flutter_refresh_app/api/user_controller.dart';
import 'package:flutter_refresh_app/models/user.dart';
import 'package:flutter_refresh_app/widgets/create_user_button.dart';
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
  late final VoidCallback _phoneListener;
  late final FocusNode _phoneFocusNode;
  late final VoidCallback _phoneFocusListener;

  // @override
  // void initState() {
  //   super.initState();
  //   _phoneListener = () => setState(() {});
  //   _phoneController.addListener(_phoneListener);
  //   _usernameController = TextEditingController(text: widget.profile.userName);
  //   _emailController = TextEditingController(text: widget.profile.email);
  //   _firstNameController = TextEditingController(
  //     text: widget.profile.firstName,
  //   );
  //   _middleNameController = TextEditingController(
  //     text: widget.profile.middleName,
  //   );
  //   _lastNameController = TextEditingController(text: widget.profile.lastName);
  //   _birthdate = widget.profile.birthdate;

  //   final rawPhone = widget.profile.phone;
  //   _phoneController = PhoneController(
  //     // <-- but it isn't created until HERE
  //     initialValue: rawPhone.startsWith('+')
  //         ? PhoneNumber.parse(rawPhone)
  //         : const PhoneNumber(isoCode: IsoCode.NO, nsn: ''),
  //   );
  // }
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

    _phoneListener = () => setState(() {});
    _phoneController.addListener(_phoneListener);
    _phoneFocusNode = FocusNode();
    _phoneFocusListener = () => setState(() {});
    _phoneFocusNode.addListener(_phoneFocusListener);
  }

  @override
  void dispose() {
    _phoneController.removeListener(_phoneListener);
    _phoneFocusNode.removeListener(_phoneFocusListener);

    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _phoneFocusNode.dispose();

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
    return Card(
      margin: EdgeInsetsGeometry.all(25),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
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
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _middleNameController,
                      decoration: const InputDecoration(
                        labelText: 'Middle Name',
                      ),
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
                    initialDate: _birthdate,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible:
                        _phoneFocusNode.hasFocus ||
                        _phoneController.value.nsn.isNotEmpty,
                    child: const Text(
                      'Phone',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ),

                  PhoneFormField(
                    controller: _phoneController,
                    focusNode: _phoneFocusNode,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText:
                          (_phoneFocusNode.hasFocus ||
                              _phoneController.value.nsn.isNotEmpty)
                          ? ''
                          : 'Phone',
                      isDense: true,
                      // contentPadding: EdgeInsets.zero,
                      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                    ),
                    validator: PhoneValidator.compose([
                      PhoneValidator.required(
                        context,
                        errorText: 'Please enter a phone number',
                      ),
                      PhoneValidator.validMobile(context),
                    ]),
                    countrySelectorNavigator:
                        const CountrySelectorNavigator.page(),
                    enabled: true,
                    isCountrySelectionEnabled: true,
                    isCountryButtonPersistent: true,
                    countryButtonStyle: const CountryButtonStyle(
                      showDialCode: true,
                      showIsoCode: true,
                      showFlag: true,
                      flagSize: 15,
                      padding: EdgeInsets.zero,
                      textStyle: TextStyle(
                        // height: 4,
                      ),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newProfile = _readFormValues();
                    final List<UserData> users = await readUsers();
                    final usernameTaken = users.any(
                      (u) => u.userName == newProfile.userName,
                    );
                    final emailTaken = users.any(
                      (u) => u.email == newProfile.email,
                    );
                    final phoneTaken = users.any(
                      (u) => u.phone == newProfile.phone,
                    );

                    if (usernameTaken || emailTaken || phoneTaken) {
                      final messages = <String>[
                        if (usernameTaken) 'Username already in use',
                        if (emailTaken) 'Email already in use',
                        if (phoneTaken) 'Phone number already in use',
                      ];

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(messages.join('\n'))),
                      );
                      return;
                    }
                    widget.onSubmit(newProfile);
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

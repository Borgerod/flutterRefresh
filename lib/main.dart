import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_refresh_app/widgets/user_table.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:flutter_refresh_app/models/user.dart';
import 'package:flutter_refresh_app/widgets/user_creation_form.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_refresh_app/api/user_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('nb', 'NO'),
      supportedLocales: const [Locale('nb', 'NO')],
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreenAccent),
      ),
      home: const MyHomePage(title: 'Flutter Refresh Practice'),
    );
  }
}

// TODO: fix phone number field - wont update from default
// TODO: datatable - format phone number
// TODO: datatable - format headeres
// TODO: datatable - add sorting
// TODO: datatable - add search
// TODO: datatable - add filters
// TODO: user creation - add user ID generator
// TODO: datatable - add a resolve button -> if two api requests collides when creating new user => two identical users.

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// TEST AREA start

// TEST AREA end
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _isVisible_NewUserReadMore = false;
  UserData? profile;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    String formatPhone(String raw) {
      final phone = PhoneNumber.parse(raw);
      return '+${phone.countryCode} ${phone.formatNsn()}';
    }

    // TEST AREA start

    //   final headers = factory UserData.fromMap(Map<String, dynamic> map) => UserData();
    // final device = UserData();
    //   final headers = device.toJson();

    //   headers.forEach((final String key, final value) {
    //       _logger.info("Key: {{$key}} -> value: ${value}");
    //       // do with this info whatever you want
    //   });
    // TEST AREA end
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0), // optional
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text('You have pushed the button this many times:'),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Register Account',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              UserForm(
                profile: UserData(
                  //> BUILD DEFAULT
                  userName: 'xX_Demon_Slayer_69_Xx',
                  email: 'borgerod@hotmail.com',
                  phone: '+4799337661',
                  firstName: 'Aleksander',
                  middleName: '',
                  lastName: 'Borgerød',
                  birthdate: DateTime(1995, 5, 29),

                  //> PRODUCTION DEFAULT
                  // userName: '',
                  // email: '',
                  // phone: '',
                  // firstName: '',
                  // middleName: '',
                  // lastName: '',
                  // birthdate: DateTime.now(),
                ),

                onSubmit: (UserData updated) async {
                  await saveUser(updated);
                  setState(() {
                    profile = updated;
                  });
                },
              ),
              // NEW PROFILE
              if (profile != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: 5.0,
                    children: [
                      const SizedBox(height: 16),
                      DefaultTextStyle.merge(
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 24,
                        ),
                        child: Wrap(
                          spacing: 5,
                          children: [
                            Text('Welcome on board,'),
                            Text(profile!.firstName),
                            Text(profile!.middleName),
                          ],
                        ),
                      ),

                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(
                          minWidth: 24,
                          minHeight: 24,
                        ),
                        iconSize: 18,
                        onPressed: () {
                          setState(() {
                            _isVisible_NewUserReadMore =
                                !_isVisible_NewUserReadMore;
                          });
                        },
                        icon: _isVisible_NewUserReadMore
                            ? Icon(CupertinoIcons.chevron_back)
                            : Icon(CupertinoIcons.chevron_forward),
                      ),

                      Visibility(
                        visible: _isVisible_NewUserReadMore,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: DefaultTextStyle.merge(
                            style: const TextStyle(
                              // fontSize: 16,
                              color: CupertinoColors.inactiveGray,
                            ),
                            child: Wrap(
                              spacing: 5,
                              children: [
                                const SizedBox(width: 16),
                                Text("${profile!.userName},"),
                                Text("${profile!.email},"),
                                Text("${profile!.phone},"),
                                Text("${profile!.firstName},"),
                                Text("${profile!.middleName},"),
                                Text("${profile!.lastName},"),
                                Text(
                                  "${MaterialLocalizations.of(context).formatCompactDate(profile!.birthdate)}.",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // TABLE - ALL USERS
              Align(
                widthFactor: 10,
                alignment: Alignment.centerLeft,
                child: UserTable(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

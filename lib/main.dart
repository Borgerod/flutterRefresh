import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
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
// TODO: user creation - add duplication checker
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
                          // fontSize: 16,
                          // color: CupertinoColors.inactiveGray,
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
                      Padding(
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
                    ],
                  ),
                ),

              // TABLE - ALL USERS
              Align(
                widthFactor: 10,
                alignment: Alignment.centerLeft,
                child: Card(
                  margin: EdgeInsetsGeometry.all(25),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          // mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'All Users:',
                              style: const TextStyle(fontSize: 24),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  deleteAll();
                                });
                              },
                              child: Text("Clear All"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        FutureBuilder<List<UserData>>(
                          future: readUsers(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }
                            final users = snapshot.data!;
                            return DataTable(
                              sortAscending: true, //TODO implement
                              sortColumnIndex: 1, //TODO implement
                              border: TableBorder.symmetric(
                                inside: const BorderSide(
                                  color: CupertinoColors.lightBackgroundGray,
                                  width: 1,
                                ),
                                outside: BorderSide.none,
                              ),
                              columns: <DataColumn>[
                                for (final key in UserData.fieldNames)
                                  if (key != 'middleName')
                                    DataColumn(
                                      label: Text(
                                        key,
                                        style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                              ],

                              rows: [
                                for (final user in users as List)
                                  DataRow(
                                    cells: [
                                      for (final u in user.toMap().entries)
                                        if (u.key != 'middleName')
                                          DataCell(
                                            Text(
                                              u.key == 'birthdate'
                                                  ? MaterialLocalizations.of(
                                                      context,
                                                    ).formatCompactDate(
                                                      DateTime.parse(
                                                        u.value as String,
                                                      ),
                                                    )
                                                  : u.key == 'phone'
                                                  ? formatPhone(
                                                      u.value as String,
                                                    )
                                                  : u.key == 'birthdate'
                                                  ? '${user.middleName ?? ''} ${u.value}'
                                                        .trim()
                                                  : u.value.toString(),
                                            ),
                                          ),
                                    ],
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
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

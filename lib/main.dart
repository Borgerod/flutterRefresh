import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
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
            if (profile != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text('New profile:', style: const TextStyle(fontSize: 24)),
                    Wrap(
                      spacing: 16,
                      children: [
                        const SizedBox(width: 16),
                        Text(profile!.userName),
                        Text(profile!.email),
                        Text(profile!.phone),
                        Text(profile!.firstName),
                        Text(profile!.middleName),
                        Text(profile!.lastName),
                        Text(
                          MaterialLocalizations.of(
                            context,
                          ).formatCompactDate(profile!.birthdate),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            // TABLE - ALL USERS
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(25),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'All Users:',
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 16),
                        FutureBuilder<List<UserData>>(
                          future: readUsers(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }
                            final users = snapshot.data!;
                            return Table(
                              // columnWidths:0,
                              border: TableBorder.symmetric(
                                inside: const BorderSide(
                                  color: CupertinoColors.lightBackgroundGray,
                                  width: 1,
                                ),
                                outside: BorderSide.none,
                                // outside: const BorderSide(
                                //   color: Colors.black,
                                //   width: 2,
                                // ),
                                // borderRadius: BorderRadius.circular(8),
                              ),
                              // border: TableBorder.all(
                              //   color: CupertinoColors.inactiveGray,
                              //   width: 1.0,
                              //   style: BorderStyle.solid,
                              //   borderRadius: BorderRadius.circular(20),
                              // ),
                              columnWidths: const <int, TableColumnWidth>{
                                0: IntrinsicColumnWidth(),
                                1: FlexColumnWidth(),
                                2: FixedColumnWidth(64),
                              },
                              defaultVerticalAlignment: .middle,
                              children: [
                                for (final user in users as List)
                                  TableRow(
                                    children: [
                                      for (final u in user.toMap().values)
                                        TableCell(child: Text(u.toString())),
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
            ),
          ],
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

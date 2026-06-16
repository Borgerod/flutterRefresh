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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
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
                userName: '',
                email: '',
                phone: '',
                firstName: '',
                middleName: '',
                lastName: '',
                birthdate: DateTime.now(),
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

            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text('all users:', style: const TextStyle(fontSize: 24)),
                  FutureBuilder<List<UserData>>(
                    future: readUsers(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }
                      final users = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: users
                            .map(
                              (u) => Wrap(
                                spacing: 16,
                                children: [
                                  const SizedBox(width: 16),
                                  Text(u.userName),
                                  Text(u.email),
                                  Text(u.phone),
                                  Text(u.firstName),
                                  Text(u.middleName),
                                  Text(u.lastName),
                                  Text(
                                    MaterialLocalizations.of(
                                      context,
                                    ).formatCompactDate(u.birthdate),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                ],
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

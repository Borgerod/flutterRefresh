import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_refresh_app/api/user_controller.dart';
import 'package:flutter_refresh_app/misc/format_phone.dart';
import 'package:flutter_refresh_app/models/user.dart';

class UserTable extends StatefulWidget {
  const UserTable({super.key});

  @override
  State<UserTable> createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsetsGeometry.all(25),
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('All Users:', style: const TextStyle(fontSize: 24)),
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
                            style: const TextStyle(fontStyle: FontStyle.italic),
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
                                          DateTime.parse(u.value as String),
                                        )
                                      : u.key == 'phone'
                                      ? formatPhone(u.value as String)
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
    );
  }
}

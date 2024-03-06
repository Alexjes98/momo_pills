import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:momo_pills/components/add_pill_alarm.dart';
import 'package:momo_pills/services/pills_reminders.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<dynamic> _data;
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    _data = getReminders();
  }

  void addNewReminder(reminder) {
    setState(() {
      _data = addReminder(reminder);
      _isAdding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: FutureBuilder<dynamic>(
                  future: _data,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const CircularProgressIndicator();
                      case ConnectionState.active:
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          if (!snapshot.hasData) {
                            return const Text('No data found');
                          }
                          return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Dismissible(
                                  key: Key(
                                      snapshot.data[index]['id'].toString()),
                                  onDismissed: (direction) {
                                    setState(() {
                                      _data =
                                          removeReminder(snapshot.data[index]);
                                    });
                                  },
                                  background: Container(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    child: const Icon(Icons.delete,
                                        color: Colors.white, size: 40),
                                  ),
                                  child: ListTile(
                                    textColor:
                                        ThemeData.dark().secondaryHeaderColor,
                                    leading: Icon(
                                      Icons.circle,
                                      size: 20,
                                      color: snapshot.data[index]['active']
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    title: Text(
                                      snapshot.data[index]['name'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          fontFamily: 'Hind',
                                          color: snapshot.data[index]['active']
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary
                                              : Colors.grey),
                                    ),
                                    subtitle: Text(
                                      snapshot.data[index]['time'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          fontFamily: 'Hind',
                                          color: snapshot.data[index]['active']
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary
                                              : Colors.grey),
                                    ),
                                    trailing: Text(
                                      snapshot.data[index]['lastTaken'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          fontFamily: 'Hind',
                                          color: snapshot.data[index]['active']
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary
                                              : Colors.grey),
                                    ),
                                    onTap: () {
                                      if (snapshot.data[index]['active']) {
                                        var newReminder = snapshot.data[index];
                                        newReminder['active'] = false;
                                        newReminder['lastTaken'] = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
                                        setState(() {
                                          _data = updateReminder(newReminder);
                                        });
                                      }
                                    },
                                  ),
                                );
                              });
                        }
                    }
                  })),
          _isAdding ? AddPillAlarm(addAlarm: addNewReminder) : Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isAdding = !_isAdding;
          });
        },
        tooltip: 'Add Reminder',
        child: const Icon(Icons.add),
      ),
    );
  }
}

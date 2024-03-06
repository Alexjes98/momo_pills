import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddPillAlarm extends StatefulWidget {
  AddPillAlarm({Key? key, required this.addAlarm }) : super(key: key);
  Function addAlarm;

  @override
  State<AddPillAlarm> createState() => _AddPillAlarmState();
}

class _AddPillAlarmState extends State<AddPillAlarm> {
  final TextEditingController _nameController = TextEditingController();

  TimeOfDay _time = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Nombre de la pastilla',
                ),
              ),
              ListTile(
                title: Text('Hour: ${_time.format(context)}'),
                onTap: () => _selectTime(context),
              ),
              ElevatedButton(child: const Text('Add'), onPressed: () {
                widget.addAlarm({
                  'id': DateTime.now().millisecondsSinceEpoch,
                  'name': _nameController.text,
                  'time': _time.format(context),
                  'active': true,
                  'lastTaken': 'Never'
                });
                _nameController.clear();
              })
            ],
          ),
        ),
      ),
    );
  }
}

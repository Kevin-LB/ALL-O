import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// calendrier.dart
typedef DateCallback = void Function(DateTime date);

class DateTimePickerButton extends StatefulWidget {
  final DateCallback onDateSelected;

  const DateTimePickerButton({required this.onDateSelected, Key? key})
      : super(key: key);

  @override
  State<DateTimePickerButton> createState() => _DateTimePickerButtonState();
}

class _DateTimePickerButtonState extends State<DateTimePickerButton> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(DateTime.now().year + 1),
        );
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (time != null) {
            setState(() {
              selectedDate = DateTime(
                date.year,
                date.month,
                date.day,
                time.hour,
                time.minute,
              );
            });
            print('${DateFormat('dd/MM/yyyy HH:mm').format(selectedDate!)}');
            widget.onDateSelected(selectedDate!);
          }
        }
      },
      child: Text(selectedDate == null
          ? 'Sélectionnez une date et une heure'
          : 'Date et heure sélectionnées: ${DateFormat('dd/MM/yyyy HH:mm').format(selectedDate!)}'),
    );
  }
}

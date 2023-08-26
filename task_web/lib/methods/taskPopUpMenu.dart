import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskDropdownState extends ChangeNotifier {
  String? _value = 'Main Tasks';

  String? get value => _value;

  set value(String? newValue) {
    _value = newValue;
    notifyListeners();
  }
}

void taskPopupMenu(BuildContext context) {
  final RenderBox overlay =
  Overlay.of(context)!.context.findRenderObject() as RenderBox;

  final RenderBox button = context.findRenderObject() as RenderBox;

  final position = RelativeRect.fromRect(
    Rect.fromPoints(
      button.localToGlobal(
          Offset(button.size.width, 0), ancestor: overlay), // Align to the right
      button.localToGlobal(
          button.size.bottomRight(Offset.zero), ancestor: overlay),
    ),
    Offset.zero & overlay.size,
  );

  final TaskItems = ['Main Tasks', 'Sub Tasks', 'In Progress', 'Overdue'];

  final taskDropdownState =
  Provider.of<TaskDropdownState>(context, listen: false); // Use the existing instance

  final popupMenuItems = TaskItems.map<PopupMenuItem<int>>((String value) {
    return PopupMenuItem<int>(
      value: TaskItems.indexOf(value), // Using the index as the value
      child: TextButton(
        onPressed: () {
          Navigator.pop(context, TaskItems.indexOf(value)); // Return the index as the result
        },
        child: Text(value),
      ),
    );
  }).toList();

  showMenu(
    context: context,
    position: position,
    items: popupMenuItems,
    elevation: 8,
  ).then((value) async {
    if (value != null && value >= 0 && value < TaskItems.length) {
      final selectedValue = TaskItems[value];
      taskDropdownState.value = selectedValue;
      print('Selected item: $selectedValue');

      // Inside your taskPopupMenu method
      if (value == 0) {
        taskDropdownState.value = 'Main Tasks';
      } else if (value == 1) {
        taskDropdownState.value = 'Sub Tasks';
      } else if (value == 2) {
        taskDropdownState.value = 'In Progress';
      } else if (value == 3) {
        taskDropdownState.value = 'Overdue';
      }
    }
  });
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class StatusDropdownState extends ChangeNotifier {
  String? _value = 'Status';

  String? get value => _value;

  set value(String? newValue) {
    _value = newValue;
    notifyListeners();
  }
}
void statusPopupMenu(BuildContext context) {
  final RenderBox overlay =
  Overlay.of(context)!.context.findRenderObject() as RenderBox;

  final RenderBox button = context.findRenderObject() as RenderBox;

  // Calculate the desired offset from top and left
  final double topOffset = 100; // Adjust this value as needed
  final double leftOffset = 700; // Adjust this value as needed

  final position = RelativeRect.fromLTRB(
    leftOffset,
    topOffset,
    leftOffset + button.size.width,
    topOffset + button.size.height,
  );

  final Statusitems = ['-All-', 'Pending', 'In Progress', 'Completed'];

  final statusdropdownState = Provider.of<StatusDropdownState>(context, listen: false); // Use the existing instance

  final popupMenuItems = Statusitems.map<PopupMenuItem<int>>((String value) {
    return PopupMenuItem<int>(
      value: Statusitems.indexOf(value), // Using the index as the value
      child: TextButton(
        onPressed: () {
          Navigator.pop(context, Statusitems.indexOf(value)); // Return the index as the result
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
    if (value != null && value >= 0 && value < Statusitems.length) {
      final selectedValue = Statusitems[value];
      statusdropdownState.value = selectedValue;
      print('Selected item: $selectedValue');

      // Inside your statusPopupMenu method
      if (value == 0) {
        statusdropdownState.value = '-All-';
      } else if (value == 1) {
        statusdropdownState.value = 'Pending';
      } else if (value == 2) {
        statusdropdownState.value = 'In Progress';
      }
      else if (value == 3) {
        statusdropdownState.value = 'Completed';
      }
    }
  });
}

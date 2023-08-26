import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AssignedDropdownState extends ChangeNotifier {
  String? _value = '-All-';

  String? get value => _value;

  set value(String? newValue) {
    _value = newValue;
    notifyListeners();
  }
}


void assignedPopupMenu(BuildContext context) {
  final RenderBox overlay =
  Overlay.of(context)!.context.findRenderObject() as RenderBox;

  final RenderBox button = context.findRenderObject() as RenderBox;

  // Calculate the desired offset from top and left
  final double topOffset = 100; // Adjust this value as needed
  final double leftOffset = 1000; // Adjust this value as needed

  final position = RelativeRect.fromLTRB(
    leftOffset,
    topOffset,
    leftOffset + button.size.width,
    topOffset + button.size.height,
  );

  final AssignedItems = ['-All-', 'Deshika', 'Iqlas', 'Udari', 'Shahiru', 'Dinethri', 'Damith'];

  final assignedDropdownState = Provider.of<AssignedDropdownState>(context, listen: false);

  final popupMenuItems = AssignedItems.map<PopupMenuItem<int>>((String value) {
    return PopupMenuItem<int>(
      value: AssignedItems.indexOf(value),
      child: TextButton(
        onPressed: () {
          Navigator.pop(context, AssignedItems.indexOf(value));
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
    if (value != null && value >= 0 && value < AssignedItems.length) {
      final selectedValue = AssignedItems[value];
      assignedDropdownState.value = selectedValue;
      print('Selected item: $selectedValue');
    }
  });
}

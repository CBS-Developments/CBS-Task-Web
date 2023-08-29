import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LabelDropdownState extends ChangeNotifier {
  String? _value = '-All-';

  String? get value => _value;

  set value(String? newValue) {
    _value = newValue;
    notifyListeners();
  }
}


void labelPopupMenu(BuildContext context) {
  final RenderBox overlay =
  Overlay.of(context)!.context.findRenderObject() as RenderBox;

  final RenderBox button = context.findRenderObject() as RenderBox;

  // Calculate the desired offset from top and left
  final double topOffset = 100; // Adjust this value as needed
  final double leftOffset = 1500; // Adjust this value as needed

  final position = RelativeRect.fromLTRB(
    leftOffset,
    topOffset,
    leftOffset + button.size.width,
    topOffset + button.size.height,
  );

  final labelItems = ['-All-', 'Top Urgent', 'Medium', 'Regular', 'Low'];

  final labelDropdownState = Provider.of<LabelDropdownState>(context, listen: false);

  final popupMenuItems = labelItems.map<PopupMenuItem<int>>((String value) {
    return PopupMenuItem<int>(
      value: labelItems.indexOf(value),
      child: TextButton(
        onPressed: () {
          Navigator.pop(context, labelItems.indexOf(value));
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
    if (value != null && value >= 0 && value < labelItems.length) {
      final selectedValue = labelItems[value];
      labelDropdownState.value = selectedValue;
      print('Selected item: $selectedValue');
    }
  });
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompanyDropdownState extends ChangeNotifier {
  String? _value = '-All-';

  String? get value => _value;

  set value(String? newValue) {
    _value = newValue;
    notifyListeners();
  }
}

void companyPopupMenu(BuildContext context) {
  final RenderBox overlay =
  Overlay.of(context)!.context.findRenderObject() as RenderBox;

  final RenderBox button = context.findRenderObject() as RenderBox;

  // Calculate the desired offset from top and left
  final double topOffset = 100; // Adjust this value as needed
  final double leftOffset = 1100; // Adjust this value as needed

  final position = RelativeRect.fromLTRB(
    leftOffset,
    topOffset,
    leftOffset + button.size.width,
    topOffset + button.size.height,
  );

  final companyNames = ['Company 01', 'Company 02', 'Company 03', 'Company 04'];

  final companyDropdownState =
  Provider.of<CompanyDropdownState>(context, listen: false); // Use the existing instance

  final popupMenuItems = companyNames.map<PopupMenuItem<int>>((String value) {
    return PopupMenuItem<int>(
      value: companyNames.indexOf(value), // Using the index as the value
      child: TextButton(
        onPressed: () {
          Navigator.pop(context, companyNames.indexOf(value)); // Return the index as the result
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
    if (value != null && value >= 0 && value < companyNames.length) {
      final selectedValue = companyNames[value];
      companyDropdownState.value = selectedValue;
      print('Selected item: $selectedValue');

      // Inside your taskPopupMenu method
      if (value == 0) {
        companyDropdownState.value = 'Company 01';
      } else if (value == 1) {
        companyDropdownState.value = 'Company 02';
      } else if (value == 2) {
        companyDropdownState.value = 'Company 03';
      } else if (value == 3) {
        companyDropdownState.value = 'Company 04';
      }
    }
  });
}

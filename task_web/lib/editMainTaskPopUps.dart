import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class EditBeneficiaryState extends ChangeNotifier {
  String? _value = 'Edit Beneficiary';

  String? get value => _value;

  set value(String? newValue) {
    _value = newValue;
    notifyListeners();
  }
}

class EditBeneficiaryPopup {
  void showPopupMenu(BuildContext context, EditBeneficiaryState editBeneficiaryState) {
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final RenderBox button = context.findRenderObject() as RenderBox;

    final double topOffset = 500; // Adjust this value as needed
    final double leftOffset = 550; // Adjust this value as needed

    final position = RelativeRect.fromLTRB(
      leftOffset,
      topOffset,
      leftOffset + button.size.width,
      topOffset + button.size.height,
    );

    final editBeneficiaryItems = [
      'Edit Beneficiary 1',
      'Edit Beneficiary 2',
      'Edit Beneficiary 3',
      // Add your "Edit Beneficiary" items here
    ];

    final popupMenuItems = editBeneficiaryItems.map<PopupMenuItem<int>>((String value) {
      return PopupMenuItem<int>(
        value: editBeneficiaryItems.indexOf(value), // Using the index as the value
        child: TextButton(
          onPressed: () {
            Navigator.pop(context, editBeneficiaryItems.indexOf(value)); // Return the index as the result
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
    ).then((value) {
      if (value != null && value >= 0 && value < editBeneficiaryItems.length) {
        final selectedValue = editBeneficiaryItems[value];
        editBeneficiaryState.value = selectedValue;
        print('Selected Edit Beneficiary: $selectedValue');
      }
    });
  }
}

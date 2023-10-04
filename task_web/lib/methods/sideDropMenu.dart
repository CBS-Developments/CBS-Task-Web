import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_web/methods/profileDialogBox.dart';

import '../pages/loginPage.dart';

void showPopupMenu(BuildContext context) {
  final RenderBox overlay =
  Overlay.of(context)!.context.findRenderObject() as RenderBox;

  final RenderBox button = context.findRenderObject() as RenderBox;

  final position = RelativeRect.fromRect(
    Rect.fromPoints(
      button.localToGlobal(Offset(button.size.width, 0), ancestor: overlay), // Align to the right
      button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
    ),
    Offset.zero & overlay.size,
  );

  showMenu(
    context: context,
    position: position,
    items: [
      PopupMenuItem(
        value: 1,
        child: TextButton(
          onPressed: () {
            Navigator.pop(context, 1);
          },
          child: const Text('Log Out'),
        ),
      ),
      PopupMenuItem(
        value: 2,
        child: TextButton(
          onPressed: () {
            Navigator.pop(context, 2);
          },
          child: const Text('Password Reset'),
        ),
      ),
      PopupMenuItem(
        value: 3,
        child: TextButton(
          onPressed: () {
            Navigator.pop(context, 3);
          },
          child: const Text('Profile'),
        ),
      ),
    ],
    elevation: 8,
  ).then((value) async {
    if (value != null) {
      // Handle selected option here
      if (value == 1) {
        final prefs = await SharedPreferences.getInstance();
        prefs.remove("login_state"); // Remove the "login_state" key
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return const LoginPage();
          }),
        );
        // Do something for Option 1
      } else if (value == 2) {
        // Do something for Option 2
      } else if (value == 3) {
        // Open a dialog box for Option 3
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const ProfilePage();
          },
        );
      }
    }
  });
}


import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components.dart';
import '../methods/colors.dart';


class EditMainTask extends StatefulWidget {

  const EditMainTask({Key? key}) : super(key: key);

  @override
  State<EditMainTask> createState() => _EditMainTaskState();
}

class _EditMainTaskState extends State<EditMainTask> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: 850,
        height: 600,
        color: Colors.white70,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 500,
              height: 400,
              color: Colors.greenAccent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Text(
                      //   "${widget.firstName} ${widget.lastName}",
                      //   style: TextStyle(
                      //     fontSize: 18,
                      //   ),
                      // ),
                      Row(
                        children: [
                          // ... (other widgets)
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}





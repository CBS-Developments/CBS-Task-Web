import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  final String topic;
  final String hintText;
  final TextEditingController controller;
  const TextFieldContainer(
      {super.key,
      required this.topic,
      required this.controller,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      color: Colors.white,
      width: 370,
      height: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              children: [
                Text(
                  topic,
                  style: const TextStyle(fontSize: 15),
                ),
                const Text('*', style: TextStyle(color: Colors.red),)
              ],
            ),
          ),
          SizedBox(
            width: 350,
            height: 35,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
                hintText: hintText,
                contentPadding: EdgeInsets.all( 5.0), // Adjust vertical padding
              ),
            )


          ),
        ],
      ),
    );
  }
}

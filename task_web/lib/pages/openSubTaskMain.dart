import 'package:flutter/material.dart';
import 'package:task_web/pages/createSubTask.dart';

import '../methods/subTaskTable.dart';

class OpenSubTask extends StatefulWidget {
  const OpenSubTask({Key? key}) : super(key: key);

  @override
  State<OpenSubTask> createState() => _OpenSubTaskState();
}

class _OpenSubTaskState extends State<OpenSubTask> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: 850, // Set the width of the dialog
        height: 450,
        color: Colors.white70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children: [
                const Text('Sub Task',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.cancel_outlined, size: 20),
                )
              ],
            ),

            SubTaskTable( mainTaskId: '',),

            const SizedBox(height: 20,),

            TextButton(
              onPressed: () {showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const CreateSubTask(   );
                },
              );},
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Create Sub Task',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                  ),
                ),
              ),
            ),

            TextButton(
              onPressed: () {showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const CreateSubTask(   );
                },
              );},
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Create Sub Task',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                  ),
                ),
              ),


            ),

          ],
        ),
      ),

    );;
  }
}


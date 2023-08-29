import 'package:flutter/material.dart';
import '../methods/taskTable.dart';

class TaskDetailsDialog extends StatelessWidget {
  final MainTask task;

  TaskDetailsDialog(this.task);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          width: 800, // Set the width of the dialog
          height: 400, // Set the height of the dialog
          child: SingleChildScrollView(
            child: Row(
              children: [
                Container(
                  width: 500,
                  height: 400,
                  color: Colors.greenAccent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${task.taskTitle}',style: TextStyle(
                        fontSize: 16,
                      ),),
                      Text('${task.taskId}',style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      ),

                    ],
                  ),



                ),

                Container(
                  width: 300,
                  height: 400,
                  color: Colors.lightBlueAccent,


                )
              ],
            )
          )),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}

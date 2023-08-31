import 'package:flutter/material.dart';
import 'package:task_web/methods/colors.dart';
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${task.taskTitle}',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.remove_red_eye_outlined,
                              color: Colors.black,
                            ))
                      ],
                    ),
                    Text(
                      '${task.taskId}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 450,
                      height: 300,
                      color: Colors.grey.shade700,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 150,
                            height: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Row(
                                  children: [
                                    Icon(Icons.calendar_month_rounded,size: 15,),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        'Start',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.drawerLight),
                                      ),
                                    ),

                                    Icon(Icons.arrow_forward,color: AppColor.drawerLight,size: 15,),

                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        'Due',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.drawerLight),
                                      ),
                                    ),

                                  ],
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 18,bottom: 4),
                                  child: Text(
                                    'Company',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColor.drawerLight),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 18,bottom: 4),
                                  child: Text(
                                    'Assign To',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColor.drawerLight),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 18,bottom: 4),
                                  child: Text(
                                    'Priority',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColor.drawerLight),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 18,bottom: 4),
                                  child: Text(
                                    'Status',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColor.drawerLight),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 18,bottom: 4),
                                  child: Text(
                                    'Created By',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColor.drawerLight),
                                  ),
                                ),

                              ],
                            ),
                          ),
                          VerticalDivider(
                            thickness: 2,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 300,
                height: 400,
                color: Colors.lightBlueAccent,
              )
            ],
          ))),
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

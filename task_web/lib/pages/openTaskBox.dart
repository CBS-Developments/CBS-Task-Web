import 'package:flutter/material.dart';
import 'package:task_web/methods/colors.dart';
import 'package:task_web/methods/subTaskTable.dart';
import 'package:task_web/pages/editMainTask.dart';
import '../methods/taskTable.dart';

class TaskDetailsDialog extends StatelessWidget {
  final MainTask task;

  TaskDetailsDialog(this.task);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
          width: 1120, // Set the width of the dialog
          height: 500, // Set the height of the dialog
          child: SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 700,
                height: 500,
                 //color: Colors.greenAccent,
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
                        Row(
                          children: [

                            IconButton(
                                onPressed: () {showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return   EditMainTask(lastName: '', firstName: '', userName: '', assign_to: '', company: task.company, documentNumber: task.documentNumber,
                                      dueDate: task.dueDate, mainTaskId: task.taskId, sourceFrom: task.sourceFrom, taskCreateBy:task.taskCreateBy, taskCreateDate: task.taskCreateDate, taskCreatedTimestamp: task.taskCreatedTimestamp,
                                      taskStatus: task.taskStatus, taskStatusName: task.taskStatusName, taskTitle: task.taskTitle, taskType: task.taskType, taskTypeName: task.taskTypeName,

                                    ); // Use the dialog widget here
                                  },
                                );},
                                tooltip: 'Edit Task',
                                icon: Icon(
                                  Icons.edit_note_rounded,
                                  color: Colors.black,
                                  size: 22,
                                )),

                            IconButton(
                                onPressed: () {},
                                tooltip: 'Delete Task',
                                icon: Icon(
                                  Icons.delete_rounded,
                                  color: Colors.redAccent,
                                  size: 19,
                                )),
                          ],
                        )
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
                      width: 480,
                      height: 160,
                      color: Colors.grey.shade100,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 160,
                            child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Row(
                                  children: [
                                    Icon(Icons.calendar_month_rounded,size: 15,),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8,right: 4 ),
                                      child: Text(
                                        'Start',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.drawerLight),
                                      ),
                                    ),

                                    Icon(Icons.arrow_forward,color: AppColor.drawerLight,size: 15,),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8,right: 4 ),
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
                                  padding: const EdgeInsets.only(left: 18,bottom: 8),
                                  child: Text(
                                    'Company',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColor.drawerLight),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 18,bottom: 8),
                                  child: Text(
                                    'Assign To',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColor.drawerLight),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 18,bottom: 8),
                                  child: Text(
                                    'Priority',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColor.drawerLight),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 18,bottom: 8),
                                  child: Text(
                                    'Status',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColor.drawerLight),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 18,bottom: 8),
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
                          ),

                          SizedBox(
                            height: 160,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Row(
                                  children: [
                                    Icon(Icons.calendar_month_rounded,size: 15,),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8,right: 4 ),
                                      child: Text(
                                        '${task.taskCreateDate}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,),
                                      ),
                                    ),

                                    Icon(Icons.arrow_forward,color: Colors.black,size: 15,),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8,right: 4 ),
                                      child: Text(
                                        '${task.dueDate}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,),
                                      ),
                                    ),

                                  ],
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 18,bottom: 8),
                                  child: Text(
                                    '${task.company}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 18,bottom: 8),
                                  child: Text(
                                    '${task.assignTo}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 18,bottom: 8),
                                  child: Text(
                                    '${task.taskTypeName}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 18,bottom: 8),
                                  child: Text(
                                    '${task.taskStatusName}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 18,bottom: 8),
                                  child: Text(
                                    '${task.taskCreateBy}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,),
                                  ),
                                ),

                              ],
                            ),
                          ),

                        ],
                      ),
                    ),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: (){},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Mark As Complete',style:
                              TextStyle(fontSize: 14,color: Colors.redAccent),),
                            ) ),

                        TextButton(
                            onPressed: (){},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Create Sub Task',style:
                              TextStyle(fontSize: 14,color: Colors.green),),
                            ) ),
                      ],
                    ),

                    SizedBox(height: 5,),

                    Text('Subtasks',style: TextStyle(fontSize: 18),),

                    SizedBox(height: 5,),

                    SubTaskTable(subtasks: [],)

                  ],
                ),
              ),

              VerticalDivider(),

              Container(
                width: 360,
                height: 500,
                // color: Colors.lightBlueAccent,
                child: Column(
                  children: [
                    Container(
                      width: 330,
                      height: 40,
                      color: Colors.grey.shade300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('Special Notice',style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 16,
                            ),),
                          ),

                        ],
                      ),
                    ),

                    Container(
                      width:300,
                      height: 150,
                      color: Colors.white,
                    ),

                    Container(
                      width: 330,
                      height: 35,
                      color: Colors.grey.shade300,
                      child: Align(alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('Comment',style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 16,
                          ),),
                        ),
                      ),
                    ),

                    Container(
                      width: 330,
                      height: 225,
                      color: Colors.white,
                    ),

                    Container(
                      width: 330,
                      height: 40,
                      child: TextField(
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade300,
                          hintText: 'Write a Comment...',
                          helperStyle: TextStyle(color: Colors.grey.shade700,fontSize: 14),
                          filled: true
                        ),

                      ),
                    ),



                  ],
                ),
              ),

              IconButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.cancel_outlined,size: 20,))
            ],
          ))),

    );
  }
}

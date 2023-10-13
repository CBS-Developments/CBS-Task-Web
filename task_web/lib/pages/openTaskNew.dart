import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../methods/appBar.dart';
import '../methods/colors.dart';
import '../methods/subTaskTable.dart';
import '../methods/taskTable.dart';
import 'editMainTask.dart';

class OpenTaskNew extends StatefulWidget {
  final MainTask task;

   OpenTaskNew({Key? key, required this.task}) : super(key: key);

  @override
  State<OpenTaskNew> createState() => _OpenTaskNewState();
}

class _OpenTaskNewState extends State<OpenTaskNew> {
  String userName ='';
  String taskDescription ='';

  String firstName='';
  String lastName='';
  String userRole='';
  String mainTaskId='';
  String mainTaskTitle='';
  String assign_to='';
  String beneficiary='';


  TextEditingController mainTaskCommentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    retrieverData();
  }

  void retrieverData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      mainTaskId = (prefs.getString('main_task_id') ?? '');
      mainTaskTitle = (prefs.getString('main_task_title') ?? '');
      taskDescription = (prefs.getString('task_description') ?? '');
      userName = (prefs.getString('user_name') ?? '');
      beneficiary = (prefs.getString('company') ?? '');
      userRole = (prefs.getString('user_role') ?? '');
      firstName = (prefs.getString('first_name') ?? '').toUpperCase();
      lastName = (prefs.getString('last_name') ?? '').toUpperCase();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: MyAppBar(),
      ),
      body: Center(
        child: Container(
          width: 1120,
          height: 500,
          color: Colors.white,
          child: SizedBox(
            width: 1120,
            height: 500,
            child: SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 700,
                    height: 500,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.task.taskTitle,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => EditMainTaskPage(
                                        currentTitle: widget.task.taskTitle,
                                        currentDescription: widget.task.task_description,
                                        currentBeneficiary: widget.task.company,
                                        currentDueDate: widget.task.dueDate,
                                        currentAssignTo: widget.task.assignTo,
                                        currentPriority: widget.task.taskTypeName,
                                        currentSourceFrom: widget.task.sourceFrom,
                                        currentCategory: widget.task.category_name,)),
                                    );

                                  },
                                  tooltip: 'Edit Task',
                                  icon: Icon(
                                    Icons.edit_note_rounded,
                                    color: Colors.black,
                                    size: 22,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  tooltip: 'Delete Task',
                                  icon: Icon(
                                    Icons.delete_rounded,
                                    color: Colors.redAccent,
                                    size: 19,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Text(
                          widget.task.taskId,
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month_rounded,
                                          size: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4, bottom: 8, top: 8, right: 4),
                                          child: Text(
                                            'Start',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: AppColor.drawerLight),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: AppColor.drawerLight,
                                          size: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4, bottom: 8, top: 8, right: 4),
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
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
                                      child: Text(
                                        'Company',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.drawerLight),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
                                      child: Text(
                                        'Assign To',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.drawerLight),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
                                      child: Text(
                                        'Priority',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.drawerLight),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
                                      child: Text(
                                        'Status',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.drawerLight),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
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
                                        Icon(
                                          Icons.calendar_month_rounded,
                                          size: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4, bottom: 8, top: 8, right: 4),
                                          child: Text(
                                            widget.task.taskCreateDate,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: Colors.black,
                                          size: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4, bottom: 8, top: 8, right: 4),
                                          child: Text(
                                            widget.task.dueDate,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
                                      child: Text(
                                        widget.task.company,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
                                      child: Text(
                                        widget.task.assignTo,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
                                      child: Text(
                                        widget.task.taskTypeName,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
                                      child: Text(
                                        widget.task.taskStatusName,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
                                      child: Text(
                                        widget.task.taskCreateBy,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
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
                              onPressed: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Mark As Complete',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Subtasks',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SubTaskTable(subtasks: const []),
                      ],
                    ),
                  ),
                  VerticalDivider(),
                  Container(
                    width: 360,
                    height: 500,
                    child: Column(
                      children: [
                        Container(
                          width: 330,
                          height: 40,
                          color: Colors.grey.shade300,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'Special Notice',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 300,
                          height: 150,
                          color: Colors.white,
                        ),
                        Container(
                          width: 330,
                          height: 35,
                          color: Colors.grey.shade300,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Comment',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 330,
                          height: 225,
                          color: Colors.white,
                          // FutureBuilder<List<comment>>(
                          //   future: getMainTaskCommentList(mainTaskId),
                          //   builder: (context, snapshot) {
                          //     if (snapshot.connectionState == ConnectionState.waiting) {
                          //       return CircularProgressIndicator(); // Display a loading indicator while fetching data
                          //     } else if (snapshot.hasError) {
                          //       return Text("Error: ${snapshot.error}");
                          //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          //       return Text("No comments available"); // Replace with your custom message
                          //     } else {
                          //       List<comment>? data = snapshot.data;
                          //       return ListView.builder(
                          //         itemCount: data!.length,
                          //         itemBuilder: (context, index) {
                          //           return Card(
                          //             child: ListTile(
                          //               title: SelectableText(
                          //                 data[index].commnt,
                          //                 style: TextStyle(
                          //                   color: Colors.black,
                          //                   fontSize: 12,
                          //                 ),
                          //               ),
                          //               subtitle: Text(
                          //                 "${data[index].commentCreateDate}      ${data[index].commentCreateBy}",
                          //                 style: TextStyle(
                          //                   color: Colors.black,
                          //                   fontSize: 12,
                          //                   fontWeight: FontWeight.bold,
                          //                 ),
                          //               ),
                          //               trailing: IconButton(
                          //                 icon: Icon(
                          //                   Icons.delete,
                          //                   size: 14,
                          //                   color: Colors.red,
                          //                 ),
                          //                 onPressed: () {
                          //                   if (data[index].commentCreateById == userName) {
                          //                     deleteCommentInMainTask(
                          //                       data[index].commentId,
                          //                       "0",
                          //                       userName,
                          //                       "$firstName $lastName",
                          //                     );
                          //                   } else {
                          //                     snackBar(
                          //                       context,
                          //                       "You can't delete this comment",
                          //                       Colors.red,
                          //                     );
                          //                   }
                          //                 },
                          //               ),
                          //             ),
                          //           );
                          //         },
                          //       );
                          //     }
                          //   },
                          // )

                        ),
                        Container(
                          width: 330,
                          height: 40,
                          child: TextField(
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade300,
                              hintText: 'Write a Comment...',
                              helperStyle: TextStyle(
                                  color: Colors.grey.shade700, fontSize: 14),
                              filled: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.cancel_outlined, size: 20),
                  )
                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
}

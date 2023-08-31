import 'package:flutter/material.dart';

import '../methods/colors.dart';

class CreateTaskDialog extends StatefulWidget {
  const CreateTaskDialog({Key? key}) : super(key: key);

  @override
  _CreateTaskDialogState createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<CreateTaskDialog> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController createTaskDueDateController = TextEditingController();
  bool _isEditingTitle = true;
  DateTime? _selectedDueDate; // Store the selected due date

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _isEditingTitle
          ? TextField(
        controller: _titleController,
        decoration: InputDecoration(
          hintText: "Task Title",
        ),
      )
          : GestureDetector(
        onTap: () {
          setState(() {
            _isEditingTitle = true;
          });
        },
        child: Text("Task Title"),
      ),
      content: Container(
        width: 800,
        height: 400,
        child: Column(
          children: [
            if (_isEditingTitle)
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: "Add Description",
                    border: InputBorder.none,
                  ),
                ),
              ),
            SizedBox(height: 20),
            Column(
              children: [
                Container(
                  width: 700,
                  height: 200,
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
                                  size: 16,
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 6, bottom: 8, top: 8, right: 4),
                                  child: Text(
                                    'Due Date',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppColor.drawerLight),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 18, bottom: 8),
                              child: Text(
                                'Company',
                                style: TextStyle(
                                    fontSize: 16, color: AppColor.drawerLight),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 18, bottom: 8),
                              child: Text(
                                'Assign To',
                                style: TextStyle(
                                    fontSize: 16, color: AppColor.drawerLight),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 18, bottom: 8),
                              child: Text(
                                'Priority',
                                style: TextStyle(
                                    fontSize: 16, color: AppColor.drawerLight),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 18, bottom: 8),
                              child: Text(
                                'Status',
                                style: TextStyle(
                                    fontSize: 16, color: AppColor.drawerLight),
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
                            GestureDetector(
                              onTap: () async {
                                final selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );

                                if (selectedDate != null) {
                                  setState(() {
                                    _selectedDueDate = selectedDate;
                                  });
                                }
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month_rounded,
                                    size: 16,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 4,
                                        bottom: 8,
                                        top: 8,
                                        right: 4),
                                    child: Text(
                                      _selectedDueDate != null
                                          ? _selectedDueDate!
                                          .toString()
                                          .split(' ')[0]
                                          : 'Select Due Date',
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
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Close the dialog
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
        ),
        if (_isEditingTitle)
          TextButton(
            onPressed: () {
              // Perform the task addition logic here
              String taskTitle = _titleController.text;
              String taskDescription = _descriptionController.text;
              // Use the taskTitle and taskDescription for your logic
              // Close the dialog
              Navigator.of(context).pop();
            },
            child: Text("Add"),
          ),
      ],
    );
  }
}

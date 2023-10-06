
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CompanyTable extends StatefulWidget {
  const CompanyTable({Key? key}) : super(key: key);

  @override
  State<CompanyTable> createState() => _CompanyTableState();
}

class _CompanyTableState extends State<CompanyTable> {

  List<Company> companyList = [];
  int companyCount = 0;

  @override
  void initState() {
    super.initState();
    getCompanyList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      width: 800,
      height: 400,
      child: Column(
        children: [
          Container(
            width: 800,
            height: 33,
            color: Colors.grey.shade300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Companies:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$companyCount',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 800,
            height: 200,
            color: Colors.white,
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(
                    label: Text(
                      'CIN No',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Company Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Company Email',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Status',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
                rows: companyList.map((company) {
                  return DataRow(cells: [
                    DataCell(Text(
                      company.cinNo,
                      style: TextStyle(fontSize: 10, color: Colors.black),
                    )),
                    DataCell(
                      Text(
                        company.companyName,
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                      onTap: () {
                        //_showUserDetailsDialog(user);
                        getCompanyList();
                      },
                    ),
                    DataCell(Text(
                      company.companyEmail,
                      style: TextStyle(fontSize: 10, color: Colors.black),
                    )),
                    // DataCell(
                    //   Text(
                    //     user.activate == '1' ? 'Active' : 'Deactivated',
                    //     style: TextStyle(
                    //       fontSize: 10,
                    //       color: user.activate == '1' ? Colors.green : Colors.red,
                    //     ),
                    //   ),
                    // ),
                    // DataCell(
                    //   Switch(
                    //     value: user.activate == '1' ? true : false,
                    //     onChanged: (value) {
                    //       setState(() {
                    //         user.activate = value ? '1' : '0';
                    //       });
                    //       userStatusToggle(user.userName, value);
                    //     },
                    //     activeColor: Colors.green,
                    //     inactiveTrackColor: Colors.redAccent.withOpacity(0.5),
                    //   ),
                    // ),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getCompanyList() async {
    companyList.clear();
    var data = {};

    const url = "http://dev.workspace.cbs.lk/companyList.php";
    final res = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
    );

    if (res.statusCode == 200) {
      final responseJson = json.decode(res.body) as List<dynamic>;
      setState(() {
        for (Map<String, dynamic> details in responseJson) {
          companyList.add(Company.fromJson(details));
        }
      });
      companyCount = companyList.length;
      print("Company Count: $companyCount");
    } else {
      throw Exception('Failed to load companies from API');
    }
  }

}

class Company {
  String cinNo = '';
  String companyName = '';
  String companyEmail = '';
  String regNo = '';
  String address = '';
  String conPersonNo = '';
  String conPersonPhone = '';
  String conPersonEmail = '';
  String userRole = '';
  String activate = '';

  Company({
    required this.cinNo,
    required this.companyName,
    required this.companyEmail,
    required this.regNo,
    required this.address,
    required this.conPersonNo,
    required this.conPersonPhone,
    required this.conPersonEmail,
    required this.userRole,
    required this.activate,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      cinNo: json['user_name'],
      companyName: json['first_name'],
      companyEmail: json['last_name'],
      regNo: json['email'],
      address: json['password_'],
      conPersonNo: json['phone'],
      conPersonPhone: json['phone'],
      conPersonEmail: json['phone'],
      userRole: json['user_role'],
      activate: json['activate'],
    );
  }
}
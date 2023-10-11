
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
      margin: const EdgeInsets.all(20),
      width: 800,
      height: 233,
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
                    style: const TextStyle(
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
                  DataColumn(
                    label: Text(
                      'Edit',
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
                      style: const TextStyle(fontSize: 10, color: Colors.black),
                    )),
                    DataCell(
                      Text(
                        company.companyName,
                        style: const TextStyle(fontSize: 10, color: Colors.black),
                      ),
                      onTap: () {
                        //_showUserDetailsDialog(user);
                        //getCompanyList();
                      },
                    ),
                    DataCell(Text(
                      company.companyEmail,
                      style: const TextStyle(fontSize: 10, color: Colors.black),
                    )),
                    DataCell(
                      Text(
                        company.activate == '1' ? 'Active' : 'Deactivated',
                        style: TextStyle(
                          fontSize: 10,
                          color: company.activate == '1' ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                    DataCell(
                      Switch(
                        value: company.activate == '1' ? true : false,
                        onChanged: (value) {
                          setState(() {
                            company.activate = value ? '1' : '0';
                          });
                          companyStatusToggle(company.cinNo, value);
                        },
                        activeColor: Colors.green,
                        inactiveTrackColor: Colors.redAccent.withOpacity(0.5),
                      ),
                    ),
                    DataCell(
                      Icon(Icons.edit_note_rounded),
                      onTap: () {
                      },
                    ),
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

  Future<void> companyStatusDeactivate(String cinNo) async {
    var data = {
      "cin_no": cinNo,
      "activate": '0',
    };

    const url = "http://dev.workspace.cbs.lk/companyStatus.php";
    final res = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
    );

    if (res.statusCode.toString() == "200") {
      Map<String, dynamic> result = jsonDecode(res.body);
      print(result);
    }
  }

  Future<void> companyStatusActivate(String cinNo) async {
    var data = {
      "cin_no": cinNo,
      "activate": '1',
    };

    const url = "http://dev.workspace.cbs.lk/companyStatus.php";
    final res = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
    );

    if (res.statusCode.toString() == "true") {
      Map<String, dynamic> result = jsonDecode(res.body);
      print(result);
    }
  }

  Future<void> companyStatusToggle(String cinNo, bool activate) async {
    var data = {
      "cin_No": cinNo,
      "activate": activate ? '1' : '0',
    };

    const url = "http://dev.workspace.cbs.lk/companyStatus.php";
    http.Response res = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
    );

    if (res.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(res.body);
      print(result);
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
      cinNo: json['cin_no'],
      companyName: json['company_name'],
      companyEmail: json['company_email'],
      regNo: json['reg_no'],
      address: json['address_'],
      conPersonNo: json['contact_person_name'],
      conPersonPhone: json['contact_person_phone'],
      conPersonEmail: json['contact_person_email'],
      userRole: json['user_role'],
      activate: json['activate'],
    );
  }
}
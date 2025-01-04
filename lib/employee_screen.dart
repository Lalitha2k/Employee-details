import 'package:employee_display_app/FilterScreen.dart';
import 'package:employee_display_app/employeeform.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeScreen extends StatefulWidget {
  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Filters and search state
  String? searchQuery;
  bool? isActive;
  RangeValues? experienceRange;
  DateTimeRange? joiningDateRange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/employeesimg.png',
              height: 30,
              width: 30,
            ),
            SizedBox(width: 8),
            Text(
              'Employee Details',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.black),
            onPressed: () async {
              final filters = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FilterScreen()),
              );
              if (filters != null) {
                setState(() {
                  isActive = filters['isActive'];
                  experienceRange = filters['experienceRange'];
                  joiningDateRange = filters['joiningDateRange'];
                });
              }
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('employees').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No employees found'));
                }
                final employees = snapshot.data!.docs.where((doc) {
                  final name = doc['name']?.toString().toLowerCase() ?? '';
                  final status = doc['isActive'] ?? false;
                  final joiningDate = DateTime.parse(doc['joiningDate']);
                  final experience = DateTime.now().year - joiningDate.year;

                  bool matchesSearch = searchQuery == null ||
                      searchQuery!.isEmpty ||
                      name.contains(searchQuery!.toLowerCase());
                  bool matchesActive = isActive == null || isActive == status;
                  bool matchesExperience = experienceRange == null ||
                      (experience >= experienceRange!.start &&
                          experience <= experienceRange!.end);
                  bool matchesJoiningDate = joiningDateRange == null ||
                      (joiningDate.isAfter(joiningDateRange!.start) &&
                          joiningDate.isBefore(joiningDateRange!.end));

                  return matchesSearch &&
                      matchesActive &&
                      matchesExperience &&
                      matchesJoiningDate;
                }).toList();

                if (employees.isEmpty) {
                  return const Center(child: Text('No employees match the filters'));
                }

                return ListView.builder(
                  itemCount: employees.length,
                  itemBuilder: (context, index) {
                    final employee = employees[index];
                    final name = employee['name'];
                    final status = employee['isActive'];
                    final joiningDateString = employee['joiningDate'];
                    DateTime joiningDate = DateTime.parse(joiningDateString);
                    final years = DateTime.now().year - joiningDate.year;

                    final flagIcon = (years >= 5 && status)
                        ? 'assets/Greenflag2.png'
                        : 'assets/greyflag.png';

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            if (flagIcon == 'assets/Greenflag2.png')
                              BoxShadow(
                                color: Colors.green.shade100,
                                blurRadius: 10,
                                spreadRadius: 5,
                              ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          title: Text(
                            name,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Years of Experience: $years',
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                'Status: ${status ? "Active" : "Inactive"}',
                                style: GoogleFonts.poppins(
                                  color: status
                                      ? Colors.green
                                      : Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                          trailing: Image.asset(
                            flagIcon,
                            height: 30,
                            width: 30,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEmployeeScreen()),
          );
        },
        backgroundColor: Colors.white,
        tooltip: 'Add Employee',
        child: Icon(Icons.add),
      ),
    );
  }
}

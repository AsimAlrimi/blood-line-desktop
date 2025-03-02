import 'dart:async';
import 'package:blood_line_desktop/services/volunteering_services.dart';
import 'package:blood_line_desktop/widgets/custom_header.dart';
import 'package:flutter/material.dart';

class StaffVolunteersPage extends StatefulWidget {
  const StaffVolunteersPage({super.key});

  @override
  State<StaffVolunteersPage> createState() => _StaffVolunteersPageState();
}

class _StaffVolunteersPageState extends State<StaffVolunteersPage> {
  late VolunteerDataSource _dataSource;
  late Timer _timer;

  List<Map<String, dynamic>> _allVolunteers = [];
  List<Map<String, dynamic>> _filteredVolunteers = [];

  @override
  void initState() {
    super.initState();
    _dataSource = VolunteerDataSource();
    _fetchVolunteers();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _fetchVolunteers() async {
    final data = await VolunteerService.fetchVolunteers(context);
    if (data != null) {
      setState(() {
        _allVolunteers = data;
        _filteredVolunteers = data; // Initialize filtered list
        _dataSource.updateData(_filteredVolunteers);
      });
    }
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _fetchVolunteers();
    });
  }

  void _searchVolunteers(String query) {
    final filtered = _allVolunteers.where((volunteer) {
      final name = volunteer['name']?.toLowerCase() ?? '';
      final email = volunteer['email']?.toLowerCase() ?? '';
      final phone = volunteer['phone_number']?.toLowerCase() ?? '';
      return name.contains(query.toLowerCase()) ||
          email.contains(query.toLowerCase()) ||
          phone.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredVolunteers = filtered;
      _dataSource.updateData(_filteredVolunteers);
    });
  }

  @override
  Widget build(BuildContext context) {
    double columnSpacing = MediaQuery.of(context).size.width <= 1280.0 ? 185 : 250;
    int rowsPerPage = MediaQuery.of(context).size.height <= 697.3333333333334 ? 9 : 11;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomHeader(
              title: "Volunteers List",
              showSearch: true,
              onSearch: _searchVolunteers, // Pass search function to header
            ),
            Flexible(
              child: SingleChildScrollView(
                child: PaginatedDataTable(
                  source: _dataSource,
                  columns: const <DataColumn>[
                    DataColumn(label: Center(child: Text('#', style: TextStyle(fontWeight: FontWeight.bold)))),
                    DataColumn(label: Center(child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)))),
                    DataColumn(label: Center(child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold)))),
                    DataColumn(label: Center(child: Text('Phone Number', style: TextStyle(fontWeight: FontWeight.bold)))),
                    DataColumn(label: Center(child: Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)))),
                  ],
                  columnSpacing: columnSpacing,
                  rowsPerPage: rowsPerPage,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VolunteerDataSource extends DataTableSource {
  List<Map<String, dynamic>> _volunteers = [];

  void updateData(List<Map<String, dynamic>> volunteers) {
    _volunteers = volunteers;
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    final volunteer = _volunteers[index];
    return DataRow(
      cells: [
        DataCell(Text((index + 1).toString())),
        DataCell(Text(volunteer['name'] ?? '')),
        DataCell(Text(volunteer['email'] ?? '')),
        DataCell(Text(volunteer['phone_number'] ?? '')),
        DataCell(Text(volunteer['gender'] ?? '')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _volunteers.length;

  @override
  int get selectedRowCount => 0;
}

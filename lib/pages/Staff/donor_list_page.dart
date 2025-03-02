import 'dart:async';
import 'package:blood_line_desktop/main.dart';
import 'package:blood_line_desktop/services/donor_info_services.dart';
import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:blood_line_desktop/widgets/custom_header.dart';
import 'package:flutter/material.dart';

class DonorListPage extends StatefulWidget {
  const DonorListPage({super.key});

  @override
  State<DonorListPage> createState() => _DonorListPageState();
}

class _DonorListPageState extends State<DonorListPage> {
  late DonorDataSource donorDataSource;
  late Timer _timer;

  List<Map<String, dynamic>> _allDonors = [];
  List<Map<String, dynamic>> _filteredDonors = [];

  String selectedBloodGroup = 'All';

  @override
  void initState() {
    super.initState();
    donorDataSource = DonorDataSource();
    _fetchDonors();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _fetchDonors() async {
    final donors = await DonorService.fetchDonors(context);
    if (donors != null) {
      setState(() {
        _allDonors = donors;
        _filteredDonors = donors; // Initialize filtered list with all donors
        donorDataSource.updateData(_filteredDonors);
      });
    }
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _fetchDonors();
    });
  }

  void _filterDonors(String query) {
    final filtered = _allDonors.where((donor) {
      final name = donor['name']?.toLowerCase() ?? '';
      final email = donor['email']?.toLowerCase() ?? '';
      final bloodGroup = donor['blood_type'] ?? '';

      return (selectedBloodGroup == 'All' || bloodGroup == selectedBloodGroup) &&
          (name.contains(query.toLowerCase()) || email.contains(query.toLowerCase()));
    }).toList();

    setState(() {
      _filteredDonors = filtered;
      donorDataSource.updateData(_filteredDonors);
    });
  }

  @override
  Widget build(BuildContext context) {
    double columnSpacing = screenWidth <= 1280.0 ? 147 : 210;
    int rowsPerPage = screenHeight <= 697.3333333333334 ? 8 : 10;

    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomHeader(
              title: "Donor List",
              showSearch: true,
              onSearch: _filterDonors, // Pass search function to header
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Donor Information",
                  style: AppTheme.h3(),
                ),
                DropdownButton<String>(
                  value: selectedBloodGroup,
                  items: ['All', 'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                      .map((String group) {
                    return DropdownMenuItem<String>(
                      value: group,
                      child: Text(group),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedBloodGroup = newValue!;
                      _filterDonors('');
                    });
                  },
                  style: const TextStyle(
                      color: AppTheme.red, fontWeight: FontWeight.bold),
                  dropdownColor: AppTheme.white,
                  icon: const Icon(Icons.arrow_drop_down, color: AppTheme.red),
                ),
              ],
            ),
            Flexible(
              child: SingleChildScrollView(
                child: PaginatedDataTable(
                  source: donorDataSource,
                  columns: const <DataColumn>[
                    DataColumn(label: Text('#', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Blood Group', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Age', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Gender', style: TextStyle(fontWeight: FontWeight.bold))),
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

class DonorDataSource extends DataTableSource {
  List<Map<String, dynamic>> _donors = [];

  void updateData(List<Map<String, dynamic>> donors) {
    _donors = donors;
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    final donor = _donors[index];
    return DataRow(cells: [
      DataCell(Text((index + 1).toString())),
      DataCell(Text(donor['name'] ?? '')),
      DataCell(Text(donor['blood_type'] ?? '')),
      DataCell(Text(donor['email'] ?? '')),
      DataCell(Text(donor['age'].toString())),
      DataCell(Text(donor['gender'] ?? '')),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _donors.length;

  @override
  int get selectedRowCount => 0;
}

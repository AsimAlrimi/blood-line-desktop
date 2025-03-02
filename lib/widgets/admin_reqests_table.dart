import 'dart:async';
import 'package:blood_line_desktop/services/admin_requests_get.dart';
import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:blood_line_desktop/widgets/admin_reqests_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:blood_line_desktop/main.dart';

class MyDataSource extends DataTableSource {
  final BuildContext context; // Pass BuildContext to the DataSource
  final List<Map<String, dynamic>> requestsData; // Accept real data

  // Constructor to initialize context and real data
  MyDataSource(this.context, this.requestsData);

  @override
  int get rowCount => requestsData.length;

  @override
  DataRow? getRow(int index) {
    final data = requestsData[index];
    return DataRow(
      cells: <DataCell>[
        DataCell(Center(child: Text(data['organization_name'] ?? ''))),
        DataCell(Center(child: Text(data['manager_email'] ?? ''))),
        DataCell(Center(child: Text(data['contact_info'] ?? ''))),
        _buildKebabMenu(index),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  // Function to create kebab menu with dynamic index
  DataCell _buildKebabMenu(int index) {
    return DataCell(
      Center(
        child: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'Details') {
              _showDetailsDialog(index);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'Details',
              child: Text('Details', style: AppTheme.instruction(color: AppTheme.black)),
            ),
          ],
          icon: const Icon(Icons.more_vert, size: 20),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }

  // Function to show details dialog
  void _showDetailsDialog(int index) {
    final selectedData = requestsData[index];
    final requestId = selectedData['request_id']; // Ensure 'id' is available in your data
    showDialog(
      //    "latitude": 31.897953282881332,
      //     "longitude": 35.95637636020258,
      context: context,
      builder: (BuildContext context) {
        return AdminReqestsDetailsDialog(
          organizationName: selectedData['organization_name'] ?? '',
          organizationAddress: selectedData['organization_address'] ?? '',
          contactInfo: selectedData['contact_info'] ?? '',
          managerName: selectedData['manager_name'] ?? '',
          managerEmail: selectedData['manager_email'] ?? '',
          
          requestId: requestId.toString(),
          startHour: selectedData['start_hour'] ?? '',
          closeHour: selectedData['close_hour'] ?? '',
          lat: selectedData['latitude'] ?? '',
          lon: selectedData['longitude'] ?? '',
        );
      },
    );
  }
}

// Your admin request table
class AdminRequestsTable extends StatefulWidget {
  const AdminRequestsTable({super.key});

  @override
  _AdminRequestsTableState createState() => _AdminRequestsTableState();
}

class _AdminRequestsTableState extends State<AdminRequestsTable> {
  List<Map<String, dynamic>> requestsData = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch data when the widget initializes
    _startAutoRefresh(); // Start auto-refresh
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  Future<void> _fetchData() async {
    final fetchedData = await AdminRequestsLogic.fetchRegistrationRequests(context);
    if (fetchedData != null) {
      setState(() {
        requestsData = fetchedData;
      });
    }
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    double columnSpacing = screenWidth <= 1280.0 ? 250 : 312; 
    int rowsPerPage = screenHeight <= 697.3333333333334 ? 8 : 10;

    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Pending Requests", style: AppTheme.h3()),
          ),
          const SizedBox(height: 10),
          Flexible(
            child: SingleChildScrollView(
              child: PaginatedDataTable(
                source: MyDataSource(context, requestsData), // Pass real data
                columns: const <DataColumn>[
                  DataColumn(label: Flexible(child: Center(child: Text('Organization')))),
                  DataColumn(label: Flexible(child: Center(child: Text('Address')))),
                  DataColumn(label: Flexible(child: Center(child: Text('Contact')))),
                  DataColumn(label: Flexible(child: Center(child: Text('Action')))),
                ],
                columnSpacing: columnSpacing, // Use adjusted columnSpacing
                rowsPerPage: rowsPerPage, // Use adjusted rowsPerPage
              ),
            ),
          ),
        ],
      ),
    );
  }
}

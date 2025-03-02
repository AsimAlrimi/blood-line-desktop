import 'dart:async';
import 'package:blood_line_desktop/main.dart';
import 'package:blood_line_desktop/services/appointment_services.dart';
import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:blood_line_desktop/widgets/custom_header.dart';
import 'package:blood_line_desktop/widgets/staff_donation_process_dialog.dart';
import 'package:flutter/material.dart';

class DonationProcessPage extends StatefulWidget {
  const DonationProcessPage({super.key});

  @override
  State<DonationProcessPage> createState() => _DonationProcessPageState();
}

class _DonationProcessPageState extends State<DonationProcessPage> {
  late DonationDataSource _dataSource;
  late Timer _timer;

  List<Map<String, dynamic>> _allDonations = [];
  List<Map<String, dynamic>> _filteredDonations = [];

  Future<void> _fetchData() async {
    final data = await AppointmentsService.fetchTodayAppointments(context, "Donation");
    if (data != null) {
      setState(() {
        _allDonations = data;
        _filteredDonations = data;
        _dataSource.updateData(_filteredDonations);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _dataSource = DonationDataSource(context, buildKebabMenu);
    _fetchData();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        _fetchData();
      } else {
        _timer.cancel();
      }
    });
  }

  void _searchDonations(String query) {
    final filtered = _allDonations.where((donation) {
      final name = donation['Name']?.toLowerCase() ?? '';
      final email = donation['Email']?.toLowerCase() ?? '';
      return name.contains(query.toLowerCase()) || email.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredDonations = filtered;
      _dataSource.updateData(_filteredDonations);
    });
  }

  void _processDonation(int donationId) {
    // Find the donation details from the _allDonations list
    final donation = _allDonations.firstWhere(
      (d) => d['id'] == donationId,
      orElse: () => {},
    );
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StaffDonationProcessDialog(
          donorName: donation['Name'] ?? '',
          AppointmentID: donationId,
        );
      },
    ).then((_) {
      setState(() {
        final index = _allDonations.indexWhere((d) => d['id'] == donationId);
        if (index != -1) {
          _allDonations[index]['status'] = 'Processed';
        }
        _fetchData();
      });
    });
  }

  Future<void> _cancelAppointment(int appointmentId) async {
    final isSuccess = await AppointmentsService.openCancelAppointment(context, appointmentId.toString(), "cancel");
    if (isSuccess) {
      _fetchData();
    }
  }

  DataCell buildKebabMenu(int index, int donationId) {
    return DataCell(
      Center(
        child: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'Process') {
              _processDonation(donationId);
            } else if (value == 'Cancel') {
              _cancelAppointment(donationId);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'Process',
              child: Text('Process', style: AppTheme.instruction(color: AppTheme.black)),
            ),
            PopupMenuItem<String>(
              value: 'Cancel',
              child: Text('Cancel', style: AppTheme.instruction(color: AppTheme.black)),
            ),
          ],
          icon: const Icon(Icons.more_vert, size: 20),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double columnSpacing = screenWidth <= 1280.0 ? 160 : 223;
    int rowsPerPage = screenHeight <= 697.3333333333334 ? 9 : 11;
    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomHeader(
              title: "Donation Process",
              showSearch: true,
              onSearch: _searchDonations,
            ),
            Flexible(
              child: SingleChildScrollView(
                child: PaginatedDataTable(
                  source: _dataSource,
                  columns: const <DataColumn>[
                    DataColumn(label: Center(child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)))),
                    DataColumn(label: Center(child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold)))),
                    DataColumn(label: Center(child: Text('Donation Date & Time', style: TextStyle(fontWeight: FontWeight.bold)))),
                    DataColumn(label: Center(child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold)))),
                    DataColumn(label: Center(child: Text('Action', style: TextStyle(fontWeight: FontWeight.bold)))),
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

class DonationDataSource extends DataTableSource {
  final BuildContext context;
  final DataCell Function(int, int) buildKebabMenu;
  List<Map<String, dynamic>> _donations = [];

  DonationDataSource(this.context, this.buildKebabMenu);

  void updateData(List<Map<String, dynamic>> donations) {
    _donations = donations;
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    final donation = _donations[index];
    final D = '${donation['Date']} at ${donation['time']}';
    return DataRow(
      cells: [
        DataCell(Text(donation['Name'] ?? '')),
        DataCell(Text(donation['Email'] ?? '')),
        DataCell(Text(D)),
        DataCell(Text(
          donation['status'] ?? '',
          style: TextStyle(
            color: donation['status'] == 'Open' ? AppTheme.black : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        )),
        buildKebabMenu(index, donation['id']),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _donations.length;

  @override
  int get selectedRowCount => 0;
}
import 'dart:async';
import 'package:blood_line_desktop/main.dart';
import 'package:blood_line_desktop/services/appointment_services.dart';
import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:blood_line_desktop/widgets/custom_header.dart';
import 'package:flutter/material.dart';

class AppointmentsListPage extends StatefulWidget {
  const AppointmentsListPage({super.key});

  @override
  State<AppointmentsListPage> createState() => _AppointmentsListPageState();
}

class _AppointmentsListPageState extends State<AppointmentsListPage> {
  late AppointmentDataSource _dataSource;
  late Timer _timer;

  List<Map<String, dynamic>> _allAppointments = [];
  List<Map<String, dynamic>> _filteredAppointments = [];

  @override
  void initState() {
    super.initState();
    _dataSource = AppointmentDataSource(context, buildKebabMenu);
    _fetchData();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _fetchData() async {
    final data = await AppointmentsService.fetchTodayAppointments(context, "Appointmen");
    if (data != null) {
      setState(() {
        _allAppointments = data;
        _filteredAppointments = data; // Initialize filtered list with all appointments
        _dataSource.updateData(_filteredAppointments);
      });
    }
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _fetchData();
    });
  }

  void _searchAppointments(String query) {
    final filtered = _allAppointments.where((appointment) {
      final name = appointment['Name']?.toLowerCase() ?? '';
      final email = appointment['Email']?.toLowerCase() ?? '';
      return name.contains(query.toLowerCase()) || email.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredAppointments = filtered;
      _dataSource.updateData(_filteredAppointments);
    });
  }

Future<void> _openAppointment(int appointmentId) async {
  final isSuccess = await AppointmentsService.openCancelAppointment(context, appointmentId.toString(), "open");

  if (isSuccess) {
    _fetchData();
  }
}


  DataCell buildKebabMenu(int index, int appointmentId) {
    return DataCell(
      Center(
        child: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'Open') {
              _openAppointment(appointmentId);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'Open',
              child: Text('Open', style: AppTheme.instruction(color: AppTheme.black)),
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
              title: "Appointments List",
              showSearch: true,
              onSearch: _searchAppointments, // Pass search function to header
            ),
            Flexible(
              child: SingleChildScrollView(
                child: PaginatedDataTable(
                  source: _dataSource,
                  columns: const <DataColumn>[
                    DataColumn(label: Center(child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)))),
                    DataColumn(label: Center(child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold)))),
                    DataColumn(label: Center(child: Text('Appointment Date & Time', style: TextStyle(fontWeight: FontWeight.bold)))),
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

class AppointmentDataSource extends DataTableSource {
  final BuildContext context;
  final DataCell Function(int, int) buildKebabMenu;
  List<Map<String, dynamic>> _appointments = [];

  AppointmentDataSource(this.context, this.buildKebabMenu);

  void updateData(List<Map<String, dynamic>> appointments) {
    _appointments = appointments;
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    final appointment = _appointments[index];
    final D = '${appointment['Date']} at ${appointment['time']}';
    return DataRow(
      cells: [
        DataCell(Text(appointment['Name'] ?? '')),
        DataCell(Text(appointment['Email'] ?? '')),
        DataCell(Text(D)),
        DataCell(Text(
          appointment['status'] ?? '',
          style: TextStyle(
            color: appointment['status'] == 'Pending' ? AppTheme.black : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        )),
        buildKebabMenu(index, appointment['id']),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _appointments.length;

  @override
  int get selectedRowCount => 0;
}

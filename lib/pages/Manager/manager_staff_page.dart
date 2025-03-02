import 'dart:async';
import 'package:blood_line_desktop/main.dart';
import 'package:blood_line_desktop/services/manager_get_staff.dart';
import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:blood_line_desktop/widgets/custom_button_loginPage.dart';
import 'package:blood_line_desktop/widgets/custom_header.dart';
import 'package:blood_line_desktop/widgets/manger_add_staff_dialog.dart';
import 'package:flutter/material.dart';

class ManagerStaffPage extends StatefulWidget {
  const ManagerStaffPage({super.key});

  @override
  State<ManagerStaffPage> createState() => _ManagerStaffPageState();
}

class _ManagerStaffPageState extends State<ManagerStaffPage> {
  late EventsDataSource _dataSource;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _dataSource = EventsDataSource(context, buildKebabMenu);
    _loadStaff();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _loadStaff() async {
    final staff = await ManagerGetStaff.fetchStaffMembers(context);
    if (staff != null) {
      setState(() {
        _dataSource.updateData(staff);
      });
    }
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _loadStaff();
    });
  }

  DataCell buildKebabMenu(int index, int staffId) {
    return DataCell(
      Center(
        child: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'Delete') {
              ManagerGetStaff.deleteStaffMember(context, staffId).then((success) {
                if (success) {
                  _loadStaff();
                }
              });
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'Delete',
              child: Text(
                'Delete',
                style: AppTheme.instruction(color: AppTheme.black),
              ),
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
    double columnSpacing = screenWidth <= 1280.0 ? 275 : 312;
    int rowsPerPage = screenHeight <= 697.3333333333334 ? 9 : 10;
    
    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              children: [
                const CustomHeader(title: "Staff"),
                Flexible(
                  child: SingleChildScrollView(
                    child: PaginatedDataTable(
                      source: _dataSource,
                      columns: const <DataColumn>[
                        DataColumn(label: Center(child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)))),
                        DataColumn(label: Center(child: Text('Role', style: TextStyle(fontWeight: FontWeight.bold)))),
                        DataColumn(label: Center(child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold)))),
                        DataColumn(label: Center(child: Text('Action', style: TextStyle(fontWeight: FontWeight.bold)))),
                      ],
                      columnSpacing: columnSpacing,
                      rowsPerPage: rowsPerPage,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 28),
              child: Align(
                alignment: Alignment.topRight,
                child: CustomButtonLoginpage(
                  text: "Add",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ManagerAddStaffDialog();
                      },
                    );
                  },
                  size: const Size(120.0, 35.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventsDataSource extends DataTableSource {
  final BuildContext context;
  final DataCell Function(int, int) buildKebabMenu;
  List<Map<String, dynamic>> _staff = [];

  EventsDataSource(this.context, this.buildKebabMenu);

  void updateData(List<Map<String, dynamic>> staff) {
    _staff = staff;
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    final staff = _staff[index];
    return DataRow(
      cells: [
        DataCell(Center(child: Text(staff['username'] ?? ''))),
        DataCell(Center(child: Text(staff['role'] ?? ''))),
        DataCell(Center(child: Text(staff['email'] ?? ''))),
        buildKebabMenu(index, staff['id']),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _staff.length;

  @override
  int get selectedRowCount => 0;
}
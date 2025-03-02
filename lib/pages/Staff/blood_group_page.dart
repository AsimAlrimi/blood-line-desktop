import 'dart:async';
import 'package:blood_line_desktop/main.dart';
import 'package:blood_line_desktop/services/blood_inventory_service.dart';
import 'package:blood_line_desktop/widgets/blood_need_dialog.dart';
import 'package:flutter/material.dart';
import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:blood_line_desktop/widgets/custom_header.dart';

class BloodGroupPage extends StatefulWidget {
  const BloodGroupPage({super.key});

  @override
  State<BloodGroupPage> createState() => _BloodGroupPageState();
}

class _BloodGroupPageState extends State<BloodGroupPage> {
  late Future<List<Map<String, dynamic>>?> _bloodInventoryFuture;
  late Timer _refreshTimer;
  final List<String> _allBloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  void initState() {
    super.initState();
    _bloodInventoryFuture = _fetchAndMapBloodInventory();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>?> _fetchAndMapBloodInventory() async {
    final fetchedData = await BloodInventoryService.fetchBloodInventory(context);
    return _allBloodTypes.map((type) {
      final existing = fetchedData?.firstWhere(
        (entry) => entry['blood_type'] == type,
        orElse: () => {'blood_type': type, 'quantity': 0},
      );
      return {
        'blood_type': type,
        'quantity': existing?['quantity'] ?? 0,
      };
    }).toList();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        _bloodInventoryFuture = _fetchAndMapBloodInventory();
      });
    });
  }

  void _refreshData() {
    setState(() {
      _bloodInventoryFuture = _fetchAndMapBloodInventory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CustomHeader(title: "Blood Groups"),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Blood Group Information", style: AppTheme.h3()),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _buildInventoryTable(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryTable() {
    return FutureBuilder<List<Map<String, dynamic>>?>(
      future: _bloodInventoryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No blood group data available.'));
        }

        return SingleChildScrollView(
          child: PaginatedDataTable(
            source: _BloodGroupDataSource(context, snapshot.data!, _refreshData),
            columns: const [
              DataColumn(label: Center(child: Text('#', style: TextStyle(fontWeight: FontWeight.bold)))),
              DataColumn(label: Center(child: Text('Blood Type', style: TextStyle(fontWeight: FontWeight.bold)))),
              DataColumn(label: Center(child: Text('Available', style: TextStyle(fontWeight: FontWeight.bold)))),
              DataColumn(label: Center(child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)))),
            ],
            columnSpacing: screenWidth <= 1280.0 ? 260 : 323,
            rowsPerPage: 8,
          ),
        );
      },
    );
  }
}

class _BloodGroupDataSource extends DataTableSource {
  final BuildContext context;
  final List<Map<String, dynamic>> bloodGroups;
  final VoidCallback onDataChanged;

  _BloodGroupDataSource(this.context, this.bloodGroups, this.onDataChanged);

  @override
  DataRow getRow(int index) {
    final bloodGroup = bloodGroups[index];
    final availableUnits = bloodGroup['quantity'] ?? 0;
    return DataRow(cells: [
      DataCell(Center(child: Text((index + 1).toString()))),
      DataCell(Center(child: Text(bloodGroup['blood_type']))),
      DataCell(Center(child: Text('$availableUnits Unit'))),
      _buildKebabMenu(index),
    ]);
  }

  DataCell _buildKebabMenu(int index) {
    return DataCell(
      Center(
        child: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'Details':
                _showDetailsDialog(index);
                break;
              case 'Send':
                _sendBloodGroupInfo(index);
                break;
              case 'Edit':
                _editBloodGroup(index);
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            _buildMenuItem('Details'),
            _buildMenuItem('Send'),
            _buildMenuItem('Edit'),
          ],
          icon: const Icon(Icons.more_vert, size: 20),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(String value) {
    return PopupMenuItem<String>(
      value: value,
      child: Text(value, style: AppTheme.instruction(color: AppTheme.black)),
    );
  }

  void _showDetailsDialog(int index) {
    final bloodGroup = bloodGroups[index];
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: AppTheme.white,
        title: const Text("Blood Group Details"),
        content: Text(
          "Blood Type: ${bloodGroup['blood_type']}\n"
          "Available: ${bloodGroup['quantity']} Unit\n\n"
          "One unit of whole blood \n(approximately 450 mL to 500 mL)",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _sendBloodGroupInfo(int index) {
    final bloodGroup = bloodGroups[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BloodNeedDialog(bloodType: bloodGroup['blood_type'],);
      }
    );
  }

  void _editBloodGroup(int index) {
    final bloodGroup = bloodGroups[index];
    final TextEditingController unitsController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: AppTheme.white,
        title: Text("Take ${bloodGroup['blood_type']} Units"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: unitsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Units to Take',
                hintText: 'Enter number of units',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Available units: ${bloodGroup['quantity']}',
              style: AppTheme.instruction(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final units = int.tryParse(unitsController.text);
              if (units == null || units <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid number')),
                );
                return;
              }
              
              if (units > bloodGroup['quantity']) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Not enough units available')),
                );
                return;
              }

              final success = await BloodInventoryService.takeBloodUnits(
                context,
                bloodGroup['blood_type'],
                units,
              );

              if (success) {
                Navigator.of(context).pop();
                onDataChanged();
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  int get rowCount => bloodGroups.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
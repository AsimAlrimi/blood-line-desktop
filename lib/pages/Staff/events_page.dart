import 'package:blood_line_desktop/main.dart';
import 'package:blood_line_desktop/services/event_services.dart';
import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:blood_line_desktop/widgets/custom_button_loginPage.dart';
import 'package:blood_line_desktop/widgets/custom_header.dart';
import 'package:blood_line_desktop/widgets/event_dialog.dart';
import 'package:flutter/material.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  late EventsDataSource _dataSource;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAndSetEvents();
  }

  Future<void> _fetchAndSetEvents() async {
    final events = await EventService.fetchEvents(context);
    if (!mounted) return; // Prevent setState if the widget is not in the tree
    setState(() {
      _dataSource = EventsDataSource(
        events ?? [],
        _fetchAndSetEvents, // Pass the refresh callback
        context,           // Add the context parameter here
      );
      _isLoading = false;
    });
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
        child: Stack(
          children: [
            Column(
              children: [
                const CustomHeader(title: "Events"),
                Flexible(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          child: PaginatedDataTable(
                            source: _dataSource,
                            columns: const <DataColumn>[
                              DataColumn(label: Center(child: Text('Title', style: TextStyle(fontWeight: FontWeight.bold)))),
                              DataColumn(label: Center(child: Text('Description', style: TextStyle(fontWeight: FontWeight.bold)))),
                              DataColumn(label: Center(child: Text('Location', style: TextStyle(fontWeight: FontWeight.bold)))),
                              DataColumn(label: Center(child: Text('Appointment Date & Time', style: TextStyle(fontWeight: FontWeight.bold)))),
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
                    text: "New",
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return EventDialog(
                            onEventCreated: _fetchAndSetEvents, // Pass the refresh method
                          );
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
  final List<Map<String, dynamic>> _events;
  final VoidCallback onRefresh;
  final BuildContext context; // Add context as a class member

  EventsDataSource(this._events, this.onRefresh, this.context); // Update constructor

  DataCell buildKebabMenu(int index, int eventID) {
    return DataCell(
      Center(
        child: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'Delete') {
              // Call deleteEvent with proper context
              await deleteEvent(eventID);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'Delete',
              child: Text('Delete', style: AppTheme.instruction(color: AppTheme.black)),
            ),
          ],
          icon: const Icon(Icons.more_vert, size: 20),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Future<void> deleteEvent(int eventId) async {
    final success = await EventService.deleteEvent(context, eventId);
    if (success) {
      onRefresh(); // Refresh events after successful deletion
    }
  }

  @override
  DataRow getRow(int index) {
    final event = _events[index];
    return DataRow(
      cells: [
        DataCell(Text(event['title'] ?? '')),
        DataCell(Text(event['description'] ?? '')),
        DataCell(Text(event['location'] ?? '')),
        DataCell(Text('${event['event_date']} ${event['event_time']}')),
        buildKebabMenu(index, event['event_id']),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _events.length;

  @override
  int get selectedRowCount => 0;
}
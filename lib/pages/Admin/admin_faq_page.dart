import 'package:blood_line_desktop/main.dart';
import 'package:blood_line_desktop/services/faq_services.dart';
import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:blood_line_desktop/widgets/create_faq_dialog.dart';
import 'package:blood_line_desktop/widgets/custom_button_loginPage.dart';
import 'package:blood_line_desktop/widgets/custom_header.dart';
import 'package:flutter/material.dart';


class AdminFaqPage extends StatefulWidget {
  const AdminFaqPage({super.key});

  @override
  State<AdminFaqPage> createState() => _AdminFaqPageState();
}

class _AdminFaqPageState extends State<AdminFaqPage> {
  late EventsDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = EventsDataSource(context, buildKebabMenu);
    _loadFaqs();
  }

  Future<void> _loadFaqs() async {
    final faqs = await FaqService.getFaqs(context);
    if (faqs != null) {
      setState(() {
        _dataSource.updateData(faqs);
      });
    }
  }

  Future<void> _addFaq(String question, String answer) async {
    final success = await FaqService.addFaq(context, question, answer);
    if (success) {
      _loadFaqs();
    }
  }

  Future<void> deleteFaq(int faqId) async {
    final success = await FaqService.deleteFaq(context, faqId);
    if (success) {
      _loadFaqs();
    }
  }

  DataCell buildKebabMenu(int index, int faqId) {
    return DataCell(
      Center(
        child: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'Delete') {
              deleteFaq(faqId);
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

  @override
  Widget build(BuildContext context) {
    double columnSpacing = screenWidth <= 1280.0 ? 411 : 473;
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
                const CustomHeader(title: "FAQs"),
                Flexible(
                  child: SingleChildScrollView(
                    child: PaginatedDataTable(
                      source: _dataSource,
                      columns: const <DataColumn>[
                        DataColumn(label: Center(child: Text('Question', style: TextStyle(fontWeight: FontWeight.bold)))),
                        DataColumn(label: Center(child: Text('Answer', style: TextStyle(fontWeight: FontWeight.bold)))),
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
                        return CreateFaqDialog(
                          onSave: (question, answer) {
                            Navigator.pop(context);
                            _addFaq(question, answer);
                          },
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
  final BuildContext context;
  final DataCell Function(int, int) buildKebabMenu; // Add a reference to the kebab menu function
  List<Map<String, dynamic>> _faqs = [];

  EventsDataSource(this.context, this.buildKebabMenu);

  void updateData(List<Map<String, dynamic>> faqs) {
    _faqs = faqs;
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    final faq = _faqs[index];
    return DataRow(
      cells: [
        DataCell(Text(faq['question'] ?? '')),
        DataCell(Text(faq['answer'] ?? '')),
        buildKebabMenu(index, faq['id']), // Use the passed-in function here
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _faqs.length;

  @override
  int get selectedRowCount => 0;
}

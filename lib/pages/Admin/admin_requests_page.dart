import 'package:blood_line_desktop/widgets/admin_reqests_table.dart';
import 'package:blood_line_desktop/widgets/custom_header.dart';
import 'package:flutter/material.dart';
// Import the new header widget

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomHeader(title: "Requests",showSearch: false,), // Reusable header with dynamic title
          Flexible(
            child: Center(child: AdminRequestsTable()),
          ),
        ],
      ),
    );
  }
}

import 'package:blood_line_desktop/services/admin_requests_updata_post.dart';
import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:blood_line_desktop/widgets/custom_button_loginPage.dart';
import 'package:blood_line_desktop/widgets/custom_textfield_loginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminReqestsDetailsDialog extends StatefulWidget {
  final String organizationName;
  final String organizationAddress;
  final String contactInfo;
  final String managerName;
  final String managerEmail;
  final String startHour;
  final String closeHour;
  final String requestId;
  final double lat;
  final double lon;

  const AdminReqestsDetailsDialog({
    super.key,
    required this.organizationName,
    required this.organizationAddress,
    required this.contactInfo,
    required this.managerName,
    required this.managerEmail,
    required this.startHour,
    required this.closeHour,
    required this.requestId,
    required this.lat,
    required this.lon,
  });

  @override
  _AdminReqestsDetailsDialogState createState() => _AdminReqestsDetailsDialogState();
}

class _AdminReqestsDetailsDialogState extends State<AdminReqestsDetailsDialog> {
  final TextEditingController _messageController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildCoordinateBox(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.red.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: AppTheme.h4().copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: AppTheme.h4(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    String coordinatesString = '${widget.lat}, ${widget.lon}';
    String mapsUrl = 'https://www.google.com/maps?q=${widget.lat},${widget.lon}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Location:", style: AppTheme.instruction()),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildCoordinateBox('Lat', widget.lat.toStringAsFixed(6)),
            const SizedBox(width: 8),
            _buildCoordinateBox('Lon', widget.lon.toStringAsFixed(6)),
            const SizedBox(width: 12),
            IconButton(
              icon: Icon(Icons.copy, color: AppTheme.red),
              onPressed: () => _copyToClipboard(coordinatesString),
              tooltip: 'Copy coordinates',
            ),
            IconButton(
              icon: Icon(Icons.map, color: AppTheme.red),
              onPressed: () async {
                try {
                  await Clipboard.setData(ClipboardData(text: mapsUrl));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Google Maps link copied to clipboard'),
                      duration: Duration(seconds: 2),
                      
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to copy link'),
                  
                    ),
                  );
                }
              },
              tooltip: 'Copy Google Maps link',
            ),
          ],
        ),
        if (widget.organizationAddress.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            widget.organizationAddress,
            style: AppTheme.h4(),
          ),
        ],
      ],
    );
  }

  void _handleAction(BuildContext context, String action) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    int parsedRequestId = int.tryParse(widget.requestId) ?? 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(color: AppTheme.red),
        );
      },
    );

    bool success = await AdminRequestsUpdateLogic.updateRegistrationRequest(
      context: context,
      requestId: parsedRequestId,
      newStatus: action,
      message: _messageController.text.trim(),
    );

    Navigator.of(context).pop();

    if (success) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width - 400,
        height: MediaQuery.of(context).size.width - 900,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Details",
                    style: AppTheme.h1(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Organization Details:", style: AppTheme.instruction()),
                          const SizedBox(height: 5),
                          Text('Organization: ${widget.organizationName}', style: AppTheme.h4()),
                          const SizedBox(height: 8),
                          _buildAddressSection(),
                          const SizedBox(height: 8),
                          Text('Contact: ${widget.contactInfo}', style: AppTheme.h4()),
                        ],
                      ),
                    ),
                    SizedBox(width: 60),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Manager Details:", style: AppTheme.instruction()),
                          const SizedBox(height: 4),
                          Text('Manager: ${widget.managerName}', style: AppTheme.h4()),
                          Text('Email: ${widget.managerEmail}', style: AppTheme.h4()),
                          Text('Operating Hours: ${widget.startHour} to ${widget.closeHour}', style: AppTheme.h4()),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                CustomTextfieldLoginpage(
                  hintText: "Message...",
                  width: 330,
                  controller: _messageController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a message.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButtonLoginpage(
                      text: "Accept",
                      onPressed: () => _handleAction(context, "Accept"),
                    ),
                    const SizedBox(width: 30.0),
                    CustomButtonLoginpage(
                      text: "Reject",
                      onPressed: () => _handleAction(context, "Reject"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
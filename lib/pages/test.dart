
import 'package:blood_line_desktop/services/admin_requests_get.dart';
import 'package:blood_line_desktop/widgets/custom_button_loginPage.dart';
import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: ElevatedButton(
          onPressed: () async {
            // Call the function and print the result
            List<Map<String, dynamic>>? requests = await AdminRequestsLogic.fetchRegistrationRequests(context);
            print('Fetched Requests: $requests');
          },
          child: const Text('Fetch Registration Requests'),

      ),
    );
  }
}

// Second dialog widget
class SecondDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        width: MediaQuery.of(context).size.width - 500,
        height: MediaQuery.of(context).size.width - 800,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('This is the second dialog'),
            CustomButtonLoginpage(
              text: "Back",
              onPressed: () {
                // Go back to the first dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

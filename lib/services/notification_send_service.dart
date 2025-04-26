import 'dart:convert';

import 'package:http/http.dart' as http;

Future<void> sendTestNotification() async {
  const serverKey =
      'BGV_9-YQxpF2eRQ-HfHD63BXu8X_LWsyI0MHAlSeutNudzczw2uIHYg5ykKpICnO1791LSHqRyMkfJsliQRB4lQ';
  const deviceToken =
      "e7cV47UTRM-hQ-eJMZtgms:APA91bFSNy-2OPNbv9lUg6MWQ7jFgyhwciFQ4p55M5mcuhVMstdNeEEyz3wjfR_TuL11OHlC_K35MKdf4R00FYhzZZsRZDfHFQaJs4LHfnVECJOOK8VBVK4";

  final response = await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'), // EXACT URL
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey', // Must include "key="
    },
    body: jsonEncode({
      'to': deviceToken,
      'notification': {
        'title': 'Test Notification',
        'body': 'This should arrive now!',
        'sound': 'default',
      },
      'priority': 'high',
    }),
  );

  print('Response Status: ${response.statusCode}');
  print('Response Body: ${response.body}');
}

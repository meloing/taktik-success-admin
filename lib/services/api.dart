import 'dart:convert';
import 'package:http/http.dart' as http;


class ApiRequests {
  Future sendFcmMessage(String topic, String title, String message,
      String screen, String level, String subject) async {
    const String serverKey = 'YOUR_SERVER_KEY';
    const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

    final Map<String, dynamic> notification = <String, dynamic>{
      'title': title,
      'body': message
    };

    final Map<String, dynamic> data = <String, dynamic>{
      'level': 'level',
      'screen': screen,
      'subject': subject,
      'click_action': 'FLUTTER_NOTIFICATION_CLICK'
    };

    final Map<String, dynamic> payload = <String, dynamic>{
      'notification': notification,
      'data': data,
      'to': topic
    };

    final http.Response response = await http.post(
      Uri.parse(fcmUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(payload),
    );

    if(response.statusCode == 200) {
      return true;
    }
    else {
      return false;
    }
  }
}
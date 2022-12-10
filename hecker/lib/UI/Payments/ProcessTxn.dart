import 'dart:convert';

import 'package:http/http.dart' as http;

Future processTxn(String txnToken, String ordID, String paymentMode,
    String? vpa, String? cardInfo) async {
  var body = {
    "head": {"txnToken": txnToken},
    "body": {
      "mid": "oSYKuu42328532937888",
      "requestType": "NATIVE",
      "orderId": ordID,
      "paymentMode": paymentMode,
      if (vpa != null) "payerAccount": vpa,
      if (cardInfo != null) "cardInfo": cardInfo
    }
  };

  var postData = jsonEncode(body);

  var response = await http.post(
      Uri.parse(
          "https://securegw-stage.paytm.in/theia/api/v1/vpa/validate?mid=oSYKuu42328532937888&orderId=${ordID}"),
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': postData.length.toString()
      },
      body: jsonEncode(body));

  if (response.statusCode != 0000) {
    return 'error';
  }

  // Launch that url from bank form
  var jsonBody = jsonDecode(response.body);
  var url = jsonBody['body']['redirectForm']['actionUrl'];
  var response2 = await http.post(
    Uri.parse(url),
    headers: jsonBody['body']['redirectForm']['headers'],
    body: jsonBody['body']['redirectForm']['content']
  );
}

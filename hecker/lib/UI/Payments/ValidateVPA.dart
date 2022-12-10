import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String> validateVPA(String txnToken, String? vpa, String? number,
    String ordID) async {

  var body = {
    "head" : {"tokenType": "TXN_TOKEN", "token": txnToken},
    "body" : { 
      if(vpa != null) "vpa": vpa,
      if(number != null) "numericID": number
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

  var vpaJSON = jsonDecode(response.body);
  var resultCode = vpaJSON['body']['resultInfo']['resultStatus'];
  if (resultCode.toString() != 'S') {
    return 'error';
  }

  return vpaJSON['body']['valid'].toString();
}

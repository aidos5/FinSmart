import 'dart:convert';
import 'dart:developer';

import 'package:hecker/Model/Bill.dart';
import 'package:hecker/Model/ShopDetail.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

Future<String> getTxnToken(ShopDetail shopDetail, Bill bill) async {
  // Make POST body
  var formatter = new DateFormat('ddMMyyyy');
  String date = formatter.format(DateTime.now());
  String shopID = shopDetail.id!;
  var items = bill.toJson()['items'];
  String shopType = "General";
  String pincode = shopDetail.pincode!;
  // String mid = shopDetail.paytmMID!;
  String customerMobile = bill.customerNumber;

  var body = {
    "mid": "oSYKuu42328532937888",
    "date": date,
    "shopID": shopID,
    "items": items,
    "customerMobile": customerMobile,
    "pincode": pincode,
    "shopType": shopType
  };

  var response = await http.post(
      Uri.parse("https://payments.finsmart.workers.dev/txnToken/"),
      body: jsonEncode(body)
    );

  var tokenJSON = jsonDecode(response.body);

  var resultCode = tokenJSON['body']['resultInfo']['resultStatus'];
  if (resultCode.toString() != 'S') {
    return 'error';
  }

  return tokenJSON['body']['txnToken'].toString() + "|" + tokenJSON['body']['ordID'].toString();
}

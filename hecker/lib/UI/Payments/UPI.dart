import 'package:flutter/material.dart';
import 'package:hecker/Model/Bill.dart';
import 'package:hecker/Model/ShopDetail.dart';
import 'package:hecker/UI/BuyStuff/BuyStuffCart.dart';
import 'package:hecker/UI/Payments/GetTxnToken.dart' as GetTxnToken;
import 'package:hecker/UI/Payments/ValidateVPA.dart';

class UPI extends StatefulWidget {
  UPI({required this.bill, required this.shopDetail, Key? key})
      : super(key: key);

  Bill? bill;
  ShopDetail? shopDetail;

  @override
  State<UPI> createState() => _UPIState(bill: bill, shopDetail: shopDetail);
}

class _UPIState extends State<UPI> {
  Bill? bill;
  ShopDetail? shopDetail;
  _UPIState({required this.bill, required this.shopDetail});

  bool isVerified = false;
  bool isInit = false;
  bool isError = false;

  String txnToken = '';
  String ordID = '';

  TextEditingController vpaController = TextEditingController();
  TextEditingController noController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setup();
  }

  void setup() async {
    txnToken = (await GetTxnToken.getTxnToken(shopDetail!, bill!)).toString();

    print(txnToken);

    if (txnToken == 'error') {
      // show error
      setState(() {
        isError = true;
      });
    } else {
      setState(() {
        List<String> tokens = txnToken.split("|");
        txnToken = tokens[0];
        ordID = tokens[1];
        isInit = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (isError) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Error'),
                content: Center(child: Text("Something went wrong...")),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => BuyStuffCart(
                                      shopDetail: shopDetail,
                                      bill: bill,
                                    )),
                            (route) => false);
                      },
                      child: Text('OK'))
                ],
              ));
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "FinSmart",
          style: TextStyle(fontSize: 37),
        ),
        leading: MaterialButton(
          onPressed: (() {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => BuyStuffCart(shopDetail: shopDetail, bill: bill,)),
                (route) => false);
          }),
          child: Icon(
            Icons.arrow_back_sharp,
            color: Colors.black,
          ),
        ),
      ),
      body: isInit
          ? Container(
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            labelText: "Enter UPI Address",
                            border: OutlineInputBorder()),
                        // keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Enter UPI Address';
                          } else {
                            return null;
                          }
                        },
                        controller: vpaController,
                        onChanged: (value) {
                          setState(() {
                            noController.text = '';
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            labelText: "Enter UPI Number",
                            border: OutlineInputBorder()),
                        // keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Enter UPI Number';
                          } else {
                            return null;
                          }
                        },
                        onChanged: ((value) {
                          setState(() {
                            vpaController.text = '';
                          });
                        }),
                        controller: noController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: screenWidth / 2,
                        child: ElevatedButton(
                          onPressed: (() async {
                            // call verify vpa API
                            bool verified = await validateVPA(
                                    txnToken,
                                    vpaController.text,
                                    noController.text,
                                    ordID) ==
                                'true';

                            // set isVerify to true
                            setState(() {
                              isVerified = verified;
                            });
                          }),
                          child: Text(
                            'Verify',
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: screenWidth / 2,
                        child: ElevatedButton(
                          onPressed: isVerified
                              ? (() {
                                  // call process transaction API
                                  // set isVerify to true
                                })
                              : null,
                          child: Text(
                            (isVerified
                                ? 'Proceed to Payment'
                                : 'Verifying...'),
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: Text('Loading...'),
            ),
    );
  }

  Future processTxn() async {}
}

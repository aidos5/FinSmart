import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hecker/AccountDone.dart';
import 'Model/ShopDetail.dart';
import 'package:localstorage/localstorage.dart';

class ShopDetails extends StatefulWidget {
  ShopDetails({Key? key}) : super(key: key);

  @override
  State<ShopDetails> createState() => _ShopDetailsState();
}

class _ShopDetailsState extends State<ShopDetails> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  // Text Controllers
  TextEditingController nameCont = new TextEditingController();
  TextEditingController pincodeCont = new TextEditingController();
  TextEditingController addrCont = new TextEditingController();
  TextEditingController numberCont = new TextEditingController();
  TextEditingController mailCont = new TextEditingController();
  TextEditingController gstnCont = new TextEditingController();

  List<String> Category = ['Select Category', 'General'];
  String? selectedCategory = 'Select Category';

  final localStorage = new LocalStorage('shopDetail.json');

  ShopDetail? shopDetail;
  bool isInit = false;
  @override
  void initState() {
    // TODO: implement initState
    GetShopDetail();
  }

  void GetShopDetail() async {
    var sD = await localStorage.getItem('shop');
    if (sD == null) {
      await localStorage.setItem('shop', new ShopDetail());
    }

    shopDetail = await ShopDetail.fromJson(localStorage.getItem('shop'));

    print(shopDetail!.toJson());
    isInit = true;
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text('FinSmart')),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Expanded(
          child: SizedBox(
            width: screenwidth,
            child: Column(
              children: [
                const Text(
                  'Enter Shop Details',
                  style: TextStyle(fontSize: 37),
                ),
                Form(
                  key: formkey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: nameCont,
                          decoration: const InputDecoration(
                              labelText: 'Shop Name',
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Enter Your Shop Name';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: pincodeCont,
                          maxLength: 6,
                          decoration: const InputDecoration(
                              labelText: "Enter Area PIN",
                              border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            if (value != null && value.length < 6) {
                              return 'Enter PIN';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: addrCont,
                          maxLines: 5,
                          decoration: const InputDecoration(
                              labelText: 'Shop Address',
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Enter Shop Address';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: numberCont,
                          decoration: const InputDecoration(
                              labelText: 'Contact Number',
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Enter Your Shop Contact Number';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: mailCont,
                          decoration: const InputDecoration(
                              labelText: 'Contact mail',
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Enter Your Shop Contact Mail';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: gstnCont,
                          decoration: const InputDecoration(
                              labelText: 'GSTN', border: OutlineInputBorder()),
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Enter Your Business GSTN';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 18,
                            left: screenwidth / 4,
                            right: screenwidth / 4),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          value: selectedCategory,
                          items: Category.map(
                            ((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                )),
                          ).toList(),
                          onChanged: (item) =>
                              setState(() => selectedCategory = item),
                          validator: (value) {
                            if (value != null && value == 'Select Category') {
                              return 'Enter Category';
                            } else
                              return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                  child: SizedBox(
                    height: screenheight / 15,
                    width: screenwidth / 3,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formkey.currentState!.validate()) {
                          shopDetail!.name = nameCont.text;
                          shopDetail!.address = addrCont.text;
                          shopDetail!.pincode = pincodeCont.text;
                          shopDetail!.contactNumber = numberCont.text;
                          shopDetail!.contactMail = mailCont.text;
                          shopDetail!.gstn = gstnCont.text;
                          shopDetail!.categoryCode = selectedCategory;

                          await localStorage.setItem('shop', shopDetail);

                          print(await localStorage.getItem('shop'));

                          //print("successful");
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => AccountDone()),
                              (route) => false);

                          return;
                        } else {
                          print("UnSuccessfull");
                        }
                      },
                      child: Text("Submit"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

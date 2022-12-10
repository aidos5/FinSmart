import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hecker/MainPage.dart';
import 'package:hecker/Model/ShopDetail.dart';
import 'package:hecker/Navigation.dart';
import 'package:hecker/UI/BuyStuff/BuyStuffItemsDisplay.dart';
import 'package:hecker/UI/Colors.dart';
import 'package:localstorage/localstorage.dart';

class BuyStuff extends StatefulWidget {
  BuyStuff({Key? key}) : super(key: key);

  @override
  State<BuyStuff> createState() => _BuyStuffState();
}

class _BuyStuffState extends State<BuyStuff> {
  TextEditingController searchController = new TextEditingController();
  var localStorageShop = new LocalStorage('shopDetail.json');
  ShopDetail? shopDetail;
  QueryDocumentSnapshot? lastDoc;

  List<ShopDetail>? shopDetails;

  bool isInit = false;

  @override
  void initState() {
    super.initState();

    loadStuff();
  }

  void loadStuff() async {
    await LoadShopDetail();
    await getShops(20);

    if (shopDetails != null) {
      setState(() {
        print("shop det = " + shopDetails!.length.toString());
        isInit = true;
      });
    }
  }

  Future getShops(int count) async {
    var shopCollection =
        FirebaseFirestore.instance.collectionGroup('shopDetail');

    var geoHash = shopDetail!.geoHash;
    print(geoHash);
    var shopDocsSnap = await shopCollection
        .where('proximityHashes', arrayContains: geoHash!)
        .limit(count)
        // .startAfter([lastDoc])
        .get();

    print(shopDocsSnap.size);

    if (shopDocsSnap.docs.isEmpty) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("No Shops!"),
                content: Text(
                    "Seems like no shops are serving to your location!\nBut Don't worry we are rapidly expanding our network :)"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("OK"))
                ],
              ));
      return null;
    }

    lastDoc = shopDocsSnap.docs[shopDocsSnap.docs.length - 1];

    shopDetails = [];
    setState(() {
      shopDocsSnap.docs.forEach((element) {
        var shopDet = ShopDetail.fromJson(element.data());

        // print(shopDet.toJson());
        shopDetails!.add(shopDet);
      });
    });

    // print("gandu");
  }

  Future loadMoreShops(int count) async {
    var shopCollection = FirebaseFirestore.instance.collection('transactions');

    var geoHash = shopDetail!.geoHash;
    print(geoHash);
    var shopDocsSnap = await shopCollection
        .where('proximityHashes', arrayContains: geoHash)
        .limit(count)
        .startAfter([lastDoc]).get();

    lastDoc = shopDocsSnap.docs[shopDocsSnap.docs.length - 1];

    setState(() {
      shopDocsSnap.docs.forEach((element) {
        var shopDet = ShopDetail.fromJson(element.data());

        shopDetails!.add(shopDet);
      });
    });
  }

  Future LoadShopDetail() async {
    var shopJSON = await localStorageShop.getItem('shop');
    shopDetail = ShopDetail.fromJson((shopJSON as Map<String, dynamic>));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "FinSmart",
          style: TextStyle(fontSize: 37),
        ),

        // leading: MaterialButton(
        //   onPressed: (() {
        //     Navigator.of(context).pushAndRemoveUntil(
        //         MaterialPageRoute(builder: (context) => MainPage()),
        //         (route) => false);
        //   }),
        //   child: Icon(
        //     Icons.arrow_back_sharp,
        //     color: AppColors.black,
        //   ),
        // ),
      ),
      drawer: Navigation(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search Item',
              ),
              onChanged: (value) {},
            ),
          ),

          // Display shops here
          Expanded(
            child: isInit
                ? ListView.builder(
                  itemCount: shopDetails!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return shop(index);
                  },
                )
                : Center(
                    child: Text("Loading..."),
                  ),
          )
        ],
      ),
    );
  }

  Card shop(int index) {
    return Card(
      child: InkWell(
        onTap: () {
          // Open Panel to show items of the shop
          Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => BuyStuffItemsDisplay.load(shopDetail: shopDetails![index],)),
                (route) => false);
        },
        child: Column(
          children: [
            Text(shopDetails![index].name!),
            Text("ID = " + shopDetails![index].id!),
          ],
        ),
      ),
    );
  }
}

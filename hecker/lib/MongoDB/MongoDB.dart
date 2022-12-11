import 'package:mongo_dart/mongo_dart.dart';

class MongoDB {
  static Db? db, dbLocal;

  static Future<Db?> init() async {
    // Init mongo db
    db = await Db.create(
        "mongodb+srv://nillastudios:ifyouseethisyouaregay@finsmart.plg9l19.mongodb.net/finsmart?retryWrites=true&w=majority");
    await db!.open();
    return db;
  }
}

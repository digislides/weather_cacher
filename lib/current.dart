import 'package:open_weather_api/open_weather_api.dart';
import 'package:open_weather_api/simple.dart' as simple;

import 'package:mongo_dart/mongo_dart.dart' as mgo;

Future<List<int>> getIds(mgo.Db db) async {
  return await (await db
          .collection("data_weath_cur")
          .find(mgo.where.fields(["id"])))
      .map((m) => m["id"])
      .cast<int>()
      .toList();
}

Future<void> cacheCurrent(mgo.Db db, OpenWeatherApi api) async {
  final ids = await getIds(db);

  for (int id in ids) {
    try {
      final data =
          (await api.byId(id.toString(), unit: TemperatureUnit.celsius))
              .simplified();
      final up = mgo.modify;
      final map = simple.Weather.serializer.toMap(data);
      map.forEach((k, v) {
        up.set(k, v);
      });
      up.set("upd", DateTime.now().toUtc().millisecondsSinceEpoch);

      await db.collection("data_weath_cur").update(mgo.where.eq('id', id), up);
    } catch (e) {
      print("Error updating for $id: $e");
    }
  }
}

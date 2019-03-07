import 'package:open_weather_api/open_weather_api.dart';
import 'package:open_weather_api/simple.dart' as simple;

import 'package:mongo_dart/mongo_dart.dart' as mgo;

import 'current.dart';
import 'hourly_forecasts.dart';

Future<void> cache(String dbUrl, OpenWeatherApi api) async {
  final db = mgo.Db(dbUrl);
  await db.open();

  try {
    await cacheCurrent(db, api);
  } catch (e) {
    // TODO
  }

  try {
    await cacheHourlyForecasts(db, api);
  } catch (e) {
    // TODO
  }

  await db.close();
}

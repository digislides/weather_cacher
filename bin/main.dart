import 'dart:io';
import 'dart:async';
import 'package:http/io_client.dart';
import 'package:jaguar_resty/jaguar_resty.dart';
import 'package:weather_cacher/weather_cacher.dart';

import 'package:open_weather_api/open_weather_api.dart';

main(List<String> arguments) async {
  globalClient = IOClient();

  final owmApiKey = Platform.environment["OWM_API_KEY"];
  final owmApi = OpenWeatherApi(owmApiKey);

  print("Updating at ${DateTime.now()} ...");
  try {
    await cache("mongodb://localhost:27018/echannel", owmApi);
  } catch (e) {
    // TODO
  }

  Timer.periodic(Duration(minutes: 30), (_) async {
    print("Updating at ${DateTime.now()} ...");
    try {
      await cache("mongodb://localhost:27018/echannel", owmApi);
    } catch (e) {
      // TODO
    }
  });
}

import 'dart:async';

import "package:open_meteo_api/open_meteo_api.dart" hide Weather;
import 'package:weather_repository/weather_repository.dart';

class WeatherRepository {
  WeatherRepository({OpenMeteoApiClient? weatherApiClient})
      : _weatherApiClient = weatherApiClient ?? OpenMeteoApiClient();

  //holding the data provider to work with ,exposing some functions if needed
  final OpenMeteoApiClient _weatherApiClient;

  Future<List<Suggest>> getSuggestions(String query) async {
    final searchResult = await _weatherApiClient.getSuggestions(query);
    final List<Suggest> finalResult = [
      ...searchResult.map((location) {
        return Suggest(location: location.name, country: location.country);
      })
    ];
    print(finalResult);
    return finalResult;
  }

  //the method exposed for our app usage, best place to
  Future<Weather> getWeather(String city) async {
    final location = await _weatherApiClient.locationSearch(city);
    final weather = await _weatherApiClient.getWeather(
        latitude: location.latitude, longitude: location.longitude);

    //basically casting model to our entity class
    return Weather(
      tempreture: weather.temperature,
      location: location.name,
      condition: weather.weatherCode.toInt().toCondition,
    );
  }
}

extension on int {
  WeatherCondition get toCondition {
    switch (this) {
      case 0:
        return WeatherCondition.clear;
      case 1:
      case 2:
      case 3:
      case 45:
      case 48:
        return WeatherCondition.cloudy;
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
      case 95:
      case 96:
      case 99:
        return WeatherCondition.rainy;
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return WeatherCondition.snowy;
      default:
        return WeatherCondition.unknown;
    }
  }
}

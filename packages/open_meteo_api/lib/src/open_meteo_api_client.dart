// finds a [Location] `/v1/search/>name=(query)`,
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import "package:open_meteo_api/open_meteo_api.dart";

class LocationRequestFailure implements Exception {}

class LocationNotFoundFailure implements Exception {}

class WeatherRequestFailure implements Exception {}

class WeatherNotFoundFailure implements Exception {}

class SuggestionRequestFailure implements Exception {}

class SuggestionNotFountFailure implements Exception {}

class OpenMeteoApiClient {
  OpenMeteoApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrlWeather = 'api.open-meteo.com';
  static const _baseUrlGeocoding = 'geocoding-api.open-meteo.com';

  final http.Client _httpClient;

  Future<Location> locationSearch(String query) async {
    final locationRequest = Uri.https(
      _baseUrlGeocoding,
      '/v1/search',
      {'name': query, 'count': '1'},
    );

    final locationResponse = await _httpClient.get(locationRequest);

    if (locationResponse.statusCode != 200) {
      throw LocationRequestFailure();
    }

    final locationJson = jsonDecode(locationResponse.body) as Map;

    if (!locationJson.containsKey('results')) throw LocationNotFoundFailure();

    final results = locationJson['results'] as List;

    if (results.isEmpty) throw LocationNotFoundFailure();

    return Location.fromJson(results.first as Map<String, dynamic>);
  }

  Future<List<Location>> getSuggestions(String query) async {
    final suggestionRequest = Uri.https(_baseUrlGeocoding, '/v1/search', {
      "name": query,
    });

    final suggestionResponse = await _httpClient.get(suggestionRequest);

    if (suggestionResponse.statusCode != 200) {
      throw SuggestionRequestFailure();
    }

    final suggestionJson = jsonDecode(suggestionResponse.body) as Map;

    if (!suggestionJson.containsKey('results'))
      throw SuggestionNotFountFailure();

    final results = suggestionJson['results'] as List;

    if (results.isEmpty) throw SuggestionNotFountFailure();

    final List<Location> finalResult = [
      ...results.map((item) {
        return Location.fromJson(item as Map<String, dynamic>);
      })
    ];

    return finalResult;
  }

  Future<Weather> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    //we just make a request using Uri and we set params and methods all along
    final weatherRequest = Uri.https(_baseUrlWeather, 'v1/forecast', {
      'latitude': '$latitude',
      'longitude': '$longitude',
      'current_weather': 'true',
    });

    //here we call the request using our httpclient instance and the method
    final weatherResponse = await _httpClient.get(weatherRequest);

    if (weatherResponse.statusCode != 200) {
      throw WeatherRequestFailure();
    }

    final bodyJson = jsonDecode(weatherResponse.body) as Map<String, dynamic>;

    if (!bodyJson.containsKey('current_weather')) {
      throw WeatherNotFoundFailure();
    }

    final weatherJson = bodyJson['current_weather'] as Map<String, dynamic>;

    return Weather.fromJson(weatherJson);
  }
}

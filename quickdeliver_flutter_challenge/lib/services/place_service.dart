import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/place_suggestions.dart';



class PlaceService {
  Future<List<PlaceSuggestion>> getPlaceSuggestions(String input) async {
    final String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final String apiKey ='AIzaSyAsbgmGJS6aQVd3tmqxyMM7QkIv89kfD3I';

    final String url =
        '$baseUrl?input=$input&key=$apiKey&components=country:gh';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final predictions = data['predictions'] as List;

      return predictions
          .map((p) => PlaceSuggestion(
                description: p['description'],
                placeId: p['place_id'],
              ))
          .toList();
    } else {
      throw Exception('Failed to fetch suggestions: ${response.body}');
    }
  }

  Future<Map<String, double>> getPlaceLatLng(String placeId) async {
    final String detailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json';
    final String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;

    final String url = '$detailsUrl?place_id=$placeId&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final location = data['result']['geometry']['location'];

      return {
        'lat': location['lat'] as double,
        'lng': location['lng'] as double,
      };
    } else {
      throw Exception('Failed to fetch place details: ${response.body}');
    }
  }
}

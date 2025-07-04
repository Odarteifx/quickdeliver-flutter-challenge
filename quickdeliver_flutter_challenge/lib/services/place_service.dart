import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PlaceService {
  Future<List<String>> getPlaceSuggestions(String input) async {
    final String baseUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;
    final String url = '$baseUrl?input=$input&key=$apiKey&components=country:gh';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final predictions = data['predictions'] as List;
      return predictions.map((p) => p['description'] as String).toList();
    } else {
      throw Exception('Failed to fetch suggestions');
    }
  }
}

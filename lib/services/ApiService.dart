import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:diacritic/diacritic.dart';

String normalizeName(String name) {
  return removeDiacritics(name).toLowerCase();
}

class ApiService {
  static const String baseUrl = 'https://v3.football.api-sports.io';
  static const String apiKey = '6b973078f78482988891aa4731224ee9';

  Future<Map<String, dynamic>> searchPlayer({
    required String playerName,
    String? teamName,
    String? teamId,
  } )async {
    try {
      String queryParams;
      
      // Split by any special character (., -, _, etc) and spaces
        String familyName = normalizeName(playerName)
        .split(RegExp(r'[\s.-]'))
        .where((part) => part.isNotEmpty)
        .last
        .trim();
      
      if (teamName != null && teamName.isNotEmpty) {
        final teamResponse = await searchTeam(teamName);
        if (teamResponse['response'].isNotEmpty) {
          teamId = teamResponse['response'][0]['team']['id'].toString();
        }
      }

      if (teamId != null) {
        queryParams = 'search=$familyName&team=$teamId';
      } else {
        queryParams = 'search=$familyName';
      }
      
      final response = await http.get(
        Uri.parse('$baseUrl/players?$queryParams'),
        headers: {
          'x-rapidapi-host': 'v3.football.api-sports.io',
          'x-rapidapi-key': apiKey,
          
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        return decodedResponse;
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw Exception('Failed to load player data: $e');
    }
  }

  Future<Map<String, dynamic>> getPlayerProfile(String playerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/players/profiles?player=$playerId'),
        headers: {
          'x-rapidapi-host': 'v3.football.api-sports.io',
          'x-rapidapi-key': apiKey
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load player profile');
      }
    } catch (e) {
      throw Exception('Failed to load player profile: $e');
    }
  }

  Future<Map<String, dynamic>> searchTeam(String teamName) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/teams?search=$teamName'),
        headers: {
          'x-rapidapi-host': 'v3.football.api-sports.io',
          'x-rapidapi-key': apiKey
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load team data');
      }
    } catch (e) {
      throw Exception('Failed to load team data: $e');
    }
  }

  Future<Map<String, dynamic>> getTeamPlayers(String teamId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/players/squads?team=$teamId'),
        headers: {
          'x-rapidapi-host': 'v3.football.api-sports.io',
          'x-rapidapi-key': apiKey
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load team players');
      }
    } catch (e) {
      throw Exception('Failed to load team players: $e');
    }
  }
}

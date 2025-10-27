import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/game.dart';


class JsonExportService {
  static const String _bundleIdentifier = 'com.gameone.collection';


  // Export games to JSON file
  Future<String> exportToJsonFile(List<Game> games, String filePath) async {
    try {
      final jsonData = _createExportData(games);
      final jsonString = jsonEncode(jsonData);
      
      final file = File(filePath);
      await file.writeAsString(jsonString);
      
      return filePath;
    } catch (e) {
      throw Exception('Failed to export JSON file: $e');
    }
  }

  // Import games from JSON file
  Future<List<Game>> importFromJsonFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File does not exist: $filePath');
      }
      
      final jsonString = await file.readAsString();
      return _parseJsonData(jsonString);
    } catch (e) {
      throw Exception('Failed to import JSON file: $e');
    }
  }

  // Export games to JSON string
  String exportToJsonString(List<Game> games) {
    final jsonData = _createExportData(games);
    return jsonEncode(jsonData);
  }

  // Import games from JSON string
  List<Game> importFromJsonString(String jsonString) {
    return _parseJsonData(jsonString);
  }

  // Create comprehensive export data
  Map<String, dynamic> _createExportData(List<Game> games) {
    final now = DateTime.now();
    
    return {
      'export_info': {
        'app_name': 'GameOne',
        'bundle_identifier': _bundleIdentifier,
        'version': '1.0.0',
        'export_date': now.toIso8601String(),
        'export_timestamp': now.millisecondsSinceEpoch,
        'platform': defaultTargetPlatform.name,
      },
      'statistics': {
        'total_games': games.length,
        'favorite_games': games.where((g) => g.isFavorite).length,
        'completed_games': games.where((g) => g.status == 'Selesai').length,
        'playing_games': games.where((g) => g.status == 'Sedang Dimainkan').length,
        'wishlist_games': games.where((g) => g.status == 'Wishlist').length,
        'unique_genres': games.map((g) => g.genre).toSet().length,
        'total_playtime_hours': games.fold<double>(0, (sum, game) => sum + game.playtime),
        'average_rating': games.isEmpty ? 0.0 : 
          games.fold<double>(0, (sum, game) => sum + game.rating) / games.length,
      },
      'genres': games.map((g) => g.genre).toSet().toList()..sort(),
      'platforms': games.map((g) => g.platform).toSet().toList()..sort(),
      'data': {
        'games_count': games.length,
        'games': games.map((game) => game.toJson()).toList(),
      }
    };
  }

  // Parse JSON data with backward compatibility
  List<Game> _parseJsonData(String jsonString) {
    try {
      final dynamic data = jsonDecode(jsonString);
      
      // New format with export_info and data structure
      if (data is Map<String, dynamic> && 
          data.containsKey('data') && 
          data.containsKey('export_info')) {
        final gameData = data['data'];
        if (gameData is Map<String, dynamic> && gameData.containsKey('games')) {
          final List<dynamic> gamesJson = gameData['games'];
          return gamesJson.map((json) => Game.fromJson(json)).toList();
        }
      }
      
      // Old format with app_info
      else if (data is Map<String, dynamic> && 
               data.containsKey('games') && 
               data.containsKey('app_info')) {
        final List<dynamic> gamesJson = data['games'];
        return gamesJson.map((json) => Game.fromJson(json)).toList();
      }
      
      // Very old format (direct array)
      else if (data is List) {
        return data.map((json) => Game.fromJson(json)).toList();
      }
      
      // Old format (object with direct games array)
      else if (data is Map<String, dynamic> && data.containsKey('games')) {
        final List<dynamic> gamesJson = data['games'];
        return gamesJson.map((json) => Game.fromJson(json)).toList();
      }
      
      throw Exception('Unrecognized JSON format');
    } catch (e) {
      throw Exception('Invalid JSON format: $e');
    }
  }

  // Validate JSON file
  Future<bool> validateJsonFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return false;
      }
      
      final jsonString = await file.readAsString();
      return validateJsonString(jsonString);
    } catch (e) {
      return false;
    }
  }

  // Validate JSON string
  bool validateJsonString(String jsonString) {
    try {
      final dynamic data = jsonDecode(jsonString);
      
      // Check new format
      if (data is Map<String, dynamic> && 
          data.containsKey('data') && 
          data.containsKey('export_info')) {
        final gameData = data['data'];
        if (gameData is Map<String, dynamic> && gameData.containsKey('games')) {
          final games = gameData['games'];
          return games is List;
        }
      }
      
      // Check old formats
      else if (data is Map<String, dynamic> && 
               data.containsKey('games') && 
               data.containsKey('app_info')) {
        final games = data['games'];
        return games is List;
      }
      else if (data is List) {
        return true;
      }
      else if (data is Map<String, dynamic> && data.containsKey('games')) {
        final games = data['games'];
        return games is List;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  // Get export metadata from JSON
  Map<String, dynamic>? getExportMetadata(String jsonString) {
    try {
      final dynamic data = jsonDecode(jsonString);
      
      if (data is Map<String, dynamic>) {
        if (data.containsKey('export_info')) {
          return Map<String, dynamic>.from(data['export_info']);
        } else if (data.containsKey('app_info')) {
          return Map<String, dynamic>.from(data['app_info']);
        }
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get statistics from JSON
  Map<String, dynamic>? getStatistics(String jsonString) {
    try {
      final dynamic data = jsonDecode(jsonString);
      
      if (data is Map<String, dynamic> && data.containsKey('statistics')) {
        return Map<String, dynamic>.from(data['statistics']);
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Create sample JSON for testing
  String createSampleJson() {
    final sampleGames = [
      Game(
        id: 'sample-1',
        title: 'The Legend of Zelda: Breath of the Wild',
        genre: 'Adventure',
        platform: 'Nintendo Switch',
        rating: 5.0,
        status: 'Selesai',
        playtimeHours: 120,
        isFavorite: true,
        notes: 'Game petualangan terbaik yang pernah saya mainkan!',
        dateAdded: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Game(
        id: 'sample-2',
        title: 'Cyberpunk 2077',
        genre: 'RPG',
        platform: 'PC',
        rating: 4.0,
        status: 'Sedang Dimainkan',
        playtimeHours: 45,
        isFavorite: false,
        notes: 'Grafik bagus tapi masih ada bug.',
        dateAdded: DateTime.now().subtract(const Duration(days: 15)),
      ),
    ];
    
    return exportToJsonString(sampleGames);
  }
}
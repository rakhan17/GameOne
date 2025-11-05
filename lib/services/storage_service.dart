import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game.dart';

class StorageService {
  static const String _gamesKey = 'games_data_json';
  static const String _bundleIdentifier = 'com.gameone.collection';

  // Save games to SharedPreferences
  Future<void> saveGames(List<Game> games) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final gamesJson = games.map((game) => game.toJson()).toList();
      final jsonString = jsonEncode(gamesJson);
      await prefs.setString(_gamesKey, jsonString);
    } catch (e) {
      debugPrint('Error saving games: $e');
      rethrow;
    }
  }

  // Load games from SharedPreferences
  Future<List<Game>> loadGames() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_gamesKey);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> gamesJson = jsonDecode(jsonString);
      return gamesJson.map((json) => Game.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading games: $e');
      return [];
    }
  }

  // Clear all games
  Future<void> clearGames() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_gamesKey);
    } catch (e) {
      debugPrint('Error clearing games: $e');
    }
  }

  // Check if data exists
  Future<bool> hasData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_gamesKey);
    } catch (e) {
      return false;
    }
  }

  // Get data size (approximate)
  Future<int> getDataSize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_gamesKey);
      if (jsonString != null) {
        return jsonString.length;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  // Export games as JSON string with metadata
  String exportGames(List<Game> games) {
    final exportData = {
      'app_info': {
        'name': 'GameOne',
        'bundle_id': _bundleIdentifier,
        'version': '1.0.0',
        'export_date': DateTime.now().toIso8601String(),
      },
      'games_count': games.length,
      'games': games.map((game) => game.toJson()).toList(),
    };
    return jsonEncode(exportData);
  }

  // Import games from JSON string
  List<Game> importGames(String jsonData) {
    try {
      final dynamic data = jsonDecode(jsonData);

      // Check if it's the new format with app_info
      if (data is Map<String, dynamic> &&
          data.containsKey('games') &&
          data.containsKey('app_info')) {
        final List<dynamic> gamesJson = data['games'];
        return gamesJson.map((json) => Game.fromJson(json)).toList();
      }
      // Handle old format (direct array)
      else if (data is List) {
        return data.map((json) => Game.fromJson(json)).toList();
      }
      // Handle old format (object with direct games array)
      else if (data is Map<String, dynamic> && data.containsKey('games')) {
        final List<dynamic> gamesJson = data['games'];
        return gamesJson.map((json) => Game.fromJson(json)).toList();
      } else {
        throw Exception('Unrecognized JSON format');
      }
    } catch (e) {
      throw Exception('Invalid JSON format: $e');
    }
  }

  // Get export metadata
  Map<String, dynamic> getExportMetadata(List<Game> games) {
    return {
      'app_name': 'GameOne',
      'bundle_identifier': _bundleIdentifier,
      'total_games': games.length,
      'favorite_games': games.where((g) => g.isFavorite).length,
      'genres': games.map((g) => g.genre).toSet().toList(),
      'export_timestamp': DateTime.now().toIso8601String(),
      'data_size_bytes': exportGames(games).length,
    };
  }

  // Validate JSON data before import
  bool validateJsonData(String jsonData) {
    try {
      final dynamic data = jsonDecode(jsonData);

      // Check new format
      if (data is Map<String, dynamic> &&
          data.containsKey('games') &&
          data.containsKey('app_info')) {
        final games = data['games'];
        return games is List && games.isNotEmpty;
      }
      // Check old formats
      else if (data is List) {
        return data.isNotEmpty;
      } else if (data is Map<String, dynamic> && data.containsKey('games')) {
        final games = data['games'];
        return games is List;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  // Get bundle identifier
  String getBundleIdentifier() {
    return _bundleIdentifier;
  }

  // Create backup with timestamp
  String createBackup(List<Game> games) {
    final backupData = {
      'backup_info': {
        'created_at': DateTime.now().toIso8601String(),
        'app_name': 'GameOne',
        'bundle_id': _bundleIdentifier,
        'backup_type': 'full',
      },
      'data': {
        'games_count': games.length,
        'games': games.map((game) => game.toJson()).toList(),
      },
    };
    return jsonEncode(backupData);
  }

  // Restore from backup
  List<Game> restoreFromBackup(String backupData) {
    try {
      final dynamic data = jsonDecode(backupData);

      if (data is Map<String, dynamic> &&
          data.containsKey('data') &&
          data.containsKey('backup_info')) {
        final gameData = data['data'];
        if (gameData is Map<String, dynamic> && gameData.containsKey('games')) {
          final List<dynamic> gamesJson = gameData['games'];
          return gamesJson.map((json) => Game.fromJson(json)).toList();
        }
      }

      throw Exception('Invalid backup format');
    } catch (e) {
      throw Exception('Failed to restore backup: $e');
    }
  }
}

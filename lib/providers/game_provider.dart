import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/game.dart';
import '../models/custom_list.dart';
import '../services/storage_service.dart';

class GameProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  final Uuid _uuid = const Uuid();

  List<Game> _games = [];
  List<CustomList> _lists = []; // NEW: List of custom lists
  String _selectedGenre = 'All';
  String _selectedStatus = 'All';
  bool _showFavoritesOnly = false;
  bool _isLoading = false;
  String _searchQuery = '';
  String _sortBy = 'dateAdded'; // dateAdded, title, rating, playtime

  List<Game> get games {
    List<Game> filteredGames = _games;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filteredGames = filteredGames.where((game) {
        return game.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            game.genre.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            game.platform.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Filter by favorites
    if (_showFavoritesOnly) {
      filteredGames = filteredGames.where((game) => game.isFavorite).toList();
    }

    // Filter by genre
    if (_selectedGenre != 'All') {
      filteredGames = filteredGames
          .where((game) => game.genre == _selectedGenre)
          .toList();
    }

    // Filter by status
    if (_selectedStatus != 'All') {
      filteredGames = filteredGames
          .where((game) => game.status == _selectedStatus)
          .toList();
    }

    // Sort games
    switch (_sortBy) {
      case 'title':
        filteredGames.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'rating':
        filteredGames.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'playtime':
        filteredGames.sort(
          (a, b) => b.playtimeHours.compareTo(a.playtimeHours),
        );
        break;
      case 'dateAdded':
      default:
        filteredGames.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
        break;
    }

    return filteredGames;
  }

  List<Game> get allGames => _games;
  String get selectedGenre => _selectedGenre;
  String get selectedStatus => _selectedStatus;
  bool get showFavoritesOnly => _showFavoritesOnly;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;

  // Statistics
  int get totalGames => _games.length;
  int get favoriteGames => _games.where((g) => g.isFavorite).length;
  int get completedGames => _games.where((g) => g.isCompleted).length;
  int get playingGames => _games.where((g) => g.isPlaying).length;
  int get wishlistGames => _games.where((g) => g.isWishlist).length;
  int get totalPlaytime =>
      _games.fold(0, (sum, game) => sum + game.playtimeHours);
  double get averageRating => _games.isEmpty
      ? 0
      : _games.fold(0.0, (sum, game) => sum + game.rating) / _games.length;

  // Get all unique genres from games
  List<String> get genres {
    final Set<String> genreSet = {'All'};
    for (var game in _games) {
      genreSet.add(game.genre);
    }
    return genreSet.toList();
  }

  // Get all custom lists
  List<CustomList> get lists => _lists;

  // Get all unique statuses
  List<String> get statuses {
    return [
      'All',
      'Playing',
      'Completed',
      'Not Started',
      'On Hold',
      'Wishlist',
    ];
  }

  // Load games and lists from storage
  Future<void> loadGames() async {
    _isLoading = true;
    notifyListeners();

    try {
      _games = await _storageService.loadGames();
      _lists = await _storageService.loadLists(); // NEW: Load custom lists
    } catch (e) {
      print('Error loading data: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add a new game
  Future<void> addGame({
    required String title,
    required String genre,
    required String platform,
    required double rating,
    String status = 'Not Started',
    String notes = '',
    int playtimeHours = 0,
    List<String> tags = const [],
  }) async {
    final newGame = Game(
      id: _uuid.v4(),
      title: title,
      genre: genre,
      platform: platform,
      rating: rating,
      status: status,
      notes: notes,
      playtimeHours: playtimeHours,
      tags: tags,
    );

    _games.add(newGame);
    await _storageService.saveGames(_games);
    notifyListeners();
  }

  // Update an existing game
  Future<void> updateGame(Game updatedGame) async {
    final index = _games.indexWhere((game) => game.id == updatedGame.id);
    if (index != -1) {
      _games[index] = updatedGame;
      await _storageService.saveGames(_games);
      notifyListeners();
    }
  }

  // Delete a game
  Future<void> deleteGame(String id) async {
    _games.removeWhere((game) => game.id == id);
    await _storageService.saveGames(_games);
    notifyListeners();
  }

  // Toggle favorite status
  Future<void> toggleFavorite(String id) async {
    final index = _games.indexWhere((game) => game.id == id);
    if (index != -1) {
      _games[index] = _games[index].copyWith(
        isFavorite: !_games[index].isFavorite,
      );
      await _storageService.saveGames(_games);
      notifyListeners();
    }
  }

  // Set genre filter
  void setGenreFilter(String genre) {
    _selectedGenre = genre;
    notifyListeners();
  }

  // Toggle favorites filter
  void toggleFavoritesFilter() {
    _showFavoritesOnly = !_showFavoritesOnly;
    notifyListeners();
  }

  // Clear all filters
  void clearFilters() {
    _selectedGenre = 'All';
    _selectedStatus = 'All';
    _showFavoritesOnly = false;
    _searchQuery = '';
    notifyListeners();
  }

  // Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Set sort option
  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  // Set status filter
  void setStatusFilter(String status) {
    _selectedStatus = status;
    notifyListeners();
  }

  // Update game status
  Future<void> updateGameStatus(String id, String status) async {
    final index = _games.indexWhere((game) => game.id == id);
    if (index != -1) {
      _games[index] = _games[index].copyWith(
        status: status,
        completedDate: status == 'Completed' ? DateTime.now() : null,
      );
      await _storageService.saveGames(_games);
      notifyListeners();
    }
  }

  // Update playtime
  Future<void> updatePlaytime(String id, int hours) async {
    final index = _games.indexWhere((game) => game.id == id);
    if (index != -1) {
      _games[index] = _games[index].copyWith(playtimeHours: hours);
      await _storageService.saveGames(_games);
      notifyListeners();
    }
  }

  // Update notes
  Future<void> updateNotes(String id, String notes) async {
    final index = _games.indexWhere((game) => game.id == id);
    if (index != -1) {
      _games[index] = _games[index].copyWith(notes: notes);
      await _storageService.saveGames(_games);
      notifyListeners();
    }
  }

  // Export data as JSON string
  String exportData() {
    return _storageService.exportGames(_games);
  }

  // Import data from JSON string
  Future<void> importData(String jsonData) async {
    try {
      final importedGames = _storageService.importGames(jsonData);
      _games = importedGames;
      await _storageService.saveGames(_games);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to import data: $e');
    }
  }

  // Get game by ID
  Game? getGameById(String id) {
    try {
      return _games.firstWhere((game) => game.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add multiple games (for import)
  Future<void> addMultipleGames(List<Game> games) async {
    for (var game in games) {
      // Check if game with same ID already exists
      if (!_games.any((existingGame) => existingGame.id == game.id)) {
        _games.add(game);
      }
    }
    await _storageService.saveGames(_games);
    notifyListeners();
  }

  // Replace all games (for import)
  Future<void> replaceAllGames(List<Game> games) async {
    _games = games;
    await _storageService.saveGames(_games);
    notifyListeners();
  }

  // Clear all games
  Future<void> clearAllGames() async {
    _games.clear();
    _lists.clear();
    await _storageService.clearGames();
    notifyListeners();
  }

  // Add a game to a custom list
  Future<void> addGameToList(String gameId, String listId) async {
    final gameIndex = _games.indexWhere((g) => g.id == gameId);
    if (gameIndex != -1) {
      final game = _games[gameIndex];
      if (!game.listIds.contains(listId)) {
        _games[gameIndex] = game.copyWith(listIds: [...game.listIds, listId]);
        await _storageService.saveGames(_games);
        notifyListeners();
      }
    }
  }

  // Remove a game from a custom list
  Future<void> removeGameFromList(String gameId, String listId) async {
    final gameIndex = _games.indexWhere((g) => g.id == gameId);
    if (gameIndex != -1) {
      final game = _games[gameIndex];
      if (game.listIds.contains(listId)) {
        _games[gameIndex] = game.copyWith(
          listIds: game.listIds.where((id) => id != listId).toList(),
        );
        await _storageService.saveGames(_games);
        notifyListeners();
      }
    }
  }

  // Create a new custom list
  Future<void> createList(String name, int colorValue) async {
    final newList = CustomList(
      id: _uuid.v4(),
      name: name,
      colorValue: colorValue,
    );
    _lists.add(newList);
    await _storageService.saveLists(_lists);
    notifyListeners();
  }

  // Update a custom list
  Future<void> updateList(String id, {String? name, int? colorValue}) async {
    final index = _lists.indexWhere((l) => l.id == id);
    if (index != -1) {
      final list = _lists[index];
      _lists[index] = CustomList(
        id: list.id,
        name: name ?? list.name,
        colorValue: colorValue ?? list.colorValue,
      );
      await _storageService.saveLists(_lists);
      notifyListeners();
    }
  }

  // Delete a custom list and remove its references
  Future<void> deleteList(String id) async {
    _lists.removeWhere((l) => l.id == id);
    // Remove this list from all games
    for (var i = 0; i < _games.length; i++) {
      if (_games[i].listIds.contains(id)) {
        _games[i] = _games[i].copyWith(
          listIds: _games[i].listIds.where((listId) => listId != id).toList(),
        );
      }
    }
    await Future.wait([
      _storageService.saveLists(_lists),
      _storageService.saveGames(_games),
    ]);
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_card.dart';
import '../utils/app_theme.dart';
import 'add_edit_game_screen.dart';
import 'statistics_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isGrid = false;

  @override
  void initState() {
    super.initState();
    // Load games when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameProvider>().loadGames();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchAndSort(),
              _buildFilterSection(),
              Expanded(
                child: _buildGameList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(
          parent: ModalRoute.of(context)!.animation!,
          curve: Curves.elasticOut,
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddEditGameScreen(),
              ),
            );
          },
          icon: const Icon(Icons.add_rounded, size: 28),
          label: const Text(
            'Tambah Game',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          backgroundColor: AppTheme.primaryYellow,
          elevation: 8,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryBlue,
            AppTheme.darkBlue,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryYellow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.gamepad,
                  size: 32,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GameOne',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Koleksi Game Favorit',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StatisticsScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.bar_chart,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Consumer<GameProvider>(
            builder: (context, provider, _) {
              final totalGames = provider.allGames.length;
              final favoriteGames = provider.allGames.where((g) => g.isFavorite).length;
              
              return Row(
                children: [
                  _buildStatCard('Total Game', totalGames.toString(), Icons.videogame_asset),
                  const SizedBox(width: 12),
                  _buildStatCard('Favorit', favoriteGames.toString(), Icons.star),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primaryYellow, size: 24),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndSort() {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryBlue.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      provider.setSearchQuery(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Cari game...',
                      prefixIcon: const Icon(Icons.search, color: AppTheme.primaryBlue),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () {
                                _searchController.clear();
                                provider.setSearchQuery('');
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Grid/List toggle
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  tooltip: _isGrid ? 'Tampilkan List' : 'Tampilkan Grid',
                  onPressed: () => setState(() => _isGrid = !_isGrid),
                  icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view, color: AppTheme.primaryBlue),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: PopupMenuButton<String>(
                  icon: const Icon(Icons.sort, color: AppTheme.primaryBlue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) {
                    provider.setSortBy(value);
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'dateAdded',
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 20,
                            color: provider.sortBy == 'dateAdded' ? AppTheme.primaryBlue : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Terbaru',
                            style: TextStyle(
                              fontWeight: provider.sortBy == 'dateAdded' ? FontWeight.bold : FontWeight.normal,
                              color: provider.sortBy == 'dateAdded' ? AppTheme.primaryBlue : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'title',
                      child: Row(
                        children: [
                          Icon(
                            Icons.sort_by_alpha,
                            size: 20,
                            color: provider.sortBy == 'title' ? AppTheme.primaryBlue : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Nama (A-Z)',
                            style: TextStyle(
                              fontWeight: provider.sortBy == 'title' ? FontWeight.bold : FontWeight.normal,
                              color: provider.sortBy == 'title' ? AppTheme.primaryBlue : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'rating',
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 20,
                            color: provider.sortBy == 'rating' ? AppTheme.primaryBlue : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Rating Tertinggi',
                            style: TextStyle(
                              fontWeight: provider.sortBy == 'rating' ? FontWeight.bold : FontWeight.normal,
                              color: provider.sortBy == 'rating' ? AppTheme.primaryBlue : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'playtime',
                      child: Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 20,
                            color: provider.sortBy == 'playtime' ? AppTheme.primaryBlue : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Playtime Terbanyak',
                            style: TextStyle(
                              fontWeight: provider.sortBy == 'playtime' ? FontWeight.bold : FontWeight.normal,
                              color: provider.sortBy == 'playtime' ? AppTheme.primaryBlue : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterSection() {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Filter',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (provider.selectedGenre != 'All' || provider.showFavoritesOnly)
                    TextButton.icon(
                      onPressed: () {
                        provider.clearFilters();
                      },
                      icon: const Icon(Icons.clear, size: 16),
                      label: const Text('Reset'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.primaryBlue,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                    ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => _openFilterSheet(context, provider),
                    icon: const Icon(Icons.tune),
                    label: const Text('Filter Lanjut'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    // Favorites filter
                    _buildFilterButton(
                      label: 'Favorit',
                      icon: provider.showFavoritesOnly ? Icons.star : Icons.star_border,
                      isSelected: provider.showFavoritesOnly,
                      onTap: () => provider.toggleFavoritesFilter(),
                      selectedColor: AppTheme.primaryYellow,
                      backgroundColor: AppTheme.lightYellow,
                    ),
                    const SizedBox(width: 8),
                    // Genre filters
                    ...provider.genres.map((genre) {
                      final isSelected = provider.selectedGenre == genre;
                      final displayText = genre == 'All' ? 'Semua' : genre;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildFilterButton(
                          label: displayText,
                          icon: _getGenreIcon(genre),
                          isSelected: isSelected,
                          onTap: () => provider.setGenreFilter(genre),
                          selectedColor: AppTheme.primaryBlue,
                          backgroundColor: AppTheme.lightBlue,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required Color selectedColor,
    required Color backgroundColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? selectedColor : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : AppTheme.textPrimary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.white : AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getGenreIcon(String genre) {
    switch (genre.toLowerCase()) {
      case 'all':
      case 'semua':
        return Icons.apps;
      case 'action':
        return Icons.sports_martial_arts;
      case 'adventure':
        return Icons.explore;
      case 'rpg':
        return Icons.person;
      case 'strategy':
        return Icons.psychology;
      case 'simulation':
        return Icons.build;
      case 'sports':
        return Icons.sports_soccer;
      case 'racing':
        return Icons.directions_car;
      case 'puzzle':
        return Icons.extension;
      case 'horror':
        return Icons.nightlight;
      case 'shooter':
        return Icons.gps_fixed;
      case 'platformer':
        return Icons.stairs;
      case 'fighting':
        return Icons.sports_kabaddi;
      case 'mmorpg':
        return Icons.groups;
      case 'indie':
        return Icons.palette;
      default:
        return Icons.videogame_asset;
    }
  }

  Widget _buildGameList() {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppTheme.primaryBlue,
            ),
          );
        }

        final games = provider.games;

        if (games.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () async {
            await provider.loadGames();
          },
          color: AppTheme.primaryBlue,
          backgroundColor: Colors.white,
          child: _isGrid
              ? LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    int crossAxisCount = 2;
                    if (width >= 1200) {
                      crossAxisCount = 5;
                    } else if (width >= 900) {
                      crossAxisCount = 4;
                    } else if (width >= 700) {
                      crossAxisCount = 3;
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                      physics: const AlwaysScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 16 / 12,
                      ),
                      itemCount: games.length,
                      itemBuilder: (context, index) {
                        return GameCard(game: games[index], compact: true);
                      },
                    );
                  },
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    return TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 200 + (index * 50)),
                      tween: Tween(begin: 0.0, end: 1.0),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: Opacity(
                            opacity: value,
                            child: child,
                          ),
                        );
                      },
                      child: GameCard(game: games[index]),
                    );
                  },
                ),
        );
      },
    );
  }

  void _openFilterSheet(BuildContext context, GameProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        String tempGenre = provider.selectedGenre;
        String tempStatus = provider.selectedStatus;
        bool tempFav = provider.showFavoritesOnly;
        String tempSort = provider.sortBy;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.tune),
                  SizedBox(width: 8),
                  Text('Filter & Sort', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                value: tempFav,
                title: const Text('Favorit saja'),
                onChanged: (v) => tempFav = v,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: tempGenre,
                decoration: const InputDecoration(labelText: 'Genre'),
                items: provider.genres.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                onChanged: (v) => tempGenre = v ?? 'All',
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: tempStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items: provider.statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => tempStatus = v ?? 'All',
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: tempSort,
                decoration: const InputDecoration(labelText: 'Urutkan'),
                items: const [
                  DropdownMenuItem(value: 'dateAdded', child: Text('Terbaru')),
                  DropdownMenuItem(value: 'title', child: Text('Nama (A-Z)')),
                  DropdownMenuItem(value: 'rating', child: Text('Rating Tertinggi')),
                  DropdownMenuItem(value: 'playtime', child: Text('Playtime Terbanyak')),
                ],
                onChanged: (v) => tempSort = v ?? 'dateAdded',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Batal'),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      provider.setSortBy(tempSort);
                      provider.setGenreFilter(tempGenre);
                      provider.setStatusFilter(tempStatus);
                      if (provider.showFavoritesOnly != tempFav) {
                        provider.toggleFavoritesFilter();
                      }
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Terapkan'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1500),
            tween: Tween(begin: 0.8, end: 1.0),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            onEnd: () {
              // Rebuild to restart animation
            },
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryBlue.withOpacity(0.2),
                    AppTheme.primaryYellow.withOpacity(0.2),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.gamepad,
                size: 80,
                color: AppTheme.primaryBlue.withOpacity(0.5),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Belum Ada Game',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tambahkan game favoritmu sekarang!',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEditGameScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Tambah Game'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryYellow,
              foregroundColor: AppTheme.textPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}

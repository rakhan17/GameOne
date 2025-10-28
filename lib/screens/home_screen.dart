import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_card.dart';
import '../utils/app_theme.dart';
import 'add_edit_game_screen.dart';
import 'statistics_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

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
<<<<<<< Updated upstream
=======
              Expanded(child: _buildGameList()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
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
        backgroundColor: AppTheme.primaryYellow,
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
          colors: [AppTheme.primaryBlue, AppTheme.darkBlue],
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
                      style: TextStyle(fontSize: 14, color: Colors.white70),
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
                icon: const Icon(Icons.settings, color: Colors.white, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Consumer<GameProvider>(
            builder: (context, provider, _) {
              final totalGames = provider.allGames.length;
              final favoriteGames = provider.allGames
                  .where((g) => g.isFavorite)
                  .length;

              return Row(
                children: [
                  _buildStatCard(
                    'Total Game',
                    totalGames.toString(),
                    Icons.videogame_asset,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    'Favorit',
                    favoriteGames.toString(),
                    Icons.star,
                  ),
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
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
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
                  style: const TextStyle(fontSize: 11, color: Colors.white70),
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
>>>>>>> Stashed changes
              Expanded(
                child: _buildGameList(),
              ),
            ],
          ),
        ),
      ),
<<<<<<< Updated upstream
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
=======
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
            child: CircularProgressIndicator(color: AppTheme.primaryBlue),
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
          child: ListView.builder(
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
>>>>>>> Stashed changes
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

  // Rest of the class methods remain unchanged
  // ... [Previous content remains identical]
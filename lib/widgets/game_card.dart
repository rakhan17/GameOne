import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game.dart';
import '../providers/game_provider.dart';
import '../utils/app_theme.dart';
import '../screens/add_edit_game_screen.dart';
import '../utils/file_image.dart';

class GameCard extends StatelessWidget {
  final Game game;
  final bool compact;
  const GameCard({super.key, required this.game, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, AppTheme.lightBlue.withOpacity(0.2)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () {
            _showGameDetails(context);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cover or Icon
                    _buildCoverOrIcon(game.coverImage),
                    const SizedBox(width: 16),
                    // Game Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            game.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryYellow,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  game.genre,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(game.status),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  game.status,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Favorite Button
                    IconButton(
                      onPressed: () {
                        context.read<GameProvider>().toggleFavorite(game.id);
                      },
                      icon: Icon(
                        game.isFavorite ? Icons.star : Icons.star_border,
                        color: game.isFavorite
                            ? AppTheme.primaryYellow
                            : AppTheme.textSecondary,
                        size: 28,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                // Platform, Rating and Playtime
                Row(
                  children: [
                    Icon(
                      _getPlatformIcon(game.platform),
                      size: 16,
                      color: AppTheme.primaryBlue,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        game.platform,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (game.playtimeHours > 0) ...[
                      const Icon(Icons.schedule, size: 16, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(
                        '${game.playtimeHours}h',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: AppTheme.primaryYellow,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      game.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getPlatformIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'pc':
        return Icons.computer;
      case 'playstation':
      case 'ps5':
      case 'ps4':
        return Icons.sports_esports;
      case 'xbox':
        return Icons.videogame_asset;
      case 'nintendo':
      case 'switch':
        return Icons.gamepad;
      case 'mobile':
        return Icons.smartphone;
      default:
        return Icons.devices;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Playing':
        return Colors.green;
      case 'Completed':
        return AppTheme.primaryBlue;
      case 'Wishlist':
        return Colors.purple;
      case 'On Hold':
        return Colors.orange;
      case 'Not Started':
      default:
        return Colors.grey;
    }
  }

  Widget _buildCoverOrIcon(String? cover) {
    final border = BorderRadius.circular(12);
    Widget buildFallback() => _buildIconBox();
    if (cover != null && cover.isNotEmpty) {
      final isNetworkish = cover.startsWith('http://') ||
          cover.startsWith('https://') ||
          cover.startsWith('blob:') ||
          cover.startsWith('data:');
      return ClipRRect(
        borderRadius: border,
        child: SizedBox(
          width: 60,
          height: 60,
          child: isNetworkish
              ? Image.network(
                  cover,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => buildFallback(),
                )
              : buildFileImage(
                  cover,
                  fit: BoxFit.cover,
                  fallback: () => buildFallback(),
                ),
        ),
      );
    }
    return _buildIconBox();
  }

  Widget _buildIconBox() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryBlue, AppTheme.darkBlue],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.gamepad,
        color: Colors.white,
        size: 32,
      ),
    );
  }

  void _showGameDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primaryBlue, AppTheme.darkBlue],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.gamepad,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildStars(),
                          const SizedBox(width: 6),
                          Text(game.rating.toStringAsFixed(1)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _buildBadges(),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailRow('Genre', game.genre, Icons.category),
            const SizedBox(height: 12),
            _buildDetailRow(
              'Platform',
              game.platform,
              _getPlatformIcon(game.platform),
            ),
            const SizedBox(height: 12),
            _buildDetailRow('Status', game.status, Icons.info_outline),
            const SizedBox(height: 12),
            _buildDetailRow(
              'Playtime',
              '${game.playtimeHours} jam',
              Icons.schedule,
            ),
            if (game.notes.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Catatan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.lightBlue.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  game.notes,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditGameScreen(game: game),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _confirmDelete(context);
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Hapus'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.lightBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: AppTheme.primaryBlue),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStars() {
    final fullStars = game.rating.floor();
    final hasHalf = (game.rating - fullStars) >= 0.5;
    final total = 5;
    return Row(
      children: List.generate(total, (index) {
        if (index < fullStars) {
          return const Icon(
            Icons.star,
            size: 18,
            color: AppTheme.primaryYellow,
          );
        } else if (index == fullStars && hasHalf) {
          return const Icon(
            Icons.star_half,
            size: 18,
            color: AppTheme.primaryYellow,
          );
        } else {
          return const Icon(
            Icons.star_border,
            size: 18,
            color: AppTheme.primaryYellow,
          );
        }
      }),
    );
  }

  // (Image helper removed — using _buildCoverOrIcon instead)

  Widget _buildBadges() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.primaryYellow.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.category, size: 14, color: AppTheme.textPrimary),
              const SizedBox(width: 4),
              Text(
                game.genre,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(game.status).withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.info_outline,
                size: 14,
                color: AppTheme.textPrimary,
              ),
              const SizedBox(width: 4),
              Text(
                game.status,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus "${game.title}"?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<GameProvider>().deleteGame(game.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${game.title} telah dihapus'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

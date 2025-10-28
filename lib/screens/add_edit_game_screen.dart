import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game.dart';
import '../providers/game_provider.dart';
import '../utils/app_theme.dart';

class AddEditGameScreen extends StatefulWidget {
  final Game? game;

  const AddEditGameScreen({super.key, this.game});

  @override
  State<AddEditGameScreen> createState() => _AddEditGameScreenState();
}

class _AddEditGameScreenState extends State<AddEditGameScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _ratingController;
  late TextEditingController _notesController;
  late TextEditingController _playtimeController;
  
  String _selectedGenre = 'Action';
  String _selectedPlatform = 'PC';
  String _selectedStatus = 'Not Started';

  final List<String> _genres = [
    'Action',
    'Adventure',
    'RPG',
    'Strategy',
    'Sports',
    'Racing',
    'Puzzle',
    'Horror',
    'Simulation',
    'Fighting',
  ];

  final List<String> _platforms = [
    'PC',
    'PlayStation',
    'Xbox',
    'Nintendo',
    'Mobile',
    'Multi-Platform',
  ];

  final List<String> _statuses = [
    'Not Started',
    'Playing',
    'Completed',
    'On Hold',
    'Wishlist',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.game?.title ?? '');
    _ratingController = TextEditingController(
      text: widget.game?.rating.toString() ?? '5.0',
    );
    _notesController = TextEditingController(text: widget.game?.notes ?? '');
    _playtimeController = TextEditingController(
      text: widget.game?.playtimeHours.toString() ?? '0',
    );
    
    if (widget.game != null) {
      _selectedGenre = widget.game!.genre;
      _selectedPlatform = widget.game!.platform;
      _selectedStatus = widget.game!.status;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _ratingController.dispose();
    _notesController.dispose();
    _playtimeController.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.game != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildForm(),
              ),
            ],
          ),
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
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryYellow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _isEditing ? Icons.edit : Icons.add,
              size: 28,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEditing ? 'Edit Game' : 'Tambah Game',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _isEditing ? 'Ubah informasi game' : 'Tambah game ke koleksi',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle('Informasi Game', Icons.info),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _titleController,
              label: 'Judul Game',
              hint: 'Masukkan judul game',
              icon: Icons.gamepad,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Judul game harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _ratingController,
              label: 'Rating (0-10)',
              hint: 'Masukkan rating',
              icon: Icons.star,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Rating harus diisi';
                }
                final rating = double.tryParse(value);
                if (rating == null || rating < 0 || rating > 10) {
                  return 'Rating harus antara 0-10';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Kategori', Icons.category),
            const SizedBox(height: 16),
            _buildDropdown(
              value: _selectedGenre,
              label: 'Genre',
              icon: Icons.category,
              items: _genres,
              onChanged: (value) {
                setState(() {
                  _selectedGenre = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              value: _selectedPlatform,
              label: 'Platform',
              icon: Icons.devices,
              items: _platforms,
              onChanged: (value) {
                setState(() {
                  _selectedPlatform = value!;
                });
              },
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Status & Progress', Icons.games),
            const SizedBox(height: 16),
            _buildDropdown(
              value: _selectedStatus,
              label: 'Status',
              icon: Icons.flag,
              items: _statuses,
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _playtimeController,
              label: 'Playtime (Jam)',
              hint: 'Berapa lama sudah dimainkan',
              icon: Icons.schedule,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final hours = int.tryParse(value);
                  if (hours == null || hours < 0) {
                    return 'Playtime harus angka positif';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Catatan', Icons.notes),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Catatan (Opsional)',
                  hintText: 'Tulis catatan atau review game',
                  prefixIcon: const Icon(Icons.notes, color: AppTheme.primaryBlue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                maxLines: 3,
              ),
            ),
            const SizedBox(height: 32),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.lightBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppTheme.primaryBlue,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: AppTheme.primaryBlue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required String label,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppTheme.primaryBlue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryBlue,
            AppTheme.darkBlue,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_isEditing ? Icons.save : Icons.add, size: 24),
            const SizedBox(width: 12),
            Text(
              _isEditing ? 'Simpan Perubahan' : 'Tambah Game',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<GameProvider>();
      final rating = double.parse(_ratingController.text);
      final playtime = int.tryParse(_playtimeController.text) ?? 0;

      try {
        if (_isEditing) {
          // Update existing game
          final updatedGame = widget.game!.copyWith(
            title: _titleController.text,
            genre: _selectedGenre,
            platform: _selectedPlatform,
            rating: rating,
            status: _selectedStatus,
            notes: _notesController.text,
            playtimeHours: playtime,
          );
          await provider.updateGame(updatedGame);
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Text('Game berhasil diupdate!'),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
            Navigator.pop(context);
          }
        } else {
          // Add new game
          await provider.addGame(
            title: _titleController.text,
            genre: _selectedGenre,
            platform: _selectedPlatform,
            rating: rating,
            status: _selectedStatus,
            notes: _notesController.text,
            playtimeHours: playtime,
          );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Text('Game berhasil ditambahkan!'),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
            Navigator.pop(context);
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/game.dart';
import '../providers/game_provider.dart';
import '../utils/app_theme.dart';
import '../utils/file_image.dart';

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
  late TextEditingController _tagInputController;
  late TextEditingController _coverUrlController;

  double _rating = 5.0;
  int _progress = 0;
  DateTime? _completedDate;
  String? _coverUrl;
  final ImagePicker _picker = ImagePicker();
  final List<String> _tags = [];
  bool _isDirty = false;

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
    _tagInputController = TextEditingController();
    _coverUrlController = TextEditingController(
      text: widget.game?.coverImage ?? '',
    );

    if (widget.game != null) {
      _selectedGenre = widget.game!.genre;
      _selectedPlatform = widget.game!.platform;
      _selectedStatus = widget.game!.status;
      _rating = widget.game!.rating;
      _tags.addAll(widget.game!.tags);
      _coverUrl = widget.game!.coverImage;
      _completedDate = widget.game!.completedDate;
      _progress = widget.game!.isCompleted ? 100 : 0;
    } else {
      final parsed = double.tryParse(_ratingController.text);
      _rating = parsed == null ? 5.0 : parsed.clamp(0.0, 10.0);
      _progress = 0;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _ratingController.dispose();
    _notesController.dispose();
    _playtimeController.dispose();
    _tagInputController.dispose();
    _coverUrlController.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.game != null;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          decoration: AppTheme.gradientBackground,
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(child: _buildForm()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                const Icon(Icons.star, color: AppTheme.primaryBlue),
                const SizedBox(width: 12),
                const Text(
                  'Rating (0-10)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.lightBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: List.generate(5, (index) {
                final threshold = (index + 1) * 2.0;
                return Icon(
                  _rating >= threshold - 1.0
                      ? Icons.star
                      : (_rating >= threshold - 2.0
                            ? Icons.star_half
                            : Icons.star_border),
                  color: Colors.amber,
                );
              }),
            ),
          ),
          Slider(
            value: _rating,
            min: 0,
            max: 10,
            divisions: 20,
            label: _rating.toStringAsFixed(1),
            activeColor: AppTheme.primaryBlue,
            onChanged: (val) {
              setState(() {
                _rating = val;
                _ratingController.text = _rating.toStringAsFixed(1);
                _markDirty();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChips() {
    final chipLabels = _statuses;
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: chipLabels.map((label) {
          final selected = _selectedStatus == label;
          return ChoiceChip(
            label: Text(label),
            selected: selected,
            pressElevation: 0,
            selectedColor: AppTheme.lightBlue,
            shape: StadiumBorder(
              side: BorderSide(
                color: selected ? AppTheme.primaryBlue : Colors.grey.shade300,
              ),
            ),
            onSelected: (_) {
              setState(() {
                _selectedStatus = label;
                if (_selectedStatus == 'Completed') {
                  _progress = 100;
                  _completedDate ??= DateTime.now();
                } else if (_progress == 100) {
                  _progress = 90; // minor drop to indicate not fully completed
                  _completedDate = null;
                }
                _markDirty();
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _quickPlaytimeChip(String text, int delta, {bool reset = false}) {
    return ActionChip(
      label: Text(text),
      avatar: Icon(reset ? Icons.refresh : Icons.add, size: 16),
      onPressed: () {
        final current = int.tryParse(_playtimeController.text) ?? 0;
        final next = reset ? 0 : (current + delta);
        setState(() {
          _playtimeController.text = next.toString();
          _markDirty();
        });
      },
    );
  }

  Widget _buildCoverSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Cover Image', Icons.image),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryBlue.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (_coverUrl != null && _coverUrl!.isNotEmpty)
                      _buildCoverImageWidget(_coverUrl!)
                    else
                      const Center(
                        child: Icon(Icons.image, size: 48, color: Colors.grey),
                      ),
                    if (_coverUrl != null && _coverUrl!.isNotEmpty)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Material(
                          color: Colors.black54,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () {
                              setState(() {
                                _coverUrl = '';
                                _coverUrlController.text = '';
                                _markDirty();
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.close, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  _buildTextField(
                    controller: _coverUrlController,
                    label: 'URL Cover',
                    hint: 'Tempel URL gambar sampul',
                    icon: Icons.link,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _coverUrl = _coverUrlController.text.trim();
                          _markDirty();
                        });
                      },
                      icon: const Icon(Icons.preview),
                      label: const Text('Terapkan'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Galeri'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon: const Icon(Icons.photo_camera),
                          label: const Text('Kamera'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCoverImageWidget(String pathOrUrl) {
    final isNetworkish =
        pathOrUrl.startsWith('http://') ||
        pathOrUrl.startsWith('https://') ||
        pathOrUrl.startsWith('blob:') ||
        pathOrUrl.startsWith('data:');
    if (isNetworkish) {
      return Image.network(
        pathOrUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (_, __, ___) =>
            const Center(child: Icon(Icons.broken_image)),
      );
    }
    // Local file handling (mobile/desktop); on web this falls back safely
    return buildFileImage(
      pathOrUrl,
      fit: BoxFit.cover,
      fallback: () => const Center(child: Icon(Icons.broken_image)),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (picked == null) {
        return;
      }
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        final b64 = base64Encode(bytes);
        // try infer mime from name
        final name = picked.name.toLowerCase();
        String mime = 'image/jpeg';
        if (name.endsWith('.png')) {
          mime = 'image/png';
        } else if (name.endsWith('.webp')) {
          mime = 'image/webp';
        } else if (name.endsWith('.jpg') || name.endsWith('.jpeg')) {
          mime = 'image/jpeg';
        }
        setState(() {
          _coverUrl = 'data:$mime;base64,$b64';
          _coverUrlController.text = _coverUrl!;
          _markDirty();
        });
      } else {
        setState(() {
          _coverUrl = picked.path;
          _coverUrlController.text = picked.path;
          _markDirty();
        });
      }
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengambil gambar: $e')));
    }
  }

  Widget _buildTagsSection() {
    final suggestions = <String>[
      'Indie',
      'Co-op',
      'Online',
      'Singleplayer',
      'Story Rich',
      'Multiplayer',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tagInputController,
                    decoration: const InputDecoration(
                      hintText: 'Tambah tag lalu tekan Enter',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (val) => _addTag(val),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _addTag(_tagInputController.text),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            ..._tags.map(
              (t) => Chip(
                label: Text(t),
                onDeleted: () {
                  setState(() {
                    _tags.remove(t);
                    _markDirty();
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: suggestions.map((s) {
            final added = _tags.contains(s);
            return ActionChip(
              label: Text(added ? '✓ $s' : s),
              onPressed: () {
                if (!added) _addTag(s);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  void _addTag(String raw) {
    final t = raw.trim();
    if (t.isEmpty) {
      return;
    }
    if (_tags.contains(t)) {
      _tagInputController.clear();
      return;
    }
    setState(() {
      _tags.add(t);
      _tagInputController.clear();
      _markDirty();
    });
  }

  Widget _buildProgressSlider() {
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.percent, color: AppTheme.primaryBlue),
              const SizedBox(width: 8),
              const Text(
                'Progress (%)',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.lightBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('$_progress%'),
              ),
            ],
          ),
          Slider(
            value: _progress.toDouble(),
            min: 0,
            max: 100,
            divisions: 20,
            label: '$_progress%',
            activeColor: AppTheme.primaryBlue,
            onChanged: (v) {
              setState(() {
                _progress = v.round();
                if (_progress == 100) {
                  _selectedStatus = 'Completed';
                  _completedDate ??= DateTime.now();
                } else if (_selectedStatus == 'Completed') {
                  _selectedStatus = 'Playing';
                  _completedDate = null;
                }
                _markDirty();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedDatePicker() {
    final text = _completedDate != null
        ? '${_completedDate!.day}/${_completedDate!.month}/${_completedDate!.year}'
        : 'Pilih tanggal selesai';
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
      child: ListTile(
        leading: const Icon(Icons.event, color: AppTheme.primaryBlue),
        title: Text(text),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: _pickCompletedDate,
      ),
    );
  }

  Future<void> _pickCompletedDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _completedDate ?? now,
      firstDate: DateTime(now.year - 20),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        _completedDate = picked;
        _markDirty();
      });
    }
  }

  void _markDirty() {
    if (!_isDirty) {
      setState(() {
        _isDirty = true;
      });
    }
  }

  Future<bool> _onWillPop() async {
    if (!_isDirty) {
      return true;
    }
    final shouldDiscard = await _showDiscardDialog();
    return shouldDiscard;
  }

  void _handleBack() async {
    if (await _onWillPop()) {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<bool> _showDiscardDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Buang Perubahan?'),
        content: const Text('Perubahan yang belum disimpan akan hilang.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Buang'),
          ),
        ],
      ),
    );
    return result ?? false;
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final isNarrow = w < 360;
          final titleSize = isNarrow ? 20.0 : 24.0;
          final subtitleSize = isNarrow ? 12.0 : 14.0;
          return Row(
            children: [
              IconButton(
                onPressed: _handleBack,
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _isEditing
                          ? 'Ubah informasi game'
                          : 'Tambah game ke koleksi',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: subtitleSize,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 700;

            final leftColumn = <Widget>[
              _buildCoverSection(),
              const SizedBox(height: 24),
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
              _buildRatingCard(),
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
                    prefixIcon: const Icon(
                      Icons.notes,
                      color: AppTheme.primaryBlue,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 6,
                  onChanged: (_) => _markDirty(),
                ),
              ),
            ];

            final rightColumn = <Widget>[
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
                    _markDirty();
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
                    _markDirty();
                  });
                },
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Status & Progress', Icons.games),
              const SizedBox(height: 16),
              _buildStatusChips(),
              const SizedBox(height: 12),
              _buildProgressSlider(),
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
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _quickPlaytimeChip('+1j', 1),
                  _quickPlaytimeChip('+5j', 5),
                  _quickPlaytimeChip('+10j', 10),
                  _quickPlaytimeChip('Reset', 0, reset: true),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Tags', Icons.sell),
              const SizedBox(height: 12),
              _buildTagsSection(),
              if (_selectedStatus == 'Completed') ...[
                const SizedBox(height: 24),
                _buildSectionTitle('Tanggal Selesai', Icons.event_available),
                const SizedBox(height: 12),
                _buildCompletedDatePicker(),
              ],
            ];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [...leftColumn],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [...rightColumn],
                        ),
                      ),
                    ],
                  )
                else ...[
                  ...leftColumn,
                  const SizedBox(height: 24),
                  ...rightColumn,
                ],
                const SizedBox(height: 32),
                _buildSubmitButton(),
              ],
            );
          },
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
          child: Icon(icon, size: 20, color: AppTheme.primaryBlue),
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
          return DropdownMenuItem(value: item, child: Text(item));
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
          colors: [AppTheme.primaryBlue, AppTheme.darkBlue],
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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<GameProvider>();
      final rating = _rating;
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
            tags: _tags,
            coverImage: (_coverUrl ?? '').isEmpty ? null : _coverUrl,
            completedDate: _selectedStatus == 'Completed'
                ? (_completedDate ?? DateTime.now())
                : null,
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
            tags: _tags,
            coverImage: (_coverUrl ?? '').isEmpty ? null : _coverUrl,
            completedDate: _selectedStatus == 'Completed'
                ? (_completedDate ?? DateTime.now())
                : null,
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
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }
}

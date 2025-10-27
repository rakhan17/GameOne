import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../services/json_export_service.dart';
import '../utils/app_theme.dart';

class ExportImportScreen extends StatefulWidget {
  const ExportImportScreen({Key? key}) : super(key: key);

  @override
  State<ExportImportScreen> createState() => _ExportImportScreenState();
}

class _ExportImportScreenState extends State<ExportImportScreen> {
  final JsonExportService _exportService = JsonExportService();
  final TextEditingController _importController = TextEditingController();
  bool _isLoading = false;
  String? _exportedJson;
  Map<String, dynamic>? _importMetadata;

  @override
  void dispose() {
    _importController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export & Import Data'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInfoCard(),
              const SizedBox(height: 20),
              _buildExportSection(),
              const SizedBox(height: 20),
              _buildImportSection(),
              const SizedBox(height: 20),
              _buildSampleSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: AppTheme.primaryBlue, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Informasi Export/Import',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '• Export: Simpan semua data game ke format JSON\n'
              '• Import: Muat data game dari format JSON\n'
              '• Bundle ID: com.gameone.collection\n'
              '• Format mendukung backward compatibility',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.upload, color: AppTheme.primaryYellow, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Export Data',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer<GameProvider>(
              builder: (context, provider, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Game: ${provider.allGames.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : () => _exportData(provider.allGames),
                        icon: _isLoading 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.download),
                        label: Text(_isLoading ? 'Mengexport...' : 'Export ke JSON'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryYellow,
                          foregroundColor: AppTheme.textPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    if (_exportedJson != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.lightBlue,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.green, size: 16),
                                const SizedBox(width: 8),
                                const Text(
                                  'Export Berhasil!',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                const Spacer(),
                                TextButton.icon(
                                  onPressed: () => _copyToClipboard(_exportedJson!),
                                  icon: const Icon(Icons.copy, size: 16),
                                  label: const Text('Copy'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppTheme.primaryBlue,
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              height: 100,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: SingleChildScrollView(
                                child: Text(
                                  _exportedJson!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'monospace',
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImportSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.download, color: AppTheme.primaryBlue, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Import Data',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _importController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Paste JSON data di sini...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  _validateImportData(value);
                } else {
                  setState(() {
                    _importMetadata = null;
                  });
                }
              },
            ),
            if (_importMetadata != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Data Valid!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_importMetadata!.containsKey('app_name'))
                      Text('App: ${_importMetadata!['app_name']}'),
                    if (_importMetadata!.containsKey('export_date'))
                      Text('Export Date: ${_importMetadata!['export_date']}'),
                    if (_importMetadata!.containsKey('total_games'))
                      Text('Total Games: ${_importMetadata!['total_games']}'),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading || _importController.text.isEmpty 
                      ? null 
                      : () => _importData(_importController.text, false),
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah ke Data'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading || _importController.text.isEmpty 
                      ? null 
                      : () => _showReplaceConfirmation(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Ganti Semua'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
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

  Widget _buildSampleSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.code, color: AppTheme.primaryYellow, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Sample Data',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Generate sample JSON data untuk testing',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _generateSampleData,
                icon: const Icon(Icons.science),
                label: const Text('Generate Sample JSON'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryYellow,
                  foregroundColor: AppTheme.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _exportData(games) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final jsonString = _exportService.exportToJsonString(games);
      setState(() {
        _exportedJson = jsonString;
      });
      
      _showSnackBar('Data berhasil diexport!', Colors.green);
    } catch (e) {
      _showSnackBar('Error: $e', Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _importData(String jsonData, bool replace) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final games = _exportService.importFromJsonString(jsonData);
      final provider = context.read<GameProvider>();
      
      if (replace) {
        await provider.replaceAllGames(games);
        _showSnackBar('Data berhasil diganti! Total: ${games.length} game', Colors.green);
      } else {
        await provider.addMultipleGames(games);
        _showSnackBar('Data berhasil ditambahkan! Total: ${games.length} game', Colors.green);
      }
      
      _importController.clear();
      setState(() {
        _importMetadata = null;
      });
    } catch (e) {
      _showSnackBar('Error: $e', Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _validateImportData(String jsonData) {
    try {
      if (_exportService.validateJsonString(jsonData)) {
        final metadata = _exportService.getExportMetadata(jsonData);
        final statistics = _exportService.getStatistics(jsonData);
        
        setState(() {
          _importMetadata = {
            ...?metadata,
            ...?statistics,
          };
        });
      } else {
        setState(() {
          _importMetadata = null;
        });
      }
    } catch (e) {
      setState(() {
        _importMetadata = null;
      });
    }
  }

  void _generateSampleData() {
    final sampleJson = _exportService.createSampleJson();
    _importController.text = sampleJson;
    _validateImportData(sampleJson);
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    _showSnackBar('JSON berhasil dicopy ke clipboard!', Colors.blue);
  }

  void _showReplaceConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text(
          'Apakah Anda yakin ingin mengganti semua data yang ada? '
          'Data lama akan hilang dan tidak dapat dikembalikan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _importData(_importController.text, true);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Ya, Ganti Semua'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
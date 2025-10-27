# Lokasi Penyimpanan Data JSON - GameOne

## Ringkasan Penyimpanan
Aplikasi GameOne **TIDAK** menyimpan data dalam file JSON fisik, melainkan menggunakan **SharedPreferences** dengan format JSON string.

## Detail Penyimpanan

### 1. Teknologi Penyimpanan
- **Primary Storage**: `SharedPreferences` (Flutter)
- **Format Data**: JSON String
- **Key**: `games_data_json`
- **Bundle ID**: `com.gameone.collection`

### 2. Lokasi Fisik Data

#### Android
```
/data/data/com.gameone.collection/shared_prefs/FlutterSharedPreferences.xml
```
**Struktur dalam XML:**
```xml
<map>
    <string name="flutter.games_data_json">[{"id":"...","title":"..."}]</string>
</map>
```

#### iOS
```
~/Library/Preferences/com.gameone.collection.plist
```
**Struktur dalam plist:**
```plist
<dict>
    <key>flutter.games_data_json</key>
    <string>[{"id":"...","title":"..."}]</string>
</dict>
```

#### Web (Browser)
```
localStorage['flutter.games_data_json']
```
**Lokasi Browser:**
- Chrome: `chrome://settings/content/all` → Site Data
- Firefox: Developer Tools → Storage → Local Storage
- Safari: Develop → Storage → Local Storage

#### Windows
```
%APPDATA%\com.gameone.collection\shared_preferences\
```

#### macOS
```
~/Library/Preferences/com.gameone.collection.plist
```

#### Linux
```
~/.local/share/com.gameone.collection/shared_preferences/
```

### 3. Format Data JSON

#### Format Penyimpanan Internal
```json
[
  {
    "id": "uuid-string",
    "title": "Game Title",
    "genre": "Action",
    "platform": "PC",
    "rating": 4.5,
    "isFavorite": true,
    "status": "Completed",
    "notes": "Great game!",
    "playtimeHours": 25,
    "dateAdded": "2024-10-27T10:30:00.000Z",
    "completedDate": "2024-10-27T15:30:00.000Z",
    "tags": ["multiplayer", "story-rich"],
    "coverImage": null
  }
]
```

#### Format Export JSON (dengan metadata)
```json
{
  "app_info": {
    "name": "GameOne",
    "bundle_id": "com.gameone.collection",
    "version": "1.0.0",
    "export_date": "2024-10-27T10:30:00.000Z"
  },
  "games_count": 1,
  "games": [
    {
      "id": "uuid-string",
      "title": "Game Title",
      // ... data game
    }
  ]
}
```

### 4. Cara Mengakses Data

#### Melalui Aplikasi
1. **Settings Screen** → Export Data (Copy JSON)
2. **Export/Import Screen** → Advanced Export/Import
3. **Programmatically**: `StorageService.exportGames()`

#### Melalui System (Advanced Users)

**Android (Root Required):**
```bash
adb shell
su
cat /data/data/com.gameone.collection/shared_prefs/FlutterSharedPreferences.xml
```

**iOS (Jailbreak Required):**
```bash
plutil -p ~/Library/Preferences/com.gameone.collection.plist
```

**Web (Browser Console):**
```javascript
localStorage.getItem('flutter.games_data_json')
```

### 5. Backup & Restore

#### Manual Backup
1. Buka aplikasi → Settings → Export Data
2. Copy JSON ke clipboard
3. Simpan di file `.json` atau text editor

#### Manual Restore
1. Copy JSON data
2. Buka aplikasi → Settings → Import Data
3. Paste JSON dan import

#### Advanced Export/Import
1. Buka aplikasi → Settings → Advanced Export/Import
2. Fitur lengkap dengan validasi dan metadata

### 6. Keamanan Data

#### Enkripsi
- **SharedPreferences**: Tidak terenkripsi secara default
- **Akses**: Hanya aplikasi yang memiliki bundle ID yang sama
- **Sandbox**: Data terisolasi per aplikasi

#### Rekomendasi Keamanan
- Regular backup data via export
- Jangan share bundle identifier dengan aplikasi lain
- Gunakan device lock untuk proteksi tambahan

### 7. Troubleshooting

#### Data Hilang
1. Check apakah aplikasi di-uninstall (data akan hilang)
2. Check storage permission
3. Restore dari backup JSON

#### Data Corrupt
1. Clear app data
2. Import dari backup JSON
3. Atau gunakan "Clear All Data" di settings

#### Migration
- Data otomatis migrate saat update aplikasi
- Format JSON backward compatible

### 8. Development Info

#### Storage Service
- File: `lib/services/storage_service.dart`
- Key: `_gamesKey = 'games_data_json'`
- Bundle: `_bundleIdentifier = 'com.gameone.collection'`

#### JSON Export Service
- File: `lib/services/json_export_service.dart`
- Advanced export dengan metadata lengkap
- Multiple format support

## Kesimpulan

Data JSON GameOne disimpan dalam **SharedPreferences** dengan key `games_data_json`, bukan dalam file JSON terpisah. Ini memberikan:

✅ **Cross-platform compatibility**  
✅ **Automatic data persistence**  
✅ **App sandbox security**  
✅ **Easy backup/restore via export/import**  
✅ **No file permission issues**  

Untuk backup, gunakan fitur Export dalam aplikasi untuk mendapatkan file JSON yang bisa disimpan secara eksternal.
# Bundle Identifier & JSON Export Information

## Bundle Identifier
- **Android**: `com.gameone.collection`
- **iOS**: `com.gameone.collection`
- **App Name**: GameOne
- **Display Name**: GameOne

## JSON Export/Import Features

### Bundle Identifier Usage
The bundle identifier `com.gameone.collection` is used throughout the app for:
- JSON export metadata
- Data validation
- Cross-platform compatibility
- Backup identification

### JSON Export Format
The app exports data in a comprehensive JSON format with the following structure:

```json
{
  "export_info": {
    "app_name": "GameOne",
    "bundle_identifier": "com.gameone.collection",
    "version": "1.0.0",
    "export_date": "2024-10-27T10:30:00.000Z",
    "export_timestamp": 1698408600000,
    "platform": "android"
  },
  "statistics": {
    "total_games": 10,
    "favorite_games": 3,
    "completed_games": 5,
    "playing_games": 2,
    "wishlist_games": 3,
    "unique_genres": 5,
    "total_playtime_hours": 120.5,
    "average_rating": 4.2
  },
  "genres": ["Action", "Adventure", "RPG", "Strategy"],
  "platforms": ["PC", "PlayStation", "Nintendo Switch"],
  "data": {
    "games_count": 10,
    "games": [
      {
        "id": "uuid-here",
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
  }
}
```

### Backward Compatibility
The JSON import system supports multiple formats:
1. **New Format**: With `export_info` and `data` structure
2. **Old Format**: With `app_info` and direct `games` array
3. **Legacy Format**: Direct array of games
4. **Simple Format**: Object with direct `games` property

### Features
- **Export**: Generate comprehensive JSON with metadata and statistics
- **Import**: Support multiple JSON formats with validation
- **Backup**: Create timestamped backups
- **Validation**: Validate JSON before import
- **Statistics**: Extract statistics from exported data
- **Sample Data**: Generate sample JSON for testing

### Usage in App
1. **Settings Screen**: Basic export/import with clipboard
2. **Export/Import Screen**: Advanced features with validation and metadata
3. **Storage Service**: Core JSON handling with bundle identifier
4. **JSON Export Service**: Comprehensive export/import with statistics

### Bundle Identifier Configuration Files
- **Android**: `android/app/build.gradle.kts`
- **iOS**: `ios/Runner.xcodeproj/project.pbxproj`
- **iOS Info**: `ios/Runner/Info.plist`

### Data Storage
- **Primary**: SharedPreferences (cross-platform)
- **Format**: JSON string with games array
- **Key**: `games_data_json`
- **Backup**: JSON export with full metadata

## Security & Privacy
- All data stored locally
- No external servers
- Bundle identifier ensures data integrity
- JSON format allows easy data portability
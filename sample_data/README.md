# 📦 Sample JSON Bundles - GameOne

## 🎮 Available Collections

### 1. **rpg_collection.json** - RPG Masterpieces
**5 Games** | RPG Genre | Completed & Playing

**Games Included:**
- ⭐ The Witcher 3: Wild Hunt (9.5/10) - Completed
- ⭐ Elden Ring (9.0/10) - Playing
- ⭐ Baldur's Gate 3 (9.2/10) - Playing
- ⭐ Final Fantasy XVI (8.7/10) - Completed
- ⭐ Persona 5 Royal (9.3/10) - Completed

**Total Playtime:** 394 hours

---

### 2. **action_collection.json** - Action Packed
**5 Games** | Action Genre | Mix Status

**Games Included:**
- ⭐ God of War Ragnarök (9.3/10) - Completed
- Devil May Cry 5 (8.5/10) - Completed
- ⭐ Sekiro: Shadows Die Twice (9.0/10) - Completed
- ⭐ Hades (9.2/10) - Playing
- Bayonetta 3 (8.0/10) - On Hold

**Total Playtime:** 185 hours

---

### 3. **wishlist_collection.json** - Future Games
**6 Games** | Wishlist | Not Started

**Games Included:**
- Starfield (RPG)
- ⭐ Cyberpunk 2077: Phantom Liberty (RPG)
- ⭐ Hogwarts Legacy (RPG)
- ⭐ Spider-Man 2 (Action)
- Lies of P (Action)
- Alan Wake 2 (Horror)

**Total Playtime:** 0 hours (belum dimainkan)

---

## 🚀 How to Import

### Method 1: Copy-Paste (Recommended)

1. **Buka file JSON** yang ingin di-import
2. **Copy semua content** (Ctrl+A, Ctrl+C / Cmd+A, Cmd+C)
3. **Buka GameOne app**
4. **Tap icon Settings** (⚙️) di header
5. **Tap "Import Data (Paste JSON)"**
6. **Paste** JSON di dialog
7. **Tap "Import"**
8. ✅ **Done!** Data sudah masuk

### Method 2: Direct File (Desktop)

**macOS/Windows/Linux:**
1. Copy file JSON ke folder yang mudah diakses
2. Buka file dengan text editor
3. Copy all content
4. Import via Settings seperti Method 1

---

## 📝 Example Import

### Step by Step

**1. Copy JSON Content:**
```json
[
  {
    "id": "550e8400...",
    "title": "The Witcher 3",
    ...
  }
]
```

**2. Open Settings:**
```
Home Screen → Icon ⚙️ → Settings Screen
```

**3. Import Data:**
```
Tap "Import Data (Paste JSON)"
→ Dialog muncul
→ Paste JSON
→ Tap "Import"
```

**4. Verify:**
```
Back to Home → See games list
Settings → Storage Info → Check data size
```

---

## 🎯 Use Cases

### 1. Quick Start
```
Import rpg_collection.json untuk instant RPG library!
```

### 2. Testing App
```
Import semua 3 files untuk test dengan 16 games
```

### 3. Backup Examples
```
Lihat structure untuk buat custom collection sendiri
```

### 4. Learning
```
Study JSON format untuk buat script automation
```

---

## 📊 Data Statistics

| Collection | Games | Favorites | Completed | Playing | Wishlist | Playtime |
|------------|-------|-----------|-----------|---------|----------|----------|
| **RPG** | 5 | 5 | 2 | 3 | 0 | 394h |
| **Action** | 5 | 3 | 3 | 1 | 0 | 185h |
| **Wishlist** | 6 | 3 | 0 | 0 | 6 | 0h |
| **TOTAL** | **16** | **11** | **5** | **4** | **6** | **579h** |

---

## 🔧 Customize Your Bundle

### Create Your Own

**1. Start with Template:**
```json
[
  {
    "id": "your-uuid-here",
    "title": "Your Game Title",
    "genre": "Your Genre",
    "platform": "Your Platform",
    "rating": 8.5,
    "isFavorite": false,
    "status": "Not Started",
    "notes": "Your notes here",
    "playtimeHours": 0,
    "dateAdded": "2024-10-27T08:00:00.000Z",
    "completedDate": null,
    "tags": ["tag1", "tag2"],
    "coverImage": null
  }
]
```

**2. Required Fields:**
- `id` - Use UUID generator
- `title` - Game name
- `genre` - Genre string
- `platform` - Platform string
- `rating` - 0-10
- `isFavorite` - true/false
- `status` - Status string
- `dateAdded` - ISO date string

**3. Optional Fields:**
- `notes` - String (can be empty)
- `playtimeHours` - Number (can be 0)
- `completedDate` - ISO date or null
- `tags` - Array (can be empty)
- `coverImage` - String or null

---

## 💡 Tips

### Combine Collections
```
1. Import rpg_collection.json
2. Import action_collection.json
3. Result: 10 games total!
```

### Replace All Data
```
Import will REPLACE existing data
💾 Tip: Export current data first before importing!
```

### Modify Before Import
```
1. Copy JSON file
2. Edit dalam text editor
3. Change titles, ratings, notes
4. Import custom version
```

### Generate UUID
```javascript
// JavaScript
crypto.randomUUID()

// Online Tools
https://www.uuidgenerator.net/
```

---

## ⚠️ Important Notes

### Valid JSON Format
```
✅ Valid: Double quotes "title"
❌ Invalid: Single quotes 'title'

✅ Valid: true, false, null (lowercase)
❌ Invalid: True, False, Null

✅ Valid: ISO date "2024-10-27T08:00:00.000Z"
❌ Invalid: "27/10/2024"
```

### Data Will Replace
```
⚠️ Import akan REPLACE semua data existing
💾 ALWAYS export current data sebelum import!
```

### File Size
```
Each file ~1-3 KB per game
16 games total ~25 KB
Very light!
```

---

## 🧪 Testing

### Validate JSON
**Online:**
- https://jsonlint.com/
- https://jsonformatter.org/

**Command Line:**
```bash
# Python
python -m json.tool rpg_collection.json

# Node.js
node -e "console.log(JSON.stringify(require('./rpg_collection.json')))"
```

### Test Import
```
1. Export current data (backup)
2. Import sample collection
3. Check if everything loads
4. Import backup (restore)
```

---

## 📚 Documentation

### Full Docs
- **README_STORAGE.md** - Complete storage guide
- **JSON_DATABASE_INFO.md** - Technical details
- **CHANGELOG.md** - Version history

### JSON Structure
See **README_STORAGE.md** for complete field descriptions

---

## 🎉 Summary

### What's Included
- ✅ 3 ready-to-use collections
- ✅ 16 sample games total
- ✅ Real reviews & notes
- ✅ Various statuses
- ✅ 579 hours playtime data

### Perfect For
- 🎯 Quick start
- 🧪 Testing
- 📚 Learning
- 🎨 Inspiration

### Ready to Go!
```
Just copy → paste → import → enjoy! 🎮✨
```

---

**Collections: ✅ Ready**
**Format: ✅ Valid JSON**
**Compatible: ✅ All Platforms**
**Size: ✅ ~25 KB total**

**Happy Gaming! 🎮**

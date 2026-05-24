# Perawatan Feature - Implementation Quick Reference

## 📌 What Was Done

### 1. **API Constants Updated** ✅
- Location: `lib/core/constants/api_constants.dart`
- Added 6 new endpoint constants for perawatan:
  - `ibuKategoriCapaian`
  - `ibuKategoriCapaianByRentangUsia(rentangUsia)`
  - `ibuPerawatan`
  - `ibuPerawatanById(id)`
  - `ibuPerawatanByAnakId(anakId)`
  - `ibuPerawatanByAnakIdAndRentangUsia(anakId, rentangUsia)`

### 2. **Improved Perawatan Screen Created** ✅
- Location: `lib/features/anak/tumbuh_kembang/presentation/screens/pemantauan/perawatan/perawatan_screen_improved.dart`
- **Recommended** to use this instead of the original integrated version
- Features:
  - ✅ Better error handling & retry mechanism
  - ✅ Comprehensive materi edukatif (5 aspek perkembangan)
  - ✅ Support for create & update answers
  - ✅ Pull-to-refresh functionality
  - ✅ Per-age-range error tracking
  - ✅ Professional debug logging
  - ✅ Loading states for each age range

### 3. **Backend Verified** ✅
- Seeder: `app/seed/kategori_capaian.go` - contains 48 development milestone questions
- Routes: `app/routes/routes.go` - all endpoints registered (lines 459-464)
- Controllers: `app/controllers/perawatan_controller.go` - all handlers implemented

### 4. **Documentation Created** ✅
- Location: `PERAWATAN_SETUP_GUIDE.md`
- Complete setup, testing, and troubleshooting guide

---

## 🚀 Getting Started (Next Steps for You)

### Step 1: Prepare Backend

```bash
# Terminal 1: Navigate to backend
cd backend/monolith/go-template-main/cmd

# Run seeder to populate kategori_capaian table
go run main.go seed

# You should see:
# 🌱 Seed: kategori capaian perkembangan anak...
# ✅ Seeded 48 kategori capaian
```

### Step 2: Start Backend

```bash
# Terminal 1 (continued)
go run main.go
# Should output: listening on :8080
```

### Step 3: Verify Database

```bash
# Optional: Check if data was seeded (using your database tool)
SELECT COUNT(*) FROM kategori_capaian;
# Should return: 48

SELECT DISTINCT rentang_usia FROM kategori_capaian;
# Should show: 0-12 Bulan, 1-2 Tahun, 2-3 Tahun, 3-4 Tahun, 4-5 Tahun, 5-6 Tahun
```

### Step 4: Update Navigation (if using improved screen)

In your navigation/menu file where you call the perawatan screen, update the import:

**Before:**
```dart
import '...perawatan_screen_integrated.dart';
// Then use:
PerawatanScreenIntegrated(
  anakId: anakId,
  anakName: anakName,
)
```

**After (Recommended):**
```dart
import '...perawatan_screen_improved.dart';
// Then use:
PerawatanScreenImproved(
  anakId: anakId,
  anakName: anakName,
)
```

### Step 5: Run Flutter App

```bash
# Terminal 2: Navigate to Flutter
cd TA-PA2/mobile/kia_app

# Run with verbose logging for debugging
flutter run -v

# Or on specific device:
flutter run -d <device_id> -v
```

### Step 6: Manual Testing

1. **Login** as ibu (email: ibu@example.com or your ibu account)
2. **Select Child** from the list
3. **Navigate to Perawatan Perkembangan** (through Monitoring menu)
4. **Expected Result:**
   - Should see 6 tabs: 0-12 Bulan, 1-2 Tahun, ..., 5-6 Tahun
   - Each tab should show 8 questions
   - Questions should load with "Perkembangan Motorik", "Perkembangan Bahasa", etc.
5. **Fill Answers:**
   - Check "Ya" or "Tidak" for each question
   - Click "Simpan Perawatan"
   - Should see green success notification
6. **Verify Save:**
   - Refresh (swipe down)
   - Previously answered questions should show your answers

---

## 🔍 Debug Guide

### If You See "Tidak ada data untuk 0-12 Bulan"

**Check 1: Backend Running?**
```bash
curl http://localhost:8080/auth/me
# Should return auth response (or 401)
```

**Check 2: Database Seeded?**
```bash
# From Flutter console, you should see logs like:
[Perawatan] Loading kategori capaian for: 0-12 Bulan
[Perawatan] Fetching: http://localhost:8080/ibu/kategori-capaian/rentang-usia/0-12%20Bulan
[Perawatan] Response status: 200
```

**Check 3: API Endpoint Works?**
```bash
curl -X GET \
  http://localhost:8080/ibu/kategori-capaian/rentang-usia/0-12%20Bulan \
  -H "Authorization: Bearer <YOUR_TOKEN>"
# Should return data array
```

### If Answers Don't Save

**Check 1: Network Error?**
Look for in console: `[Perawatan] ✗ Error save jawaban`

**Check 2: Backend Logs?**
Check terminal where backend is running for error messages

**Check 3: Auth Token Valid?**
Make sure you're logged in and token hasn't expired

---

## 📱 File Structure

```
lib/
├── core/
│  └── constants/
│     └── api_constants.dart ✅ UPDATED
├── features/anak/tumbuh_kembang/
│  ├── data/
│  │  ├── models/
│  │  │  └── perawatan_model.dart ✅ EXISTS
│  │  └── services/
│  │     └── perawatan_api_service.dart ✅ EXISTS
│  └── presentation/screens/pemantauan/perawatan/
│     ├── perawatan_screen_integrated.dart (existing)
│     └── perawatan_screen_improved.dart ✅ NEW (RECOMMENDED)

backend/
├── app/
│  ├── controllers/
│  │  └── perawatan_controller.go ✅ EXISTS
│  ├── models/
│  │  └── perawatan_anak.go ✅ EXISTS
│  ├── repositories/
│  │  └── perawatan_repository.go ✅ EXISTS
│  ├── usecases/
│  │  └── perawatan_usecase.go ✅ EXISTS
│  └── seed/
│     └── kategori_capaian.go ✅ EXISTS (48 soal)
└── app/routes/routes.go ✅ REGISTERED
```

---

## 🎯 Expected Flow

```
Login (ibu)
  ↓
Select Child
  ↓
Go to Monitoring → Perawatan
  ↓
App fetches kategori_capaian for all age ranges
  ↓
Display questions in 6 tabs
  ↓
User selects Ya/Tidak for each question
  ↓
Click Simpan → POST to /ibu/perawatan
  ↓
Data saved in database
  ↓
Refresh → Load saved answers from GET /ibu/perawatan/anak/:id/rentang-usia/:rentang
  ↓
Display saved answers in checkboxes
```

---

## ✅ Verification Checklist

After implementing, verify:

- [ ] Backend is running on port 8080
- [ ] Database has kategori_capaian table with 48 rows
- [ ] Flutter app compiles without errors
- [ ] Can navigate to Perawatan screen
- [ ] Questions load from API (check console logs)
- [ ] Can select Ya/Tidak options
- [ ] Can save answers (see success notification)
- [ ] Saved answers persist after refresh
- [ ] Material/materi card displays below checklist

---

## 📝 API Endpoint Examples

### Get Kategori Capaian for Age Range
```bash
GET /ibu/kategori-capaian/rentang-usia/0-12%20Bulan
Authorization: Bearer <token>

Response:
{
  "status_code": 200,
  "message": "Success",
  "data": [
    {
      "id": 1,
      "rentang_usia": "0-12 Bulan",
      "pertanyaan_ceklist": "Bayi dapat mengikuti benda dengan matanya",
      "aspek": "Perkembangan Motorik"
    },
    // ... 7 more items
  ]
}
```

### Create Perawatan (Save Answer)
```bash
POST /ibu/perawatan
Authorization: Bearer <token>
Content-Type: application/json

Body:
{
  "anak_id": 5,
  "kategori_capaian_id": 1,
  "jawaban": true,
  "tanggal_periksa": "2024-05-04T10:00:00Z"
}

Response:
{
  "status_code": 201,
  "message": "Success",
  "data": {
    "id": 42,
    "anak_id": 5,
    "kategori_capaian_id": 1,
    "jawaban": true,
    "tanggal_periksa": "2024-05-04T10:00:00Z"
  }
}
```

---

## 🆘 Need Help?

1. **Check console logs** - Look for `[Perawatan]` debug messages
2. **Read PERAWATAN_SETUP_GUIDE.md** - Complete documentation
3. **Verify backend is running** - `curl http://localhost:8080/auth/me`
4. **Check database seeding** - `SELECT COUNT(*) FROM kategori_capaian`
5. **Verify token** - Make sure you're logged in as ibu

---

**Last Updated**: May 5, 2026  
**Status**: Ready for Testing ✅

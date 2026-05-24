# Struktur Implementasi Lembar Pemantauan Anak

## Architecture Flow

```
┌─────────────────────────────────────────────────────┐
│                   HTTP Request                       │
│  POST /tenaga-kesehatan/lembar-pemantauan           │
└────────────────┬────────────────────────────────────┘
                 │ (with JWT Token + TenagaKesehatan Role)
                 ▼
┌─────────────────────────────────────────────────────┐
│              Middleware (JWTAuth)                    │
│         Middleware (TenagaKesehatan)                │
└────────────────┬────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────┐
│          Controller Layer                            │
│  LembarPemantauanController                         │
│  ├─ Create(ctx)                                     │
│  ├─ GetByID(ctx)                                    │
│  ├─ GetByAnakID(ctx)                                │
│  ├─ Update(ctx)                                     │
│  └─ Delete(ctx)                                     │
└────────────────┬────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────┐
│          Usecase Layer                              │
│  LembarPemantauanUsecase                            │
│  ├─ Create(request) - Validate + Transform          │
│  ├─ GetByID(id) - Parse ID + Retrieve              │
│  ├─ GetByAnakID(id) - Parse ID + Filter List       │
│  ├─ GetAll() - Retrieve All                        │
│  ├─ Update(id, request) - Validate + Update        │
│  └─ Delete(id) - Parse ID + Soft Delete            │
└────────────────┬────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────┐
│          Repository Layer                           │
│  LembarPemantauanRepository                         │
│  ├─ Create() - Insert with Transaction             │
│  ├─ FindByID() - Query + Preload Relations         │
│  ├─ FindByAnakID() - Query Filter + Preload        │
│  ├─ FindAll() - Query All + Preload                │
│  ├─ Update() - Transaction: Delete Old + Insert    │
│  └─ Delete() - Soft Delete with Timestamp          │
└────────────────┬────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────┐
│          Database Layer (PostgreSQL)                 │
│  ├─ lembar_pemantauan (Main Table)                 │
│  │  ├─ id (PK)                                      │
│  │  ├─ anak_id (FK)                                │
│  │  ├─ rentang_usia_id (FK)                        │
│  │  ├─ periode_waktu                               │
│  │  ├─ tanggal_periksa                             │
│  │  ├─ nama_pemeriksa                              │
│  │  ├─ created_at, updated_at, deleted_at          │
│  │
│  ├─ detail_pemantauan (Detail Table)               │
│  │  ├─ id (PK)                                      │
│  │  ├─ lembar_pemantauan_id (FK)                   │
│  │  ├─ kategori_tanda_sakit_id (FK)                │
│  │  ├─ is_terjadi (Boolean)                        │
│  │  ├─ created_at, updated_at, deleted_at          │
│  │
│  ├─ rentang_usia (Master Table)                    │
│  └─ kategori_tanda_sakit (Master Table)            │
└─────────────────────────────────────────────────────┘
```

## Data Flow Diagram

```
Request JSON:
{
  "anak_id": 1,
  "rentang_usia_id": 2,
  "periode_waktu": 4,
  "tanggal_periksa": "2024-04-29",
  "nama_pemeriksa": "Ibu Siti",
  "detail_gejala": [
    {"kategori_tanda_sakit_id": 1, "is_terjadi": true},
    {"kategori_tanda_sakit_id": 2, "is_terjadi": false}
  ]
}
        │
        ▼
    [Controller.Create]
    - Parse & Bind Request
    - Call Usecase.Create()
        │
        ▼
    [Usecase.Create]
    - Validate Request
    - Parse DateTime
    - Create LembarPemantauan struct
    - Create DetailPemantauan array
    - Call Repository.Create()
        │
        ▼
    [Repository.Create]
    - Start Transaction
    - Insert LembarPemantauan
    - Insert DetailPemantauan (Has-Many)
    - Commit Transaction
        │
        ▼
    Response JSON:
    {
      "message": "Lembar pemantauan berhasil dibuat",
      "data": {
        "id": 10,
        "anak_id": 1,
        "rentang_usia_id": 2,
        "periode_waktu": 4,
        "tanggal_periksa": "2024-04-29T00:00:00Z",
        "nama_pemeriksa": "Ibu Siti",
        "created_at": "2024-04-29T14:30:00Z",
        "updated_at": "2024-04-29T14:30:00Z",
        "detail_gejala": [
          {
            "id": 45,
            "lembar_pemantauan_id": 10,
            "kategori_tanda_sakit_id": 1,
            "is_terjadi": true,
            "kategori_tanda_sakit": {...}
          },
          ...
        ]
      }
    }
```

## File Structure

```
backend/monolith/go-template-main/
│
├── app/
│   ├── controllers/
│   │   ├── lembar_pemantauan_controller.go          ✅ NEW
│   │   └── init.go                                  ✅ MODIFIED
│   │
│   ├── usecases/
│   │   ├── lembar_pemantauan_usecase.go            ✅ NEW
│   │   └── init.go                                  ✅ MODIFIED
│   │
│   ├── repositories/
│   │   ├── lembar_pemantauan_repository.go         ✅ NEW
│   │   └── init.go                                  ✅ MODIFIED
│   │
│   ├── models/
│   │   ├── skrining_tanda_bahaya.go                ✅ MODIFIED
│   │   └── migration.go                             ✅ MODIFIED
│   │
│   └── routes/
│       └── routes.go                                ✅ MODIFIED
│
└── LEMBAR_PEMANTAUAN_API.md                        ✅ NEW
```

## Database Schema

### lembar_pemantauan table
```
CREATE TABLE lembar_pemantauan (
  id SERIAL PRIMARY KEY,
  anak_id INT NOT NULL REFERENCES anak(id),
  rentang_usia_id INT NOT NULL REFERENCES rentang_usia(id),
  periode_waktu INT NOT NULL,
  tanggal_periksa DATE NOT NULL,
  nama_pemeriksa VARCHAR(100),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  deleted_at TIMESTAMP,
  INDEX(anak_id),
  INDEX(rentang_usia_id)
);
```

### detail_pemantauan table
```
CREATE TABLE detail_pemantauan (
  id SERIAL PRIMARY KEY,
  lembar_pemantauan_id INT NOT NULL REFERENCES lembar_pemantauan(id) ON DELETE CASCADE,
  kategori_tanda_sakit_id INT NOT NULL REFERENCES kategori_tanda_sakit(id),
  is_terjadi BOOLEAN NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  deleted_at TIMESTAMP,
  INDEX(lembar_pemantauan_id),
  INDEX(kategori_tanda_sakit_id)
);
```

## API Endpoints Summary

| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/tenaga-kesehatan/lembar-pemantauan` | Create new lembar pemantauan |
| GET | `/tenaga-kesehatan/lembar-pemantauan?anak_id=X` | Get all or filter by anak_id |
| GET | `/tenaga-kesehatan/lembar-pemantauan/:id` | Get by ID with full details |
| PUT | `/tenaga-kesehatan/lembar-pemantauan/:id` | Update existing lembar pemantauan |
| DELETE | `/tenaga-kesehatan/lembar-pemantauan/:id` | Soft delete lembar pemantauan |

All endpoints require:
- `Authorization: Bearer {JWT_TOKEN}` header
- User role must be: Tenaga Kesehatan (Bidan, Dokter, Kader)

## Key Implementation Details

### 1. Transaction Management
```go
// Create & Update operations use transaction for atomicity
return r.db.Transaction(func(tx *gorm.DB) error {
    // Multiple operations wrapped in single transaction
    // Rollback if any error occurs
})
```

### 2. Soft Delete Pattern
```go
// Delete operation sets deleted_at timestamp
return r.db.Model(&models.LembarPemantauan{}).
    Where("id = ?", lembarID).
    Update("deleted_at", time.Now()).Error
```

### 3. Automatic Preloading
```go
// Query automatically loads relationships
Preload("Anak").
Preload("RentangUsia").
Preload("DetailGejala.KategoriTandaSakit")
```

### 4. Input Validation
```go
// Validate method in Request struct
func (r *LembarPemantauanRequest) Validate() error {
    if r.AnakID <= 0 {
        return errors.New("anak_id harus lebih dari 0")
    }
    // ... more validations
}
```

## Testing Recommendations

1. **Create Test Cases**
   - Valid request → Success 200
   - Missing required fields → Bad Request 400
   - Invalid JWT → Unauthorized 401
   - Non-TenagaKesehatan role → Forbidden 403
   - Invalid anak_id → Not Found 404

2. **Integration Tests**
   - Create → Read → Update → Delete (CRUD flow)
   - Multiple detail_gejala entries
   - Transaction rollback on error

3. **Performance Tests**
   - Query with preloading efficiency
   - Large dataset filtering by anak_id
   - Soft delete performance

## Next Steps (Optional)

1. Add caching layer for frequently accessed data
2. Add audit logging for compliance
3. Add bulk operations (batch create/update)
4. Add filtering by date range
5. Add statistics/summary endpoints

# Dokumentasi API Perawatan/Milestone Anak

## Daftar Endpoint

Semua endpoint perawatan memerlukan autentikasi JWT dan role `tenaga-kesehatan` atau `bidan`.

### 1. Get All Milestone Categories (Kategori Capaian)

**Endpoint:** `GET /tenaga-kesehatan/kategori-capaian`

**Deskripsi:** Mengambil semua kategori capaian yang tersedia, diurutkan berdasarkan rentang usia.

**Response Success (200):**
```json
{
  "status_code": 200,
  "message": "Success",
  "data": [
    {
      "id": 1,
      "rentang_usia": "0-12 Bulan",
      "pertanyaan_ceklist": "Anak bisa berdiri sendiri tanpa berpegangan 30 detik?",
      "aspek": "Motorik Kasar",
      "created_at": "2024-01-15T10:00:00Z",
      "updated_at": "2024-01-15T10:00:00Z"
    },
    {
      "id": 2,
      "rentang_usia": "1-2 Tahun",
      "pertanyaan_ceklist": "Anak bisa berjalan tanpa terseok-seok?",
      "aspek": "Motorik Kasar",
      "created_at": "2024-01-15T10:00:00Z",
      "updated_at": "2024-01-15T10:00:00Z"
    }
  ]
}
```

---

### 2. Get Milestone Categories by Age Range

**Endpoint:** `GET /tenaga-kesehatan/kategori-capaian/rentang-usia/:rentang_usia`

**Deskripsi:** Mengambil kategori capaian untuk rentang usia tertentu.

**Parameters:**
- `rentang_usia` (path): Rentang usia (contoh: "0-12 Bulan", "1-2 Tahun", "2-3 Tahun")

**Response Success (200):**
```json
{
  "status_code": 200,
  "message": "Success",
  "data": [
    {
      "id": 1,
      "rentang_usia": "0-12 Bulan",
      "pertanyaan_ceklist": "Anak bisa berdiri sendiri tanpa berpegangan 30 detik?",
      "aspek": "Motorik Kasar",
      "created_at": "2024-01-15T10:00:00Z",
      "updated_at": "2024-01-15T10:00:00Z"
    }
  ]
}
```

---

### 3. Create Perawatan (Milestone Check)

**Endpoint:** `POST /tenaga-kesehatan/perawatan`

**Deskripsi:** Membuat record perawatan/milestone baru dengan jawaban checklist.

**Request Body:**
```json
{
  "anak_id": 5,
  "kategori_capaian_id": 1,
  "jawaban": true,
  "tanggal_periksa": "2024-05-04T10:00:00Z"
}
```

**Parameters:**
- `anak_id` (required): ID anak
- `kategori_capaian_id` (required): ID kategori capaian/milestone
- `jawaban` (optional): Boolean jawaban (true/false/null)
- `tanggal_periksa` (optional): Tanggal pemeriksaan (ISO 8601 format)

**Response Success (201):**
```json
{
  "status_code": 201,
  "message": "Success",
  "data": {
    "id": 42,
    "anak_id": 5,
    "kategori_capaian_id": 1,
    "jawaban": true,
    "tanggal_periksa": "2024-05-04T10:00:00Z",
    "created_at": "2024-05-04T10:00:00Z",
    "updated_at": "2024-05-04T10:00:00Z"
  }
}
```

**Error Response (400):**
```json
{
  "status_code": 400,
  "message": ["anak_id tidak boleh kosong"]
}
```

---

### 4. Get Perawatan by ID

**Endpoint:** `GET /tenaga-kesehatan/perawatan/:id`

**Deskripsi:** Mengambil detail perawatan berdasarkan ID.

**Parameters:**
- `id` (path): ID perawatan

**Response Success (200):**
```json
{
  "status_code": 200,
  "message": "Success",
  "data": {
    "id": 42,
    "anak_id": 5,
    "kategori_capaian_id": 1,
    "jawaban": true,
    "tanggal_periksa": "2024-05-04T10:00:00Z",
    "created_at": "2024-05-04T10:00:00Z",
    "updated_at": "2024-05-04T10:00:00Z"
  }
}
```

---

### 5. Get Perawatan by Child (Anak)

**Endpoint:** `GET /tenaga-kesehatan/perawatan/anak/:anak_id`

**Deskripsi:** Mengambil semua perawatan untuk seorang anak, diurutkan dari terbaru.

**Parameters:**
- `anak_id` (path): ID anak

**Response Success (200):**
```json
{
  "status_code": 200,
  "message": "Success",
  "data": [
    {
      "id": 42,
      "anak_id": 5,
      "kategori_capaian_id": 1,
      "jawaban": true,
      "tanggal_periksa": "2024-05-04T10:00:00Z",
      "created_at": "2024-05-04T10:00:00Z",
      "updated_at": "2024-05-04T10:00:00Z"
    },
    {
      "id": 41,
      "anak_id": 5,
      "kategori_capaian_id": 2,
      "jawaban": false,
      "tanggal_periksa": "2024-04-27T10:00:00Z",
      "created_at": "2024-04-27T10:00:00Z",
      "updated_at": "2024-04-27T10:00:00Z"
    }
  ]
}
```

---

### 6. Get Perawatan by Child & Age Range

**Endpoint:** `GET /tenaga-kesehatan/perawatan/anak/:anak_id/rentang-usia/:rentang_usia`

**Deskripsi:** Mengambil perawatan untuk seorang anak dalam rentang usia tertentu.

**Parameters:**
- `anak_id` (path): ID anak
- `rentang_usia` (path): Rentang usia (contoh: "1-2 Tahun")

**Response Success (200):**
```json
{
  "status_code": 200,
  "message": "Success",
  "data": [
    {
      "id": 42,
      "anak_id": 5,
      "kategori_capaian_id": 3,
      "jawaban": true,
      "tanggal_periksa": "2024-05-04T10:00:00Z",
      "created_at": "2024-05-04T10:00:00Z",
      "updated_at": "2024-05-04T10:00:00Z"
    }
  ]
}
```

---

### 7. Update Perawatan

**Endpoint:** `PUT /tenaga-kesehatan/perawatan/:id`

**Deskripsi:** Mengupdate record perawatan yang sudah ada.

**Parameters:**
- `id` (path): ID perawatan

**Request Body:**
```json
{
  "jawaban": false,
  "tanggal_periksa": "2024-05-04T11:00:00Z"
}
```

**Response Success (200):**
```json
{
  "status_code": 200,
  "message": "Success",
  "data": {
    "id": 42,
    "anak_id": 5,
    "kategori_capaian_id": 1,
    "jawaban": false,
    "tanggal_periksa": "2024-05-04T11:00:00Z",
    "created_at": "2024-05-04T10:00:00Z",
    "updated_at": "2024-05-04T11:30:00Z"
  }
}
```

---

### 8. Delete Perawatan

**Endpoint:** `DELETE /tenaga-kesehatan/perawatan/:id`

**Deskripsi:** Menghapus (soft delete) record perawatan.

**Parameters:**
- `id` (path): ID perawatan

**Response Success (200):**
```json
{
  "status_code": 200,
  "message": "Success",
  "data": {
    "message": "perawatan berhasil dihapus"
  }
}
```

---

## Status Codes

- `200 OK`: Request berhasil
- `201 Created`: Resource berhasil dibuat
- `400 Bad Request`: Request tidak valid atau validation error
- `401 Unauthorized`: Token tidak valid atau tidak ada
- `403 Forbidden`: User tidak memiliki akses (role tidak sesuai)
- `404 Not Found`: Resource tidak ditemukan
- `500 Internal Server Error`: Error di server

---

## Authorization

Semua endpoint memerlukan header:
```
Authorization: Bearer <JWT_TOKEN>
```

User harus memiliki role `tenaga-kesehatan` atau `bidan` untuk mengakses endpoint ini.

---

## Error Response Format

```json
{
  "status_code": 400,
  "message": ["Pesan error 1", "Pesan error 2"]
}
```

---

## Contoh Request dengan cURL

### Get All Kategori Capaian
```bash
curl -X GET http://localhost:8080/tenaga-kesehatan/kategori-capaian \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### Create Perawatan
```bash
curl -X POST http://localhost:8080/tenaga-kesehatan/perawatan \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "anak_id": 5,
    "kategori_capaian_id": 1,
    "jawaban": true,
    "tanggal_periksa": "2024-05-04T10:00:00Z"
  }'
```

### Get Perawatan by Child
```bash
curl -X GET http://localhost:8080/tenaga-kesehatan/perawatan/anak/5 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### Update Perawatan
```bash
curl -X PUT http://localhost:8080/tenaga-kesehatan/perawatan/42 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "jawaban": false
  }'
```

### Delete Perawatan
```bash
curl -X DELETE http://localhost:8080/tenaga-kesehatan/perawatan/42 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

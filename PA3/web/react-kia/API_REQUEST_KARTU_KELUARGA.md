# API Request Ke Backend (Golang)
## Fitur Manajemen Kartu Keluarga & Anggota Keluarga

Dokumen ini berisi kebutuhan API dari sisi frontend untuk menampilkan, memilih, mengubah, dan menghapus data keluarga berbasis kartu keluarga (KK).

## 1) Tujuan Fitur
Frontend membutuhkan kemampuan:
- Menampilkan daftar kartu keluarga.
- Memilih satu kartu keluarga untuk melihat detail anggota.
- Mengubah data kartu keluarga dan anggota keluarga.
- Menghapus data kartu keluarga atau anggota tertentu jika dibutuhkan.

## 2) Auth & Akses
- Semua endpoint menggunakan JWT Bearer token.
- Role minimal: Admin.
- Jika role tidak sesuai, backend mengembalikan 403.

## 3) Endpoint Yang Sudah Ada
Saat ini sudah ada endpoint create:
- `POST /api/v1/admin/akun-keluarga`

Endpoint ini dipakai untuk membuat KK + anggota + akun login keluarga.

## 4) Endpoint Yang Dibutuhkan Tambahan

### 4.1 List Kartu Keluarga
`GET /api/v1/admin/kartu-keluarga`

Query params (opsional):
- `search`: cari berdasarkan no_kk / nama kepala keluarga / nik.
- `page`: nomor halaman (default 1).
- `limit`: jumlah data per halaman (default 10).
- `sort_by`: contoh `created_at`, `no_kk`.
- `sort_dir`: `asc` / `desc`.

Contoh response:
```json
{
  "status_code": 200,
  "message": ["Success"],
  "data": {
    "items": [
      {
        "kartu_keluarga_id": 12,
        "no_kk": "3201012026040006",
        "tanggal_terbit": "2026-04-25",
        "kepala_keluarga": {
          "penduduk_id": 98,
          "nik": "3201010812750001",
          "nama_lengkap": "Budi Santoso"
        },
        "jumlah_anggota": 4,
        "created_at": "2026-04-25T08:00:00Z",
        "updated_at": "2026-04-25T08:00:00Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 10,
      "total": 1,
      "total_pages": 1
    }
  }
}
```

### 4.2 Detail Kartu Keluarga (untuk dipilih di UI)
`GET /api/v1/admin/kartu-keluarga/:kartu_keluarga_id`

Contoh response:
```json
{
  "status_code": 200,
  "message": ["Success"],
  "data": {
    "kartu_keluarga_id": 12,
    "no_kk": "3201012026040006",
    "tanggal_terbit": "2026-04-25",
    "akun": {
      "user_id": 33,
      "email": "keluarga.budi@example.com",
      "penduduk_id": 98,
      "akun_penduduk_nik": "3201010812750001"
    },
    "anggota_keluarga": [
      {
        "penduduk_id": 98,
        "nik": "3201010812750001",
        "nama_lengkap": "Budi Santoso",
        "jenis_kelamin": "Laki-laki",
        "tanggal_lahir": "1975-12-08",
        "tempat_lahir": "Medan",
        "golongan_darah": "O-",
        "agama": "Katolik",
        "status_perkawinan": "Kawin",
        "pekerjaan": "Dokter",
        "pendidikan_terakhir": "S2",
        "baca_huruf": "Ya",
        "kedudukan_keluarga": "Kepala Keluarga",
        "dusun": "Polonia RT04/RW09",
        "asal_penduduk": "Lahir",
        "tujuan_pindah": "",
        "tempat_meninggal": "",
        "keterangan": "",
        "nomor_telepon": "082155667788"
      }
    ]
  }
}
```

### 4.3 Update Data Kartu Keluarga (header + akun)
`PUT /api/v1/admin/kartu-keluarga/:kartu_keluarga_id`

Contoh request:
```json
{
  "no_kk": "3201012026040006",
  "tanggal_terbit": "2026-04-25",
  "email": "keluarga.budi.updated@example.com",
  "akun_penduduk_nik": "3201010812750001"
}
```

Catatan:
- Jika `akun_penduduk_nik` berubah, backend update relasi `user.penduduk_id`.

### 4.4 Update Anggota Keluarga
`PUT /api/v1/admin/kartu-keluarga/:kartu_keluarga_id/anggota/:penduduk_id`

Contoh request:
```json
{
  "nik": "3201011906780002",
  "nama_lengkap": "Maria Susanti",
  "jenis_kelamin": "Perempuan",
  "tanggal_lahir": "1978-06-19",
  "tempat_lahir": "Medan",
  "golongan_darah": "A+",
  "agama": "Katolik",
  "status_perkawinan": "Kawin",
  "pekerjaan": "Perawat",
  "pendidikan_terakhir": "D3",
  "baca_huruf": "Ya",
  "kedudukan_keluarga": "Istri",
  "dusun": "Polonia RT04/RW09",
  "asal_penduduk": "Lahir",
  "tujuan_pindah": "",
  "tempat_meninggal": "",
  "keterangan": "",
  "nomor_telepon": "082155667789"
}
```

### 4.5 Tambah Anggota Ke KK Yang Sudah Ada
`POST /api/v1/admin/kartu-keluarga/:kartu_keluarga_id/anggota`

Contoh request: sama seperti payload anggota (tanpa kartu_keluarga_id karena sudah dari path).

### 4.6 Hapus Anggota Keluarga
`DELETE /api/v1/admin/kartu-keluarga/:kartu_keluarga_id/anggota/:penduduk_id`

Catatan validasi:
- Tidak boleh menghapus anggota yang sedang menjadi akun utama (`user.penduduk_id`) tanpa mengganti akun utama dulu.
- Jika melanggar, kembalikan 409 dengan pesan jelas.

### 4.7 Hapus Kartu Keluarga
`DELETE /api/v1/admin/kartu-keluarga/:kartu_keluarga_id`

Catatan:
- Prefer soft delete.
- Kalau ada relasi penting, kembalikan 409 conflict + alasan.

## 5) Standar Response Error
Disarankan konsisten:
```json
{
  "status_code": 400,
  "message": ["penjelasan error"],
  "data": null
}
```

Kode yang dibutuhkan frontend:
- `400`: validasi gagal.
- `401`: token tidak valid / expired.
- `403`: bukan admin.
- `404`: data tidak ditemukan.
- `409`: konflik data (misalnya no_kk/nik/email sudah dipakai).
- `500`: internal server error.

## 6) Field Minimum Yang Frontend Pakai
- KK: `kartu_keluarga_id`, `no_kk`, `tanggal_terbit`
- Akun: `user_id`, `email`, `akun_penduduk_nik`
- Anggota: `penduduk_id`, `nik`, `nama_lengkap`, `kedudukan_keluarga`, `nomor_telepon` + field detail lain

## 7) Acceptance Criteria
- Frontend bisa load daftar KK dengan pagination.
- Frontend bisa pilih satu KK dan menampilkan detail anggota.
- Frontend bisa edit KK dan anggota.
- Frontend bisa hapus anggota/KK dengan respon yang jelas.
- Semua endpoint terlindungi JWT + AdminOnly middleware.

## 8) Catatan Integrasi Frontend Saat Ini
- Create KK sudah terhubung ke endpoint: `POST /api/v1/admin/akun-keluarga`.
- Halaman frontend terkait admin berada di modul Admin:
  - `src/pages/Admin/Dashboard.jsx`
  - `src/pages/Admin/AkunKeluargaCreate.jsx`

Terima kasih, mohon konfirmasi jika struktur endpoint perlu menyesuaikan arsitektur repository/usecase backend saat ini.

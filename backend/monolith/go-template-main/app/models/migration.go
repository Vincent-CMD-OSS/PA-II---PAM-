package models

// // import (
// // 	"gorm.io/gorm"
// // )

// // func AutoMigrate(db *gorm.DB) error {
// // 	// Semua model dalam satu slice
// // 	models := []interface{}{
// // 		// Master
// // 		// &KategoriTandaBahaya{},
// // 		&SkriningPemantauan{},
// // 		// &KartuKeluarga{},
// // 		// &Kependudukan{},

// // 		// Relasi utama
// // 		// &ibu
// // 		&Kehamilan{},
// // 		&Anak{},
// // 		&Role{},
// // 		&User{},
// // 		&Bidan{},
// // 		&Kader{},
// // 		&KartuKeluarga{},
// // 		&Kependudukan{},
// // 		&Ibu{},
// // 		&Anak{},

// // 		// Evaluasi & riwayat
// // 		&EvaluasiKesehatanIbu{},
// // 		&RiwayatKehamilanLalu{},

// // 		// Pelayanan & lainnya
// // 		&JenisPelayanan{},
// // 		&JenisPelayananKategori{},
// // 		&KunjunganAnak{},
// // 		&AturanPelayanan{},
// // 		&KunjunganGizi{},
// // 		&KunjunganVitamin{},
// // 		&Neonatus{},
// // 		&DetailPelayananNeonatus{},
// // 		&DetailPelayananVitamin{},
// // 		&ASI{},
// // 		&MPASI{},
// // 		&CatatanPelayanan{},
// // 		&KehadiranImunisasi{},
// // 		&DetailPelayananImunisasi{},
// // 		&PeriksaGigi{},
// // 		&DeteksiDiniPenyimpangan{},
// // 		&PengukuranLila{},
// // 		&Pertumbuhan{},

// // 		// Kehamilan detail
// // 		&PemeriksaanKehamilan{},
// // 		&PemeriksaanDokterTrimester1{},
// // 		&PemeriksaanLaboratoriumJiwa{},
// // 		&CatatanPelayananTrimester1{},
// // 		&SkriningPreeklampsia{},
// // 		&SkriningDMGestasional{},
// // 		&CatatanPelayananTrimester2{},
// // 		&PemeriksaanDokterTrimester3{},
// // 		&PemeriksaanLanjutanTrimester3{},
// // 		&CatatanPelayananTrimester3{},

// // 		// Grafik & hasil
// // 		&GrafikEvaluasiKehamilan{},
// // 		&GrafikPeningkatanBB{},
// // 		&PenjelasanHasilGrafik{},

// // 		// Persalinan
// // 		&RencanaPersalinan{},
// // 		&RingkasanPelayananPersalinan{},
// // 		&KeteranganLahir{},
// // 		&RiwayatProsesMelahirkan{},

// // 		// Nifas & rujukan
// // 		&PelayananIbuNifas{},
// // 		&CatatanPelayananNifas{},
// // 		&Rujukan{},
// import (
// 	"gorm.io/gorm"
// )

// func AutoMigrate(db *gorm.DB) error {
// 	// Semua model dalam satu slice
// 	models := []interface{}{
// 		&InformasiUmum{},
// 		// Master
// 		// &KategoriTandaBahaya{},
// 		// &SkriningPemantauan{},
// 		// // &KartuKeluarga{},
// 		// // &Kependudukan{},

// 		// // Relasi utama
// 		// // &ibu
// 		// &Kehamilan{},
// 		// &Anak{},
// 		// &Role{},
// 		// &User{},
// 		// &Bidan{},
// 		// &Kader{},
// 		// &KartuKeluarga{},
// 		// &Kependudukan{},
// 		// &Ibu{},
// 		// &Anak{},

// 		// // Evaluasi & riwayat
// 		// &EvaluasiKesehatanIbu{},
// 		// &RiwayatKehamilanLalu{},

// 		// // Pelayanan & lainnya
// 		// &JenisPelayanan{},
// 		// &JenisPelayananKategori{},
// 		// &KunjunganAnak{},
// 		// &AturanPelayanan{},
// 		// &KunjunganGizi{},
// 		// &KunjunganVitamin{},
// 		// &Neonatus{},
// 		// &DetailPelayananNeonatus{},
// 		// &DetailPelayananVitamin{},
// 		// &ASI{},
// 		// &MPASI{},
// 		// &CatatanPelayanan{},
// 		// &KehadiranImunisasi{},
// 		// &DetailPelayananImunisasi{},
// 		// &PeriksaGigi{},
// 		// &DeteksiDiniPenyimpangan{},
// 		// &PengukuranLila{},
// 		// &Pertumbuhan{},

// 		// // Kehamilan detail
// 		// &PemeriksaanKehamilan{},
// 		// &PemeriksaanDokterTrimester1{},
// 		// &PemeriksaanLaboratoriumJiwa{},
// 		// &CatatanPelayananTrimester1{},
// 		// &SkriningPreeklampsia{},
// 		// &SkriningDMGestasional{},
// 		// &CatatanPelayananTrimester2{},
// 		// &PemeriksaanDokterTrimester3{},
// 		// &PemeriksaanLanjutanTrimester3{},
// 		// &CatatanPelayananTrimester3{},

// 		// // Grafik & hasil
// 		// &GrafikEvaluasiKehamilan{},
// 		// &GrafikPeningkatanBB{},
// 		// &PenjelasanHasilGrafik{},

// 		// // Persalinan
// 		// &RencanaPersalinan{},
// 		// &RingkasanPelayananPersalinan{},
// 		// &KeteranganLahir{},
// 		// &RiwayatProsesMelahirkan{},

// 		// // Nifas & rujukan
// 		// &PelayananIbuNifas{},
// 		// &CatatanPelayananNifas{},
// 		// &Rujukan{},

// 		// // Skrining & Pemantauan
// 		// &RentangUsia{},
// 		// &KategoriTandaSakit{},
// 		// &LembarPemantauan{},
// 		// &DetailPemantauan{},
// 	}

// // 		// MODUL IBU
// // 		&LogTTDMMS{},
// // 		&PersiapanMelahirkan{},
// // 		&ProsesMelahirkan{},
// // 		&PemantauanIbuHamil{},
// // 		&PemantauanIbuNifas{},
// // 	}

// // 	// Jalankan automigrate sekali saja
// // 	if err := db.AutoMigrate(models...); err != nil {
// // 		return err
// // 	}

// // 	// seeder
// // 	// log.Println("AutoMigrate selesai. Menjalankan Seeder...")
// // 	// seeder := seeders.NewSeeder(db)
// // 	// if err := seeder.Run(); err != nil {
// // 	// 	println("Error: seeder gagal dijalankan:", err.Error())
// // 	// }

// // 	return nil
// // }
// 	// seeder
// 	// log.Println("AutoMigrate selesai. Menjalankan Seeder...")
// 	// seeder := seeders.NewSeeder(db)
// 	// if err := seeder.Run(); err != nil {
// 	// 	println("Error: seeder gagal dijalankan:", err.Error())
// 	// }

// 	return nil
// }

package routes

import (
	"monitoring-service/app/controllers"
	"monitoring-service/app/middlewares"

	"github.com/labstack/echo/v4"
)

func ConfigureRouter(e *echo.Echo, controller *controllers.Main) {
	e.GET("/health", func(c echo.Context) error {
		return c.JSON(200, map[string]string{"status": "ok"})
	})

	// Auth routes
	auth := e.Group("/auth")
	auth.POST("/register", controller.Register)
	auth.POST("/login", controller.Login)
	// auth.POST("/register/ortu", controller.RegisterOrangTua) // registrasi khusus orang tua
	secured := auth.Group("")
	secured.Use(middlewares.JWTAuth(controller.JWTSecret()))
	secured.GET("/me", controller.Me)

	// ==================== INFORMASI UMUM ====================
	informasiUmum := e.Group("/informasi-umum")
	informasiUmum.GET("", controller.InformasiUmum.GetAll)
	informasiUmum.GET("/:id", controller.InformasiUmum.Detail)
	// CRUD dibuka agar web dashboard bisa langsung mengelola Informasi Umum.
	informasiUmum.POST("", controller.InformasiUmum.Create)
	informasiUmum.PUT("/:id", controller.InformasiUmum.Update)
	informasiUmum.DELETE("/:id", controller.InformasiUmum.Delete)

		// ==================== EDUKASI IBU ====================
	e.GET("/edukasi-imd", controller.EdukasiIMD.GetAll)
	e.GET("/edukasi-kesehatan-mental", controller.EdukasiKesehatanMental.GetAll)
	e.GET("/edukasi-menyusui-asi", controller.EdukasiMenyusuiASI.GetAll)
	e.GET("/edukasi-nifas", controller.EdukasiNifas.GetAll)
	e.GET("/edukasi-tanda-melahirkan", controller.EdukasiTandaMelahirkan.GetAll)
	e.GET("/edukasi-trimester",controller.EdukasiTrimester.GetAll,)
	e.GET("/edukasi-trimester/:trimester",controller.EdukasiTrimester.GetByTrimester,)
	e.GET("/edukasi-trimester/:trimester/:kategori",controller.EdukasiTrimester.GetByKategori,)
	// ==================== MODUL ADMIN  ====================

	admin := e.Group("/admin")
	admin.Use(middlewares.JWTAuth(controller.JWTSecret()))
	admin.Use(middlewares.AdminOnly())
	admin.POST("/akun-keluarga", controller.AdminCreateAkunKeluarga)
	admin.GET("/kartu-keluarga", controller.AdminListKartuKeluarga)
	admin.GET("/kartu-keluarga/:kartu_keluarga_id", controller.AdminDetailKartuKeluarga)
	admin.PUT("/kartu-keluarga/:kartu_keluarga_id", controller.AdminUpdateKartuKeluarga)
	admin.PUT("/kartu-keluarga/:kartu_keluarga_id/anggota/:penduduk_id", controller.AdminUpdateAnggotaKeluarga)
	admin.POST("/kartu-keluarga/:kartu_keluarga_id/anggota", controller.AdminAddAnggotaKeluarga)
	admin.DELETE("/kartu-keluarga/:kartu_keluarga_id/anggota/:penduduk_id", controller.AdminDeleteAnggotaKeluarga)
	admin.DELETE("/kartu-keluarga/:kartu_keluarga_id", controller.AdminDeleteKartuKeluarga)
	admin.GET("/penduduk/eligible", controller.AdminListEligiblePenduduk)
	admin.POST("/posyandu", controller.AdminTambahPosyandu)
	admin.GET("/posyandu", controller.AdminListPosyandu)
	admin.POST("/bidan", controller.AdminTambahBidan)
	admin.GET("/bidan", controller.AdminListBidan)
	admin.PUT("/bidan/:id", controller.AdminUpdateBidan)
	admin.PATCH("/bidan/:id/status", controller.AdminUpdateStatusBidan)
	admin.POST("/kader", controller.AdminTambahKader)
	admin.GET("/kader", controller.AdminListKader)
	admin.PUT("/kader/:id", controller.AdminUpdateKader)
	admin.PATCH("/kader/:id/status", controller.AdminUpdateStatusKader)

	// ==================== Branch Andika ====================

	anak := e.Group("/anak")
	anak.Use(middlewares.JWTAuth(controller.JWTSecret()))
	// anak.GET("", controller.GetAllAnak)
	// anak.GET("/search", controller.GetAnak)
	// anak.GET("/:anak_id", controller.GetAnakById)

	// Master Standar Routes
	masterStandar := e.Group("/master-standar")
	masterStandar.Use(middlewares.JWTAuth(controller.JWTSecret()))
	// masterStandar.GET("", controller.GetMasterStandar)
	// masterStandar.POST("", controller.CreateMasterStandar)

	// Pertumbuhan Routes
	pertumbuhan := e.Group("/pertumbuhan")
	pertumbuhan.Use(middlewares.JWTAuth(controller.JWTSecret()))
	// pertumbuhan.POST("", controller.AddCatatanPertumbuhan)
	// pertumbuhan.GET("/:anak_id", controller.GetRiwayatPertumbuhan)
	// pertumbuhan.GET("/detail/:id", controller.GetDetailCatatanPertumbuhan)
	// pertumbuhan.PUT("/:id", controller.UpdateCatatanPertumbuhan)
	// pertumbuhan.DELETE("/:id", controller.DeleteCatatanPertumbuhan)

	// Kategori Capaian Routes
	kategoriCapaian := e.Group("/kategori-capaian")
	kategoriCapaian.Use(middlewares.JWTAuth(controller.JWTSecret()))
	// kategoriCapaian.GET("", controller.GetAllKategoriCapaian)
	// kategoriCapaian.GET("/:id", controller.GetKategoriCapaianById)
	// kategoriCapaian.GET("/rentang-usia", controller.GetKategoriCapaianByRentangUsia)
	// kategoriCapaian.POST("", controller.CreateKategoriCapaian)
	// kategoriCapaian.PUT("/:id", controller.UpdateKategoriCapaian)
	// kategoriCapaian.DELETE("/:id", controller.DeleteKategoriCapaian)

	// Perkembangan Routes
	perkembangan := e.Group("/perkembangan")
	perkembangan.Use(middlewares.JWTAuth(controller.JWTSecret()))
	// perkembangan.GET("", controller.GetAllPerkembangan)
	// perkembangan.GET("/:id", controller.GetPerkembanganById)
	// perkembangan.GET("/anak/:anak_id", controller.GetPerkembanganByAnakId)
	// perkembangan.GET("/anak/:anak_id/kategori/:kategori_capaian_id", controller.GetPerkembanganByAnakIdAndKategoriId)
	// perkembangan.POST("", controller.CreatePerkembangan)
	// perkembangan.PUT("/:id", controller.UpdatePerkembangan)
	// perkembangan.DELETE("/:id", controller.DeletePerkembangan)
	// perkembangan.GET("/search", controller.SearchPerkembangan)

	// Group untuk tenaga kesehatan (termasuk bidan, dokter, tenaga-kesehatan)
	tenaga := e.Group("/tenaga-kesehatan")
	tenaga.Use(middlewares.JWTAuth(controller.JWTSecret()))
	tenaga.Use(middlewares.TenagaKesehatan())

	// ==================== MODUL ANAK & PELAYANAN ANAK (yang sudah ada) ====================
	tenaga.GET("/anak", controller.Anak.AdminList)
	tenaga.POST("/anak", controller.Anak.Create)
	tenaga.GET("/anak/:id", controller.Anak.Detail)
	tenaga.PUT("/anak/:id", controller.Anak.Update)
	tenaga.DELETE("/anak/:id", controller.Anak.Delete)

	tenaga.GET("/pelayanan-kesehatan-anak", controller.PelayananKesehatanAnak.GetByAnakID)
	tenaga.GET("/pelayanan-kesehatan-anak/:id", controller.PelayananKesehatanAnak.GetByID)
	tenaga.POST("/pelayanan-kesehatan-anak", controller.PelayananKesehatanAnak.CreatePelayananHandler)
	tenaga.PUT("/pelayanan-kesehatan-anak/:id", controller.PelayananKesehatanAnak.Update)
	tenaga.DELETE("/pelayanan-kesehatan-anak/:id", controller.PelayananKesehatanAnak.Delete)

	tenaga.GET("/Neonatus", controller.Neonatus.GetByAnakID)
	tenaga.GET("/Neonatus/:id", controller.Neonatus.GetByID)
	tenaga.POST("/Neonatus", controller.Neonatus.CreatePelayananHandler)
	tenaga.PUT("/Neonatus/:id", controller.Neonatus.Update)
	tenaga.DELETE("/Neonatus/:id", controller.Neonatus.Delete)

	tenaga.GET("/Pelayanan-Gizi-Anak", controller.PelayananGiziAnak.GetByAnakID)
	tenaga.GET("/Pelayanan-Gizi-Anak/:id", controller.PelayananGiziAnak.GetByID)
	tenaga.POST("/Pelayanan-Gizi-Anak", controller.PelayananGiziAnak.Create)
	tenaga.PUT("/Pelayanan-Gizi-Anak/:id", controller.PelayananGiziAnak.Update)
	tenaga.DELETE("/Pelayanan-Gizi-Anak/:id", controller.PelayananGiziAnak.Delete)

	tenaga.GET("/Pelayanan-Vitamin-ObatCacing", controller.KunjunganVitamin.GetByAnakID)
	tenaga.GET("/Pelayanan-Vitamin-ObatCacing/:id", controller.KunjunganVitamin.GetByID)
	tenaga.POST("/Pelayanan-Vitamin-ObatCacing", controller.KunjunganVitamin.Create)
	tenaga.PUT("/Pelayanan-Vitamin-ObatCacing/:id", controller.KunjunganVitamin.Update)
	tenaga.DELETE("/Pelayanan-Vitamin-ObatCacing/:id", controller.KunjunganVitamin.Delete)

	tenaga.GET("/Pelayanan-Imunisasi", controller.KunjunganImunisasi.GetByAnakID)
	tenaga.GET("/Pelayanan-Imunisasi/:id", controller.KunjunganImunisasi.GetByID)
	tenaga.POST("/Pelayanan-Imunisasi", controller.KunjunganImunisasi.Create)
	tenaga.PUT("/Pelayanan-Imunisasi/:id", controller.KunjunganImunisasi.Update)
	tenaga.DELETE("/Pelayanan-Imunisasi/:id", controller.KunjunganImunisasi.Delete)

	tenaga.GET("/Pemeriksaan-Gigi", controller.PemeriksaanGigi.GetByAnakID)
	tenaga.GET("/Pemeriksaan-Gigi/:id", controller.PemeriksaanGigi.GetByID)
	tenaga.POST("/Pemeriksaan-Gigi", controller.PemeriksaanGigi.Create)
	tenaga.PUT("/Pemeriksaan-Gigi/:id", controller.PemeriksaanGigi.Update)
	tenaga.DELETE("/Pemeriksaan-Gigi/:id", controller.PemeriksaanGigi.Delete)

	tenaga.GET("/Pemantauan-Pertumbuhan-Anak", controller.PemantauanPertumbuhan.GetByAnakID)
	tenaga.GET("/Pemantauan-Pertumbuhan-Anak/:id", controller.PemantauanPertumbuhan.GetByID)
	tenaga.POST("/Pemantauan-Pertumbuhan-Anak", controller.PemantauanPertumbuhan.Create)
	tenaga.PUT("/Pemantauan-Pertumbuhan-Anak/:id", controller.PemantauanPertumbuhan.Update)
	tenaga.DELETE("/Pemantauan-Pertumbuhan-Anak/:id", controller.PemantauanPertumbuhan.Delete)

	tenaga.GET("/Pengukuran-LilA", controller.PengukuranLilA.GetByAnakID)
	tenaga.GET("/Pengukuran-LilA/:id", controller.PengukuranLilA.GetByID)
	tenaga.POST("/Pengukuran-LilA", controller.PengukuranLilA.Create)
	tenaga.PUT("/Pengukuran-LilA/:id", controller.PengukuranLilA.Update)
	tenaga.DELETE("/Pengukuran-LilA/:id", controller.PengukuranLilA.Delete)

	tenaga.GET("/Catatan-Pelayanan", controller.CatatanPelayanan.GetByAnakID)
	tenaga.GET("/Catatan-Pelayanan/:id", controller.CatatanPelayanan.GetByID)
	tenaga.POST("/Catatan-Pelayanan", controller.CatatanPelayanan.Create)
	tenaga.PUT("/Catatan-Pelayanan/:id", controller.CatatanPelayanan.Update)
	tenaga.DELETE("/Catatan-Pelayanan/:id", controller.CatatanPelayanan.Delete)

	// ==================== PERAWATAN ANAK (MILESTONE/PERKEMBANGAN) ====================
	tenaga.GET("/kategori-capaian", controller.GetAllKategoriCapaian)
	tenaga.GET("/kategori-capaian/rentang-usia/:rentang_usia", controller.GetKategoriCapaianByRentangUsia)
	tenaga.GET("/perawatan/:id", controller.GetPerawatanByID)
	tenaga.GET("/perawatan/anak/:anak_id", controller.GetPerawatanByAnakID)
	tenaga.GET("/perawatan/anak/:anak_id/rentang-usia/:rentang_usia", controller.GetPerawatanByAnakIDAndRentangUsia)
	tenaga.POST("/perawatan", controller.CreatePerawatan)
	tenaga.PUT("/perawatan/:id", controller.UpdatePerawatan)
	tenaga.DELETE("/perawatan/:id", controller.DeletePerawatan)

	// ==================== LEMBAR PEMANTAUAN ANAK ====================
	tenaga.GET("/lembar-pemantauan", controller.LembarPemantauan.GetByAnakID)
	tenaga.GET("/lembar-pemantauan/:id", controller.LembarPemantauan.GetByID)
	tenaga.POST("/lembar-pemantauan", controller.LembarPemantauan.Create)
	tenaga.PUT("/lembar-pemantauan/:id", controller.LembarPemantauan.Update)
	tenaga.DELETE("/lembar-pemantauan/:id", controller.LembarPemantauan.Delete)
	// TAMBAHAN: Endpoint untuk verifikasi oleh nakes
	tenaga.PATCH("/lembar-pemantauan/:id/verifikasi", controller.LembarPemantauan.Verify)

	// ==================== MODUL IBU & KEHAMILAN ====================
	tenaga.POST("/ibu", controller.Ibu.Create)
	tenaga.GET("/ibu", controller.Ibu.GetAll)
	tenaga.GET("/ibu/:id", controller.Ibu.GetByID)
	tenaga.PUT("/ibu/:id", controller.Ibu.Update)
	tenaga.DELETE("/ibu/:id", controller.Ibu.Delete)

	tenaga.POST("/kehamilan", controller.Kehamilan.Create)
	tenaga.GET("/kehamilan/:id", controller.Kehamilan.GetByID)
	tenaga.GET("/kehamilan", controller.Kehamilan.GetByIbuID)
	tenaga.PUT("/kehamilan/:id", controller.Kehamilan.Update)
	tenaga.DELETE("/kehamilan/:id", controller.Kehamilan.Delete)

	// ==================== PEMERIKSAAN KEHAMILAN (RUTIN) ====================
	tenaga.POST("/pemeriksaan-kehamilan", controller.PemeriksaanKehamilan.Create)
	tenaga.GET("/pemeriksaan-kehamilan/:id", controller.PemeriksaanKehamilan.GetByID)
	tenaga.GET("/pemeriksaan-kehamilan", controller.PemeriksaanKehamilan.GetByKehamilanID)
	tenaga.PUT("/pemeriksaan-kehamilan/:id", controller.PemeriksaanKehamilan.Update)
	tenaga.DELETE("/pemeriksaan-kehamilan/:id", controller.PemeriksaanKehamilan.Delete)

	// ==================== EVALUASI KESEHATAN IBU ====================
	tenaga.POST("/evaluasi-kesehatan-ibu", controller.EvaluasiKesehatanIbu.Create)
	tenaga.GET("/evaluasi-kesehatan-ibu/:id", controller.EvaluasiKesehatanIbu.GetByID)
	tenaga.GET("/evaluasi-kesehatan-ibu", controller.EvaluasiKesehatanIbu.GetByKehamilanID)
	tenaga.PUT("/evaluasi-kesehatan-ibu/:id", controller.EvaluasiKesehatanIbu.Update)
	tenaga.DELETE("/evaluasi-kesehatan-ibu/:id", controller.EvaluasiKesehatanIbu.Delete)

	// ==================== RIWAYAT KEHAMILAN LALU (terhubung ke evaluasi) ====================
	tenaga.POST("/riwayat-kehamilan-lalu", controller.RiwayatKehamilanLalu.Create)
	tenaga.GET("/riwayat-kehamilan-lalu/:id", controller.RiwayatKehamilanLalu.GetByID)
	tenaga.GET("/riwayat-kehamilan-lalu", controller.RiwayatKehamilanLalu.GetByEvaluasiID)
	tenaga.PUT("/riwayat-kehamilan-lalu/:id", controller.RiwayatKehamilanLalu.Update)
	tenaga.DELETE("/riwayat-kehamilan-lalu/:id", controller.RiwayatKehamilanLalu.Delete)

	// ==================== PEMERIKSAAN DOKTER TRIMESTER 1 ====================
	tenaga.POST("/pemeriksaan-dokter-t1", controller.PemeriksaanDokterTrimester1.Create)
	tenaga.GET("/pemeriksaan-dokter-t1/:id", controller.PemeriksaanDokterTrimester1.GetByID)
	tenaga.GET("/pemeriksaan-dokter-t1", controller.PemeriksaanDokterTrimester1.GetByKehamilanID)
	tenaga.PUT("/pemeriksaan-dokter-t1/:id", controller.PemeriksaanDokterTrimester1.Update)
	tenaga.DELETE("/pemeriksaan-dokter-t1/:id", controller.PemeriksaanDokterTrimester1.Delete)

	// ==================== PEMERIKSAAN LABORATORIUM & JIWA ====================
	tenaga.POST("/pemeriksaan-lab-jiwa", controller.PemeriksaanLaboratoriumJiwa.Create)
	tenaga.GET("/pemeriksaan-lab-jiwa/:id", controller.PemeriksaanLaboratoriumJiwa.GetByID)
	tenaga.GET("/pemeriksaan-lab-jiwa", controller.PemeriksaanLaboratoriumJiwa.GetByKehamilanID)
	tenaga.PUT("/pemeriksaan-lab-jiwa/:id", controller.PemeriksaanLaboratoriumJiwa.Update)
	tenaga.DELETE("/pemeriksaan-lab-jiwa/:id", controller.PemeriksaanLaboratoriumJiwa.Delete)

	// ==================== CATATAN PELAYANAN TRIMESTER 1 ====================
	tenaga.POST("/catatan-pelayanan-t1", controller.CatatanPelayananTrimester1.Create)
	tenaga.GET("/catatan-pelayanan-t1/:id", controller.CatatanPelayananTrimester1.GetByID)
	tenaga.GET("/catatan-pelayanan-t1", controller.CatatanPelayananTrimester1.GetByKehamilanID)
	tenaga.PUT("/catatan-pelayanan-t1/:id", controller.CatatanPelayananTrimester1.Update)
	tenaga.DELETE("/catatan-pelayanan-t1/:id", controller.CatatanPelayananTrimester1.Delete)

	// ==================== CATATAN PELAYANAN TRIMESTER 2 ====================
	tenaga.POST("/catatan-pelayanan-t2", controller.CatatanPelayananTrimester2.Create)
	tenaga.GET("/catatan-pelayanan-t2/:id", controller.CatatanPelayananTrimester2.GetByID)
	tenaga.GET("/catatan-pelayanan-t2", controller.CatatanPelayananTrimester2.GetByKehamilanID)
	tenaga.PUT("/catatan-pelayanan-t2/:id", controller.CatatanPelayananTrimester2.Update)
	tenaga.DELETE("/catatan-pelayanan-t2/:id", controller.CatatanPelayananTrimester2.Delete)

	// ==================== CATATAN PELAYANAN TRIMESTER 3 ====================
	tenaga.POST("/catatan-pelayanan-t3", controller.CatatanPelayananTrimester3.Create)
	tenaga.GET("/catatan-pelayanan-t3/:id", controller.CatatanPelayananTrimester3.GetByID)
	tenaga.GET("/catatan-pelayanan-t3", controller.CatatanPelayananTrimester3.GetByKehamilanID)
	tenaga.PUT("/catatan-pelayanan-t3/:id", controller.CatatanPelayananTrimester3.Update)
	tenaga.DELETE("/catatan-pelayanan-t3/:id", controller.CatatanPelayananTrimester3.Delete)

	// ==================== CATATAN PELAYANAN NIFAS ====================
	tenaga.POST("/catatan-pelayanan-nifas", controller.CatatanPelayananNifas.Create)
	tenaga.GET("/catatan-pelayanan-nifas/:id", controller.CatatanPelayananNifas.GetByID)
	tenaga.GET("/catatan-pelayanan-nifas", controller.CatatanPelayananNifas.GetByKehamilanID)
	tenaga.PUT("/catatan-pelayanan-nifas/:id", controller.CatatanPelayananNifas.Update)
	tenaga.DELETE("/catatan-pelayanan-nifas/:id", controller.CatatanPelayananNifas.Delete)

	// ==================== GRAFIK EVALUASI KEHAMILAN ====================
	tenaga.POST("/grafik-evaluasi-kehamilan", controller.GrafikEvaluasiKehamilan.Create)
	tenaga.GET("/grafik-evaluasi-kehamilan/grafik", controller.GrafikEvaluasiKehamilan.GetGrafik)
	tenaga.GET("/grafik-evaluasi-kehamilan/:id", controller.GrafikEvaluasiKehamilan.GetByID)
	tenaga.GET("/grafik-evaluasi-kehamilan", controller.GrafikEvaluasiKehamilan.GetByKehamilanID)
	tenaga.PUT("/grafik-evaluasi-kehamilan/:id", controller.GrafikEvaluasiKehamilan.Update)
	tenaga.DELETE("/grafik-evaluasi-kehamilan/:id", controller.GrafikEvaluasiKehamilan.Delete)

	// ==================== GRAFIK PENINGKATAN BERAT BADAN ====================
	tenaga.POST("/grafik-peningkatan-bb", controller.GrafikPeningkatanBB.Create)
	tenaga.GET("/grafik-peningkatan-bb/:id", controller.GrafikPeningkatanBB.GetByID)
	tenaga.GET("/grafik-peningkatan-bb", controller.GrafikPeningkatanBB.GetByKehamilanID)
	tenaga.PUT("/grafik-peningkatan-bb/:id", controller.GrafikPeningkatanBB.Update)
	tenaga.DELETE("/grafik-peningkatan-bb/:id", controller.GrafikPeningkatanBB.Delete)

	// ==================== PENJELASAN HASIL GRAFIK ====================
	tenaga.POST("/penjelasan-hasil-grafik", controller.PenjelasanHasilGrafik.Create)
	tenaga.GET("/penjelasan-hasil-grafik/:id", controller.PenjelasanHasilGrafik.GetByID)
	tenaga.GET("/penjelasan-hasil-grafik", controller.PenjelasanHasilGrafik.GetByKehamilanID)
	tenaga.PUT("/penjelasan-hasil-grafik/:id", controller.PenjelasanHasilGrafik.Update)
	tenaga.DELETE("/penjelasan-hasil-grafik/:id", controller.PenjelasanHasilGrafik.Delete)

	// ==================== RENCANA PERSALINAN ====================
	tenaga.POST("/rencana-persalinan", controller.RencanaPersalinan.Create)
	tenaga.GET("/rencana-persalinan/:id", controller.RencanaPersalinan.GetByID)
	tenaga.GET("/rencana-persalinan", controller.RencanaPersalinan.GetByKehamilanID)
	tenaga.PUT("/rencana-persalinan/:id", controller.RencanaPersalinan.Update)
	tenaga.DELETE("/rencana-persalinan/:id", controller.RencanaPersalinan.Delete)

	// ==================== RINGKASAN PELAYANAN PERSALINAN ====================
	tenaga.POST("/ringkasan-persalinan", controller.RingkasanPelayananPersalinan.Create)
	tenaga.GET("/ringkasan-persalinan/:id", controller.RingkasanPelayananPersalinan.GetByID)
	tenaga.GET("/ringkasan-persalinan", controller.RingkasanPelayananPersalinan.GetByKehamilanID)
	tenaga.PUT("/ringkasan-persalinan/:id", controller.RingkasanPelayananPersalinan.Update)
	tenaga.DELETE("/ringkasan-persalinan/:id", controller.RingkasanPelayananPersalinan.Delete)

	// ==================== RIWAYAT PROSES MELAHIRKAN ====================
	tenaga.POST("/riwayat-proses-melahirkan", controller.RiwayatProsesMelahirkan.Create)
	tenaga.GET("/riwayat-proses-melahirkan/:id", controller.RiwayatProsesMelahirkan.GetByID)
	tenaga.GET("/riwayat-proses-melahirkan", controller.RiwayatProsesMelahirkan.GetByKehamilanID)
	tenaga.PUT("/riwayat-proses-melahirkan/:id", controller.RiwayatProsesMelahirkan.Update)
	tenaga.DELETE("/riwayat-proses-melahirkan/:id", controller.RiwayatProsesMelahirkan.Delete)

	// ==================== KETERANGAN LAHIR ====================
	tenaga.POST("/keterangan-lahir", controller.KeteranganLahir.Create)
	tenaga.GET("/keterangan-lahir/:id", controller.KeteranganLahir.GetByID)
	tenaga.GET("/keterangan-lahir", controller.KeteranganLahir.GetByIbuID) // menggunakan ibu_id relasi
	tenaga.PUT("/keterangan-lahir/:id", controller.KeteranganLahir.Update)
	tenaga.DELETE("/keterangan-lahir/:id", controller.KeteranganLahir.Delete)

	// ==================== PELAYANAN IBU NIFAS ====================
	tenaga.POST("/pelayanan-ibu-nifas", controller.PelayananIbuNifas.Create)
	tenaga.GET("/pelayanan-ibu-nifas/:id", controller.PelayananIbuNifas.GetByID)
	tenaga.GET("/pelayanan-ibu-nifas", controller.PelayananIbuNifas.GetByKehamilanID)
	tenaga.PUT("/pelayanan-ibu-nifas/:id", controller.PelayananIbuNifas.Update)
	tenaga.DELETE("/pelayanan-ibu-nifas/:id", controller.PelayananIbuNifas.Delete)

	// ==================== SKRINING PRE-EKLAMPSIA ====================
	tenaga.POST("/skrining-preeklampsia", controller.SkriningPreeklampsia.Create)
	tenaga.GET("/skrining-preeklampsia/:id", controller.SkriningPreeklampsia.GetByID)
	tenaga.GET("/skrining-preeklampsia", controller.SkriningPreeklampsia.GetByKehamilanID)
	tenaga.PUT("/skrining-preeklampsia/:id", controller.SkriningPreeklampsia.Update)
	tenaga.DELETE("/skrining-preeklampsia/:id", controller.SkriningPreeklampsia.Delete)

	// ==================== SKRINING DIABETES MELITUS GESTASIONAL ====================
	tenaga.POST("/skrining-dm-gestasional", controller.SkriningDMGestasional.Create)
	tenaga.GET("/skrining-dm-gestasional/:id", controller.SkriningDMGestasional.GetByID)
	tenaga.GET("/skrining-dm-gestasional", controller.SkriningDMGestasional.GetByKehamilanID)
	tenaga.PUT("/skrining-dm-gestasional/:id", controller.SkriningDMGestasional.Update)
	tenaga.DELETE("/skrining-dm-gestasional/:id", controller.SkriningDMGestasional.Delete)

	// ==================== RUJUKAN ====================
	tenaga.POST("/rujukan", controller.Rujukan.Create)
	tenaga.GET("/rujukan/:id", controller.Rujukan.GetByID)
	tenaga.GET("/rujukan", controller.Rujukan.GetByKehamilanID)
	tenaga.PUT("/rujukan/:id", controller.Rujukan.Update)
	tenaga.DELETE("/rujukan/:id", controller.Rujukan.Delete)

	// ==================== PEMERIKSAAN DOKTER TRIMESTER 3 ====================
	tenaga.POST("/pemeriksaan-dokter-t3", controller.PemeriksaanDokterTrimester3.Create)
	tenaga.GET("/pemeriksaan-dokter-t3/:id", controller.PemeriksaanDokterTrimester3.GetByID)
	tenaga.GET("/pemeriksaan-dokter-t3", controller.PemeriksaanDokterTrimester3.GetByKehamilanID)
	tenaga.PUT("/pemeriksaan-dokter-t3/:id", controller.PemeriksaanDokterTrimester3.Update)
	tenaga.DELETE("/pemeriksaan-dokter-t3/:id", controller.PemeriksaanDokterTrimester3.Delete)

	// ==================== PEMERIKSAAN LANJUTAN TRIMESTER 3 ====================
	tenaga.POST("/pemeriksaan-lanjutan-t3", controller.PemeriksaanLanjutanTrimester3.Create)
	tenaga.GET("/pemeriksaan-lanjutan-t3/:id", controller.PemeriksaanLanjutanTrimester3.GetByID)
	tenaga.GET("/pemeriksaan-lanjutan-t3", controller.PemeriksaanLanjutanTrimester3.GetByKehamilanID)
	tenaga.PUT("/pemeriksaan-lanjutan-t3/:id", controller.PemeriksaanLanjutanTrimester3.Update)
	tenaga.DELETE("/pemeriksaan-lanjutan-t3/:id", controller.PemeriksaanLanjutanTrimester3.Delete)

	// ==================== KATEGORI TANDA BAHAYA ====================
	tenaga.GET("/kategori-tanda-bahaya", controller.KategoriTandaBahaya.GetAll)
	tenaga.POST("/kategori-tanda-bahaya", controller.KategoriTandaBahaya.Create)
	tenaga.GET("/kategori-tanda-bahaya/:id", controller.KategoriTandaBahaya.Detail)
	tenaga.GET("/kategori-tanda-bahaya/filter", controller.KategoriTandaBahaya.GetByTipeAndKategoriUsia)
	tenaga.PUT("/kategori-tanda-bahaya/:id", controller.KategoriTandaBahaya.Update)
	tenaga.DELETE("/kategori-tanda-bahaya/:id", controller.KategoriTandaBahaya.Delete)

	// ==================== SKRINING PEMANTAUAN TANDA BAHAYA ====================
	tenaga.GET("/skrining-pemantauan", controller.SkriningPemantauan.GetAll)
	tenaga.POST("/skrining-pemantauan", controller.SkriningPemantauan.Create)
	tenaga.GET("/skrining-pemantauan/:id", controller.SkriningPemantauan.Detail)
	tenaga.GET("/skrining-pemantauan/anak/:anak_id", controller.SkriningPemantauan.GetByAnakID)
	tenaga.PUT("/skrining-pemantauan/:id", controller.SkriningPemantauan.Update)
	tenaga.DELETE("/skrining-pemantauan/:id", controller.SkriningPemantauan.Delete)

	// ==================== KARTU KELUARGA ====================
	// tenaga.GET("/kartu-keluarga", controller.KartuKeluarga.GetAll)
	// tenaga.POST("/kartu-keluarga", controller.KartuKeluarga.Create)
	// tenaga.GET("/kartu-keluarga/:id", controller.KartuKeluarga.GetByID)
	// tenaga.GET("/kartu-keluarga/no-kk/:no_kk", controller.KartuKeluarga.GetByNoKartuKeluarga)
	// tenaga.PUT("/kartu-keluarga/:id", controller.KartuKeluarga.Update)
	// tenaga.DELETE("/kartu-keluarga/:id", controller.KartuKeluarga.Delete)

	// ==================== KEPENDUDUKAN ====================
	// tenaga.GET("/kependudukan", controller.Kependudukan.GetAll)
	// tenaga.POST("/kependudukan", controller.Kependudukan.Create)
	// tenaga.GET("/kependudukan/:id", controller.Kependudukan.GetByID)
	// // tenaga.GET("/kep// endudukan/kartu-keluarga/:kartu_keluarga_id", controller.Kependudukan.GetByKartuKeluargaID)
	// tenaga.PUT("/kependudukan/:id", controller.Kependudukan.Update)
	// tenaga.DELETE("/kependudukan/:id", controller.Kependudukan.Delete)

	//jenis pelayanan neonatus
	tenaga.GET("/jenis-pelayanan", controller.JenisPelayanan.GetJenisPelayanan)

	// ========================================= MODUL IBU - KIA- Kel-3 =========================================

	ibuk := e.Group("/modul-ibu")
	ibuk.Use(middlewares.JWTAuth(controller.JWTSecret()))
	ibuk.Use(middlewares.Ibu())

	// Data Ibu
	ibuk.GET("/kehamilan-aktif", controller.Kehamilan.GetAktifForOrangtua)

	// Evaluasi Kehamilan Ibu
	ibuk.GET("/evaluasi-kesehatan-ibu/me", controller.EvaluasiKesehatanIbu.GetMine)
	ibuk.GET("/evaluasi-kesehatan-ibu/:id", controller.EvaluasiKesehatanIbu.GetByIDForOrangtua)

	// Pemeriksaan Kehamilan
	ibuk.GET("/pemeriksaan-kehamilan/me", controller.PemeriksaanKehamilan.GetMine)
	ibuk.GET("/pemeriksaan-kehamilan/:id", controller.PemeriksaanKehamilan.GetByIDForOrangtua)

	// Skrining Preeklampsia
	ibuk.GET("/skrining-preeklampsia/me", controller.SkriningPreeklampsia.GetMine)
	ibuk.GET("/skrining-preeklampsia/:id", controller.SkriningPreeklampsia.GetByIDForOrangtua)

	ibuk.GET("/rujukan/:id", controller.Rujukan.GetByIDForOrangtua)

	// Pemeriksaan Dokter Trimester 1 & 3
	// ibuk.GET("/pemeriksaan-dokter-trimester-1/me", controller.PemeriksaanDokterTrimester1.GetMine)
	// ibuk.GET("/pemeriksaan-dokter-trimester-3/me", controller.PemeriksaanDokterTrimester3.GetMine)

	ibuk.GET("/pemeriksaan-dokter-trimester-1/me", controller.PemeriksaanDokterTrimester1.GetMine)
	ibuk.GET("/pemeriksaan-dokter-trimester-1/all", controller.PemeriksaanDokterTrimester1.GetAllMine) // BARU: list semua kunjungan
	ibuk.GET("/pemeriksaan-dokter-trimester-3/me", controller.PemeriksaanDokterTrimester3.GetMine)
	ibuk.GET("/pemeriksaan-dokter-trimester-3/all", controller.PemeriksaanDokterTrimester3.GetAllMine) // BARU: list semua kunjungan
	
	ibuk.GET("/riwayat-proses-melahirkan/me", controller.RiwayatProsesMelahirkan.GetMine)

	// Log TTD MMS
	ibuk.GET("/log-ttd-mms/me", controller.LogTTDMMS.GetMine)
	ibuk.POST("/log-ttd-mms", controller.LogTTDMMS.SaveMine)

	// Pemantauan Ibu Hamil
	ibuk.GET("/pemantauan-ibu-hamil/me", controller.PemantauanIbuHamil.GetMine)
	ibuk.POST("/pemantauan-ibu-hamil", controller.PemantauanIbuHamil.SaveMine)

	// Persiapan Melahirkan
	ibuk.GET("/persiapan-melahirkan/me", controller.PersiapanMelahirkan.GetMine)
	ibuk.POST("/persiapan-melahirkan", controller.PersiapanMelahirkan.SaveMine)

	// Proses Melahirkan
	ibuk.GET("/proses-melahirkan/me", controller.ProsesMelahirkan.GetMine)
	ibuk.POST("/proses-melahirkan", controller.ProsesMelahirkan.SaveMine)

	// Absensi Kelas Ibu Hamil
	ibuk.GET("/absensi-kelas-ibu-hamil/me", controller.AbsensiKelasIbuHamil.GetMine)
	ibuk.POST("/absensi-kelas-ibu-hamil", controller.AbsensiKelasIbuHamil.SaveMine)

	// Checklist Pemantauan Ibu Nifas
	ibuk.GET("/checklist-pemantauan-ibu-nifas/me", controller.ChecklistPemantauanIbuNifas.GetMine)
	ibuk.POST("/checklist-pemantauan-ibu-nifas", controller.ChecklistPemantauanIbuNifas.SaveMine)
	ibuk.GET("/checklist-pemantauan-ibu-nifas/filled-days", controller.ChecklistPemantauanIbuNifas.GetFilledDays)

	// Catatan Pelayanan Ibu
	ibuk.GET("/catatan-pelayanan-t1", controller.CatatanPelayananTrimester1.GetByKehamilanID)
	ibuk.GET("/catatan-pelayanan-t2", controller.CatatanPelayananTrimester2.GetByKehamilanID)
	ibuk.GET("/catatan-pelayanan-t3", controller.CatatanPelayananTrimester3.GetByKehamilanID)
	ibuk.GET("/rujukan", controller.Rujukan.GetByKehamilanID)

	// Grafik Evaluasi Kehamilan
	ibuk.GET("/grafik-evaluasi-kehamilan/grafik", controller.GrafikEvaluasiKehamilan.GetGrafikForOrangtua)
	ibuk.GET("/grafik-evaluasi-kehamilan/me", controller.GrafikEvaluasiKehamilan.GetMine)
	// Baru
	ibuk.GET("/grafik-evaluasi-kehamilan/v2", controller.GrafikEvaluasiKehamilan.GetGrafikOnTheFlyForOrangtua)
	ibuk.GET("/grafik-evaluasi-kehamilan/:id", controller.GrafikEvaluasiKehamilan.GetByIDForOrangtua)
	ibuk.GET("/grafik-peningkatan-bb/v2", controller.GrafikPeningkatanBB.GetGrafikBBForOrangtua)
	
	// Keterangan Lahir
	ibuk.GET("/keterangan-lahir/me", controller.KeteranganLahir.GetMine)
	
	// Ringkasan Persalinan
	ibuk.GET("/ringkasan-persalinan/me",controller.RingkasanPelayananPersalinan.GetMine,)
	// Pelayanan Ibu Nifas
	ibuk.GET("/pelayanan-ibu-nifas/me",controller.PelayananIbuNifas.GetMine,)
	ibuk.GET("/catatan-pelayanan-nifas/me",controller.CatatanPelayananNifas.GetMine,)
	
	ibu := e.Group("/ibu")
	ibu.Use(middlewares.JWTAuth(controller.JWTSecret()))
	ibu.Use(middlewares.Ibu())
	ibu.GET("/anak", controller.Ibu.GetAnakSaya)

	ibu.GET("/lembar-pemantauan/rentang-usia", controller.LembarPemantauan.GetRentangUsiaForIbu)
	ibu.GET("/lembar-pemantauan/kategori-tanda-sakit", controller.LembarPemantauan.GetKategoriByRentangUsiaForIbu)
	ibu.POST("/lembar-pemantauan", controller.LembarPemantauan.CreateForIbu)
	ibu.GET("/lembar-pemantauan", controller.LembarPemantauan.GetByAnakIDForIbu)

	ibu.GET("/warna-tinja", controller.WarnaTinja.GetByAnakIDForIbu)
	ibu.POST("/warna-tinja", controller.WarnaTinja.SaveForIbu)

	ibu.GET("/pemeriksaan-gigi", controller.PemeriksaanGigi.GetByAnakIDForIbu)
	ibu.GET("/pengukuran-lila", controller.PengukuranLilA.GetByAnakIDForIbu)
	ibu.GET("/pengukuran-lila/:anak_id", controller.PengukuranLilA.GetByAnakIDForIbu)

	// ==================== PERAWATAN/MILESTONE (IBU) ====================
	ibu.GET("/kategori-capaian", controller.GetAllKategoriCapaian)
	ibu.GET("/kategori-capaian/rentang-usia/:rentang_usia", controller.GetKategoriCapaianByRentangUsia)
	ibu.GET("/perawatan/:id", controller.GetPerawatanByID)
	ibu.GET("/perawatan/anak/:anak_id", controller.GetPerawatanByAnakID)
	ibu.GET("/perawatan/anak/:anak_id/rentang-usia/:rentang_usia", controller.GetPerawatanByAnakIDAndRentangUsia)
	ibu.POST("/perawatan", controller.CreatePerawatan)
	ibu.PUT("/perawatan/:id", controller.UpdatePerawatan)
	ibu.DELETE("/perawatan/:id", controller.DeletePerawatan)
	// Catatan: Ibu tidak memiliki akses UPDATE/DELETE/VERIFY untuk menjaga integritas rekam medis

	// ==================== KELUHAN ANAK ====================
	ibu.GET("/keluhan-anak", controller.KeluhanAnak.GetByAnakIDForIbu)
	ibu.GET("/keluhan-anak/:id", controller.KeluhanAnak.GetByIDForIbu)
	tenaga.GET("/keluhan-anak/:anak_id", controller.KeluhanAnak.GetByAnakID)
	tenaga.GET("/keluhan-anak/detail/:id", controller.KeluhanAnak.GetByID)
	tenaga.POST("/keluhan-anak", controller.KeluhanAnak.Create)
	tenaga.PUT("/keluhan-anak/:id", controller.KeluhanAnak.Update)
	tenaga.DELETE("/keluhan-anak/:id", controller.KeluhanAnak.Delete)

	// ==================== EDUKASI MPASI (IBU) ====================
	ibu.GET("/edukasi-mpasi/materi/:bulan", controller.EdukasiMPASI.GetMateriByBulan)
	ibu.GET("/edukasi-mpasi/porsi-jadwal/:bulan", controller.EdukasiMPASI.GetPorsiJadwalByBulan)
	ibu.GET("/edukasi-mpasi/resep/:bulan", controller.EdukasiMPASI.GetResepByBulan)

	// ==================== EDUKASI MPASI (NAKES) ====================

	// Materi
	tenaga.GET("/edukasi-mpasi/materi", controller.EdukasiMPASI.GetMateriAll)
	tenaga.POST("/edukasi-mpasi/materi", controller.EdukasiMPASI.CreateMateri)
	tenaga.GET("/edukasi-mpasi/materi/:id", controller.EdukasiMPASI.GetMateriByID)
	tenaga.PUT("/edukasi-mpasi/materi/:id", controller.EdukasiMPASI.UpdateMateri)
	tenaga.DELETE("/edukasi-mpasi/materi/:id", controller.EdukasiMPASI.DeleteMateri)

	// Aturan Porsi
	tenaga.GET("/edukasi-mpasi/aturan-porsi", controller.EdukasiMPASI.GetAturanPorsiAll)
	tenaga.POST("/edukasi-mpasi/aturan-porsi", controller.EdukasiMPASI.CreateAturanPorsi)
	tenaga.GET("/edukasi-mpasi/aturan-porsi/:id", controller.EdukasiMPASI.GetAturanPorsiByID)
	tenaga.PUT("/edukasi-mpasi/aturan-porsi/:id", controller.EdukasiMPASI.UpdateAturanPorsi)
	tenaga.DELETE("/edukasi-mpasi/aturan-porsi/:id", controller.EdukasiMPASI.DeleteAturanPorsi)

	// Jadwal
	tenaga.GET("/edukasi-mpasi/jadwal", controller.EdukasiMPASI.GetJadwalAll)
	tenaga.POST("/edukasi-mpasi/jadwal", controller.EdukasiMPASI.CreateJadwal)
	tenaga.GET("/edukasi-mpasi/jadwal/:id", controller.EdukasiMPASI.GetJadwalByID)
	tenaga.PUT("/edukasi-mpasi/jadwal/:id", controller.EdukasiMPASI.UpdateJadwal)
	tenaga.DELETE("/edukasi-mpasi/jadwal/:id", controller.EdukasiMPASI.DeleteJadwal)

	// Resep
	tenaga.GET("/edukasi-mpasi/resep", controller.EdukasiMPASI.GetResepAll)
	tenaga.POST("/edukasi-mpasi/resep", controller.EdukasiMPASI.CreateResep)
	tenaga.GET("/edukasi-mpasi/resep/:id", controller.EdukasiMPASI.GetResepByID)
	tenaga.PUT("/edukasi-mpasi/resep/:id", controller.EdukasiMPASI.UpdateResep)
	tenaga.DELETE("/edukasi-mpasi/resep/:id", controller.EdukasiMPASI.DeleteResep)

}

package repositories

import (
	"monitoring-service/pkg/config"

	"gorm.io/gorm"
)

type Main struct {
	postgres *gorm.DB
	config   *config.Config

	// Existing
	Anak                        *AnakRepository
	PelayananKesehatanAnak      PelayananKesehatanAnakRepository
	Neonatus                    PelayananNeonatusRepository
	KunjunganGizi               KunjunganGiziRepository
	KunjunganVitamin            KunjunganVitaminRepository
	KunjunganImunisasi          KunjunganImunisasiRepository
	PemeriksaanGigi             PemeriksaanGigiRepository
	PemantauanPertumbuhan       PemantauanPertumbuhanRepository
	PengukuranLilA              PengukuranLilaRepository
	CatatanPelayanan            CatatanPelayananRepository
	ChecklistPemantauanIbuNifas ChecklistPemantauanIbuNifasRepository
	InformasiUmum               *InformasiUmumRepository
	EdukasiMPASI                EdukasiMPASIRepository

	// New repositories (semua pointer, mengikuti pola Anak)
	User                          *UserRepository
	Role                          *RoleRepository
	KartuKeluarga                 *KartuKeluargaRepository
	Kependudukan                  *KependudukanRepository
	Bidan                         *BidanRepository
	Kader                         *KaderRepository
	Ibu                           *IbuRepository
	Kehamilan                     *KehamilanRepository
	PemeriksaanKehamilan          *PemeriksaanKehamilanRepository
	EvaluasiKesehatanIbu          *EvaluasiKesehatanIbuRepository
	RiwayatKehamilanLalu          *RiwayatKehamilanLaluRepository
	PemeriksaanDokterTrimester1   *PemeriksaanDokterTrimester1Repository
	PemeriksaanLaboratoriumJiwa   *PemeriksaanLaboratoriumJiwaRepository
	CatatanPelayananTrimester1    *CatatanPelayananTrimester1Repository
	SkriningPreeklampsia          *SkriningPreeklampsiaRepository
	SkriningDMGestasional         *SkriningDMGestasionalRepository
	SkriningPemantauan            *SkriningPemantauanRepository
	KategoriTandaBahaya           *KategoriTandaBahayaRepository
	CatatanPelayananTrimester2    *CatatanPelayananTrimester2Repository
	PemeriksaanDokterTrimester3   *PemeriksaanDokterTrimester3Repository
	PemeriksaanLanjutanTrimester3 *PemeriksaanLanjutanTrimester3Repository
	CatatanPelayananTrimester3    *CatatanPelayananTrimester3Repository
	GrafikEvaluasiKehamilan       *GrafikEvaluasiKehamilanRepository
	GrafikPeningkatanBB           *GrafikPeningkatanBBRepository
	PenjelasanHasilGrafik         *PenjelasanHasilGrafikRepository
	RencanaPersalinan             *RencanaPersalinanRepository
	RingkasanPelayananPersalinan  *RingkasanPelayananPersalinanRepository
	KeteranganLahir               *KeteranganLahirRepository // <-- TAMBAHKAN INI
	LembarPemantauan              LembarPemantauanRepository
	RiwayatProsesMelahirkan       *RiwayatProsesMelahirkanRepository
	PelayananIbuNifas             *PelayananIbuNifasRepository
	CatatanPelayananNifas         *CatatanPelayananNifasRepository
	Rujukan                       *RujukanRepository
	JenisPelayanan                JenisPelayananRepository
	Perawatan                     PerawatanRepository
	KeluhanAnak                   KeluhanAnakRepository
	// MODUL IBU
	LogTTDMMS            *LogTTDMMSRepository
	PemantauanIbuHamil   *PemantauanIbuHamilRepository
	PersiapanMelahirkan  *PersiapanMelahirkanRepository
	ProsesMelahirkan     *ProsesMelahirkanRepository
	AbsensiKelasIbuHamil *AbsensiKelasIbuHamilRepository
	WarnaTinja           WarnaTinjaRepository
	EdukasiIMD             EdukasiIMDRepository
	EdukasiKesehatanMental EdukasiKesehatanMentalRepository
	EdukasiMenyusuiASI     EdukasiMenyusuiASIRepository
	EdukasiNifas           EdukasiNifasRepository
	EdukasiTandaMelahirkan EdukasiTandaMelahirkanRepository
	EdukasiTrimester 	   EdukasiTrimesterRepository
}

type Options struct {
	Postgres *gorm.DB
	Config   *config.Config
}

func Init(opts Options) *Main {
	m := &Main{
		postgres: opts.Postgres,
		config:   opts.Config,
	}

	// Existing
	m.Anak = NewAnakRepository(opts.Postgres)
	m.PelayananKesehatanAnak = NewPelayananKesehatanAnakRepository(opts.Postgres)

	// New repositories
	m.User = NewUserRepository(opts.Postgres)
	m.Ibu = NewIbuRepository(opts.Postgres)
	m.ChecklistPemantauanIbuNifas = NewChecklistPemantauanIbuNifasRepository(opts.Postgres)
	m.Role = NewRoleRepository(opts.Postgres)
	m.KartuKeluarga = NewKartuKeluargaRepository(opts.Postgres)
	m.Kependudukan = NewKependudukanRepository(opts.Postgres)
	m.Bidan = NewBidanRepository(opts.Postgres)
	m.Kader = NewKaderRepository(opts.Postgres)
	m.Kehamilan = NewKehamilanRepository(opts.Postgres)
	m.PemeriksaanKehamilan = NewPemeriksaanKehamilanRepository(opts.Postgres)
	m.EvaluasiKesehatanIbu = NewEvaluasiKesehatanIbuRepository(opts.Postgres)
	m.RiwayatKehamilanLalu = NewRiwayatKehamilanLaluRepository(opts.Postgres)
	m.PemeriksaanDokterTrimester1 = NewPemeriksaanDokterTrimester1Repository(opts.Postgres)
	m.PemeriksaanLaboratoriumJiwa = NewPemeriksaanLaboratoriumJiwaRepository(opts.Postgres)
	m.CatatanPelayananTrimester1 = NewCatatanPelayananTrimester1Repository(opts.Postgres)
	m.SkriningPreeklampsia = NewSkriningPreeklampsiaRepository(opts.Postgres)
	m.SkriningDMGestasional = NewSkriningDMGestasionalRepository(opts.Postgres)
	m.SkriningPemantauan = NewSkriningPemantauanRepository(opts.Postgres)
	m.KategoriTandaBahaya = NewKategoriTandaBahayaRepository(opts.Postgres)
	m.CatatanPelayananTrimester2 = NewCatatanPelayananTrimester2Repository(opts.Postgres)
	m.PemeriksaanDokterTrimester3 = NewPemeriksaanDokterTrimester3Repository(opts.Postgres)
	m.PemeriksaanLanjutanTrimester3 = NewPemeriksaanLanjutanTrimester3Repository(opts.Postgres)
	m.CatatanPelayananTrimester3 = NewCatatanPelayananTrimester3Repository(opts.Postgres)
	m.GrafikEvaluasiKehamilan = NewGrafikEvaluasiKehamilanRepository(opts.Postgres)
	m.GrafikPeningkatanBB = NewGrafikPeningkatanBBRepository(opts.Postgres)
	m.PenjelasanHasilGrafik = NewPenjelasanHasilGrafikRepository(opts.Postgres)
	m.RencanaPersalinan = NewRencanaPersalinanRepository(opts.Postgres)
	m.RingkasanPelayananPersalinan = NewRingkasanPelayananPersalinanRepository(opts.Postgres)
	m.KeteranganLahir = NewKeteranganLahirRepository(opts.Postgres) // <-- TAMBAHKAN INI
	m.LembarPemantauan = NewLembarPemantauanRepository(opts.Postgres)
	m.RiwayatProsesMelahirkan = NewRiwayatProsesMelahirkanRepository(opts.Postgres)
	m.PelayananIbuNifas = NewPelayananIbuNifasRepository(opts.Postgres)
	m.CatatanPelayananNifas = NewCatatanPelayananNifasRepository(opts.Postgres)
	m.Rujukan = NewRujukanRepository(opts.Postgres)

	m.Neonatus = NewPelayananNeonatusRepository(opts.Postgres)
	m.KunjunganGizi = NewKunjunganGiziRepository(opts.Postgres)
	m.KunjunganVitamin = NewKunjunganVitaminRepository(opts.Postgres)
	m.KunjunganImunisasi = NewKunjunganImunisasiRepository(opts.Postgres)
	m.PemeriksaanGigi = NewPemeriksaanGigiRepository(opts.Postgres)
	m.PemantauanPertumbuhan = NewPemantauanPertumbuhanRepository(opts.Postgres)
	m.PengukuranLilA = NewPengukuranLilaRepository(opts.Postgres)
	m.CatatanPelayanan = NewCatatanPelayananRepository(opts.Postgres)
	m.InformasiUmum = NewInformasiUmumRepository(opts.Postgres)
	m.EdukasiMPASI = NewEdukasiMPASIRepository(opts.Postgres)
	m.JenisPelayanan = NewJenisPelayananRepository(opts.Postgres)
	m.Perawatan = NewPerawatanRepository(opts.Postgres)
	m.KeluhanAnak = NewKeluhanAnakRepository(opts.Postgres)

	// MODUL IBU
	m.LogTTDMMS = NewLogTTDMMSRepository(opts.Postgres)
	m.PemantauanIbuHamil = NewPemantauanIbuHamilRepository(opts.Postgres)
	m.PersiapanMelahirkan = NewPersiapanMelahirkanRepository(opts.Postgres)
	m.ProsesMelahirkan = NewProsesMelahirkanRepository(opts.Postgres)
	m.AbsensiKelasIbuHamil = NewAbsensiKelasIbuHamilRepository(opts.Postgres)
	m.WarnaTinja = NewWarnaTinjaRepository(opts.Postgres)

	m.EdukasiIMD = NewEdukasiIMDRepository(opts.Postgres)
	m.EdukasiKesehatanMental = NewEdukasiKesehatanMentalRepository(opts.Postgres)
	m.EdukasiMenyusuiASI = NewEdukasiMenyusuiASIRepository(opts.Postgres)
	m.EdukasiNifas = NewEdukasiNifasRepository(opts.Postgres)
	m.EdukasiTandaMelahirkan = NewEdukasiTandaMelahirkanRepository(opts.Postgres)
	m.EdukasiTrimester = NewEdukasiTrimesterRepository(opts.Postgres)
	return m
}

// usecases/profil_ibu_usecase.go
// Tambahkan file ini di folder: app/usecases/
package usecases

import (
	"errors"
	"monitoring-service/app/models"
	"monitoring-service/app/repositories"
)

// ─── Response DTO ────────────────────────────────────────────────────────────

type ProfilIbuResponse struct {
	// Data pengguna (dari tabel pengguna)
	UserID      int32  `json:"user_id"`
	Email       string `json:"email"`
	NomorTelepon string `json:"nomor_telepon"`

	// Data kependudukan (dari tabel penduduk)
	NIK                string `json:"nik"`
	NamaLengkap        string `json:"nama_lengkap"`
	TempatLahir        string `json:"tempat_lahir"`
	TanggalLahir       string `json:"tanggal_lahir"`
	GolonganDarah      string `json:"golongan_darah"`
	Agama              string `json:"agama"`
	Pendidikan         string `json:"pendidikan_terakhir"`
	Pekerjaan          string `json:"pekerjaan"`
	StatusPerkawinan   string `json:"status_perkawinan"`
	Dusun              string `json:"dusun"`
	Desa               string `json:"desa"`
	Kecamatan          string `json:"kecamatan"`
	NomorTeleponPenduduk string `json:"nomor_telepon_penduduk,omitempty"`

	// Data ibu
	IbuID          int32  `json:"ibu_id"`
	StatusKehamilan string `json:"status_kehamilan"`

	// Riwayat kehamilan (singkat, hanya yang relevan)
	RiwayatKehamilan []RiwayatKehamilanSingkat `json:"riwayat_kehamilan"`
}

type RiwayatKehamilanSingkat struct {
	ID                 int32  `json:"id"`
	Gravida            int32  `json:"gravida"`
	Paritas            int32  `json:"paritas"`
	Abortus            int32  `json:"abortus"`
	HPHT               string `json:"hpht"`
	TaksiranPersalinan string `json:"taksiran_persalinan"`
	StatusKehamilan    string `json:"status_kehamilan"`
	BBawal             float64 `json:"bb_awal"`
	TB                 float64 `json:"tb"`
	IMTAwal            float64 `json:"imt_awal"`
}

// ─── Interface & Implementasi ─────────────────────────────────────────────────

type ProfilIbuUsecase interface {
	GetProfilSaya(userID int32) (*ProfilIbuResponse, error)
}

type profilIbuUsecase struct {
	userRepo      *repositories.UserRepository
	ibuRepo       *repositories.IbuRepository
	kehamilanRepo *repositories.KehamilanRepository
}

func NewProfilIbuUsecase(
	userRepo *repositories.UserRepository,
	ibuRepo *repositories.IbuRepository,
	kehamilanRepo *repositories.KehamilanRepository,
) ProfilIbuUsecase {
	return &profilIbuUsecase{
		userRepo:      userRepo,
		ibuRepo:       ibuRepo,
		kehamilanRepo: kehamilanRepo,
	}
}

func (u *profilIbuUsecase) GetProfilSaya(userID int32) (*ProfilIbuResponse, error) {
	// 1. Ambil data user beserta relasi penduduk
	user, err := u.userRepo.FindByIDWithPenduduk(userID)
	if err != nil {
		return nil, errors.New("data pengguna tidak ditemukan")
	}

	if user.PendudukID == nil {
		return nil, errors.New("akun belum terhubung dengan data kependudukan")
	}

	// 2. Ambil data ibu berdasarkan penduduk_id
	ibu, err := u.ibuRepo.FindByPendudukID(int32(*user.PendudukID))
	if err != nil {
		return nil, errors.New("data ibu tidak ditemukan")
	}

	// 3. Ambil riwayat kehamilan
	kehamilanList, err := u.kehamilanRepo.FindByIbuID(ibu.IDIbu)
	if err != nil {
		kehamilanList = []models.Kehamilan{} // tidak error kalau belum ada
	}

	// 4. Susun response
	resp := &ProfilIbuResponse{
		UserID:       user.ID,
		Email:        user.Email,
		NomorTelepon: user.PhoneNumber,
		IbuID:        ibu.IDIbu,
		StatusKehamilan: ibu.StatusKehamilan,
	}

	if ibu.Kependudukan != nil {
		k := ibu.Kependudukan
		resp.NIK = k.NIK
		resp.NamaLengkap = k.NamaLengkap
		resp.TempatLahir = k.TempatLahir
		if !k.TanggalLahir.IsZero() {
			resp.TanggalLahir = k.TanggalLahir.Format("2006-01-02")
		}
		resp.GolonganDarah = k.GolonganDarah
		resp.Agama = k.Agama
		resp.Pendidikan = k.PendidikanTerakhir
		resp.Pekerjaan = k.Pekerjaan
		resp.StatusPerkawinan = k.StatusPerkawinan
		resp.Dusun = k.Dusun
		resp.Desa = k.Desa
		resp.Kecamatan = k.Kecamatan
		resp.NomorTeleponPenduduk = k.NomorTelepon
	}

	riwayat := make([]RiwayatKehamilanSingkat, 0, len(kehamilanList))
	for _, kh := range kehamilanList {
		item := RiwayatKehamilanSingkat{
			ID:              kh.ID,
			Gravida:         kh.Gravida,
			Paritas:         kh.Paritas,
			Abortus:         kh.Abortus,
			StatusKehamilan: kh.StatusKehamilan,
			BBawal:          kh.BB_Awal,
			TB:              kh.TB,
			IMTAwal:         kh.IMT_Awal,
		}
		if !kh.HPHT.IsZero() {
			item.HPHT = kh.HPHT.Format("2006-01-02")
		}
		if !kh.TaksiranPersalinan.IsZero() {
			item.TaksiranPersalinan = kh.TaksiranPersalinan.Format("2006-01-02")
		}
		riwayat = append(riwayat, item)
	}
	resp.RiwayatKehamilan = riwayat

	return resp, nil
}
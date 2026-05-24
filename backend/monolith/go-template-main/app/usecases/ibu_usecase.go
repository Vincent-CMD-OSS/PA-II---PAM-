package usecases

import (
	"errors"
	"fmt"
	"monitoring-service/app/models"
	"monitoring-service/app/repositories"
	"time"
)

type IbuUsecase interface {
	Create(ibu *models.Ibu) error
	GetByID(id int32) (*models.Ibu, error)
	GetAll() ([]models.Ibu, error)
	GetAnakSaya(userID int32) ([]models.AnakResponse, error)
	Update(ibu *models.Ibu) error
	Delete(id int32) error
}

type ibuUsecase struct {
	repo *repositories.IbuRepository
}

func NewIbuUsecase(repo *repositories.IbuRepository) IbuUsecase {
	return &ibuUsecase{repo: repo}
}

func (u *ibuUsecase) Create(ibu *models.Ibu) error {
	if ibu.IDKependudukan == 0 {
		return errors.New("id_kependudukan wajib diisi")
	}
	return u.repo.Create(ibu)
}

func (u *ibuUsecase) GetByID(id int32) (*models.Ibu, error) {
	return u.repo.FindByID(id)
}

func (u *ibuUsecase) GetAll() ([]models.Ibu, error) {
	return u.repo.FindAll()
}

func mapAnakToResponse(data models.Anak) models.AnakResponse {
	res := models.AnakResponse{
		ID:            data.ID,
		KehamilanID:   data.KehamilanID,
		PendudukID:    data.PendudukID,
		BeratLahirKg:  data.BeratLahirKg,
		TinggiLahirCm: data.TinggiLahirCm,
	}

	if data.Penduduk != nil {
		res.Nama = data.Penduduk.NamaLengkap
		res.TanggalLahir = data.Penduduk.TanggalLahir.Format("2006-01-02")
		res.JenisKelamin = data.Penduduk.JenisKelamin
		res.GolonganDarah = data.Penduduk.GolonganDarah

		now := time.Now()
		ageMonths := (now.Year()-data.Penduduk.TanggalLahir.Year())*12 + int(now.Month()-data.Penduduk.TanggalLahir.Month())
		if now.Day() < data.Penduduk.TanggalLahir.Day() {
			ageMonths--
		}
		if ageMonths < 0 {
			ageMonths = 0
		}
		res.UsiaBulan = ageMonths
		res.UsiaTeks = fmt.Sprintf("%d Tahun %d Bulan", ageMonths/12, ageMonths%12)
	}

	if data.Kehamilan != nil {
		res.Kehamilan = &models.KehamilanSimple{ID: data.Kehamilan.ID}
	}

	return res
}

func (u *ibuUsecase) GetAnakSaya(userID int32) ([]models.AnakResponse, error) {
	data, err := u.repo.FindAnakByUserID(userID)
	if err != nil {
		return nil, err
	}

	result := make([]models.AnakResponse, 0, len(data))
	for _, anak := range data {
		result = append(result, mapAnakToResponse(anak))
	}

	return result, nil
}

func (u *ibuUsecase) Update(ibu *models.Ibu) error {
	_, err := u.repo.FindByID(ibu.IDIbu)
	if err != nil {
		return errors.New("data ibu tidak ditemukan")
	}
	return u.repo.Update(ibu)
}

func (u *ibuUsecase) Delete(id int32) error {
	return u.repo.Delete(id)
}

package usecases

import (
	"errors"
	"monitoring-service/app/models"
	"monitoring-service/app/repositories"
	"time"
)

type PemeriksaanGigiUseCase interface {
	Create(req models.CreatePemeriksaanGigiRequest) error
	Update(id int32, req models.UpdatePemeriksaanGigiRequest) error
	GetByAnakID(anakID int32) ([]models.PeriksaGigi, error)
	GetByAnakIDForIbu(anakID int32, userID uint) ([]models.PeriksaGigi, error)
	GetByID(id int32) (*models.PeriksaGigi, error)
	GetAll() ([]models.PeriksaGigi, error)
	Delete(id int32) error
}

type pemeriksaangigiUseCase struct {
	repo repositories.PemeriksaanGigiRepository
}

func NewPemeriksaanGigiUseCase(repo repositories.PemeriksaanGigiRepository) PemeriksaanGigiUseCase {
	return &pemeriksaangigiUseCase{repo: repo}
}

func (u *pemeriksaangigiUseCase) Create(req models.CreatePemeriksaanGigiRequest) error {

	if req.AnakID == 0 {
		return errors.New("anak_id wajib diisi")
	}

	now := time.Now()

	pemeriksaan := models.PeriksaGigi{
		AnakID:    req.AnakID,
		Bulanke:   req.Bulanke,
		Tanggal:   req.Tanggal,
		Jumlahgigi: req.Jumlahgigi,
		GigiBerlubang: req.GigiBerlubang,
		StatusPlak: req.StatusPlak,
		ResikoGigiBerlubang: req.ResikoGigiBerlubang,
		CreatedAt: now,
		UpdatedAt: now,
	}

	return u.repo.Create(&pemeriksaan)
}
func (u *pemeriksaangigiUseCase) Update(id int32, req models.UpdatePemeriksaanGigiRequest) error {
	now := time.Now()
	return u.repo.Update(id, req, now)
}
func (u *pemeriksaangigiUseCase) GetByAnakID(anakID int32) ([]models.PeriksaGigi, error) {
	return u.repo.GetByAnakID(anakID)
}

func (u *pemeriksaangigiUseCase) GetByAnakIDForIbu(anakID int32, userID uint) ([]models.PeriksaGigi, error) {
	ok, err := u.repo.IsAnakMilikIbu(userID, anakID)
	if err != nil {
		return nil, err
	}
	if !ok {
		return nil, errors.New("akses ditolak: anak tidak ditemukan atau bukan milik anda")
	}
	return u.repo.GetByAnakID(anakID)
}

func (u *pemeriksaangigiUseCase) GetByID(id int32) (*models.PeriksaGigi, error) {
	return u.repo.GetByID(id)
}

func (u *pemeriksaangigiUseCase) GetAll() ([]models.PeriksaGigi, error) {
	return u.repo.GetAll()
}
func (u *pemeriksaangigiUseCase) Delete(id int32) error {
	return u.repo.Delete(id)
}

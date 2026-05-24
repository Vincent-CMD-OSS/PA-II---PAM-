package usecases

import (
	"errors"
	"monitoring-service/app/models"
	"monitoring-service/app/repositories"
)

type PemeriksaanKehamilanUsecase interface {
	Create(p *models.PemeriksaanKehamilan) error
	GetByID(id int32) (*models.PemeriksaanKehamilan, error)
	GetMine(userID int32) ([]models.PemeriksaanKehamilan, error) // MODUL IBU
	GetByIDForOrangtua(id int32, userID int32) (*models.PemeriksaanKehamilan, error) // MODUL IBU
	GetByKehamilanID(kehamilanID int32) ([]models.PemeriksaanKehamilan, error)
	Update(p *models.PemeriksaanKehamilan) error
	Delete(id int32) error
}

type pemeriksaanKehamilanUsecase struct {
	repo *repositories.PemeriksaanKehamilanRepository
}

func NewPemeriksaanKehamilanUsecase(repo *repositories.PemeriksaanKehamilanRepository) PemeriksaanKehamilanUsecase {
	return &pemeriksaanKehamilanUsecase{repo: repo}
}

func (u *pemeriksaanKehamilanUsecase) Create(p *models.PemeriksaanKehamilan) error {
	if p.KehamilanID == 0 {
		return errors.New("kehamilan_id wajib diisi")
	}
	return u.repo.Create(p)
}

func (u *pemeriksaanKehamilanUsecase) GetByID(id int32) (*models.PemeriksaanKehamilan, error) {
	return u.repo.FindByID(id)
}

func (u *pemeriksaanKehamilanUsecase) GetByKehamilanID(kehamilanID int32) ([]models.PemeriksaanKehamilan, error) {
	return u.repo.FindByKehamilanID(kehamilanID)
}

func (u *pemeriksaanKehamilanUsecase) Update(p *models.PemeriksaanKehamilan) error {
	_, err := u.repo.FindByID(p.IDPeriksa)
	if err != nil {
		return errors.New("data pemeriksaan kehamilan tidak ditemukan")
	}
	return u.repo.Update(p)
}

func (u *pemeriksaanKehamilanUsecase) Delete(id int32) error {
	return u.repo.Delete(id)
}

// MODUL IBU
func (u *pemeriksaanKehamilanUsecase) GetByIDForOrangtua(id int32, userID int32) (*models.PemeriksaanKehamilan, error) {
	allowed, err := u.repo.IsOwnedByUser(id, userID)
	if err != nil {
		return nil, err
	}

	if !allowed {
		return nil, errors.New("Anda tidak dapat mengakses data ini")
	}

	return u.repo.FindByID(id)
}

// MODUL IBU
func (u *pemeriksaanKehamilanUsecase) GetMine(userID int32) ([]models.PemeriksaanKehamilan, error) {
	return u.repo.FindMineByUserID(userID)
}
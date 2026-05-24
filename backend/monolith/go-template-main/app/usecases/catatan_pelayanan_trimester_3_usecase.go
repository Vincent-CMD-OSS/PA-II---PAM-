package usecases

import (
	"errors"
	"monitoring-service/app/models"
	"monitoring-service/app/repositories"
)

type CatatanPelayananTrimester3Usecase interface {
	Create(c *models.CatatanPelayananTrimester3) error
	GetByID(id int32) (*models.CatatanPelayananTrimester3, error)
	GetByKehamilanID(kehamilanID int32) ([]models.CatatanPelayananTrimester3, error)
	Update(c *models.CatatanPelayananTrimester3) error
	Delete(id int32) error
}

type catatanPelayananTrimester3Usecase struct {
	repo *repositories.CatatanPelayananTrimester3Repository
}

func NewCatatanPelayananTrimester3Usecase(repo *repositories.CatatanPelayananTrimester3Repository) CatatanPelayananTrimester3Usecase {
	return &catatanPelayananTrimester3Usecase{repo: repo}
}

func (u *catatanPelayananTrimester3Usecase) Create(c *models.CatatanPelayananTrimester3) error {
	if c.KehamilanID == 0 {
		return errors.New("kehamilan_id wajib diisi")
	}
	return u.repo.Create(c)
}

func (u *catatanPelayananTrimester3Usecase) GetByID(id int32) (*models.CatatanPelayananTrimester3, error) {
	return u.repo.FindByID(id)
}

func (u *catatanPelayananTrimester3Usecase) GetByKehamilanID(kehamilanID int32) ([]models.CatatanPelayananTrimester3, error) {
	return u.repo.FindByKehamilanID(kehamilanID)
}

func (u *catatanPelayananTrimester3Usecase) Update(c *models.CatatanPelayananTrimester3) error {
	_, err := u.repo.FindByID(c.IDCatatanT3)
	if err != nil {
		return errors.New("data catatan pelayanan trimester 3 tidak ditemukan")
	}
	return u.repo.Update(c)
}

func (u *catatanPelayananTrimester3Usecase) Delete(id int32) error {
	return u.repo.Delete(id)
}

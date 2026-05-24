package usecases

import (
	"errors"
	"monitoring-service/app/models"
	"monitoring-service/app/repositories"
)

type CatatanPelayananTrimester1Usecase interface {
	Create(c *models.CatatanPelayananTrimester1) error
	GetByID(id int32) (*models.CatatanPelayananTrimester1, error)
	GetByKehamilanID(kehamilanID int32) ([]models.CatatanPelayananTrimester1, error)
	Update(c *models.CatatanPelayananTrimester1) error
	Delete(id int32) error
}

type catatanPelayananTrimester1Usecase struct {
	repo *repositories.CatatanPelayananTrimester1Repository
}

func NewCatatanPelayananTrimester1Usecase(repo *repositories.CatatanPelayananTrimester1Repository) CatatanPelayananTrimester1Usecase {
	return &catatanPelayananTrimester1Usecase{repo: repo}
}

func (u *catatanPelayananTrimester1Usecase) Create(c *models.CatatanPelayananTrimester1) error {
	if c.KehamilanID == 0 {
		return errors.New("kehamilan_id wajib diisi")
	}
	return u.repo.Create(c)
}

func (u *catatanPelayananTrimester1Usecase) GetByID(id int32) (*models.CatatanPelayananTrimester1, error) {
	return u.repo.FindByID(id)
}

func (u *catatanPelayananTrimester1Usecase) GetByKehamilanID(kehamilanID int32) ([]models.CatatanPelayananTrimester1, error) {
	return u.repo.FindByKehamilanID(kehamilanID)
}

func (u *catatanPelayananTrimester1Usecase) Update(c *models.CatatanPelayananTrimester1) error {
	_, err := u.repo.FindByID(c.IDCatatan)
	if err != nil {
		return errors.New("data catatan pelayanan trimester 1 tidak ditemukan")
	}
	return u.repo.Update(c)
}

func (u *catatanPelayananTrimester1Usecase) Delete(id int32) error {
	return u.repo.Delete(id)
}

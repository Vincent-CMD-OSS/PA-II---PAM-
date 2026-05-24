package usecases

import (
	"errors"
	"monitoring-service/app/models"
	"monitoring-service/app/repositories"
	"time"
)

type ImunisasiUsecase interface {
	CreateImunisasi(req models.ImunisasiRequest) (*models.Imunisasi, error)
	GetImunisasiByAnakID(anakID int) ([]models.Imunisasi, error)
	GetImunisasiByID(id uint) (*models.Imunisasi, error)
	UpdateImunisasi(id uint, req models.ImunisasiRequest) (*models.Imunisasi, error)
	DeleteImunisasi(id uint) error
}

type imunisasiUsecase struct {
	imunisasiRepo repositories.ImunisasiRepository
}

func NewImunisasiUsecase(repo repositories.ImunisasiRepository) ImunisasiUsecase {
	return &imunisasiUsecase{
		imunisasiRepo: repo,
	}
}

func (u *imunisasiUsecase) CreateImunisasi(req models.ImunisasiRequest) (*models.Imunisasi, error) {
	imunisasi := &models.Imunisasi{
		AnakID:       req.AnakID,
		ImunisasiID:  req.ImunisasiID,
		TglRencana:   req.TglRencana,
		TglPemberian: req.TglPemberian,
		Status:       req.Status,
		Lokasi:       req.Lokasi,
		Petugas:      req.Petugas,
		CreatedAt:    time.Now(),
		UpdatedAt:    time.Now(),
	}

	err := u.imunisasiRepo.Create(imunisasi)
	if err != nil {
		return nil, err
	}
	return imunisasi, nil
}

func (u *imunisasiUsecase) GetImunisasiByAnakID(anakID int) ([]models.Imunisasi, error) {
	return u.imunisasiRepo.FindAllByAnakID(anakID)
}

func (u *imunisasiUsecase) GetImunisasiByID(id uint) (*models.Imunisasi, error) {
	return u.imunisasiRepo.FindByID(id)
}

func (u *imunisasiUsecase) UpdateImunisasi(id uint, req models.ImunisasiRequest) (*models.Imunisasi, error) {
	imunisasi, err := u.imunisasiRepo.FindByID(id)
	if err != nil {
		return nil, errors.New("data imunisasi tidak ditemukan")
	}

	imunisasi.AnakID = req.AnakID
	imunisasi.ImunisasiID = req.ImunisasiID
	imunisasi.TglRencana = req.TglRencana
	imunisasi.TglPemberian = req.TglPemberian
	imunisasi.Status = req.Status
	imunisasi.Lokasi = req.Lokasi
	imunisasi.Petugas = req.Petugas
	imunisasi.UpdatedAt = time.Now()

	err = u.imunisasiRepo.Update(imunisasi)
	if err != nil {
		return nil, err
	}
	return imunisasi, nil
}

func (u *imunisasiUsecase) DeleteImunisasi(id uint) error {
	return u.imunisasiRepo.Delete(id)
}

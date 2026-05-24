package usecases

import (
	"errors"
	"monitoring-service/app/models"
	"monitoring-service/app/repositories"
	"time"
)

type PemantauanPertumbuhanAnakUseCase interface {
	Create(req models.CreatePemantauanPemeriksaanRequest) error
	Update(id int32, req models.UpdatePemantauanPemeriksaanRequest) error
	GetByAnakID(anakID int32) ([]models.DeteksiDiniPenyimpangan, error)
	GetByID(id int32) (*models.DeteksiDiniPenyimpangan, error)
	GetAll() ([]models.DeteksiDiniPenyimpangan, error)
	Delete(id int32) error
}

type pemantauanpertumbuhanUseCase struct {
	repo repositories.PemantauanPertumbuhanRepository
}

func NewPemantauanPertumbuhanUseCase(repo repositories.PemantauanPertumbuhanRepository) PemantauanPertumbuhanAnakUseCase {
	return &pemantauanpertumbuhanUseCase{repo: repo}
}

func (u *pemantauanpertumbuhanUseCase) Create(req models.CreatePemantauanPemeriksaanRequest) error {

	if req.AnakID == 0 {
		return errors.New("anak_id wajib diisi")
	}

	now := time.Now()

	pemeriksaan := models.DeteksiDiniPenyimpangan{
		AnakID:    req.AnakID,
		BulanKe:   req.Bulanke,
		Tanggal:   req.Tanggal,
		TenagaKesehatanID: req.TenagaKesehatanID,
		BBperU: req.BBperU,
		BBperTB: req.BBperTB,
		TBperU: req.TBperU,
		LKperU: req.LKperU,
		LILA: req.LILA,
		KPSP: req.KPSP,
		TDD: req.TDD,
		TDL: req.TDL,
		KMPE: req.KMPE,
		MCHATRevised: req.MCHATRevised,
		ACTRS: req.ACTRS,
		HasilPKAT: req.HasilPKAT,
		Tindakan: req.Tindakan,
		KunjunganUlang: req.KunjunganUlang,
		CreatedAt: now,
		UpdatedAt: now,
	}

	return u.repo.Create(&pemeriksaan)
}
func (u *pemantauanpertumbuhanUseCase) Update(id int32, req models.UpdatePemantauanPemeriksaanRequest) error {
	now := time.Now()
	return u.repo.Update(id, req, now)
}
func (u *pemantauanpertumbuhanUseCase) GetByAnakID(anakID int32) ([]models.DeteksiDiniPenyimpangan, error) {
	return u.repo.GetByAnakID(anakID)
}

func (u *pemantauanpertumbuhanUseCase) GetByID(id int32) (*models.DeteksiDiniPenyimpangan, error) {
	return u.repo.GetByID(id)
}

func (u *pemantauanpertumbuhanUseCase) GetAll() ([]models.DeteksiDiniPenyimpangan, error) {
	return u.repo.GetAll()
}
func (u *pemantauanpertumbuhanUseCase) Delete(id int32) error {
	return u.repo.Delete(id)
}

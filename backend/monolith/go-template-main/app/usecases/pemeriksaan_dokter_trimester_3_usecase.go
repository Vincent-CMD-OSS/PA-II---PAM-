// package usecases

// import (
// 	"errors"
// 	"monitoring-service/app/models"
// 	"monitoring-service/app/repositories"
// )

// type PemeriksaanDokterTrimester3Usecase interface {
// 	Create(p *models.PemeriksaanDokterTrimester3) error
// 	GetByID(id int32) (*models.PemeriksaanDokterTrimester3, error)
// 	GetMine(userID int32) (*models.PemeriksaanDokterTrimester3, error) // MODUL IBU
// 	GetByKehamilanID(kehamilanID int32) ([]models.PemeriksaanDokterTrimester3, error)
// 	Update(p *models.PemeriksaanDokterTrimester3) error
// 	Delete(id int32) error
// }

// type pemeriksaanDokterTrimester3Usecase struct {
// 	repo *repositories.PemeriksaanDokterTrimester3Repository
// }

// func NewPemeriksaanDokterTrimester3Usecase(repo *repositories.PemeriksaanDokterTrimester3Repository) PemeriksaanDokterTrimester3Usecase {
// 	return &pemeriksaanDokterTrimester3Usecase{repo: repo}
// }

// func (u *pemeriksaanDokterTrimester3Usecase) Create(p *models.PemeriksaanDokterTrimester3) error {
// 	if p.KehamilanID == 0 {
// 		return errors.New("kehamilan_id wajib diisi")
// 	}
// 	return u.repo.Create(p)
// }

// func (u *pemeriksaanDokterTrimester3Usecase) GetByID(id int32) (*models.PemeriksaanDokterTrimester3, error) {
// 	return u.repo.FindByID(id)
// }

// func (u *pemeriksaanDokterTrimester3Usecase) GetByKehamilanID(kehamilanID int32) ([]models.PemeriksaanDokterTrimester3, error) {
// 	return u.repo.FindByKehamilanID(kehamilanID)
// }

// func (u *pemeriksaanDokterTrimester3Usecase) Update(p *models.PemeriksaanDokterTrimester3) error {
// 	_, err := u.repo.FindByID(p.ID)
// 	if err != nil {
// 		return errors.New("data pemeriksaan dokter trimester 3 tidak ditemukan")
// 	}
// 	return u.repo.Update(p)
// }

// func (u *pemeriksaanDokterTrimester3Usecase) Delete(id int32) error {
// 	return u.repo.Delete(id)
// }

// // MODUL IBU
// func (u *pemeriksaanDokterTrimester3Usecase) GetMine(userID int32) (*models.PemeriksaanDokterTrimester3, error) {
// 	return u.repo.FindMineByUserID(userID)
// }

package usecases

import (
	"errors"
	"monitoring-service/app/models"
	"monitoring-service/app/repositories"
)

type PemeriksaanDokterTrimester3Usecase interface {
	Create(p *models.PemeriksaanDokterTrimester3) error
	GetByID(id int32) (*models.PemeriksaanDokterTrimester3, error)
	GetMine(userID int32) (*models.PemeriksaanDokterTrimester3, error)    // single (lama)
	GetAllMine(userID int32) ([]models.PemeriksaanDokterTrimester3, error) // list (BARU)
	GetByKehamilanID(kehamilanID int32) ([]models.PemeriksaanDokterTrimester3, error)
	Update(p *models.PemeriksaanDokterTrimester3) error
	Delete(id int32) error
}

type pemeriksaanDokterTrimester3Usecase struct {
	repo *repositories.PemeriksaanDokterTrimester3Repository
}

func NewPemeriksaanDokterTrimester3Usecase(repo *repositories.PemeriksaanDokterTrimester3Repository) PemeriksaanDokterTrimester3Usecase {
	return &pemeriksaanDokterTrimester3Usecase{repo: repo}
}

func (u *pemeriksaanDokterTrimester3Usecase) Create(p *models.PemeriksaanDokterTrimester3) error {
	if p.KehamilanID == 0 {
		return errors.New("kehamilan_id wajib diisi")
	}
	return u.repo.Create(p)
}

func (u *pemeriksaanDokterTrimester3Usecase) GetByID(id int32) (*models.PemeriksaanDokterTrimester3, error) {
	return u.repo.FindByID(id)
}

func (u *pemeriksaanDokterTrimester3Usecase) GetByKehamilanID(kehamilanID int32) ([]models.PemeriksaanDokterTrimester3, error) {
	return u.repo.FindByKehamilanID(kehamilanID)
}

func (u *pemeriksaanDokterTrimester3Usecase) Update(p *models.PemeriksaanDokterTrimester3) error {
	_, err := u.repo.FindByID(p.ID)
	if err != nil {
		return errors.New("data pemeriksaan dokter trimester 3 tidak ditemukan")
	}
	return u.repo.Update(p)
}

func (u *pemeriksaanDokterTrimester3Usecase) Delete(id int32) error {
	return u.repo.Delete(id)
}

// MODUL IBU - single (existing)
func (u *pemeriksaanDokterTrimester3Usecase) GetMine(userID int32) (*models.PemeriksaanDokterTrimester3, error) {
	return u.repo.FindMineByUserID(userID)
}

// MODUL IBU - list (BARU)
func (u *pemeriksaanDokterTrimester3Usecase) GetAllMine(userID int32) ([]models.PemeriksaanDokterTrimester3, error) {
	return u.repo.FindAllMineByUserID(userID)
}
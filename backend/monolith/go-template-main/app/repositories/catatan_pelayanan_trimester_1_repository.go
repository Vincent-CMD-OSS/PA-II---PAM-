package repositories

import (
	"errors"
	"monitoring-service/app/models"

	"gorm.io/gorm"
)

type CatatanPelayananTrimester1Repository struct {
	db *gorm.DB
}

func NewCatatanPelayananTrimester1Repository(db *gorm.DB) *CatatanPelayananTrimester1Repository {
	return &CatatanPelayananTrimester1Repository{db: db}
}

func (r *CatatanPelayananTrimester1Repository) Create(c *models.CatatanPelayananTrimester1) error {
	return r.db.Create(c).Error
}

func (r *CatatanPelayananTrimester1Repository) FindByID(id int32) (*models.CatatanPelayananTrimester1, error) {
	var c models.CatatanPelayananTrimester1
	err := r.db.Preload("Kehamilan.Ibu.Kependudukan").First(&c, id).Error
	return &c, err
}

func (r *CatatanPelayananTrimester1Repository) FindByKehamilanID(kehamilanID int32) ([]models.CatatanPelayananTrimester1, error) {
	var list []models.CatatanPelayananTrimester1
	err := r.db.Where("kehamilan_id = ?", kehamilanID).Order("tanggal_periksa_stamp_paraf DESC").Find(&list).Error
	return list, err
}

func (r *CatatanPelayananTrimester1Repository) Update(c *models.CatatanPelayananTrimester1) error {
	return r.db.Save(c).Error
}

func (r *CatatanPelayananTrimester1Repository) Delete(id int32) error {
	result := r.db.Delete(&models.CatatanPelayananTrimester1{}, id)
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return errors.New("data catatan pelayanan trimester 1 tidak ditemukan")
	}
	return nil
}

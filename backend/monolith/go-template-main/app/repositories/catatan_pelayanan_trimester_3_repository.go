package repositories

import (
	"errors"
	"monitoring-service/app/models"

	"gorm.io/gorm"
)

type CatatanPelayananTrimester3Repository struct {
	db *gorm.DB
}

func NewCatatanPelayananTrimester3Repository(db *gorm.DB) *CatatanPelayananTrimester3Repository {
	return &CatatanPelayananTrimester3Repository{db: db}
}

func (r *CatatanPelayananTrimester3Repository) Create(c *models.CatatanPelayananTrimester3) error {
	return r.db.Create(c).Error
}

func (r *CatatanPelayananTrimester3Repository) FindByID(id int32) (*models.CatatanPelayananTrimester3, error) {
	var c models.CatatanPelayananTrimester3
	err := r.db.Preload("Kehamilan.Ibu.Kependudukan").First(&c, id).Error
	return &c, err
}

func (r *CatatanPelayananTrimester3Repository) FindByKehamilanID(kehamilanID int32) ([]models.CatatanPelayananTrimester3, error) {
	var list []models.CatatanPelayananTrimester3
	err := r.db.Where("kehamilan_id = ?", kehamilanID).Order("tanggal_periksa_stamp_paraf DESC").Find(&list).Error
	return list, err
}

func (r *CatatanPelayananTrimester3Repository) Update(c *models.CatatanPelayananTrimester3) error {
	return r.db.Save(c).Error
}

func (r *CatatanPelayananTrimester3Repository) Delete(id int32) error {
	result := r.db.Delete(&models.CatatanPelayananTrimester3{}, id)
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return errors.New("data catatan pelayanan trimester 3 tidak ditemukan")
	}
	return nil
}

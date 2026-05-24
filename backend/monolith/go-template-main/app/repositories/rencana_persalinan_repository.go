package repositories

import (
	"errors"
	"monitoring-service/app/models"

	"gorm.io/gorm"
)

type RencanaPersalinanRepository struct {
	db *gorm.DB
}

func NewRencanaPersalinanRepository(db *gorm.DB) *RencanaPersalinanRepository {
	return &RencanaPersalinanRepository{db: db}
}

func (r *RencanaPersalinanRepository) Create(rp *models.RencanaPersalinan) error {
	return r.db.Create(rp).Error
}

func (r *RencanaPersalinanRepository) FindByID(id int32) (*models.RencanaPersalinan, error) {
	var rp models.RencanaPersalinan
	err := r.db.Preload("Kehamilan.Ibu.Kependudukan").First(&rp, id).Error
	return &rp, err
}

func (r *RencanaPersalinanRepository) FindByKehamilanID(kehamilanID int32) ([]models.RencanaPersalinan, error) {
	var list []models.RencanaPersalinan
	err := r.db.Where("kehamilan_id = ?", kehamilanID).Find(&list).Error
	return list, err
}

func (r *RencanaPersalinanRepository) Update(rp *models.RencanaPersalinan) error {
	return r.db.Save(rp).Error
}

func (r *RencanaPersalinanRepository) Delete(id int32) error {
	result := r.db.Delete(&models.RencanaPersalinan{}, id)
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return errors.New("data rencana persalinan tidak ditemukan")
	}
	return nil
}

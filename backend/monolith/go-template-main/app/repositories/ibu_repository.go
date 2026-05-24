package repositories

import (
	"errors"
	"monitoring-service/app/models"

	"gorm.io/gorm"
)

type IbuRepository struct {
	db *gorm.DB
}

func NewIbuRepository(db *gorm.DB) *IbuRepository {
	return &IbuRepository{db: db}
}

func (r *IbuRepository) Create(ibu *models.Ibu) error {
	return r.db.Create(ibu).Error
}

func (r *IbuRepository) FindByID(id int32) (*models.Ibu, error) {
	var ibu models.Ibu
	err := r.db.Preload("Kependudukan").First(&ibu, id).Error
	return &ibu, err
}

func (r *IbuRepository) FindAll() ([]models.Ibu, error) {
	var list []models.Ibu
	err := r.db.Preload("Kependudukan").Find(&list).Error
	return list, err
}

func (r *IbuRepository) FindAnakByUserID(userID int32) ([]models.Anak, error) {
	var list []models.Anak
	err := r.db.
		Model(&models.Anak{}).
		Joins("JOIN kehamilan k ON k.id = anak.kehamilan_id").
		Joins("JOIN ibu i ON i.id = k.ibu_id").
		Joins("JOIN penduduk p_ibu ON p_ibu.id = i.penduduk_id").
		Joins("JOIN pengguna u ON u.penduduk_id = p_ibu.id").
		Where("u.id = ?", userID).
		Preload("Penduduk").
		Preload("Kehamilan").
		Order("anak.created_at DESC").
		Find(&list).Error
	return list, err
}

func (r *IbuRepository) Update(ibu *models.Ibu) error {
	return r.db.Save(ibu).Error
}

func (r *IbuRepository) Delete(id int32) error {
	result := r.db.Delete(&models.Ibu{}, id)
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return errors.New("data ibu tidak ditemukan")
	}
	return nil
}

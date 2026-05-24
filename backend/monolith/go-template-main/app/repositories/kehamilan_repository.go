package repositories

import (
	"errors"
	"monitoring-service/app/models"

	"gorm.io/gorm"
)

type KehamilanRepository struct {
	db *gorm.DB
}

func NewKehamilanRepository(db *gorm.DB) *KehamilanRepository {
	return &KehamilanRepository{db: db}
}

func (r *KehamilanRepository) Create(kehamilan *models.Kehamilan) error {
	return r.db.Create(kehamilan).Error
}

func (r *KehamilanRepository) FindByID(id int32) (*models.Kehamilan, error) {
	var kehamilan models.Kehamilan
	err := r.db.Preload("Ibu.Kependudukan").
	Preload("Anak").
	First(&kehamilan, id).Error
	
	if err != nil {
		return nil, err
	}

	return &kehamilan, nil
}

func (r *KehamilanRepository) FindByIbuID(ibuID int32) ([]models.Kehamilan, error) {
	var list []models.Kehamilan
	err := r.db.Where("ibu_id = ?", ibuID).Order("created_at DESC").Find(&list).Error
	return list, err
}

func (r *KehamilanRepository) GetAll() ([]models.Kehamilan, error) {
	var list []models.Kehamilan
	err := r.db.Preload("Ibu.Kependudukan").
	Preload("Anak"). 
	Find(&list).Error
	return list, err
}

func (r *KehamilanRepository) Update(kehamilan *models.Kehamilan) error {
	return r.db.Save(kehamilan).Error
}

func (r *KehamilanRepository) Delete(id int32) error {
	result := r.db.Delete(&models.Kehamilan{}, id)
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return errors.New("data kehamilan tidak ditemukan")
	}
	return nil
}

// MODUL IBU (INTERNAL BACKUP ONLY)
// func (r *KehamilanRepository) FindAktifByUserID(userID int32) (*models.Kehamilan, error) {
// 	var kehamilan models.Kehamilan

// 	err := r.db.
// 		Table("kehamilan k").
// 		Select("k.*").
// 		Joins("JOIN ibu i ON i.id = k.ibu_id").
// 		Joins("JOIN penduduk p ON p.id = i.id").
// 		Joins("JOIN pengguna u ON u.id = p.id").
// 		Where("u.id = ?", userID).
// 		Where("k.status_kehamilan IN ?", []string{"aktif", "TRIMESTER 1", "TRIMESTER 2", "TRIMESTER 3"}).
// 		Order("k.created_at DESC").
// 		First(&kehamilan).Error

// 	return &kehamilan, err
// }

// MODUL IBU (SUPABASE UTAMA)
func (r *KehamilanRepository) FindAktifByUserID(userID int32) (*models.Kehamilan, error) {
	var kehamilan models.Kehamilan

	err := r.db.
		Table("kehamilan k").
		Select("k.*").
		Joins("JOIN ibu i ON i.id = k.ibu_id").
		Joins("JOIN penduduk p ON p.id = i.penduduk_id").
		Joins("JOIN pengguna u ON u.penduduk_id = p.id").
		Where("u.id = ?", userID).
		Where("k.status_kehamilan IN ?", []string{"aktif", "TRIMESTER 1", "TRIMESTER 2", "TRIMESTER 3"}).
		Order("k.created_at DESC").
		First(&kehamilan).Error

	return &kehamilan, err
}

package repositories

import (
	"errors"
	"monitoring-service/app/models"

	"gorm.io/gorm"
)

type PemeriksaanKehamilanRepository struct {
	db *gorm.DB
}

func NewPemeriksaanKehamilanRepository(db *gorm.DB) *PemeriksaanKehamilanRepository {
	return &PemeriksaanKehamilanRepository{db: db}
}

func (r *PemeriksaanKehamilanRepository) Create(p *models.PemeriksaanKehamilan) error {
	return r.db.Create(p).Error
}

func (r *PemeriksaanKehamilanRepository) FindByID(id int32) (*models.PemeriksaanKehamilan, error) {
	var p models.PemeriksaanKehamilan
	err := r.db.Preload("Kehamilan.Ibu.Kependudukan").First(&p, id).Error
	return &p, err
}

func (r *PemeriksaanKehamilanRepository) FindByKehamilanID(kehamilanID int32) ([]models.PemeriksaanKehamilan, error) {
	var list []models.PemeriksaanKehamilan
	err := r.db.Where("kehamilan_id = ?", kehamilanID).Order("tanggal_periksa DESC").Find(&list).Error
	return list, err
}

func (r *PemeriksaanKehamilanRepository) Update(p *models.PemeriksaanKehamilan) error {
	return r.db.Save(p).Error
}

func (r *PemeriksaanKehamilanRepository) Delete(id int32) error {
	result := r.db.Delete(&models.PemeriksaanKehamilan{}, id)
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return errors.New("data pemeriksaan kehamilan tidak ditemukan")
	}
	return nil
}

// MODUL IBU
func (r *PemeriksaanKehamilanRepository) IsOwnedByUser(periksaID int32, userID int32) (bool, error) {
	var count int64

	err := r.db.
		Table("pemeriksaan_kehamilan p").
		Joins("JOIN kehamilan k ON k.id = p.kehamilan_id").
		Joins("JOIN ibu i ON i.id = k.ibu_id").
		Joins("JOIN penduduk pd ON pd.id = i.penduduk_id").
		Joins("JOIN pengguna u ON u.penduduk_id = pd.id").
		Where("p.id = ? AND u.id = ?", periksaID, userID).
		Count(&count).Error

	return count > 0, err
}

// MODUL IBU
func (r *PemeriksaanKehamilanRepository) FindMineByUserID(userID int32) ([]models.PemeriksaanKehamilan, error) {
	var list []models.PemeriksaanKehamilan

	err := r.db.
		Table("pemeriksaan_kehamilan p").
		Joins("JOIN kehamilan k ON k.id = p.kehamilan_id").
		Joins("JOIN ibu i ON i.id = k.ibu_id").
		Joins("JOIN penduduk pd ON pd.id = i.penduduk_id").
		Joins("JOIN pengguna u ON u.id = pd.id").
		Where("u.id = ?", userID).
		Order("p.tanggal_periksa DESC").
		Find(&list).Error

	return list, err
}
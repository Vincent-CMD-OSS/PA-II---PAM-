package repositories

import (
	"monitoring-service/app/models"
	"time"

	"gorm.io/gorm"
)

type KaderListItem struct {
	ID          int32     `json:"id"`
	PendudukID  int32     `json:"penduduk_id"`
	NamaLengkap string    `json:"nama_lengkap"`
	NIK         string    `json:"nik"`
	Kecamatan   string    `json:"kecamatan"`
	Desa        string    `json:"desa"`
	PosyanduID  *int64    `json:"posyandu_id,omitempty"`
	Status      string    `json:"status"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
}

type KaderRepository struct {
	db *gorm.DB
}

func NewKaderRepository(db *gorm.DB) *KaderRepository {
	return &KaderRepository{db: db}
}

func (r *KaderRepository) Create(data *models.Kader) error {
	return r.db.Create(data).Error
}

func (r *KaderRepository) FindByID(id int32) (*models.Kader, error) {
	var data models.Kader
	err := r.db.Where("id = ? AND deleted_at IS NULL", id).First(&data).Error
	return &data, err
}

func (r *KaderRepository) FindByPendudukID(pendudukID int32) (*models.Kader, error) {
	var data models.Kader
	err := r.db.Where("penduduk_id = ? AND deleted_at IS NULL", pendudukID).First(&data).Error
	return &data, err
}

func (r *KaderRepository) FindAnyByPendudukID(pendudukID int32) (*models.Kader, error) {
	var data models.Kader
	err := r.db.Unscoped().Where("penduduk_id = ?", pendudukID).First(&data).Error
	return &data, err
}

func (r *KaderRepository) Update(data *models.Kader) error {
	return r.db.Save(data).Error
}

func (r *KaderRepository) SetStatus(id int32, status string) error {
	now := time.Now()
	return r.db.Model(&models.Kader{}).
		Where("id = ? AND deleted_at IS NULL", id).
		Updates(map[string]interface{}{
			"status":     status,
			"updated_at": now,
		}).Error
}

func (r *KaderRepository) List(desa string) ([]KaderListItem, error) {
	var rows []KaderListItem

	q := r.db.Table("kader k").
		Select("k.id, k.penduduk_id, p.nama_lengkap, p.nik, p.kecamatan, p.desa, k.posyandu_id, k.status, k.created_at, k.updated_at").
		Joins("JOIN penduduk p ON p.id = k.penduduk_id").
		Where("k.deleted_at IS NULL AND p.deleted_at IS NULL").
		Order("k.id DESC")

	if desa != "" {
		q = q.Where("COALESCE(p.desa, '') = ?", desa)
	}

	err := q.Scan(&rows).Error
	return rows, err
}

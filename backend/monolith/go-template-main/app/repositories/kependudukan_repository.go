package repositories

import (
	"errors"
	"fmt"
	"monitoring-service/app/models"
	"strings"
	"time"

	"gorm.io/gorm"
)

type KependudukanRepository struct {
	db *gorm.DB
}

type EligiblePendudukItem struct {
	ID              int32  `json:"id"`
	KartuKeluargaID *int64 `json:"kartu_keluarga_id,omitempty"`
	NIK             string `json:"nik"`
	NamaLengkap     string `json:"nama_lengkap"`
	JenisKelamin    string `json:"jenis_kelamin"`
	Kecamatan       string `json:"kecamatan"`
	Desa            string `json:"desa"`
	NomorTelepon    string `json:"nomor_telepon"`
}

type PosyanduItem struct {
	ID   int64  `json:"id"`
	Nama string `json:"nama"`
}

func NewKependudukanRepository(db *gorm.DB) *KependudukanRepository {
	return &KependudukanRepository{db: db}
}

func (r *KependudukanRepository) Create(k *models.Kependudukan) error {
	return r.db.Create(k).Error
}

func (r *KependudukanRepository) FindByID(id int32) (*models.Kependudukan, error) {
	var k models.Kependudukan
	err := r.db.Where("id = ? AND deleted_at IS NULL", id).First(&k).Error
	return &k, err
}

func (r *KependudukanRepository) FindByNIK(nik string) (*models.Kependudukan, error) {
	var k models.Kependudukan
	err := r.db.Where("nik = ? AND deleted_at IS NULL", nik).First(&k).Error
	return &k, err
}

func (r *KependudukanRepository) FindByKartuKeluargaID(kkID int32) ([]models.Kependudukan, error) {
	var list []models.Kependudukan
	err := r.db.Preload("KartuKeluarga").Where("kartu_keluarga_id = ?", kkID).Find(&list).Error
	return list, err
}

func (r *KependudukanRepository) GetAll() ([]models.Kependudukan, error) {
	var list []models.Kependudukan
	err := r.db.Where("deleted_at IS NULL").Find(&list).Error
	return list, err
}

func (r *KependudukanRepository) Update(k *models.Kependudukan) error {
	return r.db.Save(k).Error
}

func (r *KependudukanRepository) Delete(id int32) error {
	result := r.db.Delete(&models.Kependudukan{}, id)
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return errors.New("data kependudukan tidak ditemukan")
	}
	return nil
}

func (r *KependudukanRepository) ListByKartuKeluargaID(kartuKeluargaID int64) ([]models.Kependudukan, error) {
	var list []models.Kependudukan
	err := r.db.
		Where("kartu_keluarga_id = ? AND deleted_at IS NULL", kartuKeluargaID).
		Order("id ASC").
		Find(&list).Error
	return list, err
}

func (r *KependudukanRepository) FindByIDAndKartuKeluargaID(id int32, kartuKeluargaID int64) (*models.Kependudukan, error) {
	var k models.Kependudukan
	err := r.db.
		Where("id = ? AND kartu_keluarga_id = ? AND deleted_at IS NULL", id, kartuKeluargaID).
		First(&k).Error
	return &k, err
}

func (r *KependudukanRepository) FindByNIKExceptID(nik string, exceptID int32) (*models.Kependudukan, error) {
	var k models.Kependudukan
	err := r.db.Where("nik = ? AND id <> ? AND deleted_at IS NULL", nik, exceptID).First(&k).Error
	return &k, err
}

func (r *KependudukanRepository) ListEligibleForRole(role, search, kecamatan, desa string) ([]EligiblePendudukItem, error) {
	role = strings.ToLower(strings.TrimSpace(role))
	search = strings.TrimSpace(search)
	kecamatan = strings.TrimSpace(kecamatan)
	desa = strings.TrimSpace(desa)

	if role != "bidan" && role != "kader" {
		return nil, errors.New("role harus bidan atau kader")
	}

	var list []EligiblePendudukItem
	q := r.db.Table("penduduk p").
		Select("p.id, p.kartu_keluarga_id, p.nik, p.nama_lengkap, p.jenis_kelamin, p.kecamatan, p.desa, p.nomor_telepon").
		Where("p.deleted_at IS NULL")

	if search != "" {
		pattern := "%" + search + "%"
		q = q.Where("(p.nik ILIKE ? OR p.nama_lengkap ILIKE ?)", pattern, pattern)
	}
	if kecamatan != "" {
		q = q.Where("COALESCE(p.kecamatan, '') = ?", kecamatan)
	}
	if desa != "" {
		q = q.Where("COALESCE(p.desa, '') = ?", desa)
	}

	switch role {
	case "bidan":
		q = q.Where("NOT EXISTS (SELECT 1 FROM bidan b WHERE b.penduduk_id = p.id AND b.deleted_at IS NULL)")
	case "kader":
		q = q.Where("NOT EXISTS (SELECT 1 FROM kader k WHERE k.penduduk_id = p.id AND k.deleted_at IS NULL)")
	}

	err := q.Order("p.nama_lengkap ASC").Scan(&list).Error
	return list, err
}

func detectPosyanduNameColumn(db *gorm.DB) (string, map[string]bool, error) {
	type columnInfo struct {
		ColumnName string `gorm:"column:column_name"`
	}

	var columns []columnInfo
	if err := db.Raw(`
		SELECT column_name
		FROM information_schema.columns
		WHERE table_schema = current_schema()
		  AND table_name = 'posyandu'
	`).Scan(&columns).Error; err != nil {
		return "", nil, err
	}
	if len(columns) == 0 {
		return "", nil, errors.New("tabel posyandu tidak ditemukan")
	}

	hasColumn := map[string]bool{}
	for _, c := range columns {
		hasColumn[c.ColumnName] = true
	}

	for _, candidate := range []string{"nama", "nama_posyandu", "name"} {
		if hasColumn[candidate] {
			return candidate, hasColumn, nil
		}
	}

	return "", nil, errors.New("kolom nama posyandu tidak ditemukan")
}

func (r *KependudukanRepository) CreatePosyandu(nama string) error {
	nama = strings.TrimSpace(nama)
	if nama == "" {
		return errors.New("nama posyandu wajib diisi")
	}

	nameColumn, _, err := detectPosyanduNameColumn(r.db)
	if err != nil {
		return err
	}

	return r.db.Table("posyandu").Create(map[string]interface{}{nameColumn: nama}).Error
}

func (r *KependudukanRepository) ListPosyandu(search string) ([]PosyanduItem, error) {
	search = strings.TrimSpace(search)

	nameColumn, hasColumn, err := detectPosyanduNameColumn(r.db)
	if err != nil {
		return nil, err
	}

	q := r.db.Table("posyandu").
		Select(fmt.Sprintf("id, %s AS nama", nameColumn)).
		Order(fmt.Sprintf("%s ASC", nameColumn))

	if hasColumn["deleted_at"] {
		q = q.Where("deleted_at IS NULL")
	}
	if search != "" {
		q = q.Where(fmt.Sprintf("%s ILIKE ?", nameColumn), "%"+search+"%")
	}

	var list []PosyanduItem
	if err := q.Scan(&list).Error; err != nil {
		return nil, err
	}
	return list, nil
}

func (r *KependudukanRepository) SoftDeleteByID(id int32) error {
	now := time.Now()
	return r.db.Model(&models.Kependudukan{}).
		Where("id = ? AND deleted_at IS NULL", id).
		Updates(map[string]interface{}{
			"deleted_at": now,
			"updated_at": now,
		}).Error
}

func (r *KependudukanRepository) SoftDeleteByKartuKeluargaID(kartuKeluargaID int64) error {
	now := time.Now()
	return r.db.Model(&models.Kependudukan{}).
		Where("kartu_keluarga_id = ? AND deleted_at IS NULL", kartuKeluargaID).
		Updates(map[string]interface{}{
			"deleted_at": now,
			"updated_at": now,
		}).Error
}

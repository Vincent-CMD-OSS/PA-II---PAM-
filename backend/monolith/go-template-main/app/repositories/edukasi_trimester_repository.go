package repositories

import (
	"context"

	"gorm.io/gorm"

	"monitoring-service/app/models"
)

type EdukasiTrimesterRepository interface {
	GetAll(ctx context.Context) ([]models.EdukasiTrimester, error)

	GetByTrimester(
		ctx context.Context,
		trimester string,
	) ([]models.EdukasiTrimester, error)

	GetByKategori(
		ctx context.Context,
		trimester string,
		kategori string,
	) ([]models.EdukasiTrimester, error)
}

type edukasiTrimesterRepository struct {
	db *gorm.DB
}

func NewEdukasiTrimesterRepository(
	db *gorm.DB,
) EdukasiTrimesterRepository {
	return &edukasiTrimesterRepository{
		db: db,
	}
}

func (r *edukasiTrimesterRepository) GetAll(
	ctx context.Context,
) ([]models.EdukasiTrimester, error) {

	var data []models.EdukasiTrimester

	err := r.db.WithContext(ctx).
		Find(&data).Error

	return data, err
}

func (r *edukasiTrimesterRepository) GetByTrimester(
	ctx context.Context,
	trimester string,
) ([]models.EdukasiTrimester, error) {

	var data []models.EdukasiTrimester

	err := r.db.WithContext(ctx).
		Where("trimester = ?", trimester).
		Find(&data).Error

	return data, err
}

func (r *edukasiTrimesterRepository) GetByKategori(
	ctx context.Context,
	trimester string,
	kategori string,
) ([]models.EdukasiTrimester, error) {

	var data []models.EdukasiTrimester

	err := r.db.WithContext(ctx).
		Where(
			"trimester = ? AND kategori = ?",
			trimester,
			kategori,
		).
		Find(&data).Error

	return data, err
}
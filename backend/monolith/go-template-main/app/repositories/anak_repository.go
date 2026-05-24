package repositories

import (
	"strings"

	"monitoring-service/app/constants"
	"monitoring-service/app/models"
	"monitoring-service/pkg/customerror"
)

func (m *Main) GetAllAnak() ([]models.Anak, error) {
	var data []models.Anak
	err := m.postgres.
		Preload("Kependudukan").
		Preload("Ibu").
		Preload("Ibu.Kependudukan").
		Preload("Ibu.Kependudukan.NoKartuKeluarga").
		Find(&data).Error
	if err != nil {
		return nil, customerror.NewInternalServiceError("gagal mengambil data anak")
	}

	return data, nil
}

func (m *Main) SearchAnak(namaAnak, namaIbu, noKK string) ([]models.Anak, error) {
	var data []models.Anak

	query := m.postgres.Model(&models.Anak{}).
		Joins("LEFT JOIN ibu i ON i.id = anak.ibu_id").
		Joins("LEFT JOIN kependudukan ki ON ki.id = i.kependudukan_id").
		Joins("LEFT JOIN kartu_keluarga kk ON kk.id = ki.no_kartu_keluarga_id")

	namaAnak = strings.TrimSpace(namaAnak)
	namaIbu = strings.TrimSpace(namaIbu)
	noKK = strings.TrimSpace(noKK)

	if namaAnak != "" {
		query = query.Where("anak.nama_anak ILIKE ?", "%"+namaAnak+"%")
	}

	if namaIbu != "" {
		query = query.Where("ki.nama ILIKE ?", "%"+namaIbu+"%")
	}

	if noKK != "" {
		searchNoKK := "%" + noKK + "%"
		query = query.Where("CAST(anak.no_kartu_keluarga AS TEXT) ILIKE ? OR CAST(kk.no_kartu_keluarga AS TEXT) ILIKE ?", searchNoKK, searchNoKK)
	}

	err := query.
		Preload("Kependudukan").
		Preload("Ibu").
		Preload("Ibu.Kependudukan").
		Preload("Ibu.Kependudukan.NoKartuKeluarga").
		Order("anak.created_at DESC").
		Find(&data).Error

	if err != nil {
		return nil, customerror.NewInternalServiceError("gagal mencari data anak")
	}

	return data, nil
}

func (m *Main) GetAnakByID(anakID uint) (*models.Anak, error) {
	var data models.Anak
	err := m.postgres.
		Preload("Kependudukan").
		Preload("Ibu").
		Preload("Ibu.Kependudukan").
		Preload("Ibu.Kependudukan.NoKartuKeluarga").
		Where("id = ?", anakID).
		First(&data).Error
	if err != nil {
		if err.Error() == constants.GORM_ERR_NOT_FOUND {
			return nil, customerror.NewNotFoundError("data anak tidak ditemukan")
		}
		return nil, customerror.NewInternalServiceError("gagal mengambil data anak")
	}

	return &data, nil
}

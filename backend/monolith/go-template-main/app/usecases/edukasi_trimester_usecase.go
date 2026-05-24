package usecases

import (
	"context"

	"monitoring-service/app/models"
	"monitoring-service/app/repositories"
)

type EdukasiTrimesterUseCase interface {
	GetAll(
		ctx context.Context,
	) ([]models.EdukasiTrimester, error)

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

type edukasiTrimesterUseCase struct {
	repository repositories.EdukasiTrimesterRepository
}

func NewEdukasiTrimesterUseCase(
	repository repositories.EdukasiTrimesterRepository,
) EdukasiTrimesterUseCase {
	return &edukasiTrimesterUseCase{
		repository: repository,
	}
}

func (u *edukasiTrimesterUseCase) GetAll(
	ctx context.Context,
) ([]models.EdukasiTrimester, error) {

	return u.repository.GetAll(ctx)
}

func (u *edukasiTrimesterUseCase) GetByTrimester(
	ctx context.Context,
	trimester string,
) ([]models.EdukasiTrimester, error) {

	return u.repository.GetByTrimester(
		ctx,
		trimester,
	)
}

func (u *edukasiTrimesterUseCase) GetByKategori(
	ctx context.Context,
	trimester string,
	kategori string,
) ([]models.EdukasiTrimester, error) {

	return u.repository.GetByKategori(
		ctx,
		trimester,
		kategori,
	)
}
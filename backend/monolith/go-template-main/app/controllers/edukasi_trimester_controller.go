package controllers

import (
	"net/http"

	"github.com/labstack/echo/v4"

	"monitoring-service/app/usecases"
)

type EdukasiTrimesterController struct {
	usecase usecases.EdukasiTrimesterUseCase
}

func NewEdukasiTrimesterController(
	usecase usecases.EdukasiTrimesterUseCase,
) *EdukasiTrimesterController {
	return &EdukasiTrimesterController{
		usecase: usecase,
	}
}

func (c *EdukasiTrimesterController) GetAll(
	ctx echo.Context,
) error {

	data, err := c.usecase.GetAll(
		ctx.Request().Context(),
	)

	if err != nil {
		return ctx.JSON(
			http.StatusInternalServerError,
			map[string]interface{}{
				"message": err.Error(),
			},
		)
	}

	return ctx.JSON(
		http.StatusOK,
		data,
	)
}

func (c *EdukasiTrimesterController) GetByTrimester(
	ctx echo.Context,
) error {

	trimester := ctx.Param("trimester")

	data, err := c.usecase.GetByTrimester(
		ctx.Request().Context(),
		trimester,
	)

	if err != nil {
		return ctx.JSON(
			http.StatusInternalServerError,
			map[string]interface{}{
				"message": err.Error(),
			},
		)
	}

	return ctx.JSON(
		http.StatusOK,
		data,
	)
}

func (c *EdukasiTrimesterController) GetByKategori(
	ctx echo.Context,
) error {

	trimester := ctx.Param("trimester")
	kategori := ctx.Param("kategori")

	data, err := c.usecase.GetByKategori(
		ctx.Request().Context(),
		trimester,
		kategori,
	)

	if err != nil {
		return ctx.JSON(
			http.StatusInternalServerError,
			map[string]interface{}{
				"message": err.Error(),
			},
		)
	}

	return ctx.JSON(
		http.StatusOK,
		data,
	)
}
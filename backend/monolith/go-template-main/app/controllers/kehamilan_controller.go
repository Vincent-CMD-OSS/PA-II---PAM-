package controllers

import (
	"net/http"
	"strconv"
	"time"

	"monitoring-service/app/models"
	"monitoring-service/app/usecases"

	"github.com/labstack/echo/v4"
)

type KehamilanController struct {
	usecase usecases.KehamilanUsecase
}

func NewKehamilanController(u usecases.KehamilanUsecase) *KehamilanController {
	return &KehamilanController{usecase: u}
}

type createKehamilanRequest struct {
	IbuID                    int32   `json:"ibu_id"`
	Gravida                  int32   `json:"gravida,omitempty"`
	Paritas                  int32   `json:"paritas,omitempty"`
	Abortus                  int32   `json:"abortus,omitempty"`
	HPHT                     string  `json:"hpht,omitempty"`
	TaksiranPersalinan       string  `json:"taksiran_persalinan,omitempty"`
	UKKehamilanSaatIni       int32   `json:"uk_kehamilan_saat_ini,omitempty"`
	BB_Awal                  float64 `json:"bb_awal,omitempty"`
	TB                       float64 `json:"tb,omitempty"`
	IMT_Awal                 float64 `json:"imt_awal,omitempty"`
	JarakKehamilanSebelumnya int32   `json:"jarak_kehamilan_sebelumnya,omitempty"`
	StatusKehamilan          string  `json:"status_kehamilan,omitempty"`
}

type updateKehamilanRequest struct {
	Gravida                  int32   `json:"gravida,omitempty"`
	Paritas                  int32   `json:"paritas,omitempty"`
	Abortus                  int32   `json:"abortus,omitempty"`
	HPHT                     string  `json:"hpht,omitempty"`
	TaksiranPersalinan       string  `json:"taksiran_persalinan,omitempty"`
	UKKehamilanSaatIni       int32   `json:"uk_kehamilan_saat_ini,omitempty"`
	BB_Awal                  float64 `json:"bb_awal,omitempty"`
	TB                       float64 `json:"tb,omitempty"`
	IMT_Awal                 float64 `json:"imt_awal,omitempty"`
	JarakKehamilanSebelumnya int32   `json:"jarak_kehamilan_sebelumnya,omitempty"`
	StatusKehamilan          string  `json:"status_kehamilan,omitempty"`
}

func (c *KehamilanController) Create(ctx echo.Context) error {
	claims, ok := ctx.Get("auth_claims").(*models.AuthClaims)
	if !ok || claims == nil {
		return ctx.JSON(http.StatusUnauthorized, models.Response{
			StatusCode: http.StatusUnauthorized,
			Message:    "Unauthorized",
		})
	}

	var req createKehamilanRequest
	if err := ctx.Bind(&req); err != nil {
		return ctx.JSON(http.StatusBadRequest, models.Response{
			StatusCode: http.StatusBadRequest,
			Message:    err.Error(),
		})
	}

	kehamilan := &models.Kehamilan{
		IbuID:                    req.IbuID,
		Gravida:                  req.Gravida,
		Paritas:                  req.Paritas,
		Abortus:                  req.Abortus,
		UKKehamilanSaatIni:       req.UKKehamilanSaatIni,
		JarakKehamilanSebelumnya: req.JarakKehamilanSebelumnya,
		StatusKehamilan:          req.StatusKehamilan,
		BB_Awal:                  req.BB_Awal,
		TB:                       req.TB,
	}

	// Parse tanggal jika ada
	if req.HPHT != "" {
		if t, err := time.Parse("2006-01-02", req.HPHT); err == nil {
			kehamilan.HPHT = t
		}
	}
	if req.TaksiranPersalinan != "" {
		if t, err := time.Parse("2006-01-02", req.TaksiranPersalinan); err == nil {
			kehamilan.TaksiranPersalinan = t
		}
	}

	if err := c.usecase.Create(kehamilan); err != nil {
		return ctx.JSON(http.StatusInternalServerError, models.Response{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		})
	}

	return ctx.JSON(http.StatusCreated, models.Response{
		StatusCode: http.StatusCreated,
		Data:       kehamilan,
	})
}

func (c *KehamilanController) GetByID(ctx echo.Context) error {
	id, err := strconv.ParseInt(ctx.Param("id"), 10, 32)
	if err != nil {
		return ctx.JSON(http.StatusBadRequest, models.Response{
			StatusCode: http.StatusBadRequest,
			Message:    "invalid id",
		})
	}
	data, err := c.usecase.GetByID(int32(id))
	if err != nil {
		return ctx.JSON(http.StatusNotFound, models.Response{
			StatusCode: http.StatusNotFound,
			Message:    err.Error(),
		})
	}
	return ctx.JSON(http.StatusOK, models.Response{
		StatusCode: http.StatusOK,
		Data:       data,
	})
}

func (c *KehamilanController) GetByIbuID(ctx echo.Context) error {
	ibuID, err := strconv.ParseInt(ctx.QueryParam("ibu_id"), 10, 32)
	if err != nil {
		return ctx.JSON(http.StatusBadRequest, models.Response{
			StatusCode: http.StatusBadRequest,
			Message:    "ibu_id required",
		})
	}
	list, err := c.usecase.GetByIbuID(int32(ibuID))
	if err != nil {
		return ctx.JSON(http.StatusInternalServerError, models.Response{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		})
	}
	return ctx.JSON(http.StatusOK, models.Response{
		StatusCode: http.StatusOK,
		Data:       list,
	})
}

func (c *KehamilanController) GetAll(ctx echo.Context) error {
	list, err := c.usecase.GetAll()
	if err != nil {
		return ctx.JSON(http.StatusInternalServerError, models.Response{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		})
	}
	return ctx.JSON(http.StatusOK, models.Response{
		StatusCode: http.StatusOK,
		Data:       list,
	})
}

func (c *KehamilanController) Update(ctx echo.Context) error {
	id, err := strconv.ParseInt(ctx.Param("id"), 10, 32)
	if err != nil {
		return ctx.JSON(http.StatusBadRequest, models.Response{
			StatusCode: http.StatusBadRequest,
			Message:    "invalid id",
		})
	}

	var req updateKehamilanRequest
	if err := ctx.Bind(&req); err != nil {
		return ctx.JSON(http.StatusBadRequest, models.Response{
			StatusCode: http.StatusBadRequest,
			Message:    err.Error(),
		})
	}

	existing, err := c.usecase.GetByID(int32(id))
	if err != nil {
		return ctx.JSON(http.StatusNotFound, models.Response{
			StatusCode: http.StatusNotFound,
			Message:    "Data tidak ditemukan",
		})
	}
	if req.BB_Awal > 0 {
		existing.BB_Awal = req.BB_Awal
	}
	if req.TB > 0 {
		existing.TB = req.TB
	}
	if req.Gravida != 0 {
		existing.Gravida = req.Gravida
	}
	if req.Paritas != 0 {
		existing.Paritas = req.Paritas
	}
	if req.Abortus != 0 {
		existing.Abortus = req.Abortus
	}
	if req.HPHT != "" {
		if t, err := time.Parse("2006-01-02", req.HPHT); err == nil {
			existing.HPHT = t
		}
	}
	if req.TaksiranPersalinan != "" {
		if t, err := time.Parse("2006-01-02", req.TaksiranPersalinan); err == nil {
			existing.TaksiranPersalinan = t
		}
	}
	if req.UKKehamilanSaatIni != 0 {
		existing.UKKehamilanSaatIni = req.UKKehamilanSaatIni
	}
	if req.JarakKehamilanSebelumnya != 0 {
		existing.JarakKehamilanSebelumnya = req.JarakKehamilanSebelumnya
	}
	if req.StatusKehamilan != "" {
		existing.StatusKehamilan = req.StatusKehamilan
	}

	if err := c.usecase.Update(existing); err != nil {
		return ctx.JSON(http.StatusInternalServerError, models.Response{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		})
	}

	return ctx.JSON(http.StatusOK, models.Response{
		StatusCode: http.StatusOK,
		Data:       existing,
	})
}

func (c *KehamilanController) Delete(ctx echo.Context) error {
	id, err := strconv.ParseInt(ctx.Param("id"), 10, 32)
	if err != nil {
		return ctx.JSON(http.StatusBadRequest, models.Response{
			StatusCode: http.StatusBadRequest,
			Message:    "invalid id",
		})
	}
	if err := c.usecase.Delete(int32(id)); err != nil {
		return ctx.JSON(http.StatusInternalServerError, models.Response{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		})
	}
	return ctx.JSON(http.StatusOK, models.Response{
		StatusCode: http.StatusOK,
		Message:    "deleted",
	})
}

// MODUL IBU
// func (c *KehamilanController) GetAktifForOrangtua(ctx echo.Context) error {
// 	claims, ok := ctx.Get("auth_claims").(*models.AuthClaims)
// 	if !ok || claims == nil {
// 		return ctx.JSON(http.StatusUnauthorized, models.Response{
// 			StatusCode: http.StatusUnauthorized,
// 			Message:    "Unauthorized",
// 		})
// 	}

// 	data, err := c.usecase.GetAktifByPhoneNumber(claims.PhoneNumber)
// 	if err != nil {
// 		return ctx.JSON(http.StatusNotFound, models.Response{
// 			StatusCode: http.StatusNotFound,
// 			Message:    "Data kehamilan aktif tidak ditemukan",
// 		})
// 	}

// 	return ctx.JSON(http.StatusOK, models.Response{
// 		StatusCode: http.StatusOK,
// 		Data:       data,
// 	})
// }

func (c *KehamilanController) GetAktifForOrangtua(ctx echo.Context) error {
	claims, ok := ctx.Get("auth_claims").(*models.AuthClaims)
	if !ok || claims == nil {
		return ctx.JSON(http.StatusUnauthorized, models.Response{
			StatusCode: http.StatusUnauthorized,
			Message:    "Unauthorized",
		})
	}

	data, err := c.usecase.GetAktifByUserID(claims.UserID)
	if err != nil {
		return ctx.JSON(http.StatusNotFound, models.Response{
			StatusCode: http.StatusNotFound,
			Message:    "Data kehamilan aktif tidak ditemukan",
		})
	}

	return ctx.JSON(http.StatusOK, models.Response{
		StatusCode: http.StatusOK,
		Data:       data,
	})
}
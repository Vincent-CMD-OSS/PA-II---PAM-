package controllers

import (
	"net/http"
	"strconv"
	"time"

	"monitoring-service/app/models"
	"monitoring-service/app/usecases"

	"github.com/labstack/echo/v4"
)

type PemeriksaanKehamilanController struct {
	usecase usecases.PemeriksaanKehamilanUsecase
}

func NewPemeriksaanKehamilanController(u usecases.PemeriksaanKehamilanUsecase) *PemeriksaanKehamilanController {
	return &PemeriksaanKehamilanController{usecase: u}
}

type createPemeriksaanKehamilanRequest struct {
	KehamilanID            int32   `json:"kehamilan_id"`
	Trimester              string  `json:"trimester"`
	KunjunganKe            int     `json:"kunjungan_ke"`
	TanggalPeriksa         string  `json:"tanggal_periksa"`
	TempatPeriksa          string  `json:"tempat_periksa"`
	BeratBadan             float64 `json:"berat_badan"`
	TinggiBadan            float64 `json:"tinggi_badan"`
	LingkarLenganAtas      float64 `json:"lingkar_lengan_atas"`
	TekananDarah           string  `json:"tekanan_darah"`
	TinggiRahim            float64 `json:"tinggi_rahim"`
	LetakDenyutJantungBayi string  `json:"letak_denyut_jantung_bayi"`
	StatusImunisasiTetanus string  `json:"status_imunisasi_tetanus"`
	Konseling              string  `json:"konseling"`
	SkriningDokter         string  `json:"skrining_dokter"`
	TabletTambahDarah      int     `json:"tablet_tambah_darah"`
	TesLabHb               float64 `json:"tes_lab_hb"`
	TesGolonganDarah       string  `json:"tes_golongan_darah"`
	TesLabProteinUrine     string  `json:"tes_lab_protein_urine"`
	TesLabGulaDarah        int     `json:"tes_lab_gula_darah"`
	USG                    string  `json:"usg"`
	TripelEliminasi        string  `json:"tripel_eliminasi"`
	TataLaksanaKasus       string  `json:"tata_laksana_kasus"`
}

type updatePemeriksaanKehamilanRequest struct {
	Trimester              string  `json:"trimester"`
	KunjunganKe            int     `json:"kunjungan_ke"`
	TanggalPeriksa         string  `json:"tanggal_periksa"`
	TempatPeriksa          string  `json:"tempat_periksa"`
	BeratBadan             float64 `json:"berat_badan"`
	TinggiBadan            float64 `json:"tinggi_badan"`
	LingkarLenganAtas      float64 `json:"lingkar_lengan_atas"`
	TekananDarah           string  `json:"tekanan_darah"`
	TinggiRahim            float64 `json:"tinggi_rahim"`
	LetakDenyutJantungBayi string  `json:"letak_denyut_jantung_bayi"`
	StatusImunisasiTetanus string  `json:"status_imunisasi_tetanus"`
	Konseling              string  `json:"konseling"`
	SkriningDokter         string  `json:"skrining_dokter"`
	TabletTambahDarah      int     `json:"tablet_tambah_darah"`
	TesLabHb               float64 `json:"tes_lab_hb"`
	TesGolonganDarah       string  `json:"tes_golongan_darah"`
	TesLabProteinUrine     string  `json:"tes_lab_protein_urine"`
	TesLabGulaDarah        int     `json:"tes_lab_gula_darah"`
	USG                    string  `json:"usg"`
	TripelEliminasi        string  `json:"tripel_eliminasi"`
	TataLaksanaKasus       string  `json:"tata_laksana_kasus"`
}

func (c *PemeriksaanKehamilanController) Create(ctx echo.Context) error {
	claims, ok := ctx.Get("auth_claims").(*models.AuthClaims)
	if !ok || claims == nil {
		return ctx.JSON(http.StatusUnauthorized, models.Response{
			StatusCode: http.StatusUnauthorized,
			Message:    "Unauthorized",
		})
	}

	var req createPemeriksaanKehamilanRequest
	if err := ctx.Bind(&req); err != nil {
		return ctx.JSON(http.StatusBadRequest, models.Response{
			StatusCode: http.StatusBadRequest,
			Message:    err.Error(),
		})
	}

	pemeriksaan := &models.PemeriksaanKehamilan{
		KehamilanID:            req.KehamilanID,
		Trimester:              req.Trimester,
		KunjunganKe:            req.KunjunganKe,
		TempatPeriksa:          req.TempatPeriksa,
		BeratBadan:             &req.BeratBadan,
		TinggiBadan:            &req.TinggiBadan,
		LingkarLenganAtas:      &req.LingkarLenganAtas,
		TekananDarah:           req.TekananDarah,
		TinggiRahim:            &req.TinggiRahim,
		LetakDenyutJantungBayi: req.LetakDenyutJantungBayi,
		StatusImunisasiTetanus: req.StatusImunisasiTetanus,
		Konseling:              req.Konseling,
		SkriningDokter:         req.SkriningDokter,
		TabletTambahDarah:      &req.TabletTambahDarah,
		TesLabHb:               &req.TesLabHb,
		TesGolonganDarah:       req.TesGolonganDarah,
		TesLabProteinUrine:     req.TesLabProteinUrine,
		TesLabGulaDarah:        &req.TesLabGulaDarah,
		USG:                    req.USG,
		TripelEliminasi:        req.TripelEliminasi,
		TataLaksanaKasus:       req.TataLaksanaKasus,
	}

	// Parse tanggal
	if req.TanggalPeriksa != "" {
		if t, err := time.Parse("2006-01-02", req.TanggalPeriksa); err == nil {
			pemeriksaan.TanggalPeriksa = &t
		}
	}

	if err := c.usecase.Create(pemeriksaan); err != nil {
		return ctx.JSON(http.StatusInternalServerError, models.Response{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		})
	}

	return ctx.JSON(http.StatusCreated, models.Response{
		StatusCode: http.StatusCreated,
		Data:       pemeriksaan,
	})
}

func (c *PemeriksaanKehamilanController) GetByID(ctx echo.Context) error {
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

func (c *PemeriksaanKehamilanController) GetByKehamilanID(ctx echo.Context) error {
	kehamilanID, err := strconv.ParseInt(ctx.QueryParam("kehamilan_id"), 10, 32)
	if err != nil {
		return ctx.JSON(http.StatusBadRequest, models.Response{
			StatusCode: http.StatusBadRequest,
			Message:    "kehamilan_id required",
		})
	}
	list, err := c.usecase.GetByKehamilanID(int32(kehamilanID))
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

func (c *PemeriksaanKehamilanController) Update(ctx echo.Context) error {
	id, err := strconv.ParseInt(ctx.Param("id"), 10, 32)
	if err != nil {
		return ctx.JSON(http.StatusBadRequest, models.Response{
			StatusCode: http.StatusBadRequest,
			Message:    "invalid id",
		})
	}

	var req updatePemeriksaanKehamilanRequest
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

	// Update field yang dikirim (hanya yang tidak zero value)
	if req.Trimester != "" {
		existing.Trimester = req.Trimester
	}
	if req.KunjunganKe != 0 {
		existing.KunjunganKe = req.KunjunganKe
	}
	if req.TanggalPeriksa != "" {
		if t, err := time.Parse("2006-01-02", req.TanggalPeriksa); err == nil {
			existing.TanggalPeriksa = &t
		}
	}
	if req.TempatPeriksa != "" {
		existing.TempatPeriksa = req.TempatPeriksa
	}
	if req.BeratBadan != 0 {
		existing.BeratBadan = &req.BeratBadan
	}
	if req.TinggiBadan != 0 {
		existing.TinggiBadan = &req.TinggiBadan
	}
	if req.LingkarLenganAtas != 0 {
		existing.LingkarLenganAtas = &req.LingkarLenganAtas
	}
	if req.TekananDarah != "" {
		existing.TekananDarah = req.TekananDarah
	}
	if req.TinggiRahim != 0 {
		existing.TinggiRahim = &req.TinggiRahim
	}
	if req.LetakDenyutJantungBayi != "" {
		existing.LetakDenyutJantungBayi = req.LetakDenyutJantungBayi
	}
	if req.StatusImunisasiTetanus != "" {
		existing.StatusImunisasiTetanus = req.StatusImunisasiTetanus
	}
	if req.Konseling != "" {
		existing.Konseling = req.Konseling
	}
	if req.SkriningDokter != "" {
		existing.SkriningDokter = req.SkriningDokter
	}
	if req.TabletTambahDarah != 0 {
		existing.TabletTambahDarah = &req.TabletTambahDarah
	}
	if req.TesLabHb != 0 {
		existing.TesLabHb = &req.TesLabHb
	}
	if req.TesGolonganDarah != "" {
		existing.TesGolonganDarah = req.TesGolonganDarah
	}
	if req.TesLabProteinUrine != "" {
		existing.TesLabProteinUrine = req.TesLabProteinUrine
	}
	if req.TesLabGulaDarah != 0 {
		existing.TesLabGulaDarah = &req.TesLabGulaDarah
	}
	if req.USG != "" {
		existing.USG = req.USG
	}
	if req.TripelEliminasi != "" {
		existing.TripelEliminasi = req.TripelEliminasi
	}
	if req.TataLaksanaKasus != "" {
		existing.TataLaksanaKasus = req.TataLaksanaKasus
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

func (c *PemeriksaanKehamilanController) Delete(ctx echo.Context) error {
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

// MODUL IBY
func (c *PemeriksaanKehamilanController) GetByIDForOrangtua(ctx echo.Context) error {
	id, err := strconv.ParseInt(ctx.Param("id"), 10, 32)
	if err != nil {
		return ctx.JSON(http.StatusBadRequest, models.Response{
			StatusCode: http.StatusBadRequest,
			Message:    "invalid id",
		})
	}

	claims, ok := ctx.Get("auth_claims").(*models.AuthClaims)
	if !ok || claims == nil {
		return ctx.JSON(http.StatusUnauthorized, models.Response{
			StatusCode: http.StatusUnauthorized,
			Message:    "token tidak valid",
		})
	}

	data, err := c.usecase.GetByIDForOrangtua(int32(id), claims.UserID)
	if err != nil {
		return ctx.JSON(http.StatusForbidden, models.Response{
			StatusCode: http.StatusForbidden,
			Message:    err.Error(),
		})
	}

	return ctx.JSON(http.StatusOK, models.Response{
		StatusCode: http.StatusOK,
		Data:       data,
	})
}

// MODUL IBU
func (c *PemeriksaanKehamilanController) GetMine(ctx echo.Context) error {
	claims, ok := ctx.Get("auth_claims").(*models.AuthClaims)
	if !ok || claims == nil {
		return ctx.JSON(http.StatusUnauthorized, models.Response{
			StatusCode: http.StatusUnauthorized,
			Message:    "token tidak valid",
		})
	}

	data, err := c.usecase.GetMine(claims.UserID)
	if err != nil {
		return ctx.JSON(http.StatusInternalServerError, models.Response{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		})
	}

	return ctx.JSON(http.StatusOK, models.Response{
		StatusCode: http.StatusOK,
		Data:       data,
	})
}
package usecases

import (
	"monitoring-service/app/models"
	"strings"
)

func GeneratePenjelasanSingle(
	current *models.GrafikEvaluasiKehamilan,
	history []models.GrafikEvaluasiKehamilan,
) (string, string) {

	var result []string
	score := 0

	// ======================
	// 1. TFU vs USIA
	// ======================
	if current.UsiaGestasiMinggu != nil && current.TinggiFundusUteriCm != nil {
		usia := float64(*current.UsiaGestasiMinggu)
		tfu := *current.TinggiFundusUteriCm
		selisih := tfu - usia

		switch {
		case selisih >= -2 && selisih <= 2:
			result = append(result, "TFU sesuai usia kehamilan")
		case selisih < -2:
			result = append(result, "TFU lebih kecil dari usia kehamilan (curiga IUGR)")
			score += 2
		default:
			result = append(result, "TFU lebih besar dari usia kehamilan")
			score++
		}
	}

	// ======================
	// 2. TREND TFU
	// ======================
	if len(history) > 0 {
		last := history[len(history)-1] // pastikan repo sudah ORDER ASC

		if last.TinggiFundusUteriCm != nil && current.TinggiFundusUteriCm != nil {
			diff := *current.TinggiFundusUteriCm - *last.TinggiFundusUteriCm

			if diff < 1 {
				result = append(result, "Kenaikan TFU lambat")
				score += 2
			} else if diff > 3 {
				result = append(result, "Kenaikan TFU cepat")
				score++
			} else {
				result = append(result, "Kenaikan TFU normal")
			}
		}
	}

	// ======================
	// 3. DJJ
	// ======================
	if current.DenyutJantungBayiXMenit != nil {
		djj := *current.DenyutJantungBayiXMenit

		switch {
		case djj < 110:
			result = append(result, "DJJ rendah (bradikardi)")
			score += 3
		case djj > 160:
			result = append(result, "DJJ tinggi (takikardi)")
			score += 3
		default:
			result = append(result, "DJJ normal")
		}
	}

	// ======================
	// 4. TEKANAN DARAH
	// ======================
	hipertensi := false
	if current.TekananDarahSistole != nil && current.TekananDarahDiastole != nil {
		if *current.TekananDarahSistole >= 140 || *current.TekananDarahDiastole >= 90 {
			result = append(result, "Hipertensi")
			score += 3
			hipertensi = true
		}
	}

	// ======================
	// 5. URIN PROTEIN
	// ======================
	proteinPositif := false
	if current.UrinProtein != nil {
		val := strings.ToLower(*current.UrinProtein)
		if val == "positif" {
			result = append(result, "Protein urin positif")
			proteinPositif = true
		}
	}

	// ======================
	// 6. KOMBINASI (PREEKLAMPSIA)
	// ======================
	if hipertensi && proteinPositif {
		result = append(result, "Curiga preeklampsia")
		score += 4
	}

	// ======================
	// 7. HB
	// ======================
	if current.Hemoglobin != nil && *current.Hemoglobin < 11 {
		result = append(result, "Anemia")
		score++
	}

	// ======================
	// 8. GERAKAN JANIN
	// ======================
	if current.GerakanBayi != nil {
		val := strings.ToLower(*current.GerakanBayi)
		if val == "kurang" {
			result = append(result, "Gerakan janin berkurang")
			score += 2
		}
	}

	// ======================
	// 9. RISK LEVEL
	// ======================
	risk := "rendah"
	if score >= 6 {
		risk = "tinggi"
	} else if score >= 3 {
		risk = "sedang"
	}

	// ======================
	// DEFAULT
	// ======================
	if len(result) == 0 {
		return "Kondisi ibu dan janin dalam batas normal", risk
	}

	return strings.Join(result, ". ") + ".", risk
}
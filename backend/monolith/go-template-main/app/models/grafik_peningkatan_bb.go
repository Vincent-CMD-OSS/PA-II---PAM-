package models

type GrafikPeningkatanBB struct {
	ID                    int32      `gorm:"primaryKey" json:"id"`
	KehamilanID           int32      `gorm:"not null;index" json:"kehamilan_id"`
	Kehamilan             *Kehamilan `gorm:"foreignKey:KehamilanID;references:ID" json:"kehamilan,omitempty"`
	BeratBadan            *float64   `gorm:"type:decimal(4,1)" json:"berat_badan"`
	MingguKehamilan       *int       `json:"minggu_kehamilan"`
	PenjelasanHasilGrafik string     `json:"penjelasan_hasil_grafik"`	
	// IMT_Mingguan          float64    `gorm:"type:decimal(4,1)" json:"imt_mingguan"`

}

func (GrafikPeningkatanBB) TableName() string {
	return "grafik_peningkatan_bb"
}

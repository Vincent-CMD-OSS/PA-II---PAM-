// src/pages/Ibu/PemeriksaanKehamilanForm.jsx
import React, { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import MainLayout from "../../components/Layout/MainLayout";
import { getKehamilanByIbuId } from "../../services/kehamilan";
import { 
  getPemeriksaanKehamilanById, 
  createPemeriksaanKehamilan, 
  updatePemeriksaanKehamilan 
} from "../../services/pemeriksaanKehamilan";
import { Save, ArrowLeft, Loader2, ClipboardCheck, Activity, Beaker } from "lucide-react";

export default function PemeriksaanKehamilanForm() {
  const { id, periksaId } = useParams(); // id = IbuId, periksaId = ANC record ID
  const navigate = useNavigate();
  const isEdit = periksaId !== "baru";

  const [kehamilan, setKehamilan] = useState(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  const [form, setForm] = useState({
    trimester: "T1",
    kunjungan_ke: 1,
    tanggal_periksa: "",
    tempat_periksa: "",
    berat_badan: "",
    tinggi_badan: "",
    lingkar_lengan_atas: "",
    tekanan_darah: "",
    tinggi_rahim: "",
    letak_denyut_jantung_bayi: "",
    status_imunisasi_tetanus: "T1",
    konseling: "",
    skrining_dokter: "",
    tablet_tambah_darah: "",
    tes_lab_hb: "",
    tes_golongan_darah: "",
    tes_lab_protein_urine: "Negatif",
    tes_lab_gula_darah: "",
    usg: "",
    tripel_eliminasi: "NonReaktif",
    tata_laksana_kasus: "",
  });

  useEffect(() => {
    const fetchData = async () => {
      try {
        const kehamilanList = await getKehamilanByIbuId(id);
        if (kehamilanList.length > 0) {
          const aktif = kehamilanList[0];
          setKehamilan(aktif);

          if (isEdit) {
            const data = await getPemeriksaanKehamilanById(periksaId);
            setForm({
              trimester: data.trimester || "T1",
              kunjungan_ke: data.kunjungan_ke || 1,
              tanggal_periksa: data.tanggal_periksa ? data.tanggal_periksa.split("T")[0] : "",
              tempat_periksa: data.tempat_periksa || "",
              berat_badan: data.berat_badan || "",
              tinggi_badan: data.tinggi_badan || "",
              lingkar_lengan_atas: data.lingkar_lengan_atas || "",
              tekanan_darah: data.tekanan_darah || "",
              tinggi_rahim: data.tinggi_rahim || "",
              letak_denyut_jantung_bayi: data.letak_denyut_jantung_bayi || "",
              status_imunisasi_tetanus: data.status_imunisasi_tetanus || "T1",
              konseling: data.konseling || "",
              skrining_dokter: data.skrining_dokter || "",
              tablet_tambah_darah: data.tablet_tambah_darah || "",
              tes_lab_hb: data.tes_lab_hb || "",
              tes_golongan_darah: data.tes_golongan_darah || "",
              tes_lab_protein_urine: data.tes_lab_protein_urine || "Negatif",
              tes_lab_gula_darah: data.tes_lab_gula_darah || "",
              usg: data.usg || "",
              tripel_eliminasi: data.tripel_eliminasi || "NonReaktif",
              tata_laksana_kasus: data.tata_laksana_kasus || "",
            });
          }
        }
      } catch (err) {
        console.error("Gagal memuat data:", err);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, [id, periksaId, isEdit]);

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    setForm({ ...form, [name]: type === "checkbox" ? checked : value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!kehamilan) return;
    setSaving(true);
    try {
      const payload = {
        ...form,
        kehamilan_id: kehamilan.id,
        kunjungan_ke: parseInt(form.kunjungan_ke) || 0,
        berat_badan: parseFloat(form.berat_badan) || 0,
        tinggi_badan: parseFloat(form.tinggi_badan) || 0,
        lingkar_lengan_atas: parseFloat(form.lingkar_lengan_atas) || 0,
        tinggi_rahim: parseFloat(form.tinggi_rahim) || 0,
        tablet_tambah_darah: parseInt(form.tablet_tambah_darah) || 0,
        tes_lab_hb: parseFloat(form.tes_lab_hb) || 0,
        tes_lab_gula_darah: parseInt(form.tes_lab_gula_darah) || 0,
      };

      if (isEdit) {
        await updatePemeriksaanKehamilan(periksaId, payload);
        alert("Pemeriksaan ANC berhasil diperbarui");
      } else {
        await createPemeriksaanKehamilan(payload);
        alert("Pemeriksaan ANC berhasil disimpan");
      }
      navigate(`/data-ibu/${id}/pemeriksaan-rutin`);
    } catch (err) {
      console.error(err);
      alert("Gagal menyimpan data pemeriksaan");
    } finally {
      setSaving(false);
    }
  };

  if (loading) return <MainLayout><div className="p-6 text-center">Memuat...</div></MainLayout>;

  return (
    <MainLayout>
      <div className="p-6 max-w-5xl mx-auto">
        <div className="flex items-center gap-4 mb-6">
          <button onClick={() => navigate(-1)} className="p-3 bg-white rounded-full shadow-sm hover:shadow-md transition-all text-gray-600 hover:text-indigo-600">
            <ArrowLeft size={24} />
          </button>
          <div>
            <h1 className="text-3xl font-extrabold text-gray-900 tracking-tight">{isEdit ? "Edit" : "Input"} Pemeriksaan ANC</h1>
            <p className="text-gray-500 text-lg">Standar Pelayanan KIA 2024</p>
          </div>
        </div>

        <form onSubmit={handleSubmit} className="space-y-6">
          {/* 1. Informasi Kunjungan */}
          <div className="bg-white/80 backdrop-blur-xl rounded-2xl shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-white/50 p-8 transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.08)]">
            <div className="flex items-center gap-3 mb-6 border-b border-indigo-100 pb-4">
              <div className="bg-indigo-100 p-2 rounded-lg text-indigo-600"><ClipboardCheck size={24} /></div>
              <h2 className="text-xl font-bold text-indigo-900">Informasi Kunjungan</h2>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">Kunjungan Ke-</label>
                <select name="kunjungan_ke" value={form.kunjungan_ke} onChange={handleChange} className="w-full border-gray-300 rounded-xl shadow-sm focus:border-indigo-500 focus:ring-indigo-500 px-4 py-3 bg-white">
                  {[1, 2, 3, 4, 5, 6].map(n => <option key={n} value={n}>{n}</option>)}
                </select>
              </div>
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">Trimester</label>
                <select name="trimester" value={form.trimester} onChange={handleChange} className="w-full border-gray-300 rounded-xl shadow-sm focus:border-indigo-500 focus:ring-indigo-500 px-4 py-3 bg-white">
                  <option value="T1">Trimester 1</option>
                  <option value="T2">Trimester 2</option>
                  <option value="T3">Trimester 3</option>
                </select>
              </div>
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">Tanggal Periksa</label>
                <input type="date" name="tanggal_periksa" value={form.tanggal_periksa} onChange={handleChange} className="w-full border-gray-300 rounded-xl shadow-sm focus:border-indigo-500 focus:ring-indigo-500 px-4 py-3 bg-white" required />
              </div>
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">Tempat Periksa</label>
                <input name="tempat_periksa" value={form.tempat_periksa} onChange={handleChange} className="w-full border-gray-300 rounded-xl shadow-sm focus:border-indigo-500 focus:ring-indigo-500 px-4 py-3 bg-white" placeholder="Nama Faskes" />
              </div>
            </div>
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            {/* 2. Pemeriksaan Fisik */}
            <div className="bg-white/80 backdrop-blur-xl rounded-2xl shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-white/50 p-8 transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.08)]">
              <div className="flex items-center gap-3 mb-6 border-b border-indigo-100 pb-4">
                <div className="bg-indigo-100 p-2 rounded-lg text-indigo-600"><Activity size={24} /></div>
                <h2 className="text-xl font-bold text-indigo-900">Pemeriksaan Fisik</h2>
              </div>
              <div className="grid grid-cols-2 gap-5">
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">Berat Badan (kg)</label>
                  <input type="number" step="0.1" name="berat_badan" value={form.berat_badan} onChange={handleChange} className="w-full border-gray-300 rounded-xl shadow-sm focus:border-indigo-500 focus:ring-indigo-500 px-4 py-3 bg-gray-50" />
                </div>
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">Tekanan Darah</label>
                  <input name="tekanan_darah" value={form.tekanan_darah} onChange={handleChange} className="w-full border-gray-300 rounded-xl shadow-sm focus:border-indigo-500 focus:ring-indigo-500 px-4 py-3 bg-gray-50" placeholder="120/80" />
                </div>
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">Tinggi Badan (cm)</label>
                  <input type="number" step="0.1" name="tinggi_badan" value={form.tinggi_badan} onChange={handleChange} className="w-full border-gray-300 rounded-xl shadow-sm focus:border-indigo-500 focus:ring-indigo-500 px-4 py-3 bg-gray-50" />
                </div>
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">LILA (cm)</label>
                  <input type="number" step="0.1" name="lingkar_lengan_atas" value={form.lingkar_lengan_atas} onChange={handleChange} className="w-full border-gray-300 rounded-xl shadow-sm focus:border-indigo-500 focus:ring-indigo-500 px-4 py-3 bg-gray-50" />
                </div>
                <div className="col-span-2">
                  <label className="block text-sm font-semibold text-gray-700 mb-2">Tinggi Rahim (TFU cm)</label>
                  <input type="number" step="0.1" name="tinggi_rahim" value={form.tinggi_rahim} onChange={handleChange} className="w-full border-gray-300 rounded-xl shadow-sm focus:border-indigo-500 focus:ring-indigo-500 px-4 py-3 bg-gray-50" />
                </div>
                <div className="col-span-2">
                  <label className="block text-sm font-semibold text-gray-700 mb-2">Letak & DJJ Bayi</label>
                  <input name="letak_denyut_jantung_bayi" value={form.letak_denyut_jantung_bayi} onChange={handleChange} className="w-full border-gray-300 rounded-xl shadow-sm focus:border-indigo-500 focus:ring-indigo-500 px-4 py-3 bg-gray-50" placeholder="Letak kepala, DJJ 140x/mnt" />
                </div>
              </div>
            </div>

            {/* 3. Pemeriksaan Laboratorium */}
            <div className="bg-white/80 backdrop-blur-xl rounded-2xl shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-white/50 p-8 transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.08)]">
              <div className="flex items-center gap-3 mb-6 border-b border-indigo-100 pb-4">
                <div className="bg-indigo-100 p-2 rounded-lg text-indigo-600"><Beaker size={24} /></div>
                <h2 className="text-xl font-bold text-indigo-900">Laboratorium & Tindakan</h2>
              </div>
              <div className="grid grid-cols-2 gap-5">
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">Kadar Hb (g/dL)</label>
                  <input type="number" step="0.1" name="tes_lab_hb" value={form.tes_lab_hb} onChange={handleChange} className="w-full border-gray-300 rounded-xl shadow-sm focus:border-indigo-500 focus:ring-indigo-500 px-4 py-3 bg-gray-50" />
                </div>
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">Protein Urine</label>
                  <select name="tes_lab_protein_urine" value={form.tes_lab_protein_urine} onChange={handleChange} className="w-full border-gray-300 rounded-xl shadow-sm focus:border-indigo-500 focus:ring-indigo-500 px-4 py-3 bg-gray-50">
                    <option value="Negatif">Negatif (-)</option>
                    <option value="Positif 1">Positif 1 (+)</option>
                    <option value="Positif 2">Positif 2 (++)</option>
                    <option value="Positif 3">Positif 3 (+++)</option>
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">Triple Eliminasi</label>
                  <select name="tripel_eliminasi" value={form.tripel_eliminasi} onChange={handleChange} className="w-full border-gray-300 rounded-xl shadow-sm focus:border-indigo-500 focus:ring-indigo-500 px-4 py-3 bg-gray-50">
                    <option value="NonReaktif">Non-Reaktif</option>
                    <option value="Reak HIV">Reaktif (HIV)</option>
                    <option value="Reak Sif">Reaktif (Sifilis)</option>
                    <option value="Reak HBsAg">Reaktif (HBsAg)</option>
                    <option value="Reak Multi">Reaktif Multi</option>
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">Gula Darah</label>
                  <input type="number" name="tes_lab_gula_darah" value={form.tes_lab_gula_darah} onChange={handleChange} className="w-full border-gray-300 rounded-xl shadow-sm focus:border-indigo-500 focus:ring-indigo-500 px-4 py-3 bg-gray-50" />
                </div>
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">Status Imunisasi TT</label>
                  <select name="status_imunisasi_tetanus" value={form.status_imunisasi_tetanus} onChange={handleChange} className="w-full border-gray-300 rounded-xl shadow-sm focus:border-indigo-500 focus:ring-indigo-500 px-4 py-3 bg-gray-50">
                    {["T1", "T2", "T3", "T4", "T5"].map(t => <option key={t}>{t}</option>)}
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">Tab. Tambah Darah</label>
                  <input type="number" name="tablet_tambah_darah" value={form.tablet_tambah_darah} onChange={handleChange} className="w-full border-gray-300 rounded-xl shadow-sm focus:border-indigo-500 focus:ring-indigo-500 px-4 py-3 bg-gray-50" />
                </div>
              </div>
            </div>
          </div>

          {/* 4. Konseling & Tata Laksana */}
          <div className="bg-white/80 backdrop-blur-xl rounded-2xl shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-white/50 p-8 transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.08)] space-y-6">
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">Konseling / Temuan Skrining Dokter</label>
              <textarea name="konseling" value={form.konseling} onChange={handleChange} className="w-full border-gray-300 rounded-xl shadow-sm focus:border-indigo-500 focus:ring-indigo-500 px-4 py-4 bg-gray-50" rows="3" placeholder="Hasil edukasi atau temuan pemeriksaan kesehatan..."></textarea>
            </div>
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">Tata Laksana Kasus</label>
              <textarea name="tata_laksana_kasus" value={form.tata_laksana_kasus} onChange={handleChange} className="w-full border-gray-300 rounded-xl shadow-sm focus:border-indigo-500 focus:ring-indigo-500 px-4 py-4 bg-gray-50" rows="3" placeholder="Tindakan medik atau obat yang diberikan..."></textarea>
            </div>
          </div>

          <div className="flex gap-4 pt-4 pb-12">
            <button 
              type="submit" 
              disabled={saving}
              className="flex-1 bg-gradient-to-r from-indigo-600 to-indigo-700 text-white font-bold py-4 rounded-xl shadow-lg hover:shadow-indigo-500/30 transform transition-all hover:-translate-y-1 flex items-center justify-center gap-3 text-lg"
            >
              {saving ? <Loader2 className="animate-spin" size={24} /> : <Save size={24} />}
              {saving ? "Sedang Menyimpan..." : "Simpan Data ANC"}
            </button>
            <button 
              type="button"
              onClick={() => navigate(-1)}
              className="px-10 bg-white border border-gray-200 text-gray-700 font-bold py-4 rounded-xl shadow-sm hover:bg-gray-50 transition-all text-lg"
            >
              Batal
            </button>
          </div>
        </form>
      </div>
    </MainLayout>
  );
}

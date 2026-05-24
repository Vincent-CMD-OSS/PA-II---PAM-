// src/pages/Ibu/SkriningDMGestasional.jsx
import React, { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import MainLayout from "../../components/Layout/MainLayout";
import { getKehamilanByIbuId } from "../../services/kehamilan";
import { getSkriningDMByKehamilanId, createSkriningDM, updateSkriningDM } from "../../services/rujukanService";
import { Save, ArrowLeft, Loader2 } from "lucide-react";

export default function SkriningDMGestasional() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [kehamilan, setKehamilan] = useState(null);
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  const [form, setForm] = useState({
    gula_darah_puasa_hasil: "",
    gula_darah_puasa_rencana_tindak_lanjut: "",
    gula_darah_2_jam_post_prandial_hasil: "",
    gula_darah_2_jam_post_prandial_rencana_tindak_lanjut: "",
  });

  useEffect(() => {
    const fetchData = async () => {
      try {
        const kehamilanList = await getKehamilanByIbuId(id);
        if (kehamilanList.length > 0) {
          const aktif = kehamilanList[0];
          setKehamilan(aktif);
          const result = await getSkriningDMByKehamilanId(aktif.id);
          if (result && result.length > 0) {
            const d = result[0];
            setData(d);
            setForm({
              gula_darah_puasa_hasil: d.gula_darah_puasa_hasil || "",
              gula_darah_puasa_rencana_tindak_lanjut: d.gula_darah_puasa_rencana_tindak_lanjut || "",
              gula_darah_2_jam_post_prandial_hasil: d.gula_darah_2_jam_post_prandial_hasil || "",
              gula_darah_2_jam_post_prandial_rencana_tindak_lanjut: d.gula_darah_2_jam_post_prandial_rencana_tindak_lanjut || "",
            });
          }
        }
      } catch (err) {
        console.error(err);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, [id]);

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!kehamilan) return;
    setSaving(true);
    try {
      const payload = {
        kehamilan_id: kehamilan.id,
        gula_darah_puasa_hasil: parseFloat(form.gula_darah_puasa_hasil) || null,
        gula_darah_puasa_rencana_tindak_lanjut: form.gula_darah_puasa_rencana_tindak_lanjut,
        gula_darah_2_jam_post_prandial_hasil: parseFloat(form.gula_darah_2_jam_post_prandial_hasil) || null,
        gula_darah_2_jam_post_prandial_rencana_tindak_lanjut: form.gula_darah_2_jam_post_prandial_rencana_tindak_lanjut,
      };

      if (data) {
        await updateSkriningDM(data.id_skrining_dm, payload);
      } else {
        await createSkriningDM(payload);
      }
      alert("Skrining DM Gestasional berhasil disimpan");
    } catch (err) {
      console.error(err);
      alert("Gagal menyimpan data skrining DM");
    } finally {
      setSaving(false);
    }
  };

  if (loading) return <MainLayout><div className="p-6">Memuat...</div></MainLayout>;

  return (
    <MainLayout>
      <div className="p-6 max-w-4xl mx-auto">
        <div className="flex items-center gap-4 mb-6">
          <button onClick={() => navigate(-1)} className="p-2 rounded-full hover:bg-gray-100">
            <ArrowLeft size={20} />
          </button>
          <div>
            <h1 className="text-2xl font-bold">Skrining DM Gestasional</h1>
            <p className="text-gray-500">Pemeriksaan profil glukosa untuk mendeteksi diabetes melitus gestasional.</p>
          </div>
        </div>

        <form onSubmit={handleSubmit} className="bg-white rounded-xl shadow-sm p-6 space-y-6">
          
          <div className="bg-indigo-50 border border-indigo-100 p-4 rounded-lg mb-6">
            <h2 className="text-lg font-semibold text-indigo-800 mb-2">Test Toleransi Glukosa Oral (TTGO)</h2>
            <p className="text-sm text-indigo-700">Dilakukan umumnya pada usia kehamilan 24-28 minggu atau jika terdapat faktor risiko (misal: riwayat keluarga DM, obesitas, riwayat melahirkan bayi besar &gt;4000g, atau riwayat abortus berulang).</p>
          </div>

          <div className="space-y-6">
            <div>
              <h3 className="font-semibold mb-3 text-gray-800">1. Gula Darah Puasa (GDP)</h3>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                  <label className="block text-sm font-medium mb-1">Hasil (mg/dL)</label>
                  <input 
                    type="number" 
                    step="0.1" 
                    name="gula_darah_puasa_hasil" 
                    value={form.gula_darah_puasa_hasil} 
                    onChange={handleChange} 
                    className="w-full border rounded-lg px-3 py-2" 
                    placeholder="Contoh: 90" 
                  />
                </div>
                <div className="md:col-span-2">
                  <label className="block text-sm font-medium mb-1">Rencana Tindak Lanjut</label>
                  <input 
                    name="gula_darah_puasa_rencana_tindak_lanjut" 
                    value={form.gula_darah_puasa_rencana_tindak_lanjut} 
                    onChange={handleChange} 
                    className="w-full border rounded-lg px-3 py-2" 
                    placeholder="Tindakan yang akan dilakukan berdasarkan hasil" 
                  />
                </div>
              </div>
              <p className="text-xs text-gray-500 mt-1">Nilai rujukan normal: {"< 92 mg/dL"}</p>
            </div>

            <div className="border-t pt-4">
              <h3 className="font-semibold mb-3 text-gray-800">2. Gula Darah 2 Jam Post Prandial (TTGO 75g)</h3>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                  <label className="block text-sm font-medium mb-1">Hasil (mg/dL)</label>
                  <input 
                    type="number" 
                    step="0.1" 
                    name="gula_darah_2_jam_post_prandial_hasil" 
                    value={form.gula_darah_2_jam_post_prandial_hasil} 
                    onChange={handleChange} 
                    className="w-full border rounded-lg px-3 py-2" 
                    placeholder="Contoh: 140" 
                  />
                </div>
                <div className="md:col-span-2">
                  <label className="block text-sm font-medium mb-1">Rencana Tindak Lanjut</label>
                  <input 
                    name="gula_darah_2_jam_post_prandial_rencana_tindak_lanjut" 
                    value={form.gula_darah_2_jam_post_prandial_rencana_tindak_lanjut} 
                    onChange={handleChange} 
                    className="w-full border rounded-lg px-3 py-2" 
                    placeholder="Tindakan yang akan dilakukan berdasarkan hasil" 
                  />
                </div>
              </div>
              <p className="text-xs text-gray-500 mt-1">Nilai rujukan normal 2 jam setelah minum glukosa: {"< 153 mg/dL"}</p>
            </div>
          </div>

          <div className="flex gap-3 pt-4 border-t mt-6">
            <button type="button" onClick={() => navigate(-1)} className="px-6 py-2 border rounded-lg hover:bg-gray-50 transition-colors">
              Batal
            </button>
            <button 
              type="submit" 
              disabled={saving} 
              className="bg-indigo-600 text-white px-6 py-2 rounded-lg flex items-center gap-2 hover:bg-indigo-700 transition-colors"
            >
              {saving ? <Loader2 className="animate-spin" size={18} /> : <Save size={18} />}
              {saving ? "Menyimpan..." : "Simpan Data Skrining"}
            </button>
          </div>
        </form>
      </div>
    </MainLayout>
  );
}

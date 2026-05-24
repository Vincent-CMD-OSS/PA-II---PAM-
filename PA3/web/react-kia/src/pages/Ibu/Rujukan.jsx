// src/pages/Ibu/Rujukan.jsx
import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import MainLayout from "../../components/Layout/MainLayout";
import { getKehamilanByIbuId } from "../../services/kehamilan";
import { getRujukanByKehamilanId, createRujukan, updateRujukan } from "../../services/rujukanService";
import { Save } from "lucide-react";

export default function Rujukan() {
  const { id } = useParams();
  const [kehamilan, setKehamilan] = useState(null);
  const [data, setData] = useState(null);
  const [form, setForm] = useState({
    rujukan_resume_pemeriksaan_tatalaksana: "",
    rujukan_diagnosis_akhir: "",
    rujukan_alasan_dirujuk_ke_fkrtl: "",
    rujukan_balik_tanggal: "",
    rujukan_balik_diagnosis_akhir: "",
    rujukan_balik_resume_pemeriksaan_tatalaksana: "",
    anjuran_rekomendasi_tempat_melahirkan: "",
  });
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const kehamilanList = await getKehamilanByIbuId(id);
        if (kehamilanList.length > 0) {
          const aktif = kehamilanList[0];
          setKehamilan(aktif);
          const result = await getRujukanByKehamilanId(aktif.id);
          if (result && result.length > 0) {
            const d = result[0];
            setData(d);
            setForm({
              rujukan_resume_pemeriksaan_tatalaksana: d.rujukan_resume_pemeriksaan_tatalaksana || "",
              rujukan_diagnosis_akhir: d.rujukan_diagnosis_akhir || "",
              rujukan_alasan_dirujuk_ke_fkrtl: d.rujukan_alasan_dirujuk_ke_fkrtl || "",
              rujukan_balik_tanggal: d.rujukan_balik_tanggal ? new Date(d.rujukan_balik_tanggal).toISOString().split("T")[0] : "",
              rujukan_balik_diagnosis_akhir: d.rujukan_balik_diagnosis_akhir || "",
              rujukan_balik_resume_pemeriksaan_tatalaksana: d.rujukan_balik_resume_pemeriksaan_tatalaksana || "",
              anjuran_rekomendasi_tempat_melahirkan: d.anjuran_rekomendasi_tempat_melahirkan || "",
            });
          }
        }
      } catch (err) { console.error(err); }
      finally { setLoading(false); }
    };
    fetchData();
  }, [id]);

  const handleChange = (e) => setForm({ ...form, [e.target.name]: e.target.value });

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!kehamilan) return;
    setSaving(true);
    try {
      const payload = { ...form, kehamilan_id: kehamilan.id };
      if (data) await updateRujukan(data.id_rujukan, payload);
      else await createRujukan(payload);
      alert("Data rujukan berhasil disimpan");
    } catch (err) { alert("Gagal menyimpan rujukan"); console.error(err); }
    finally { setSaving(false); }
  };

  if (loading) return <MainLayout><div className="p-6">Memuat...</div></MainLayout>;

  return (
    <MainLayout>
      <div className="p-6 max-w-5xl mx-auto">
        <h1 className="text-2xl font-bold mb-2">Rujukan</h1>
        <p className="text-gray-500 mb-6">Dokumentasi rujukan ke FKRTL dan rujukan balik.</p>
        <form onSubmit={handleSubmit} className="bg-white rounded-xl shadow-sm p-6 space-y-6">
          <div>
            <h3 className="font-semibold mb-3 text-indigo-700">Rujukan ke FKRTL</h3>
            <div className="space-y-4">
              <div><label className="block text-sm font-medium mb-1">Resume Pemeriksaan & Tatalaksana</label><textarea name="rujukan_resume_pemeriksaan_tatalaksana" value={form.rujukan_resume_pemeriksaan_tatalaksana} onChange={handleChange} className="w-full border rounded-lg px-3 py-2" rows="3" /></div>
              <div><label className="block text-sm font-medium mb-1">Diagnosis Akhir</label><input name="rujukan_diagnosis_akhir" value={form.rujukan_diagnosis_akhir} onChange={handleChange} className="w-full border rounded-lg px-3 py-2" /></div>
              <div><label className="block text-sm font-medium mb-1">Alasan Dirujuk ke FKRTL</label><textarea name="rujukan_alasan_dirujuk_ke_fkrtl" value={form.rujukan_alasan_dirujuk_ke_fkrtl} onChange={handleChange} className="w-full border rounded-lg px-3 py-2" rows="3" /></div>
            </div>
          </div>
          <div>
            <h3 className="font-semibold mb-3 text-indigo-700">Rujukan Balik</h3>
            <div className="space-y-4">
              <div><label className="block text-sm font-medium mb-1">Tanggal Rujukan Balik</label><input type="date" name="rujukan_balik_tanggal" value={form.rujukan_balik_tanggal} onChange={handleChange} className="w-full max-w-xs border rounded-lg px-3 py-2" /></div>
              <div><label className="block text-sm font-medium mb-1">Diagnosis Akhir</label><input name="rujukan_balik_diagnosis_akhir" value={form.rujukan_balik_diagnosis_akhir} onChange={handleChange} className="w-full border rounded-lg px-3 py-2" /></div>
              <div><label className="block text-sm font-medium mb-1">Resume Pemeriksaan & Tatalaksana</label><textarea name="rujukan_balik_resume_pemeriksaan_tatalaksana" value={form.rujukan_balik_resume_pemeriksaan_tatalaksana} onChange={handleChange} className="w-full border rounded-lg px-3 py-2" rows="3" /></div>
            </div>
          </div>
          <div>
            <h3 className="font-semibold mb-3 text-indigo-700">Anjuran</h3>
            <div><label className="block text-sm font-medium mb-1">Rekomendasi Tempat Melahirkan</label><input name="anjuran_rekomendasi_tempat_melahirkan" value={form.anjuran_rekomendasi_tempat_melahirkan} onChange={handleChange} className="w-full border rounded-lg px-3 py-2" /></div>
          </div>
          <button type="submit" disabled={saving} className="bg-indigo-600 text-white px-6 py-2 rounded-lg flex items-center gap-2">
            <Save size={18} /> {saving ? "Menyimpan..." : "Simpan Rujukan"}
          </button>
        </form>
      </div>
    </MainLayout>
  );
}

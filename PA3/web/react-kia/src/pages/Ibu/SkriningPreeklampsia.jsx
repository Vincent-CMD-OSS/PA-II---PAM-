// src/pages/Ibu/SkriningPreeklampsia.jsx
import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import MainLayout from "../../components/Layout/MainLayout";
import { getKehamilanByIbuId } from "../../services/kehamilan";
import { getSkriningByKehamilanId, createSkrining, updateSkrining } from "../../services/skrining";
import { AlertCircle, Save, ArrowRight, ShieldAlert, CheckCircle2 } from "lucide-react";
import { useNavigate } from "react-router-dom";

export default function SkriningPreeklampsia() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [kehamilan, setKehamilan] = useState(null);
  const [skrining, setSkrining] = useState(null);
  const [form, setForm] = useState({
    anamnesis_multipara_pasangan_baru_sedang: false,
    anamnesis_teknologi_reproduksi_berbantu_sedang: false,
    anamnesis_umur_diatas_35_tahun_sedang: false,
    anamnesis_nulipara_sedang: false,
    anamnesis_jarak_kehamilan_diatas_10_tahun_sedang: false,
    anamnesis_riwayat_preeklampsia_keluarga_sedang: false,
    anamnesis_obesitas_imt_diatas_30_sedang: false,
    anamnesis_riwayat_preeklampsia_sebelumnya_tinggi: false,
    anamnesis_kehamilan_multipel_tinggi: false,
    anamnesis_diabetes_dalam_kehamilan_tinggi: false,
    anamnesis_hipertensi_kronik_tinggi: false,
    anamnesis_penyakit_ginjal_tinggi: false,
    anamnesis_penyakit_autoimun_sle_tinggi: false,
    anamnesis_anti_phospholipid_syndrome_tinggi: false,
    fisik_map_diatas_90_mmhg: false,
    fisik_proteinuria_urin_celup: false,
    kesimpulan: "",
    gula_darah_puasa_hasil: "",
    gula_darah_puasa_rencana: "",
    gula_darah_2_jam_post_prandial_hasil: "",
    gula_darah_2_jam_post_prandial_rencana: "",
  });
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    const fetch = async () => {
      try {
        const kehamilanList = await getKehamilanByIbuId(id);
        if (kehamilanList.length > 0) {
          const aktif = kehamilanList[0];
          setKehamilan(aktif);
          const skriningData = await getSkriningByKehamilanId(aktif.id);
          if (skriningData && skriningData.length > 0) {
            const s = skriningData[0];
            setSkrining(s);
            setForm({
              ...s,
              gula_darah_puasa_hasil: s.gula_darah_puasa_hasil || "",
              gula_darah_puasa_rencana: s.gula_darah_puasa_rencana || "",
              gula_darah_2_jam_post_prandial_hasil: s.gula_darah_2_jam_post_prandial_hasil || "",
              gula_darah_2_jam_post_prandial_rencana: s.gula_darah_2_jam_post_prandial_rencana || "",
            });
          }
        }
      } catch (err) {
        console.error(err);
      } finally {
        setLoading(false);
      }
    };
    fetch();
  }, [id]);

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    setForm({ ...form, [name]: type === "checkbox" ? checked : value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!kehamilan) return;
    setSaving(true);
    try {
      const payload = { ...form, kehamilan_id: kehamilan.id };
      if (skrining) {
        await updateSkrining(skrining.id, payload);
      } else {
        await createSkrining(payload);
      }
      alert("Skrining berhasil disimpan");
      if (hitungRisiko() === "PERLU RUJUKAN") {
        navigate(`/data-ibu/${id}/rujukan`);
      } else {
        navigate(`/data-ibu/${id}/pemeriksaan-rutin`);
      }
    } catch (err) {
      alert("Gagal menyimpan skrining");
    } finally {
      setSaving(false);
    }
  };

  const hitungRisiko = () => {
    const risikoSedang = [
      form.anamnesis_multipara_pasangan_baru_sedang,
      form.anamnesis_teknologi_reproduksi_berbantu_sedang,
      form.anamnesis_umur_diatas_35_tahun_sedang,
      form.anamnesis_nulipara_sedang,
      form.anamnesis_jarak_kehamilan_diatas_10_tahun_sedang,
      form.anamnesis_riwayat_preeklampsia_keluarga_sedang,
      form.anamnesis_obesitas_imt_diatas_30_sedang,
    ].filter(Boolean).length;
    const risikoTinggi = [
      form.anamnesis_riwayat_preeklampsia_sebelumnya_tinggi,
      form.anamnesis_kehamilan_multipel_tinggi,
      form.anamnesis_diabetes_dalam_kehamilan_tinggi,
      form.anamnesis_hipertensi_kronik_tinggi,
      form.anamnesis_penyakit_ginjal_tinggi,
      form.anamnesis_penyakit_autoimun_sle_tinggi,
      form.anamnesis_anti_phospholipid_syndrome_tinggi,
    ].filter(Boolean).length;
    const map = form.fisik_map_diatas_90_mmhg;
    const protein = form.fisik_proteinuria_urin_celup;
    if (risikoTinggi >= 1 || risikoSedang >= 2 || map || protein) return "PERLU RUJUKAN";
    return "TIDAK PERLU RUJUKAN";
  };

  const isRujukan = hitungRisiko() === "PERLU RUJUKAN";

  const CheckboxToggle = ({ name, label }) => {
    const isChecked = form[name];
    return (
      <label 
        className={`cursor-pointer select-none flex items-center gap-2 text-sm px-4 py-3 rounded-xl border transition-all duration-300 w-full ${
          isChecked 
            ? "bg-rose-500 text-white border-rose-500 shadow-md shadow-rose-200" 
            : "bg-white text-gray-700 border-gray-200 hover:border-rose-300 hover:bg-rose-50"
        }`}
      >
        <input type="checkbox" name={name} checked={isChecked} onChange={handleChange} className="hidden" />
        {label}
      </label>
    );
  };

  if (loading) return <MainLayout><div className="p-6">Memuat...</div></MainLayout>;

  return (
    <MainLayout>
      <div className="p-6 max-w-5xl mx-auto">
        <h1 className="text-3xl font-extrabold mb-2 text-gray-900 tracking-tight">Skrining Risiko Kehamilan</h1>
        <p className="text-gray-500 mb-8 text-lg">Evaluasi terpadu risiko preeklampsia dan diabetes gestasional pada ibu hamil.</p>
        
        <form onSubmit={handleSubmit} className="space-y-8">
          
          {/* Status Badge */}
          <div className={`p-6 rounded-2xl flex items-center justify-between shadow-sm border ${isRujukan ? 'bg-red-50 border-red-200 text-red-800' : 'bg-emerald-50 border-emerald-200 text-emerald-800'}`}>
            <div className="flex items-center gap-4">
              {isRujukan ? <ShieldAlert size={36} className="text-red-600" /> : <CheckCircle2 size={36} className="text-emerald-600" />}
              <div>
                <h3 className="text-xl font-bold">Status Risiko: {hitungRisiko()}</h3>
                <p className="text-sm opacity-80">{isRujukan ? "Pasien ini memiliki indikasi risiko tinggi dan disarankan untuk segera dirujuk." : "Risiko rendah terpantau. Dapat melanjutkan ANC secara rutin."}</p>
              </div>
            </div>
          </div>

          {/* Anamnesis Risiko Sedang */}
          <div className="bg-white/80 backdrop-blur-xl rounded-2xl shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-white/50 p-8 transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.08)]">
            <h3 className="font-bold mb-4 text-lg text-amber-600 border-b border-amber-100 pb-2 flex items-center gap-2">
              <AlertCircle size={20} /> Anamnesis - Risiko Sedang
            </h3>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
              {[
                { label: "Multipara Dengan Kehamilan oleh Pasangan Baru", name: "anamnesis_multipara_pasangan_baru_sedang" },
                { label: "Kehamilan dengan Teknologi Reproduksi Berbantu", name: "anamnesis_teknologi_reproduksi_berbantu_sedang" },
                { label: "Umur ≥ 35 Tahun", name: "anamnesis_umur_diatas_35_tahun_sedang" },
                { label: "Nulipara", name: "anamnesis_nulipara_sedang" },
                { label: "Jarak Kehamilan Sebelumnya > 10 Tahun", name: "anamnesis_jarak_kehamilan_diatas_10_tahun_sedang" },
                { label: "Riwayat Preeklampsia pada Ibu/Saudara Perempuan", name: "anamnesis_riwayat_preeklampsia_keluarga_sedang" },
                { label: "Obesitas Sebelum Hamil (IMT > 30)", name: "anamnesis_obesitas_imt_diatas_30_sedang" },
              ].map((item) => (
                <CheckboxToggle key={item.name} name={item.name} label={item.label} />
              ))}
            </div>
          </div>

          {/* Anamnesis Risiko Tinggi */}
          <div className="bg-white/80 backdrop-blur-xl rounded-2xl shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-white/50 p-8 transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.08)]">
            <h3 className="font-bold mb-4 text-lg text-rose-600 border-b border-rose-100 pb-2 flex items-center gap-2">
              <ShieldAlert size={20} /> Anamnesis - Risiko Tinggi
            </h3>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
              {[
                { label: "Riwayat Preeklampsia Sebelumnya", name: "anamnesis_riwayat_preeklampsia_sebelumnya_tinggi" },
                { label: "Kehamilan Multipel", name: "anamnesis_kehamilan_multipel_tinggi" },
                { label: "Diabetes dalam Kehamilan", name: "anamnesis_diabetes_dalam_kehamilan_tinggi" },
                { label: "Hipertensi Kronik", name: "anamnesis_hipertensi_kronik_tinggi" },
                { label: "Penyakit Ginjal", name: "anamnesis_penyakit_ginjal_tinggi" },
                { label: "Penyakit Autoimun, SLE", name: "anamnesis_penyakit_autoimun_sle_tinggi" },
                { label: "Anti Phospholipid Syndrome", name: "anamnesis_anti_phospholipid_syndrome_tinggi" },
              ].map((item) => (
                <CheckboxToggle key={item.name} name={item.name} label={item.label} />
              ))}
            </div>
          </div>

          {/* Pemeriksaan Fisik */}
          <div className="bg-white/80 backdrop-blur-xl rounded-2xl shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-white/50 p-8 transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.08)]">
            <h3 className="font-bold mb-4 text-lg text-indigo-900 border-b border-indigo-100 pb-2">Pemeriksaan Fisik Khusus</h3>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-3 mb-6">
              <CheckboxToggle name="fisik_map_diatas_90_mmhg" label="Mean Arterial Pressure > 90 mmHg" />
              <CheckboxToggle name="fisik_proteinuria_urin_celup" label="Proteinuria (Urin Celup > +1)" />
            </div>
            <div>
              <label className="block font-semibold mb-2 text-gray-700">Kesimpulan Klinis (Opsional)</label>
              <textarea name="kesimpulan" value={form.kesimpulan} onChange={handleChange} className="w-full border-gray-300 rounded-xl shadow-sm focus:border-indigo-500 focus:ring-indigo-500 p-4" rows="3" placeholder="Tambahkan catatan khusus hasil skrining..." />
            </div>
          </div>

          {/* Skrining DMG */}
          <div className="bg-white/80 backdrop-blur-xl rounded-2xl shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-white/50 p-8 transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.08)]">
            <h3 className="font-bold mb-6 text-lg text-indigo-900 border-b border-indigo-100 pb-2">Skrining Diabetes Melitus Gestasional (DMG)</h3>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="bg-gray-50 p-4 rounded-xl border border-gray-100">
                <label className="block text-sm font-semibold mb-2">Gula Darah Puasa (mg/dL)</label>
                <input type="number" name="gula_darah_puasa_hasil" value={form.gula_darah_puasa_hasil} onChange={handleChange} className="w-full border-gray-300 rounded-lg shadow-sm px-3 py-2" />
              </div>
              <div className="bg-gray-50 p-4 rounded-xl border border-gray-100">
                <label className="block text-sm font-semibold mb-2">Rencana Tindak Lanjut Puasa</label>
                <input name="gula_darah_puasa_rencana" value={form.gula_darah_puasa_rencana} onChange={handleChange} className="w-full border-gray-300 rounded-lg shadow-sm px-3 py-2" />
              </div>
              <div className="bg-gray-50 p-4 rounded-xl border border-gray-100">
                <label className="block text-sm font-semibold mb-2">Gula Darah 2 Jam PP (mg/dL)</label>
                <input type="number" name="gula_darah_2_jam_post_prandial_hasil" value={form.gula_darah_2_jam_post_prandial_hasil} onChange={handleChange} className="w-full border-gray-300 rounded-lg shadow-sm px-3 py-2" />
              </div>
              <div className="bg-gray-50 p-4 rounded-xl border border-gray-100">
                <label className="block text-sm font-semibold mb-2">Rencana Tindak Lanjut 2 Jam PP</label>
                <input name="gula_darah_2_jam_post_prandial_rencana" value={form.gula_darah_2_jam_post_prandial_rencana} onChange={handleChange} className="w-full border-gray-300 rounded-lg shadow-sm px-3 py-2" />
              </div>
            </div>
          </div>

          <div className="flex justify-end pt-4 pb-12">
            <button type="submit" disabled={saving} className="bg-gradient-to-r from-indigo-600 to-indigo-700 text-white px-8 py-4 rounded-xl font-bold text-lg shadow-lg hover:shadow-indigo-500/30 transform transition-all hover:-translate-y-1 flex items-center gap-3">
              {saving ? "Menyimpan..." : (isRujukan ? "Simpan & Lanjut Buat Rujukan" : "Simpan & Lanjut Pemeriksaan Rutin")} <ArrowRight size={20} />
            </button>
          </div>
        </form>
      </div>
    </MainLayout>
  );
}
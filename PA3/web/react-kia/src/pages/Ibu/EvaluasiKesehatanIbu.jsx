import React, { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import MainLayout from "../../components/Layout/MainLayout";
import { getKehamilanByIbuId } from "../../services/kehamilan";
import { getEvaluasiByKehamilanId, createEvaluasi, updateEvaluasi, getRiwayatKehamilanByEvaluasiId, createRiwayatKehamilan } from "../../services/evaluasiKesehatan";
import { Save, Plus, ArrowRight, ArrowLeft } from "lucide-react";

export default function EvaluasiKesehatanIbu() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [kehamilan, setKehamilan] = useState(null);
  const [evaluasi, setEvaluasi] = useState(null);
  const [riwayatList, setRiwayatList] = useState([]);
  const [activeTab, setActiveTab] = useState("evaluasi");
  const [form, setForm] = useState({
    nama_dokter: "",
    tanggal_periksa: "",
    fasilitas_kesehatan: "",
    tb_cm: "",
    bb_kg: "",
    imt_kategori: "",
    lila_cm: "",
    status_tt_1: false,
    status_tt_2: false,
    status_tt_3: false,
    status_tt_4: false,
    status_tt_5: false,
    imunisasi_lainnya_covid19: "",
    riwayat_alergi: false,
    riwayat_asma: false,
    riwayat_autoimun: false,
    riwayat_diabetes: false,
    riwayat_hepatitis_b: false,
    riwayat_hipertensi: false,
    riwayat_jantung: false,
    riwayat_jiwa: false,
    riwayat_sifilis: false,
    riwayat_tb: false,
    riwayat_kesehatan_lainnya: "",
    perilaku_aktivitas_fisik_kurang: false,
    perilaku_alkohol: false,
    perilaku_kosmetik_berbahaya: false,
    perilaku_merokok: false,
    perilaku_obat_teratogenik: false,
    perilaku_pola_makan_berisiko: false,
    perilaku_lainnya: "",
    keluarga_alergi: false,
    keluarga_asma: false,
    keluarga_autoimun: false,
    keluarga_diabetes: false,
    keluarga_hepatitis_b: false,
    keluarga_hipertensi: false,
    keluarga_jantung: false,
    keluarga_jiwa: false,
    keluarga_sifilis: false,
    keluarga_tb: false,
    keluarga_lainnya: "",
    inspeksi_porsio: "",
    inspeksi_uretra: "",
    inspeksi_vagina: "",
    inspeksi_vulva: "",
    inspeksi_fluksus: "",
    inspeksi_fluor: "",
  });
  const [formRiwayat, setFormRiwayat] = useState({
    no_urut: 1,
    tahun: "",
    bb_gram: "",
    proses_melahirkan: "",
    penolong_proses_melahirkan: "",
    masalah: "",
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
          const evalData = await getEvaluasiByKehamilanId(aktif.id);
          if (evalData && evalData.length > 0) {
            const e = evalData[0];
            setEvaluasi(e);
            setForm((prev) => ({
              ...prev,
              nama_dokter: e.nama_dokter || "",
              tanggal_periksa: e.tanggal_periksa ? e.tanggal_periksa.split("T")[0] : "",
              fasilitas_kesehatan: e.fasilitas_kesehatan || "",
              tb_cm: e.tb_cm ?? "",
              bb_kg: e.bb_kg ?? "",
              imt_kategori: e.imt_kategori || "",
              lila_cm: e.lila_cm ?? "",
              status_tt_1: e.status_tt_1 || false,
              status_tt_2: e.status_tt_2 || false,
              status_tt_3: e.status_tt_3 || false,
              status_tt_4: e.status_tt_4 || false,
              status_tt_5: e.status_tt_5 || false,
              imunisasi_lainnya_covid19: e.imunisasi_lainnya_covid19 || "",
              riwayat_alergi: e.riwayat_alergi || false,
              riwayat_asma: e.riwayat_asma || false,
              riwayat_autoimun: e.riwayat_autoimun || false,
              riwayat_diabetes: e.riwayat_diabetes || false,
              riwayat_hepatitis_b: e.riwayat_hepatitis_b || false,
              riwayat_hipertensi: e.riwayat_hipertensi || false,
              riwayat_jantung: e.riwayat_jantung || false,
              riwayat_jiwa: e.riwayat_jiwa || false,
              riwayat_sifilis: e.riwayat_sifilis || false,
              riwayat_tb: e.riwayat_tb || false,
              riwayat_kesehatan_lainnya: e.riwayat_kesehatan_lainnya || "",
              perilaku_aktivitas_fisik_kurang: e.perilaku_aktivitas_fisik_kurang || false,
              perilaku_alkohol: e.perilaku_alkohol || false,
              perilaku_kosmetik_berbahaya: e.perilaku_kosmetik_berbahaya || false,
              perilaku_merokok: e.perilaku_merokok || false,
              perilaku_obat_teratogenik: e.perilaku_obat_teratogenik || false,
              perilaku_pola_makan_berisiko: e.perilaku_pola_makan_berisiko || false,
              perilaku_lainnya: e.perilaku_lainnya || "",
              keluarga_alergi: e.keluarga_alergi || false,
              keluarga_asma: e.keluarga_asma || false,
              keluarga_autoimun: e.keluarga_autoimun || false,
              keluarga_diabetes: e.keluarga_diabetes || false,
              keluarga_hepatitis_b: e.keluarga_hepatitis_b || false,
              keluarga_hipertensi: e.keluarga_hipertensi || false,
              keluarga_jantung: e.keluarga_jantung || false,
              keluarga_jiwa: e.keluarga_jiwa || false,
              keluarga_sifilis: e.keluarga_sifilis || false,
              keluarga_tb: e.keluarga_tb || false,
              keluarga_lainnya: e.keluarga_lainnya || "",
              inspeksi_porsio: e.inspeksi_porsio || "",
              inspeksi_uretra: e.inspeksi_uretra || "",
              inspeksi_vagina: e.inspeksi_vagina || "",
              inspeksi_vulva: e.inspeksi_vulva || "",
              inspeksi_fluksus: e.inspeksi_fluksus || "",
              inspeksi_fluor: e.inspeksi_fluor || "",
            }));
            // Load riwayat kehamilan lalu
            try {
              const riwayat = await getRiwayatKehamilanByEvaluasiId(e.id_evaluasi);
              if (riwayat) setRiwayatList(riwayat);
            } catch (err) {
              console.error("Gagal load riwayat:", err);
            }
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
    const { name, value, type, checked } = e.target;
    setForm({ ...form, [name]: type === "checkbox" ? checked : value });
  };

  const handleSubmitEvaluasi = async (e) => {
    e.preventDefault();
    if (!kehamilan) return;
    setSaving(true);
    try {
      const payload = {
        ...form,
        kehamilan_id: kehamilan.id,
        tb_cm: parseFloat(form.tb_cm) || null,
        bb_kg: parseFloat(form.bb_kg) || null,
        lila_cm: parseFloat(form.lila_cm) || null,
      };
      if (evaluasi) {
        await updateEvaluasi(evaluasi.id_evaluasi, payload);
      } else {
        const created = await createEvaluasi(payload);
        setEvaluasi(created);
      }
      alert("Evaluasi kesehatan ibu berhasil disimpan");
      // Auto-navigate to next step (Skrining Preeklampsia)
      navigate(`/data-ibu/${id}/skrining-preeklampsia`);
    } catch (err) {
      alert("Gagal menyimpan evaluasi");
      console.error(err);
    } finally {
      setSaving(false);
    }
  };

  const handleAddRiwayat = async () => {
    if (!evaluasi) {
      alert("Simpan evaluasi terlebih dahulu");
      return;
    }
    try {
      const payload = {
        id_evaluasi: evaluasi.id_evaluasi,
        no_urut: parseInt(formRiwayat.no_urut) || 1,
        tahun: parseInt(formRiwayat.tahun) || 0,
        bb_gram: parseInt(formRiwayat.bb_gram) || 0,
        proses_melahirkan: formRiwayat.proses_melahirkan,
        penolong_proses_melahirkan: formRiwayat.penolong_proses_melahirkan,
        masalah: formRiwayat.masalah,
      };
      const created = await createRiwayatKehamilan(payload);
      setRiwayatList([...riwayatList, created]);
      setFormRiwayat({ no_urut: riwayatList.length + 2, tahun: "", bb_gram: "", proses_melahirkan: "", penolong_proses_melahirkan: "", masalah: "" });
      alert("Riwayat kehamilan lalu berhasil ditambahkan");
    } catch (err) {
      alert("Gagal menambahkan riwayat");
      console.error(err);
    }
  };

  const CheckboxGroup = ({ title, items }) => (
    <div className="space-y-3">
      <h4 className="font-semibold text-sm text-indigo-900 border-b border-indigo-100 pb-1">{title}</h4>
      <div className="flex flex-wrap gap-2">
        {items.map((item) => {
          const isChecked = form[item.name];
          return (
            <label
              key={item.name}
              className={`cursor-pointer select-none flex items-center gap-2 text-sm px-4 py-2 rounded-full border transition-all duration-300 ${
                isChecked ? "bg-indigo-600 text-white border-indigo-600 shadow-md shadow-indigo-200" : "bg-white text-gray-600 border-gray-200 hover:border-indigo-300 hover:bg-indigo-50"
              }`}
            >
              <input type="checkbox" name={item.name} checked={isChecked} onChange={handleChange} className="hidden" />
              {item.label}
            </label>
          );
        })}
      </div>
    </div>
  );

  if (loading)
    return (
      <MainLayout>
        <div className="p-6">Memuat...</div>
      </MainLayout>
    );

  return (
    <MainLayout>
      <div className="p-6 max-w-5xl mx-auto">
        <div className="flex items-center gap-4 mb-6">
          <button onClick={() => navigate(-1)} className="p-2 rounded-full hover:bg-gray-100 transition-colors">
            <ArrowLeft size={20} />
          </button>
          <div>
            <h1 className="text-2xl font-bold text-gray-900">Evaluasi Kesehatan Ibu</h1>
            <p className="text-gray-500">Lakukan pemeriksaan dasar dan skrining risiko.</p>
          </div>
        </div>

        <div className="flex gap-4 mb-8">
          {["evaluasi", "riwayat"].map((tab) => (
            <button
              key={tab}
              onClick={() => setActiveTab(tab)}
              className={`px-6 py-3 rounded-xl font-semibold transition-all duration-300 ${
                activeTab === tab ? "bg-indigo-600 text-white shadow-lg shadow-indigo-200 transform scale-105" : "bg-white text-gray-500 hover:bg-indigo-50 hover:text-indigo-600 border border-gray-200"
              }`}
            >
              {tab === "evaluasi" ? "📋 Form Evaluasi Kesehatan" : "⏳ Riwayat Kehamilan Lalu"}
            </button>
          ))}
        </div>

        {activeTab === "evaluasi" && (
          <form onSubmit={handleSubmitEvaluasi} className="space-y-8">
            {/* Data Umum */}
            <div className="bg-white/80 backdrop-blur-xl rounded-2xl shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-white/50 p-8 transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.08)]">
              <h3 className="font-semibold mb-3 text-indigo-700">Data Pemeriksaan</h3>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                  <label className="block text-sm font-medium mb-1">Nama Dokter</label>
                  <input name="nama_dokter" value={form.nama_dokter} onChange={handleChange} className="w-full border rounded-lg px-3 py-2" />
                </div>
                <div>
                  <label className="block text-sm font-medium mb-1">Tanggal Periksa</label>
                  <input type="date" name="tanggal_periksa" value={form.tanggal_periksa} onChange={handleChange} className="w-full border rounded-lg px-3 py-2" />
                </div>
                <div>
                  <label className="block text-sm font-medium mb-1">Fasilitas Kesehatan</label>
                  <input name="fasilitas_kesehatan" value={form.fasilitas_kesehatan} onChange={handleChange} className="w-full border rounded-lg px-3 py-2" />
                </div>
              </div>
            </div>

            {/* Antropometri */}
            <div className="bg-white/80 backdrop-blur-xl rounded-2xl shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-white/50 p-8 transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.08)]">
              <h3 className="font-semibold mb-3 text-indigo-700">Antropometri</h3>
              <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                <div>
                  <label className="block text-sm font-medium mb-1">TB (cm)</label>
                  <input type="number" step="0.1" name="tb_cm" value={form.tb_cm} onChange={handleChange} className="w-full border rounded-lg px-3 py-2" />
                </div>
                <div>
                  <label className="block text-sm font-medium mb-1">BB (kg)</label>
                  <input type="number" step="0.1" name="bb_kg" value={form.bb_kg} onChange={handleChange} className="w-full border rounded-lg px-3 py-2" />
                </div>
                <div>
                  <label className="block text-sm font-medium mb-1">IMT Kategori</label>
                  <select name="imt_kategori" value={form.imt_kategori} onChange={handleChange} className="w-full border rounded-lg px-3 py-2">
                    <option value="">-- Pilih --</option>
                    <option>Kurus</option>
                    <option>Normal</option>
                    <option>Gemuk</option>
                    <option>Obesitas</option>
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-medium mb-1">LILA (cm)</label>
                  <input type="number" step="0.1" name="lila_cm" value={form.lila_cm} onChange={handleChange} className="w-full border rounded-lg px-3 py-2" />
                </div>
              </div>
            </div>

            {/* Imunisasi TT */}
            <div className="bg-white/80 backdrop-blur-xl rounded-2xl shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-white/50 p-8 transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.08)]">
              <h3 className="font-semibold mb-3 text-indigo-700">Status Imunisasi TT</h3>
              <div className="flex flex-wrap gap-4">
                {[1, 2, 3, 4, 5].map((n) => (
                  <label key={n} className="flex items-center gap-2">
                    <input type="checkbox" name={`status_tt_${n}`} checked={form[`status_tt_${n}`]} onChange={handleChange} className="rounded" />
                    TT {n}
                  </label>
                ))}
              </div>
              <div className="mt-2">
                <label className="block text-sm font-medium mb-1">Imunisasi Lainnya (Covid-19, dll)</label>
                <input name="imunisasi_lainnya_covid19" value={form.imunisasi_lainnya_covid19} onChange={handleChange} className="w-full border rounded-lg px-3 py-2" />
              </div>
            </div>

            {/* Riwayat Kesehatan & Perilaku */}
            <div className="bg-white/80 backdrop-blur-xl rounded-2xl shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-white/50 p-8 transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.08)] space-y-6">
              <CheckboxGroup
                title="Riwayat Kesehatan Ibu"
                items={[
                  { name: "riwayat_alergi", label: "Alergi" },
                  { name: "riwayat_asma", label: "Asma" },
                  { name: "riwayat_autoimun", label: "Autoimun" },
                  { name: "riwayat_diabetes", label: "Diabetes" },
                  { name: "riwayat_hepatitis_b", label: "Hepatitis B" },
                  { name: "riwayat_hipertensi", label: "Hipertensi" },
                  { name: "riwayat_jantung", label: "Jantung" },
                  { name: "riwayat_jiwa", label: "Jiwa" },
                  { name: "riwayat_sifilis", label: "Sifilis" },
                  { name: "riwayat_tb", label: "TB" },
                ]}
              />
              <div>
                <label className="block text-sm font-medium mb-1">Riwayat Kesehatan Lainnya</label>
                <input name="riwayat_kesehatan_lainnya" value={form.riwayat_kesehatan_lainnya} onChange={handleChange} className="w-full border rounded-lg px-3 py-2" />
              </div>

              <CheckboxGroup
                title="Perilaku Berisiko"
                items={[
                  { name: "perilaku_aktivitas_fisik_kurang", label: "Aktivitas Fisik Kurang" },
                  { name: "perilaku_alkohol", label: "Alkohol" },
                  { name: "perilaku_kosmetik_berbahaya", label: "Kosmetik Berbahaya" },
                  { name: "perilaku_merokok", label: "Merokok" },
                  { name: "perilaku_obat_teratogenik", label: "Obat Teratogenik" },
                  { name: "perilaku_pola_makan_berisiko", label: "Pola Makan Berisiko" },
                ]}
              />
              <div>
                <label className="block text-sm font-medium mb-1">Perilaku Lainnya</label>
                <input name="perilaku_lainnya" value={form.perilaku_lainnya} onChange={handleChange} className="w-full border rounded-lg px-3 py-2" />
              </div>

              <CheckboxGroup
                title="Riwayat Kesehatan Keluarga"
                items={[
                  { name: "keluarga_alergi", label: "Alergi" },
                  { name: "keluarga_asma", label: "Asma" },
                  { name: "keluarga_autoimun", label: "Autoimun" },
                  { name: "keluarga_diabetes", label: "Diabetes" },
                  { name: "keluarga_hepatitis_b", label: "Hepatitis B" },
                  { name: "keluarga_hipertensi", label: "Hipertensi" },
                  { name: "keluarga_jantung", label: "Jantung" },
                  { name: "keluarga_jiwa", label: "Jiwa" },
                  { name: "keluarga_sifilis", label: "Sifilis" },
                  { name: "keluarga_tb", label: "TB" },
                ]}
              />
              <div>
                <label className="block text-sm font-medium mb-1">Riwayat Keluarga Lainnya</label>
                <input name="keluarga_lainnya" value={form.keluarga_lainnya} onChange={handleChange} className="w-full border rounded-lg px-3 py-2" />
              </div>
            </div>

            {/* Inspeksi */}
            <div className="bg-white/80 backdrop-blur-xl rounded-2xl shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-white/50 p-8 transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.08)]">
              <h3 className="font-bold mb-6 text-xl text-indigo-900 border-b pb-2">Inspeksi Medis</h3>
              <div className="grid grid-cols-2 md:grid-cols-3 gap-6">
                {[
                  { name: "inspeksi_porsio", label: "Porsio" },
                  { name: "inspeksi_uretra", label: "Uretra" },
                  { name: "inspeksi_vagina", label: "Vagina" },
                  { name: "inspeksi_vulva", label: "Vulva" },
                  { name: "inspeksi_fluksus", label: "Fluksus" },
                  { name: "inspeksi_fluor", label: "Fluor" },
                ].map((item) => (
                  <div key={item.name} className="bg-gray-50 p-4 rounded-xl border border-gray-100">
                    <label className="block text-sm font-semibold mb-2 text-gray-700">{item.label}</label>
                    <select name={item.name} value={form[item.name]} onChange={handleChange} className="w-full border-gray-300 rounded-lg shadow-sm focus:border-indigo-500 focus:ring-indigo-500 px-3 py-2">
                      <option value="">-- Pilih Status --</option>
                      <option>Normal</option>
                      <option>Abnormal</option>
                    </select>
                  </div>
                ))}
              </div>
            </div>

            <div className="flex justify-end pt-4 pb-12">
              <button
                type="submit"
                disabled={saving}
                className="bg-gradient-to-r from-indigo-600 to-indigo-700 text-white px-8 py-4 rounded-xl font-bold text-lg shadow-lg hover:shadow-indigo-500/30 transform transition-all hover:-translate-y-1 flex items-center gap-3"
              >
                {saving ? "Menyimpan..." : "Simpan & Lanjut ke Skrining"} <ArrowRight size={20} />
              </button>
            </div>
          </form>
        )}

        {activeTab === "riwayat" && (
          <div className="space-y-6">
            {/* Tabel Riwayat */}
            <div className="bg-white rounded-xl shadow-sm p-6">
              <h3 className="font-semibold mb-4">Riwayat Kehamilan Terdahulu</h3>
              {riwayatList.length > 0 ? (
                <div className="overflow-x-auto">
                  <table className="min-w-full divide-y divide-gray-200">
                    <thead className="bg-gray-50">
                      <tr>
                        <th className="px-4 py-2 text-left text-xs font-medium text-gray-500">No</th>
                        <th className="px-4 py-2 text-left text-xs font-medium text-gray-500">Tahun</th>
                        <th className="px-4 py-2 text-left text-xs font-medium text-gray-500">BB (gram)</th>
                        <th className="px-4 py-2 text-left text-xs font-medium text-gray-500">Proses Melahirkan</th>
                        <th className="px-4 py-2 text-left text-xs font-medium text-gray-500">Penolong</th>
                        <th className="px-4 py-2 text-left text-xs font-medium text-gray-500">Masalah</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-100">
                      {riwayatList.map((r, idx) => (
                        <tr key={r.id_riwayat || idx}>
                          <td className="px-4 py-2 text-sm">{r.no_urut}</td>
                          <td className="px-4 py-2 text-sm">{r.tahun}</td>
                          <td className="px-4 py-2 text-sm">{r.bb_gram}</td>
                          <td className="px-4 py-2 text-sm">{r.proses_melahirkan}</td>
                          <td className="px-4 py-2 text-sm">{r.penolong_proses_melahirkan}</td>
                          <td className="px-4 py-2 text-sm">{r.masalah}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              ) : (
                <p className="text-gray-500 text-sm">Belum ada riwayat kehamilan lalu.</p>
              )}
            </div>

            {/* Form Tambah Riwayat */}
            <div className="bg-white rounded-xl shadow-sm p-6">
              <h3 className="font-semibold mb-4">Tambah Riwayat Kehamilan Lalu</h3>
              {!evaluasi && <p className="text-red-500 text-sm mb-4">⚠️ Simpan evaluasi terlebih dahulu sebelum menambah riwayat.</p>}
              <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
                <div>
                  <label className="block text-sm font-medium mb-1">No Urut</label>
                  <input type="number" value={formRiwayat.no_urut} onChange={(e) => setFormRiwayat({ ...formRiwayat, no_urut: e.target.value })} className="w-full border rounded-lg px-3 py-2" />
                </div>
                <div>
                  <label className="block text-sm font-medium mb-1">Tahun</label>
                  <input type="number" value={formRiwayat.tahun} onChange={(e) => setFormRiwayat({ ...formRiwayat, tahun: e.target.value })} className="w-full border rounded-lg px-3 py-2" />
                </div>
                <div>
                  <label className="block text-sm font-medium mb-1">BB (gram)</label>
                  <input type="number" value={formRiwayat.bb_gram} onChange={(e) => setFormRiwayat({ ...formRiwayat, bb_gram: e.target.value })} className="w-full border rounded-lg px-3 py-2" />
                </div>
                <div>
                  <label className="block text-sm font-medium mb-1">Proses Melahirkan</label>
                  <input value={formRiwayat.proses_melahirkan} onChange={(e) => setFormRiwayat({ ...formRiwayat, proses_melahirkan: e.target.value })} className="w-full border rounded-lg px-3 py-2" />
                </div>
                <div>
                  <label className="block text-sm font-medium mb-1">Penolong</label>
                  <input value={formRiwayat.penolong_proses_melahirkan} onChange={(e) => setFormRiwayat({ ...formRiwayat, penolong_proses_melahirkan: e.target.value })} className="w-full border rounded-lg px-3 py-2" />
                </div>
                <div>
                  <label className="block text-sm font-medium mb-1">Masalah</label>
                  <input value={formRiwayat.masalah} onChange={(e) => setFormRiwayat({ ...formRiwayat, masalah: e.target.value })} className="w-full border rounded-lg px-3 py-2" />
                </div>
              </div>
              <button type="button" onClick={handleAddRiwayat} disabled={!evaluasi} className="mt-4 bg-green-600 text-white px-4 py-2 rounded-lg flex items-center gap-2 disabled:opacity-50">
                <Plus size={18} /> Tambah Riwayat
              </button>
            </div>
          </div>
        )}
      </div>
    </MainLayout>
  );
}

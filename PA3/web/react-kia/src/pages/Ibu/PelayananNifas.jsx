// src/pages/Ibu/PelayananNifas.jsx
import React, { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import MainLayout from "../../components/Layout/MainLayout";
import { getKehamilanByIbuId } from "../../services/kehamilan";
import { getNifasByKehamilanId, createNifas, updateNifas } from "../../services/nifas";
import { Save, ArrowLeft } from "lucide-react";

export default function PelayananNifas() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [kehamilan, setKehamilan] = useState(null);
  const [nifas, setNifas] = useState([]);
  const [form, setForm] = useState({
    kunjungan_ke: "KF1",
    tanggal_periksa: "",
    tanda_vital_tekanan_darah: "",
    tanda_vital_suhu_tubuh: "",
    pelayanan_involusi_uteri: "",
    pelayanan_cairan_pervaginam: "",
    pelayanan_periksa_jalan_lahir: "",
    pelayanan_periksa_payudara: "",
    pelayanan_asi_eksklusif: "",
    pemberian_kapsul_vitamin_a: false,
    pemberian_tablet_tambah_darah_jumlah: "",
    pelayanan_skrining_depresi_nifas: "",
    pelayanan_kontrasepsi_pasca_persalinan: "",
    pelayanan_penanganan_risiko_malaria: "",
    komplikasi_nifas: "",
    tindakan_saran: "",
    nama_pemeriksa_paraf: "",
    tanggal_kembali: "",
  });
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [selectedKunjungan, setSelectedKunjungan] = useState("KF1");

  useEffect(() => {
    const fetch = async () => {
      try {
        const kehamilanList = await getKehamilanByIbuId(id);
        if (kehamilanList.length > 0) {
          const aktif = kehamilanList[0];
          setKehamilan(aktif);
          const data = await getNifasByKehamilanId(aktif.id);
          setNifas(data);
          const existing = data.find((n) => n.kunjungan_ke === selectedKunjungan);
          if (existing) {
            setForm({
              kunjungan_ke: existing.kunjungan_ke,
              tanggal_periksa: existing.tanggal_periksa ? new Date(existing.tanggal_periksa).toISOString().split("T")[0] : "",
              tanda_vital_tekanan_darah: existing.tanda_vital_tekanan_darah,
              tanda_vital_suhu_tubuh: existing.tanda_vital_suhu_tubuh,
              pelayanan_involusi_uteri: existing.pelayanan_involusi_uteri,
              pelayanan_cairan_pervaginam: existing.pelayanan_cairan_pervaginam,
              pelayanan_periksa_jalan_lahir: existing.pelayanan_periksa_jalan_lahir,
              pelayanan_periksa_payudara: existing.pelayanan_periksa_payudara,
              pelayanan_asi_eksklusif: existing.pelayanan_asi_eksklusif,
              pemberian_kapsul_vitamin_a: existing.pemberian_kapsul_vitamin_a,
              pemberian_tablet_tambah_darah_jumlah: existing.pemberian_tablet_tambah_darah_jumlah,
              pelayanan_skrining_depresi_nifas: existing.pelayanan_skrining_depresi_nifas,
              pelayanan_kontrasepsi_pasca_persalinan: existing.pelayanan_kontrasepsi_pasca_persalinan,
              pelayanan_penanganan_risiko_malaria: existing.pelayanan_penanganan_risiko_malaria,
              komplikasi_nifas: existing.komplikasi_nifas,
              tindakan_saran: existing.tindakan_saran,
              nama_pemeriksa_paraf: existing.nama_pemeriksa_paraf,
              tanggal_kembali: existing.tanggal_kembali ? new Date(existing.tanggal_kembali).toISOString().split("T")[0] : "",
            });
          } else {
            resetForm(selectedKunjungan);
          }
        }
      } catch (err) {
        console.error(err);
      } finally {
        setLoading(false);
      }
    };
    fetch();
  }, [id, selectedKunjungan]);

  const resetForm = (kunjungan) => {
    setForm({
      kunjungan_ke: kunjungan,
      tanggal_periksa: "",
      tanda_vital_tekanan_darah: "",
      tanda_vital_suhu_tubuh: "",
      pelayanan_involusi_uteri: "",
      pelayanan_cairan_pervaginam: "",
      pelayanan_periksa_jalan_lahir: "",
      pelayanan_periksa_payudara: "",
      pelayanan_asi_eksklusif: "",
      pemberian_kapsul_vitamin_a: false,
      pemberian_tablet_tambah_darah_jumlah: "",
      pelayanan_skrining_depresi_nifas: "",
      pelayanan_kontrasepsi_pasca_persalinan: "",
      pelayanan_penanganan_risiko_malaria: "",
      komplikasi_nifas: "",
      tindakan_saran: "",
      nama_pemeriksa_paraf: "",
      tanggal_kembali: "",
    });
  };

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
      const existing = nifas.find((n) => n.kunjungan_ke === selectedKunjungan);
      if (existing) {
        await updateNifas(existing.id, payload);
      } else {
        await createNifas(payload);
      }
      alert("Data pelayanan nifas berhasil disimpan");
    } catch (err) {
      alert("Gagal menyimpan data nifas");
    } finally {
      setSaving(false);
    }
  };

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
            <h1 className="text-2xl font-bold text-gray-900">Pelayanan Nifas</h1>
            <p className="text-gray-500">Pencatatan proses persalinan hingga bayi lahir.</p>
          </div>
        </div>
        <div className="flex gap-2 mb-6">
          {["KF1", "KF2", "KF3", "KF4"].map((k) => (
            <button key={k} onClick={() => setSelectedKunjungan(k)} className={`px-4 py-2 rounded-lg ${selectedKunjungan === k ? "bg-indigo-600 text-white" : "bg-gray-100"}`}>
              {k === "KF1" ? "6-48 Jam" : k === "KF2" ? "3-7 Hari" : k === "KF3" ? "8-28 Hari" : "29-42 Hari"}
            </button>
          ))}
        </div>
        <form onSubmit={handleSubmit} className="bg-white rounded-xl shadow-sm p-6 space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label>Tanggal Periksa</label>
              <input type="date" name="tanggal_periksa" value={form.tanggal_periksa} onChange={handleChange} className="w-full border rounded px-3 py-2" />
            </div>
            <div>
              <label>Tekanan Darah</label>
              <input name="tanda_vital_tekanan_darah" value={form.tanda_vital_tekanan_darah} onChange={handleChange} className="w-full border rounded px-3 py-2" />
            </div>
            <div>
              <label>Suhu Tubuh</label>
              <input type="number" step="0.1" name="tanda_vital_suhu_tubuh" value={form.tanda_vital_suhu_tubuh} onChange={handleChange} className="w-full border rounded px-3 py-2" />
            </div>
            <div>
              <label>Involusi Uteri</label>
              <input name="pelayanan_involusi_uteri" value={form.pelayanan_involusi_uteri} onChange={handleChange} className="w-full border rounded px-3 py-2" />
            </div>
            <div>
              <label>Cairan Pervaginam</label>
              <input name="pelayanan_cairan_pervaginam" value={form.pelayanan_cairan_pervaginam} onChange={handleChange} className="w-full border rounded px-3 py-2" />
            </div>
            <div>
              <label>Periksa Jalan Lahir</label>
              <input name="pelayanan_periksa_jalan_lahir" value={form.pelayanan_periksa_jalan_lahir} onChange={handleChange} className="w-full border rounded px-3 py-2" />
            </div>
            <div>
              <label>Periksa Payudara</label>
              <input name="pelayanan_periksa_payudara" value={form.pelayanan_periksa_payudara} onChange={handleChange} className="w-full border rounded px-3 py-2" />
            </div>
            <div>
              <label>ASI Eksklusif</label>
              <input name="pelayanan_asi_eksklusif" value={form.pelayanan_asi_eksklusif} onChange={handleChange} className="w-full border rounded px-3 py-2" />
            </div>
            <label className="flex items-center gap-2">
              <input type="checkbox" name="pemberian_kapsul_vitamin_a" checked={form.pemberian_kapsul_vitamin_a} onChange={handleChange} /> Vitamin A
            </label>
            <div>
              <label>Tablet Tambah Darah</label>
              <input type="number" name="pemberian_tablet_tambah_darah_jumlah" value={form.pemberian_tablet_tambah_darah_jumlah} onChange={handleChange} className="w-full border rounded px-3 py-2" />
            </div>
            <div>
              <label>Skrining Depresi Nifas</label>
              <input name="pelayanan_skrining_depresi_nifas" value={form.pelayanan_skrining_depresi_nifas} onChange={handleChange} className="w-full border rounded px-3 py-2" />
            </div>
            <div>
              <label>Kontrasepsi Pasca Persalinan</label>
              <input name="pelayanan_kontrasepsi_pasca_persalinan" value={form.pelayanan_kontrasepsi_pasca_persalinan} onChange={handleChange} className="w-full border rounded px-3 py-2" />
            </div>
            <div>
              <label>Penanganan Risiko Malaria</label>
              <input name="pelayanan_penanganan_risiko_malaria" value={form.pelayanan_penanganan_risiko_malaria} onChange={handleChange} className="w-full border rounded px-3 py-2" />
            </div>
            <div>
              <label>Komplikasi Nifas</label>
              <textarea name="komplikasi_nifas" value={form.komplikasi_nifas} onChange={handleChange} className="w-full border rounded px-3 py-2" rows="2" />
            </div>
            <div>
              <label>Tindakan/Saran</label>
              <textarea name="tindakan_saran" value={form.tindakan_saran} onChange={handleChange} className="w-full border rounded px-3 py-2" rows="2" />
            </div>
            <div>
              <label>Nama Pemeriksa/Paraf</label>
              <input name="nama_pemeriksa_paraf" value={form.nama_pemeriksa_paraf} onChange={handleChange} className="w-full border rounded px-3 py-2" />
            </div>
            <div>
              <label>Tanggal Kembali</label>
              <input type="date" name="tanggal_kembali" value={form.tanggal_kembali} onChange={handleChange} className="w-full border rounded px-3 py-2" />
            </div>
          </div>
          <button type="submit" disabled={saving} className="bg-indigo-600 text-white px-4 py-2 rounded-lg flex items-center gap-2">
            <Save size={18} /> Simpan Nifas
          </button>
        </form>
      </div>
    </MainLayout>
  );
}

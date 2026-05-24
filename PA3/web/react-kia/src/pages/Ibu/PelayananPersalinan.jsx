// src/pages/Ibu/PelayananPersalinan.jsx
import React, { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import MainLayout from "../../components/Layout/MainLayout";
import { getKehamilanByIbuId } from "../../services/kehamilan";
import {
  getRingkasanPersalinanByKehamilanId,
  createRingkasanPersalinan,
  updateRingkasanPersalinan,
  getRiwayatMelahirkanByKehamilanId,
  createRiwayatMelahirkan,
  updateRiwayatMelahirkan,
  getKeteranganLahirByIbuId,
  createKeteranganLahir,
  updateKeteranganLahir,
} from "../../services/prosesMelahirkan";
import { Save, ArrowLeft, Loader2 } from "lucide-react";

export default function PelayananPersalinan() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState("ringkasan");
  const [kehamilan, setKehamilan] = useState(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  // States
  const [ringkasan, setRingkasan] = useState(null);
  const [formRingkasan, setFormRingkasan] = useState({
    tanggal_melahirkan: "",
    pukul_melahirkan: "",
    umur_kehamilan_minggu: "",
    penolong_proses_melahirkan: "",
    cara_melahirkan: "",
    keadaan_ibu: "",
    keadaan_ibu_detail_sakit: "",
    kb_pasca_melahirkan: "",
    keterangan_tambahan_ibu: "",
    bayi_anak_ke: "",
    bayi_berat_lahir_gram: "",
    bayi_panjang_badan_cm: "",
    bayi_lingkar_kepala_cm: "",
    bayi_jenis_kelamin: "",
    kondisi_bayi_segera_menangis: false,
    kondisi_bayi_seluruh_tubuh_kemerahan: false,
    asuhan_imd_1_jam_pertama: false,
    asuhan_suntikan_vitamin_k1: false,
    asuhan_salep_mata_antibiotika: false,
    asuhan_imunisasi_hb0: false,
    keterangan_tambahan_bayi: "",
  });

  const [riwayat, setRiwayat] = useState(null);
  const [formRiwayat, setFormRiwayat] = useState({
    g_gravida: "",
    p_partus: "",
    a_abortus: "",
    hari_melahirkan: "",
    tanggal_melahirkan: "",
    pukul_melahirkan: "",
    cara_melahirkan_spontan: false,
    tindakan_sc: false,
    penolong_bidan: false,
    penolong_dokter: false,
    taksiran_melahirkan: "",
    fasyankes_tempat_melahirkan: "",
    rujukan_keterangan: "",
    inisiasi_menyusu_dini_keterangan: "",
  });

  const [keterangan, setKeterangan] = useState(null);
  const [formKeterangan, setFormKeterangan] = useState({
    nomor_surat: "",
    hari_lahir: "",
    tanggal_lahir: "",
    pukul_lahir: "",
    jenis_kelamin: "",
    jenis_kelahiran: "",
    anak_ke: "",
    usia_gestasi_minggu: "",
    berat_lahir_gram: "",
    panjang_badan_cm: "",
    lingkar_kepala_cm: "",
    lokasi_persalinan: "",
    alamat_lokasi_persalinan: "",
    nama_bayi_diberi_nama: "",
    nama_ibu: "",
    nik_ibu: "",
    nama_ayah: "",
    pekerjaan_orang_tua: "",
    alamat_orang_tua: "",
    nama_penolong_kelahiran: "",
  });

  useEffect(() => {
    const fetchData = async () => {
      try {
        const kehamilanList = await getKehamilanByIbuId(id);
        if (kehamilanList.length > 0) {
          const aktif = kehamilanList[0];
          setKehamilan(aktif);

          // Fetch Ringkasan
          const dRingkasan = await getRingkasanPersalinanByKehamilanId(aktif.id);
          if (dRingkasan && dRingkasan.length > 0) {
            setRingkasan(dRingkasan[0]);
            const d = dRingkasan[0];
            setFormRingkasan((prev) => ({
              ...prev,
              tanggal_melahirkan: d.tanggal_melahirkan ? d.tanggal_melahirkan.split("T")[0] : "",
              pukul_melahirkan:
                d.pukul_melahirkan && !d.pukul_melahirkan.startsWith("0000") ? new Date(d.pukul_melahirkan).toTimeString().substring(0, 5) : d.pukul_melahirkan?.includes("T") ? d.pukul_melahirkan.split("T")[1].substring(0, 5) : "",
              umur_kehamilan_minggu: d.umur_kehamilan_minggu ?? "",
              penolong_proses_melahirkan: d.penolong_proses_melahirkan || "",
              cara_melahirkan: d.cara_melahirkan || "",
              keadaan_ibu: d.keadaan_ibu || "",
              kb_pasca_melahirkan: d.kb_pasca_melahirkan || "",
              bayi_anak_ke: d.bayi_anak_ke ?? "",
              bayi_berat_lahir_gram: d.bayi_berat_lahir_gram ?? "",
              bayi_panjang_badan_cm: d.bayi_panjang_badan_cm ?? "",
              bayi_lingkar_kepala_cm: d.bayi_lingkar_kepala_cm ?? "",
              bayi_jenis_kelamin: d.bayi_jenis_kelamin || "",
              kondisi_bayi_segera_menangis: d.kondisi_bayi_segera_menangis || false,
              asuhan_imd_1_jam_pertama: d.asuhan_imd_1_jam_pertama || false,
            }));
          }

          // Fetch Riwayat
          const dRiwayat = await getRiwayatMelahirkanByKehamilanId(aktif.id);
          if (dRiwayat && dRiwayat.length > 0) {
            setRiwayat(dRiwayat[0]);
            const d = dRiwayat[0];
            setFormRiwayat((prev) => ({
              ...prev,
              g_gravida: d.g_gravida ?? "",
              p_partus: d.p_partus ?? "",
              a_abortus: d.a_abortus ?? "",
              hari_melahirkan: d.hari_melahirkan || "",
              tanggal_melahirkan: d.tanggal_melahirkan ? d.tanggal_melahirkan.split("T")[0] : "",
              pukul_melahirkan:
                d.pukul_melahirkan && !d.pukul_melahirkan.startsWith("0000") ? new Date(d.pukul_melahirkan).toTimeString().substring(0, 5) : d.pukul_melahirkan?.includes("T") ? d.pukul_melahirkan.split("T")[1].substring(0, 5) : "",
              cara_melahirkan_spontan: d.cara_melahirkan_spontan || false,
              cara_melahirkan_sungsang: d.cara_melahirkan_sungsang || false,
              tindakan_ekstraksi_vakum: d.tindakan_ekstraksi_vakum || false,
              tindakan_ekstraksi_forsep: d.tindakan_ekstraksi_forsep || false,
              tindakan_sc: d.tindakan_sc || false,
              penolong_dokter_spesialis: d.penolong_dokter_spesialis || false,
              penolong_dokter: d.penolong_dokter || false,
              penolong_bidan: d.penolong_bidan || false,
              taksiran_melahirkan: d.taksiran_melahirkan ? d.taksiran_melahirkan.split("T")[0] : "",
              fasyankes_tempat_melahirkan: d.fasyankes_tempat_melahirkan || "",
              rujukan_keterangan: d.rujukan_keterangan || "",
              inisiasi_menyusu_dini_keterangan: d.inisiasi_menyusu_dini_keterangan || "",
            }));
          }
        }

        // Fetch Keterangan Lahir by Ibu ID
        const dKeterangan = await getKeteranganLahirByIbuId(id);
        if (dKeterangan && dKeterangan.length > 0) {
          setKeterangan(dKeterangan[0]);
          const d = dKeterangan[0];
          setFormKeterangan((prev) => ({
            ...prev,
            nomor_surat: d.nomor_surat || "",
            hari_lahir: d.hari_lahir || "",
            tanggal_lahir: d.tanggal_lahir ? d.tanggal_lahir.split("T")[0] : "",
            pukul_lahir: d.pukul_lahir && !d.pukul_lahir.startsWith("0000") ? new Date(d.pukul_lahir).toTimeString().substring(0, 5) : d.pukul_lahir?.includes("T") ? d.pukul_lahir.split("T")[1].substring(0, 5) : "",
            jenis_kelamin: d.jenis_kelamin || "",
            jenis_kelahiran: d.jenis_kelahiran || "",
            anak_ke: d.anak_ke ?? "",
            usia_gestasi_minggu: d.usia_gestasi_minggu ?? "",
            berat_lahir_gram: d.berat_lahir_gram ?? "",
            panjang_badan_cm: d.panjang_badan_cm ?? "",
            lingkar_kepala_cm: d.lingkar_kepala_cm ?? "",
            lokasi_persalinan: d.lokasi_persalinan || "",
            alamat_lokasi_persalinan: d.alamat_lokasi_persalinan || "",
            nama_bayi_diberi_nama: d.nama_bayi_diberi_nama || "",
            nama_ibu: d.nama_ibu || "",
            nik_ibu: d.nik_ibu || "",
            nama_ayah: d.nama_ayah || "",
            pekerjaan_orang_tua: d.pekerjaan_orang_tua || "",
            alamat_orang_tua: d.alamat_orang_tua || "",
            nama_penolong_kelahiran: d.nama_penolong_kelahiran || "",
          }));
        }
      } catch (err) {
        console.error(err);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, [id]);

  const handleChange = (e, setForm) => {
    const { name, value, type, checked } = e.target;
    const val = type === "checkbox" ? checked : value;
    setForm((prev) => ({ ...prev, [name]: val }));
  };

  const submitRingkasan = async (e) => {
    e.preventDefault();
    if (!kehamilan) return;
    setSaving(true);
    try {
      const payload = { ...formRingkasan, kehamilan_id: kehamilan.id };
      // parseInt for numbers
      payload.umur_kehamilan_minggu = parseInt(payload.umur_kehamilan_minggu) || 0;
      payload.bayi_anak_ke = parseInt(payload.bayi_anak_ke) || 0;
      payload.bayi_berat_lahir_gram = parseInt(payload.bayi_berat_lahir_gram) || 0;
      payload.bayi_panjang_badan_cm = parseInt(payload.bayi_panjang_badan_cm) || 0;
      payload.bayi_lingkar_kepala_cm = parseInt(payload.bayi_lingkar_kepala_cm) || 0;

      if (ringkasan) await updateRingkasanPersalinan(ringkasan.id_ringkasan, payload);
      else await createRingkasanPersalinan(payload);
      alert("Ringkasan Persalinan berhasil disimpan!");
    } catch (err) {
      alert("Gagal menyimpan data.");
    } finally {
      setSaving(false);
    }
  };

  const submitRiwayat = async (e) => {
    e.preventDefault();
    if (!kehamilan) return;
    setSaving(true);
    try {
      const payload = { ...formRiwayat, kehamilan_id: kehamilan.id };
      payload.g_gravida = parseInt(payload.g_gravida) || 0;
      payload.p_partus = parseInt(payload.p_partus) || 0;
      payload.a_abortus = parseInt(payload.a_abortus) || 0;

      if (riwayat) await updateRiwayatMelahirkan(riwayat.id_riwayat_melahirkan, payload);
      else await createRiwayatMelahirkan(payload);
      alert("Riwayat Proses Melahirkan berhasil disimpan!");
    } catch (err) {
      alert("Gagal menyimpan data.");
    } finally {
      setSaving(false);
    }
  };

  const submitKeterangan = async (e) => {
    e.preventDefault();
    setSaving(true);
    try {
      const payload = { ...formKeterangan, id_ibu_relasi: parseInt(id) };
      payload.anak_ke = parseInt(payload.anak_ke) || 0;
      payload.berat_lahir_gram = parseInt(payload.berat_lahir_gram) || 0;
      payload.panjang_badan_cm = parseInt(payload.panjang_badan_cm) || 0;
      payload.lingkar_kepala_cm = parseInt(payload.lingkar_kepala_cm) || 0;

      if (keterangan) await updateKeteranganLahir(keterangan.id_keterangan_lahir, payload);
      else await createKeteranganLahir(payload);
      alert("Keterangan Lahir berhasil disimpan!");
    } catch (err) {
      alert("Gagal menyimpan data.");
    } finally {
      setSaving(false);
    }
  };

  const TabButton = ({ id, label }) => (
    <button
      onClick={() => setActiveTab(id)}
      className={`py-3 px-6 text-sm font-medium border-b-2 transition-colors ${activeTab === id ? "border-indigo-600 text-indigo-600 bg-indigo-50" : "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300"}`}
    >
      {label}
    </button>
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
          <button onClick={() => navigate(-1)} className="p-2 rounded-full hover:bg-gray-100">
            <ArrowLeft size={20} />
          </button>
          <div>
            <h1 className="text-2xl font-bold text-gray-900">Proses & Riwayat Melahirkan</h1>
            <p className="text-gray-500">Pencatatan proses persalinan hingga bayi lahir.</p>
          </div>
        </div>

        <div className="w-full border-b border-gray-200 mb-6 flex overflow-x-auto">
          <TabButton id="ringkasan" label="Ringkasan Melahirkan" />
          <TabButton id="riwayat" label="Riwayat Melahirkan" />
          <TabButton id="keterangan" label="Surat Keterangan Lahir" />
        </div>

        {activeTab === "ringkasan" && (
          <form onSubmit={submitRingkasan} className="bg-white rounded-xl shadow-sm p-6 space-y-6 animate-fadeIn">
            <h2 className="text-lg font-semibold text-indigo-700">Ringkasan Pelayanan Persalinan</h2>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">Tanggal Melahirkan</label>
                <input type="date" name="tanggal_melahirkan" value={formRingkasan.tanggal_melahirkan} onChange={(e) => handleChange(e, setFormRingkasan)} className="w-full border rounded px-3 py-2" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Umur Kehamilan (Mgg)</label>
                <input type="number" name="umur_kehamilan_minggu" value={formRingkasan.umur_kehamilan_minggu} onChange={(e) => handleChange(e, setFormRingkasan)} className="w-full border rounded px-3 py-2" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Penolong Persalinan</label>
                <input name="penolong_proses_melahirkan" value={formRingkasan.penolong_proses_melahirkan} onChange={(e) => handleChange(e, setFormRingkasan)} className="w-full border rounded px-3 py-2" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Cara Melahirkan</label>
                <select name="cara_melahirkan" value={formRingkasan.cara_melahirkan} onChange={(e) => handleChange(e, setFormRingkasan)} className="w-full border rounded px-3 py-2">
                  <option value="">-- Pilih --</option>
                  <option>Spontan/Normal</option>
                  <option>SC</option>
                  <option>Vakum</option>
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Keadaan Ibu</label>
                <input name="keadaan_ibu" value={formRingkasan.keadaan_ibu} onChange={(e) => handleChange(e, setFormRingkasan)} className="w-full border rounded px-3 py-2" placeholder="Sehat / Sakit" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">KB Pasca Salin</label>
                <input name="kb_pasca_melahirkan" value={formRingkasan.kb_pasca_melahirkan} onChange={(e) => handleChange(e, setFormRingkasan)} className="w-full border rounded px-3 py-2" />
              </div>
            </div>
            <hr />
            <h3 className="font-semibold text-gray-800">Keadaan Bayi Saat Lahir</h3>
            <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">Anak Ke</label>
                <input type="number" name="bayi_anak_ke" value={formRingkasan.bayi_anak_ke} onChange={(e) => handleChange(e, setFormRingkasan)} className="w-full border rounded px-3 py-2" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Berat (gram)</label>
                <input type="number" name="bayi_berat_lahir_gram" value={formRingkasan.bayi_berat_lahir_gram} onChange={(e) => handleChange(e, setFormRingkasan)} className="w-full border rounded px-3 py-2" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Panjang (cm)</label>
                <input type="number" name="bayi_panjang_badan_cm" value={formRingkasan.bayi_panjang_badan_cm} onChange={(e) => handleChange(e, setFormRingkasan)} className="w-full border rounded px-3 py-2" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Lingkar Kepala (cm)</label>
                <input type="number" name="bayi_lingkar_kepala_cm" value={formRingkasan.bayi_lingkar_kepala_cm} onChange={(e) => handleChange(e, setFormRingkasan)} className="w-full border rounded px-3 py-2" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Jenis Kelamin</label>
                <select name="bayi_jenis_kelamin" value={formRingkasan.bayi_jenis_kelamin} onChange={(e) => handleChange(e, setFormRingkasan)} className="w-full border rounded px-3 py-2">
                  <option value="">-- Pilih --</option>
                  <option>Laki-laki</option>
                  <option>Perempuan</option>
                </select>
              </div>
            </div>
            <div className="flex flex-wrap gap-6 pt-2">
              <label className="flex items-center gap-2">
                <input type="checkbox" name="kondisi_bayi_segera_menangis" checked={formRingkasan.kondisi_bayi_segera_menangis} onChange={(e) => handleChange(e, setFormRingkasan)} className="w-4 h-4" /> Segera Menangis
              </label>
              <label className="flex items-center gap-2">
                <input type="checkbox" name="asuhan_imd_1_jam_pertama" checked={formRingkasan.asuhan_imd_1_jam_pertama} onChange={(e) => handleChange(e, setFormRingkasan)} className="w-4 h-4" /> IMD 1 Jam Pertama
              </label>
            </div>
            <button type="submit" disabled={saving} className="bg-indigo-600 text-white px-6 py-2 rounded-lg flex items-center gap-2 mt-4">
              <Save size={18} /> Simpan Ringkasan
            </button>
          </form>
        )}

        {activeTab === "riwayat" && (
          <form onSubmit={submitRiwayat} className="bg-white rounded-xl shadow-sm p-6 space-y-6 animate-fadeIn">
            <h2 className="text-lg font-semibold text-indigo-700">Riwayat Proses Melahirkan</h2>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">Gravida (G)</label>
                <input type="number" name="g_gravida" value={formRiwayat.g_gravida} onChange={(e) => handleChange(e, setFormRiwayat)} className="w-full border rounded px-3 py-2" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Partus (P)</label>
                <input type="number" name="p_partus" value={formRiwayat.p_partus} onChange={(e) => handleChange(e, setFormRiwayat)} className="w-full border rounded px-3 py-2" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Abortus (A)</label>
                <input type="number" name="a_abortus" value={formRiwayat.a_abortus} onChange={(e) => handleChange(e, setFormRiwayat)} className="w-full border rounded px-3 py-2" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Tanggal Melahirkan</label>
                <input type="date" name="tanggal_melahirkan" value={formRiwayat.tanggal_melahirkan} onChange={(e) => handleChange(e, setFormRiwayat)} className="w-full border rounded px-3 py-2" />
              </div>
              <div className="md:col-span-2">
                <label className="block text-sm font-medium mb-1">Faskes / Tempat Melahirkan</label>
                <input name="fasyankes_tempat_melahirkan" value={formRiwayat.fasyankes_tempat_melahirkan} onChange={(e) => handleChange(e, setFormRiwayat)} className="w-full border rounded px-3 py-2" />
              </div>
            </div>
            <div className="flex flex-wrap gap-6 pt-2">
              <label className="flex items-center gap-2">
                <input type="checkbox" name="cara_melahirkan_spontan" checked={formRiwayat.cara_melahirkan_spontan} onChange={(e) => handleChange(e, setFormRiwayat)} className="w-4 h-4" /> Spontan/Normal
              </label>
              <label className="flex items-center gap-2">
                <input type="checkbox" name="tindakan_sc" checked={formRiwayat.tindakan_sc} onChange={(e) => handleChange(e, setFormRiwayat)} className="w-4 h-4" /> Operasi Caesar
              </label>
            </div>
            <button type="submit" disabled={saving} className="bg-indigo-600 text-white px-6 py-2 rounded-lg flex items-center gap-2 mt-4">
              <Save size={18} /> Simpan Riwayat
            </button>
          </form>
        )}

        {activeTab === "keterangan" && (
          <form onSubmit={submitKeterangan} className="bg-white rounded-xl shadow-sm p-6 space-y-6 animate-fadeIn">
            <h2 className="text-lg font-semibold text-indigo-700">Surat Keterangan Lahir (Model A.B)</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">Nomor Surat</label>
                <input name="nomor_surat" value={formKeterangan.nomor_surat} onChange={(e) => handleChange(e, setFormKeterangan)} className="w-full border rounded px-3 py-2" placeholder="Nomor reg surat..." />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Nama Bayi Diberikan</label>
                <input name="nama_bayi_diberi_nama" value={formKeterangan.nama_bayi_diberi_nama} onChange={(e) => handleChange(e, setFormKeterangan)} className="w-full border rounded px-3 py-2" placeholder="Tulis An. jika belum" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Tanggal Lahir</label>
                <input type="date" name="tanggal_lahir" value={formKeterangan.tanggal_lahir} onChange={(e) => handleChange(e, setFormKeterangan)} className="w-full border rounded px-3 py-2" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Hari Lahir</label>
                <input name="hari_lahir" value={formKeterangan.hari_lahir} onChange={(e) => handleChange(e, setFormKeterangan)} className="w-full border rounded px-3 py-2" placeholder="Contoh: Senin" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Berat Lahir (gram)</label>
                <input type="number" name="berat_lahir_gram" value={formKeterangan.berat_lahir_gram} onChange={(e) => handleChange(e, setFormKeterangan)} className="w-full border rounded px-3 py-2" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Panjang Bayi (cm)</label>
                <input type="number" name="panjang_badan_cm" value={formKeterangan.panjang_badan_cm} onChange={(e) => handleChange(e, setFormKeterangan)} className="w-full border rounded px-3 py-2" />
              </div>

              <div className="col-span-1 md:col-span-2 border-t pt-4 mt-2">
                <h3 className="font-semibold mb-3 text-gray-800">Orang Tua</h3>
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Nama Ibu</label>
                <input name="nama_ibu" value={formKeterangan.nama_ibu} onChange={(e) => handleChange(e, setFormKeterangan)} className="w-full border rounded px-3 py-2" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">NIK Ibu</label>
                <input name="nik_ibu" value={formKeterangan.nik_ibu} onChange={(e) => handleChange(e, setFormKeterangan)} className="w-full border rounded px-3 py-2" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Nama Ayah</label>
                <input name="nama_ayah" value={formKeterangan.nama_ayah} onChange={(e) => handleChange(e, setFormKeterangan)} className="w-full border rounded px-3 py-2" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Saksi / Penolong</label>
                <input name="nama_penolong_kelahiran" value={formKeterangan.nama_penolong_kelahiran} onChange={(e) => handleChange(e, setFormKeterangan)} className="w-full border rounded px-3 py-2" />
              </div>
            </div>
            <button type="submit" disabled={saving} className="bg-indigo-600 text-white px-6 py-2 rounded-lg flex items-center gap-2 mt-4">
              <Save size={18} /> Simpan Keterangan Lahir
            </button>
          </form>
        )}
      </div>
    </MainLayout>
  );
}

// src/pages/Ibu/RencanaPersalinan.jsx
import React, { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import MainLayout from "../../components/Layout/MainLayout";
import { getKehamilanByIbuId } from "../../services/kehamilan";
import { getRencanaByKehamilanId, createRencana, updateRencana } from "../../services/persalinan";
import { Save, ArrowLeft } from "lucide-react";

export default function RencanaPersalinan() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [kehamilan, setKehamilan] = useState(null);
  const [rencana, setRencana] = useState(null);
  const [formRencana, setFormRencana] = useState({
    nama_ibu_pernyataan: "",
    alamat_ibu_pernyataan: "",
    perkiraan_bulan_persalinan: "",
    perkiraan_tahun_persalinan: "",
    fasyankes_1_nama_tenaga: "",
    fasyankes_1_nama_fasilitas: "",
    fasyankes_2_nama_tenaga: "",
    fasyankes_2_nama_fasilitas: "",
    sumber_dana_persalinan: "JKN/BPJS",
    kendaraan_1_nama: "",
    kendaraan_1_hp: "",
    metode_kontrasepsi_pilihan: "",
    donor_golongan_darah: "",
    donor_rhesus: "",
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
          const rencanaData = await getRencanaByKehamilanId(aktif.id);
          if (rencanaData && rencanaData.length > 0) {
            const r = rencanaData[0];
            setRencana(r);
            setFormRencana({
              nama_ibu_pernyataan: r.nama_ibu_pernyataan || "",
              alamat_ibu_pernyataan: r.alamat_ibu_pernyataan || "",
              perkiraan_bulan_persalinan: r.perkiraan_bulan_persalinan || "",
              perkiraan_tahun_persalinan: r.perkiraan_tahun_persalinan || "",
              fasyankes_1_nama_tenaga: r.fasyankes_1_nama_tenaga || "",
              fasyankes_1_nama_fasilitas: r.fasyankes_1_nama_fasilitas || "",
              fasyankes_2_nama_tenaga: r.fasyankes_2_nama_tenaga || "",
              fasyankes_2_nama_fasilitas: r.fasyankes_2_nama_fasilitas || "",
              sumber_dana_persalinan: r.sumber_dana_persalinan || "JKN/BPJS",
              kendaraan_1_nama: r.kendaraan_1_nama || "",
              kendaraan_1_hp: r.kendaraan_1_hp || "",
              metode_kontrasepsi_pilihan: r.metode_kontrasepsi_pilihan || "",
              donor_golongan_darah: r.donor_golongan_darah || "",
              donor_rhesus: r.donor_rhesus || "",
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
    const { name, value } = e.target;
    setFormRencana((prev) => ({ ...prev, [name]: value }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!kehamilan) return;
    setSaving(true);
    try {
      const payload = { ...formRencana, kehamilan_id: kehamilan.id };
      if (rencana) await updateRencana(rencana.id_rencana_persalinan, payload);
      else await createRencana(payload);
      alert("Rencana persalinan berhasil disimpan");
    } catch (err) {
      console.error(err);
      alert("Gagal menyimpan rencana persalinan");
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
            <h1 className="text-2xl font-bold text-gray-900">Rencana Persalinan</h1>
            <p className="text-gray-500">Pencatatan proses persalinan hingga bayi lahir.</p>
          </div>
        </div>

        <form onSubmit={handleSubmit} className="space-y-6">
          {/* Data Ibu */}
          <div className="bg-white rounded-xl shadow-sm p-6">
            <h3 className="font-semibold mb-4 text-indigo-700">Data Ibu</h3>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">Nama Ibu</label>
                <input name="nama_ibu_pernyataan" value={formRencana.nama_ibu_pernyataan} onChange={handleChange} className="w-full border rounded px-3 py-2" placeholder="Nama lengkap ibu" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Alamat</label>
                <input name="alamat_ibu_pernyataan" value={formRencana.alamat_ibu_pernyataan} onChange={handleChange} className="w-full border rounded px-3 py-2" placeholder="Alamat domisili" />
              </div>
            </div>
          </div>

          {/* Perkiraan Persalinan */}
          <div className="bg-white rounded-xl shadow-sm p-6">
            <h3 className="font-semibold mb-4 text-indigo-700">Perkiraan Waktu Persalinan</h3>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">Perkiraan Bulan</label>
                <select name="perkiraan_bulan_persalinan" value={formRencana.perkiraan_bulan_persalinan} onChange={handleChange} className="w-full border rounded px-3 py-2">
                  <option value="">-- Pilih Bulan --</option>
                  {["Januari", "Februari", "Maret", "April", "Mei", "Juni", "Juli", "Agustus", "September", "Oktober", "November", "Desember"].map((b) => (
                    <option key={b} value={b}>
                      {b}
                    </option>
                  ))}
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Perkiraan Tahun</label>
                <input type="number" name="perkiraan_tahun_persalinan" value={formRencana.perkiraan_tahun_persalinan} onChange={handleChange} className="w-full border rounded px-3 py-2" placeholder="2026" />
              </div>
            </div>
          </div>

          {/* Penolong & Fasyankes */}
          <div className="bg-white rounded-xl shadow-sm p-6">
            <h3 className="font-semibold mb-4 text-indigo-700">Penolong & Fasilitas Kesehatan</h3>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">Penolong 1 (Nama Tenaga)</label>
                <input name="fasyankes_1_nama_tenaga" value={formRencana.fasyankes_1_nama_tenaga} onChange={handleChange} className="w-full border rounded px-3 py-2" placeholder="Nama bidan/dokter" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Fasyankes 1 (Nama Fasilitas)</label>
                <input name="fasyankes_1_nama_fasilitas" value={formRencana.fasyankes_1_nama_fasilitas} onChange={handleChange} className="w-full border rounded px-3 py-2" placeholder="Puskesmas/RS" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Penolong 2 (Nama Tenaga)</label>
                <input name="fasyankes_2_nama_tenaga" value={formRencana.fasyankes_2_nama_tenaga} onChange={handleChange} className="w-full border rounded px-3 py-2" placeholder="Cadangan penolong" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Fasyankes 2 (Nama Fasilitas)</label>
                <input name="fasyankes_2_nama_fasilitas" value={formRencana.fasyankes_2_nama_fasilitas} onChange={handleChange} className="w-full border rounded px-3 py-2" placeholder="Cadangan fasyankes" />
              </div>
            </div>
          </div>

          {/* Sumber Dana, Kendaraan, Kontrasepsi */}
          <div className="bg-white rounded-xl shadow-sm p-6">
            <h3 className="font-semibold mb-4 text-indigo-700">Pendukung Persalinan</h3>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">Sumber Dana Persalinan</label>
                <select name="sumber_dana_persalinan" value={formRencana.sumber_dana_persalinan} onChange={handleChange} className="w-full border rounded px-3 py-2">
                  <option>JKN/BPJS</option>
                  <option>Jamkesda</option>
                  <option>Asuransi Swasta</option>
                  <option>Biaya sendiri</option>
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Kendaraan</label>
                <input name="kendaraan_1_nama" value={formRencana.kendaraan_1_nama} onChange={handleChange} className="w-full border rounded px-3 py-2" placeholder="Jenis kendaraan" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">HP / Kontak Kendaraan</label>
                <input name="kendaraan_1_hp" value={formRencana.kendaraan_1_hp} onChange={handleChange} className="w-full border rounded px-3 py-2" placeholder="08xxxxxxxxxx" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Metode Kontrasepsi Pilihan</label>
                <input name="metode_kontrasepsi_pilihan" value={formRencana.metode_kontrasepsi_pilihan} onChange={handleChange} className="w-full border rounded px-3 py-2" placeholder="IUD / Implant / Pil / dll" />
              </div>
            </div>
          </div>

          {/* Donor Darah */}
          <div className="bg-white rounded-xl shadow-sm p-6">
            <h3 className="font-semibold mb-4 text-indigo-700">Calon Donor Darah</h3>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">Golongan Darah Donor</label>
                <select name="donor_golongan_darah" value={formRencana.donor_golongan_darah} onChange={handleChange} className="w-full border rounded px-3 py-2">
                  <option value="">-- Pilih --</option>
                  <option>A</option>
                  <option>B</option>
                  <option>AB</option>
                  <option>O</option>
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Rhesus Donor</label>
                <select name="donor_rhesus" value={formRencana.donor_rhesus} onChange={handleChange} className="w-full border rounded px-3 py-2">
                  <option value="">-- Pilih --</option>
                  <option>Positif</option>
                  <option>Negatif</option>
                </select>
              </div>
            </div>
          </div>

          <button type="submit" disabled={saving} className="bg-indigo-600 text-white px-6 py-2 rounded-lg flex items-center gap-2 hover:bg-indigo-700 transition-colors">
            <Save size={18} /> {saving ? "Menyimpan..." : "Simpan Rencana Persalinan"}
          </button>
        </form>
      </div>
    </MainLayout>
  );
}

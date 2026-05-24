// src/pages/Ibu/CatatanPelayanan.jsx
import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import MainLayout from "../../components/Layout/MainLayout";
import { getKehamilanByIbuId } from "../../services/kehamilan";
import { catatanT1, catatanT2, catatanT3, catatanNifas } from "../../services/catatanPelayanan";
import { Save, Plus } from "lucide-react";

const services = { T1: catatanT1, T2: catatanT2, T3: catatanT3, Nifas: catatanNifas };
const tabLabels = { T1: "Trimester 1", T2: "Trimester 2", T3: "Trimester 3", Nifas: "Nifas" };

export default function CatatanPelayanan() {
  const { id } = useParams();
  const [kehamilan, setKehamilan] = useState(null);
  const [activeTab, setActiveTab] = useState("T1");
  const [records, setRecords] = useState([]);
  const [form, setForm] = useState({
    tanggal_periksa_stamp_paraf: "",
    keluhan_pemeriksaan_tindakan_saran: "",
    tanggal_kembali: "",
  });
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      try {
        const kehamilanList = await getKehamilanByIbuId(id);
        if (kehamilanList.length > 0) {
          const aktif = kehamilanList[0];
          setKehamilan(aktif);
          const svc = services[activeTab];
          const data = await svc.getByKehamilanId(aktif.id);
          setRecords(data || []);
        }
      } catch (err) {
        console.error(err);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, [id, activeTab]);

  const handleChange = (e) => setForm({ ...form, [e.target.name]: e.target.value });

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!kehamilan) return;
    setSaving(true);
    try {
      const svc = services[activeTab];
      const payload = { ...form, kehamilan_id: kehamilan.id };
      const created = await svc.create(payload);
      setRecords([...records, created]);
      setForm({ tanggal_periksa_stamp_paraf: "", keluhan_pemeriksaan_tindakan_saran: "", tanggal_kembali: "" });
      alert("Catatan pelayanan berhasil ditambahkan");
    } catch (err) {
      alert("Gagal menyimpan catatan");
      console.error(err);
    } finally {
      setSaving(false);
    }
  };

  const idKey = activeTab === "Nifas" ? "id_catatan_nifas" : "id_catatan";

  return (
    <MainLayout>
      <div className="p-6 max-w-5xl mx-auto">
        <h1 className="text-2xl font-bold mb-2">Catatan Pelayanan</h1>
        <p className="text-gray-500 mb-6">Catatan kunjungan pelayanan per trimester dan nifas.</p>

        <div className="flex gap-2 mb-6 border-b">
          {Object.keys(tabLabels).map((tab) => (
            <button key={tab} onClick={() => setActiveTab(tab)} className={`px-4 py-2 ${activeTab === tab ? "border-b-2 border-indigo-600 text-indigo-600 font-semibold" : "text-gray-500"}`}>
              {tabLabels[tab]}
            </button>
          ))}
        </div>

        {/* Tabel Catatan */}
        <div className="bg-white rounded-xl shadow-sm p-6 mb-6">
          <h3 className="font-semibold mb-4">Riwayat Catatan - {tabLabels[activeTab]}</h3>
          {loading ? (
            <p className="text-gray-500">Memuat...</p>
          ) : records.length > 0 ? (
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="px-4 py-2 text-left text-xs font-medium text-gray-500">No</th>
                    <th className="px-4 py-2 text-left text-xs font-medium text-gray-500">Tanggal Periksa</th>
                    <th className="px-4 py-2 text-left text-xs font-medium text-gray-500">Keluhan / Pemeriksaan / Tindakan / Saran</th>
                    <th className="px-4 py-2 text-left text-xs font-medium text-gray-500">Tanggal Kembali</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-100">
                  {records.map((r, idx) => (
                    <tr key={r[idKey] || idx}>
                      <td className="px-4 py-2 text-sm">{idx + 1}</td>
                      <td className="px-4 py-2 text-sm">{r.tanggal_periksa_stamp_paraf ? new Date(r.tanggal_periksa_stamp_paraf).toLocaleDateString("id-ID") : "-"}</td>
                      <td className="px-4 py-2 text-sm whitespace-pre-wrap">{r.keluhan_pemeriksaan_tindakan_saran || "-"}</td>
                      <td className="px-4 py-2 text-sm">{r.tanggal_kembali ? new Date(r.tanggal_kembali).toLocaleDateString("id-ID") : "-"}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          ) : (
            <p className="text-gray-500 text-sm">Belum ada catatan pelayanan {tabLabels[activeTab]}.</p>
          )}
        </div>

        {/* Form Tambah Catatan */}
        <form onSubmit={handleSubmit} className="bg-white rounded-xl shadow-sm p-6 space-y-4">
          <h3 className="font-semibold">Tambah Catatan Baru - {tabLabels[activeTab]}</h3>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium mb-1">Tanggal Periksa / Stempel / Paraf</label>
              <input type="date" name="tanggal_periksa_stamp_paraf" value={form.tanggal_periksa_stamp_paraf} onChange={handleChange} className="w-full border rounded-lg px-3 py-2" required />
            </div>
            <div>
              <label className="block text-sm font-medium mb-1">Tanggal Kembali</label>
              <input type="date" name="tanggal_kembali" value={form.tanggal_kembali} onChange={handleChange} className="w-full border rounded-lg px-3 py-2" />
            </div>
          </div>
          <div>
            <label className="block text-sm font-medium mb-1">Keluhan / Pemeriksaan / Tindakan / Saran</label>
            <textarea name="keluhan_pemeriksaan_tindakan_saran" value={form.keluhan_pemeriksaan_tindakan_saran} onChange={handleChange} className="w-full border rounded-lg px-3 py-2" rows="4" required />
          </div>
          <button type="submit" disabled={saving} className="bg-indigo-600 text-white px-6 py-2 rounded-lg flex items-center gap-2">
            <Plus size={18} /> {saving ? "Menyimpan..." : "Tambah Catatan"}
          </button>
        </form>
      </div>
    </MainLayout>
  );
}

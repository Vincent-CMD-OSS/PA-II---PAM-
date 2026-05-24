import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import MainLayout from "../../components/Layout/MainLayout";
import { createKependudukan } from "../../services/kependudukan";
import { Save, ArrowLeft } from "lucide-react";

export default function KependudukanCreate() {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const [form, setForm] = useState({
    no_kk: "",
    nik: "",
    dusun: "",
    nama_lengkap: "",
    golongan_darah: "",
    jenis_kelamin: "Perempuan",
    tempat_lahir: "",
    tanggal_lahir: "",
    pekerjaan: "",
    pendidikan_terakhir: "",
    alamat: "",
    telepon: "",
  });

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    try {
      await createKependudukan(form);
      alert("Data KK berhasil ditambahkan");
      navigate("/kependudukan");
    } catch (err) {
      alert(err.response?.data?.message || "Gagal menambahkan data");
    } finally {
      setLoading(false);
    }
  };

  return (
    <MainLayout>
      <div className="p-6 max-w-3xl mx-auto">
        <div className="flex items-center gap-4 mb-6">
          <button onClick={() => navigate(-1)} className="p-2 rounded-full hover:bg-gray-100"><ArrowLeft size={20} /></button>
          <h1 className="text-2xl font-bold">Tambah Data KK</h1>
        </div>
        <form onSubmit={handleSubmit} className="bg-white rounded-xl shadow-sm p-6 space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div><label>Nama Lengkap</label><input name="nama_lengkap" required onChange={handleChange} className="w-full border rounded px-3 py-2" /></div>
            <div><label>NIK</label><input name="nik" required onChange={handleChange} className="w-full border rounded px-3 py-2" /></div>
            <div><label>No. KK</label><input name="no_kk" onChange={handleChange} className="w-full border rounded px-3 py-2" /></div>
            <div><label>Tempat Lahir</label><input name="tempat_lahir" onChange={handleChange} className="w-full border rounded px-3 py-2" /></div>
            <div><label>Tanggal Lahir</label><input type="date" name="tanggal_lahir" required onChange={handleChange} className="w-full border rounded px-3 py-2" /></div>
            <div><label>Jenis Kelamin</label><select name="jenis_kelamin" onChange={handleChange} className="w-full border rounded px-3 py-2"><option>Perempuan</option><option>Laki-laki</option></select></div>
            <div><label>Golongan Darah</label><input name="golongan_darah" onChange={handleChange} className="w-full border rounded px-3 py-2" /></div>
            <div><label>Pendidikan Terakhir</label><input name="pendidikan_terakhir" onChange={handleChange} className="w-full border rounded px-3 py-2" /></div>
            <div><label>Pekerjaan</label><input name="pekerjaan" onChange={handleChange} className="w-full border rounded px-3 py-2" /></div>
            <div><label>Dusun</label><input name="dusun" onChange={handleChange} className="w-full border rounded px-3 py-2" /></div>
            <div className="md:col-span-2"><label>Alamat</label><textarea name="alamat" rows="2" onChange={handleChange} className="w-full border rounded px-3 py-2" /></div>
            <div><label>Nomor Telepon</label><input name="telepon" onChange={handleChange} className="w-full border rounded px-3 py-2" /></div>
          </div>
          <button type="submit" disabled={loading} className="bg-indigo-600 text-white px-4 py-2 rounded-lg flex items-center gap-2 w-full justify-center"><Save size={18} /> {loading ? "Menyimpan..." : "Simpan KK"}</button>
        </form>
      </div>
    </MainLayout>
  );
}
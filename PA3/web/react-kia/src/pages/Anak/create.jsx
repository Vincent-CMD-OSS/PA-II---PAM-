import React, { useEffect, useState } from "react";
import MainLayout from "../../components/Layout/MainLayout";
import { createAnak } from "../../services/Anak";
import { getKehamilanList } from "../../services/kehamilan";
import { useNavigate } from "react-router-dom";
import { UserPlus, CheckCircle2, AlertCircle } from "lucide-react";

export default function CreateAnak() {
  const navigate = useNavigate();
  const [kehamilanList, setKehamilanList] = useState([]);
  const [loading, setLoading] = useState(false);
  const [errors, setErrors] = useState({});
  const [generalError, setGeneralError] = useState("");

  const [form, setForm] = useState({
    nama: "",
    jenis_kelamin: "",
    tanggal_lahir: "",
    berat_lahir_kg: "",
    kehamilan_id: "",
    tempat_lahir: "",
    anak_ke: "",
  });

  useEffect(() => {
    const fetchKehamilan = async () => {
      try {
        const data = await getKehamilanList();
        setKehamilanList(data);
      } catch (err) {
        console.error("Detail Error:", err); 
      setGeneralError("Gagal mengambil data ibu hamil.");
      }
    };
    fetchKehamilan();
  }, []);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm({ ...form, [name]: value });
    // Menghapus error saat user mulai mengetik
    if (errors[name]) {
      setErrors((prev) => {
        const newErrors = { ...prev };
        delete newErrors[name];
        return newErrors;
      });
    }
  };

  const validateForm = () => {
    let tempErrors = {};
    if (!form.nama.trim()) tempErrors.nama = "Nama anak wajib diisi.";
    if (!form.tanggal_lahir) tempErrors.tanggal_lahir = "Tanggal lahir wajib diisi.";
    if (!form.jenis_kelamin) tempErrors.jenis_kelamin = "Pilih jenis kelamin anak.";
    if (!form.kehamilan_id) tempErrors.kehamilan_id = "Pilih data ibu hamil.";
    
    setErrors(tempErrors);
    return Object.keys(tempErrors).length === 0;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setGeneralError("");
    if (!validateForm()) return;

    setLoading(true);
    try {
      const payload = {
        ...form,
        kehamilan_id: Number(form.kehamilan_id),
        berat_lahir_kg: parseFloat(form.berat_lahir_kg) || 0
      };
      await createAnak(payload);
      alert("Data anak berhasil disimpan.");
      navigate("/Daftar-Anak");
    } catch (err) {
      setGeneralError("Terjadi kesalahan sistem. Silakan coba lagi.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <MainLayout>
      <div className="min-h-screen bg-gray-50 flex flex-col items-center py-10 px-4">
        <div className="max-w-5xl w-full grid grid-cols-1 lg:grid-cols-3 gap-8">
          
          <div className="lg:col-span-2 bg-white rounded-3xl p-8 shadow-sm border border-gray-100">
            {/* Pesan Error Umum */}
            {generalError && (
              <div className="mb-6 p-4 bg-red-50 border border-red-200 text-red-600 rounded-xl flex items-center gap-2">
                <AlertCircle size={20} />
                <span className="text-sm font-medium">{generalError}</span>
              </div>
            )}

            <form onSubmit={handleSubmit} className="space-y-6">
              
              {/* Nama Anak */}
              <div>
                <label className="block text-[12px] font-bold text-gray-500 tracking-wider uppercase mb-2">Nama Anak</label>
                <input
                  name="nama"
                  type="text"
                  placeholder="Masukkan nama"
                  value={form.nama}
                  onChange={handleChange}
                  className={`w-full p-4 bg-gray-50 border rounded-xl outline-none transition-all ${
                    errors.nama ? "border-red-500 focus:ring-red-200" : "border-gray-200 focus:ring-blue-500 focus:ring-2"
                  }`}
                />
                {errors.nama && <p className="mt-1 text-xs text-red-500 font-medium flex items-center gap-1"><AlertCircle size={12}/> {errors.nama}</p>}
              </div>

              {/* Tempat & Tanggal Lahir */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-[12px] font-bold text-gray-500 tracking-wider uppercase mb-2">Tempat Lahir</label>
                  <input
                    name="tempat_lahir"
                    type="text"
                    placeholder="Masukkan kota atau desa"
                    value={form.tempat_lahir}
                    onChange={handleChange}
                    className="w-full p-4 bg-gray-50 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none transition-all"
                  />
                </div>
                <div>
                  <label className="block text-[12px] font-bold text-gray-500 tracking-wider uppercase mb-2">Tanggal Lahir</label>
                  <input
                    name="tanggal_lahir"
                    type="date"
                    value={form.tanggal_lahir}
                    onChange={handleChange}
                    className={`w-full p-4 bg-gray-50 border rounded-xl outline-none transition-all ${
                        errors.tanggal_lahir ? "border-red-500 focus:ring-red-200" : "border-gray-200 focus:ring-blue-500 focus:ring-2"
                    }`}
                  />
                  {errors.tanggal_lahir && <p className="mt-1 text-xs text-red-500 font-medium flex items-center gap-1"><AlertCircle size={12}/> {errors.tanggal_lahir}</p>}
                </div>
              </div>

              {/* Jenis Kelamin & Anak Ke */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-[12px] font-bold text-gray-500 tracking-wider uppercase mb-2">Jenis Kelamin</label>
                  <div className="flex gap-2">
                    {["Laki-laki", "Perempuan"].map((jk) => (
                      <button
                        key={jk}
                        type="button"
                        onClick={() => {
                            setForm({ ...form, jenis_kelamin: jk.toLowerCase() });
                            if(errors.jenis_kelamin) setErrors(prev => ({...prev, jenis_kelamin: ""}));
                        }}
                        className={`flex-1 py-4 rounded-xl border font-semibold transition-all ${
                          form.jenis_kelamin === jk.toLowerCase()
                            ? "bg-white border-blue-500 text-blue-600 shadow-sm"
                            : errors.jenis_kelamin ? "border-red-300 text-gray-400" : "bg-white border-gray-200 text-gray-700 hover:bg-gray-50"
                        }`}
                      >
                        {jk}
                      </button>
                    ))}
                  </div>
                  {errors.jenis_kelamin && <p className="mt-1 text-xs text-red-500 font-medium flex items-center gap-1"><AlertCircle size={12}/> {errors.jenis_kelamin}</p>}
                </div>
                <div>
                  <label className="block text-[12px] font-bold text-gray-500 tracking-wider uppercase mb-2">Anak Ke -</label>
                  <input
                    name="anak_ke"
                    type="number"
                    placeholder="e.g. 1"
                    value={form.anak_ke}
                    onChange={handleChange}
                    className="w-full p-4 bg-gray-50 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none transition-all"
                  />
                </div>
              </div>

              <hr className="my-8 border-gray-100" />

              {/* Data Orangtua */}
              <div className="space-y-4">
                <div className="flex items-center gap-2 text-gray-800 font-bold">
                   <UserPlus size={20} className="text-blue-600" />
                   <span>Data Orangtua</span>
                </div>
                <div>
                  <label className="block text-[12px] font-bold text-gray-500 tracking-wider uppercase mb-2">Nama Ibu</label>
                  <select
                      name="kehamilan_id"
                      value={form.kehamilan_id}
                      onChange={handleChange}
                      className={`w-full p-4 bg-gray-50 border rounded-xl outline-none transition-all ${
                        errors.kehamilan_id ? "border-red-500 focus:ring-red-200" : "border-gray-200 focus:ring-blue-500 focus:ring-2"
                      }`}
                    >
                      <option value="">Masukkan nama ibu</option>
                      {/* Pastikan kehamilanList adalah array sebelum di-map */}
                      {Array.isArray(kehamilanList) && kehamilanList.map((item) => (
                        <option key={item.id} value={item.id}>
                          {/* SESUAIKAN DI SINI: mengikuti struktur JSON baru */}
                          {item.ibu?.kependudukan?.nama_lengkap || "Nama tidak ditemukan"}
                        </option>
                      ))}
                    </select>
                  {errors.kehamilan_id && <p className="mt-1 text-xs text-red-500 font-medium flex items-center gap-1"><AlertCircle size={12}/> {errors.kehamilan_id}</p>}
                </div>
              </div>

              {/* Buttons */}
              <div className="flex flex-col md:flex-row gap-4 pt-4">
                <button
                  type="button"
                  onClick={() => navigate(-1)}
                  className="flex-1 py-4 px-6 rounded-xl bg-indigo-50 text-indigo-700 font-bold hover:bg-indigo-100 transition-all"
                >
                  Kembali
                </button>
                <button
                  type="submit"
                  disabled={loading}
                  className="flex-[2] py-4 px-6 rounded-xl bg-[#3B71FE] text-white font-bold hover:bg-blue-700 shadow-lg shadow-blue-200 transition-all flex items-center justify-center gap-2"
                >
                  <UserPlus size={20} />
                  {loading ? "Menyimpan..." : "Daftar anak"}
                </button>
              </div>
            </form>
          </div>

          {/* Kolom Kanan */}
          <div className="space-y-6">
            <div className="bg-blue-50 rounded-3xl p-6 border border-blue-100">
              <p className="text-blue-800 text-sm leading-relaxed">
                Pendaftaran dini memastikan anak menerima jadwal imunisasi lengkap dan pemantauan nutrisi sejak hari pertama.
              </p>
            </div>
            <div className="bg-white rounded-3xl p-8 shadow-sm border border-gray-100">
              <h3 className="text-gray-800 font-bold mb-6">Dokumen Pendukung</h3>
              <ul className="space-y-4">
                {["Buku KIA", "Data Identitas Anak", "Data Identitas Ibu"].map((doc) => (
                  <li key={doc} className="flex items-center gap-3 text-gray-600 text-sm font-medium">
                    <CheckCircle2 size={18} className="text-teal-500" />
                    {doc}
                  </li>
                ))}
              </ul>
            </div>
          </div>
        </div>
      </div>
    </MainLayout>
  );
}
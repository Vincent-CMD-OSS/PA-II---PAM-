// src/pages/Ibu/IbuCreate.jsx
import React, { useState, useEffect } from "react";
import { useNavigate, Link } from "react-router-dom";
import MainLayout from "../../components/Layout/MainLayout";
import { createIbu } from "../../services/ibu";
import { createKehamilan } from "../../services/kehamilan";
import { getKependudukanList } from "../../services/kependudukan";
import { Save, ArrowLeft, ArrowRight, Loader2, CheckCircle2, Baby, Users, ClipboardList } from "lucide-react";

export default function IbuCreate() {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const [kkList, setKkList] = useState([]);
  const [step, setStep] = useState(1);
  const [createdIbu, setCreatedIbu] = useState(null);

  // Step 1: Data Ibu
  const [formIbu, setFormIbu] = useState({
    id_kependudukan: "",
    status_kehamilan: "TRIMESTER 1",
  });

  // Step 2: Data Kehamilan
  const [formKehamilan, setFormKehamilan] = useState({
    gravida: "",
    paritas: "",
    abortus: "",
    hpht: "",
    taksiran_persalinan: "",
    uk_kehamilan_saat_ini: "",
    jarak_kehamilan_sebelumnya: "",
    status_kehamilan: "TRIMESTER 1",
  });

  useEffect(() => {
    const fetchKK = async () => {
      try {
        const data = await getKependudukanList();
        setKkList(data);
      } catch (err) {
        console.error(err);
      }
    };
    fetchKK();
  }, []);

  // Auto-calculate HPL from HPHT (Naegele's rule: +7 days, -3 months, +1 year)
  useEffect(() => {
    if (formKehamilan.hpht) {
      const hpht = new Date(formKehamilan.hpht);
      const hpl = new Date(hpht);
      hpl.setDate(hpl.getDate() + 7);
      hpl.setMonth(hpl.getMonth() + 9);
      setFormKehamilan((prev) => ({
        ...prev,
        taksiran_persalinan: hpl.toISOString().split("T")[0],
      }));
    }
  }, [formKehamilan.hpht]);

  const handleChangeIbu = (e) => {
    setFormIbu({ ...formIbu, [e.target.name]: e.target.value });
  };

  const handleChangeKehamilan = (e) => {
    setFormKehamilan({ ...formKehamilan, [e.target.name]: e.target.value });
  };

  // Step 1: Submit data ibu
  const handleSubmitStep1 = async (e) => {
    e.preventDefault();
    if (!formIbu.id_kependudukan) {
      alert("Pilih data penduduk terlebih dahulu");
      return;
    }
    setLoading(true);
    try {
      const payload = {
        id_kependudukan: Number(formIbu.id_kependudukan),
        status_kehamilan: formIbu.status_kehamilan,
      };
      const ibu = await createIbu(payload);
      setCreatedIbu(ibu);
      setFormKehamilan((prev) => ({
        ...prev,
        status_kehamilan: formIbu.status_kehamilan,
      }));
      setStep(2);
    } catch (err) {
      console.error(err);
      alert(err.response?.data?.message || "Gagal menambahkan data ibu");
    } finally {
      setLoading(false);
    }
  };

  // Step 2: Submit data kehamilan
  const handleSubmitStep2 = async (e) => {
    e.preventDefault();
    if (!createdIbu) {
      alert("Data ibu belum dibuat");
      return;
    }
    setLoading(true);
    try {
      const ibuId = createdIbu.id_ibu || createdIbu.id;
      const payload = {
        ibu_id: Number(ibuId),
        gravida: parseInt(formKehamilan.gravida) || 0,
        paritas: parseInt(formKehamilan.paritas) || 0,
        abortus: parseInt(formKehamilan.abortus) || 0,
        hpht: formKehamilan.hpht || "",
        taksiran_persalinan: formKehamilan.taksiran_persalinan || "",
        uk_kehamilan_saat_ini: parseInt(formKehamilan.uk_kehamilan_saat_ini) || 0,
        jarak_kehamilan_sebelumnya: parseInt(formKehamilan.jarak_kehamilan_sebelumnya) || 0,
        status_kehamilan: formKehamilan.status_kehamilan,
      };
      await createKehamilan(payload);
      setStep(3);
      setTimeout(() => navigate(`/data-ibu/${ibuId}`), 2000);
    } catch (err) {
      console.error(err);
      alert(err.response?.data?.message || "Gagal menyimpan data kehamilan");
    } finally {
      setLoading(false);
    }
  };

  // Skip step 2
  const handleSkipKehamilan = () => {
    const ibuId = createdIbu?.id_ibu || createdIbu?.id;
    navigate(`/data-ibu/${ibuId}`);
  };

  // Stepper UI
  const steps = [
    { num: 1, label: "Data Ibu", icon: Users },
    { num: 2, label: "Data Kehamilan", icon: Baby },
    { num: 3, label: "Selesai", icon: CheckCircle2 },
  ];

  // Get selected penduduk info
  const selectedPenduduk = kkList.find((kk) => String(kk.id_kependudukan) === String(formIbu.id_kependudukan));

  return (
    <MainLayout>
      <div className="p-6 max-w-3xl mx-auto">
        {/* Header */}
        <div className="flex items-center gap-4 mb-8">
          <button onClick={() => navigate(-1)} className="p-2 rounded-full hover:bg-gray-100 transition-colors">
            <ArrowLeft size={20} />
          </button>
          <div>
            <h1 className="text-2xl font-bold text-gray-900">Tambah Data Ibu Baru</h1>
            <p className="text-gray-500 text-sm">Isi data identitas ibu dan informasi kehamilan</p>
          </div>
        </div>

        {/* Stepper */}
        <div className="flex items-center justify-center mb-10 px-4">
          {steps.map((s, idx) => {
            const Icon = s.icon;
            const isActive = step === s.num;
            const isDone = step > s.num;
            return (
              <React.Fragment key={s.num}>
                <div className="flex flex-col items-center">
                  <div
                    className={`w-12 h-12 rounded-full flex items-center justify-center transition-all duration-300 ${
                      isDone ? "bg-green-500 text-white shadow-lg shadow-green-200" : isActive ? "bg-indigo-600 text-white shadow-lg shadow-indigo-200 scale-110" : "bg-gray-100 text-gray-400"
                    }`}
                  >
                    {isDone ? <CheckCircle2 size={22} /> : <Icon size={20} />}
                  </div>
                  <span className={`text-xs mt-2 font-medium ${isActive ? "text-indigo-600" : isDone ? "text-green-600" : "text-gray-400"}`}>{s.label}</span>
                </div>
                {idx < steps.length - 1 && <div className={`flex-1 h-1 mx-3 rounded-full transition-all duration-500 ${step > s.num ? "bg-green-400" : "bg-gray-200"}`} />}
              </React.Fragment>
            );
          })}
        </div>

        {/* Step 1: Data Ibu */}
        {step === 1 && (
          <form onSubmit={handleSubmitStep1} className="space-y-6">
            <div className="bg-white/80 backdrop-blur-xl rounded-2xl shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-white/50 p-8">
              <h3 className="font-semibold text-lg text-indigo-700 mb-6 flex items-center gap-2">
                <Users size={20} /> Pilih Data Penduduk
              </h3>

              <div className="space-y-4">
                <div>
                  <label className="block text-sm font-medium mb-2 text-gray-700">
                    Penduduk (KK / NIK) <span className="text-red-500">*</span>
                  </label>
                  <select
                    name="id_kependudukan"
                    value={formIbu.id_kependudukan}
                    onChange={handleChangeIbu}
                    className="w-full border border-gray-200 rounded-xl px-4 py-3 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition-all"
                    required
                  >
                    <option value="">-- Pilih Data Penduduk --</option>
                    {kkList.map((kk) => (
                      <option key={kk.id_kependudukan} value={kk.id_kependudukan}>
                        {kk.nama_lengkap} — NIK: {kk.nik} — KK: {kk.no_kk}
                      </option>
                    ))}
                  </select>
                  <p className="text-xs text-gray-500 mt-2">
                    Belum ada data penduduk?{" "}
                    <Link to="/kependudukan/create" className="text-indigo-600 hover:underline font-medium">
                      + Tambah Data Penduduk
                    </Link>
                  </p>
                </div>

                {/* Preview selected penduduk */}
                {selectedPenduduk && (
                  <div className="bg-indigo-50/50 rounded-xl p-5 border border-indigo-100 mt-4">
                    <h4 className="text-sm font-semibold text-indigo-800 mb-3">Data Penduduk Terpilih</h4>
                    <div className="grid grid-cols-2 gap-3 text-sm">
                      <div>
                        <span className="text-gray-500">Nama:</span> <span className="font-medium">{selectedPenduduk.nama_lengkap}</span>
                      </div>
                      <div>
                        <span className="text-gray-500">NIK:</span> <span className="font-medium">{selectedPenduduk.nik}</span>
                      </div>
                      <div>
                        <span className="text-gray-500">No KK:</span> <span className="font-medium">{selectedPenduduk.no_kk}</span>
                      </div>
                      <div>
                        <span className="text-gray-500">Dusun:</span> <span className="font-medium">{selectedPenduduk.dusun || "-"}</span>
                      </div>
                      <div>
                        <span className="text-gray-500">Gol. Darah:</span> <span className="font-medium">{selectedPenduduk.golongan_darah || "-"}</span>
                      </div>
                      <div>
                        <span className="text-gray-500">Telepon:</span> <span className="font-medium">{selectedPenduduk.telepon || "-"}</span>
                      </div>
                    </div>
                  </div>
                )}

                <div>
                  <label className="block text-sm font-medium mb-2 text-gray-700">Status Kehamilan</label>
                  <select
                    name="status_kehamilan"
                    value={formIbu.status_kehamilan}
                    onChange={handleChangeIbu}
                    className="w-full border border-gray-200 rounded-xl px-4 py-3 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition-all"
                  >
                    <option>TRIMESTER 1</option>
                    <option>TRIMESTER 2</option>
                    <option>TRIMESTER 3</option>
                    <option>NIFAS</option>
                  </select>
                </div>
              </div>
            </div>

            <div className="flex justify-end">
              <button
                type="submit"
                disabled={loading}
                className="bg-gradient-to-r from-indigo-600 to-indigo-700 text-white px-8 py-3 rounded-xl font-semibold shadow-lg hover:shadow-indigo-300/40 transform transition-all hover:-translate-y-0.5 flex items-center gap-2 disabled:opacity-50"
              >
                {loading ? <Loader2 className="animate-spin" size={18} /> : <ArrowRight size={18} />}
                {loading ? "Menyimpan..." : "Simpan & Lanjut"}
              </button>
            </div>
          </form>
        )}

        {/* Step 2: Data Kehamilan */}
        {step === 2 && (
          <form onSubmit={handleSubmitStep2} className="space-y-6">
            <div className="bg-white/80 backdrop-blur-xl rounded-2xl shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-white/50 p-8">
              <h3 className="font-semibold text-lg text-indigo-700 mb-2 flex items-center gap-2">
                <ClipboardList size={20} /> Riwayat Obstetri
              </h3>
              <p className="text-gray-500 text-sm mb-6">Data riwayat kehamilan ibu (Gravida, Paritas, Abortus)</p>

              <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
                <div>
                  <label className="block text-sm font-medium mb-2 text-gray-700">Gravida (G)</label>
                  <input
                    type="number"
                    name="gravida"
                    value={formKehamilan.gravida}
                    onChange={handleChangeKehamilan}
                    placeholder="Jumlah kehamilan"
                    min="0"
                    className="w-full border border-gray-200 rounded-xl px-4 py-3 focus:ring-2 focus:ring-indigo-500 outline-none"
                  />
                  <p className="text-xs text-gray-400 mt-1">Total kehamilan termasuk saat ini</p>
                </div>
                <div>
                  <label className="block text-sm font-medium mb-2 text-gray-700">Paritas (P)</label>
                  <input
                    type="number"
                    name="paritas"
                    value={formKehamilan.paritas}
                    onChange={handleChangeKehamilan}
                    placeholder="Jumlah persalinan"
                    min="0"
                    className="w-full border border-gray-200 rounded-xl px-4 py-3 focus:ring-2 focus:ring-indigo-500 outline-none"
                  />
                  <p className="text-xs text-gray-400 mt-1">Jumlah persalinan viable</p>
                </div>
                <div>
                  <label className="block text-sm font-medium mb-2 text-gray-700">Abortus (A)</label>
                  <input
                    type="number"
                    name="abortus"
                    value={formKehamilan.abortus}
                    onChange={handleChangeKehamilan}
                    placeholder="Jumlah keguguran"
                    min="0"
                    className="w-full border border-gray-200 rounded-xl px-4 py-3 focus:ring-2 focus:ring-indigo-500 outline-none"
                  />
                  <p className="text-xs text-gray-400 mt-1">Jumlah keguguran/abortus</p>
                </div>
              </div>
            </div>

            <div className="bg-white/80 backdrop-blur-xl rounded-2xl shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-white/50 p-8">
              <h3 className="font-semibold text-lg text-indigo-700 mb-2 flex items-center gap-2">
                <Baby size={20} /> Data Kehamilan Saat Ini
              </h3>
              <p className="text-gray-500 text-sm mb-6">Informasi kehamilan yang sedang berjalan</p>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
                <div>
                  <label className="block text-sm font-medium mb-2 text-gray-700">HPHT (Hari Pertama Haid Terakhir)</label>
                  <input type="date" name="hpht" value={formKehamilan.hpht} onChange={handleChangeKehamilan} className="w-full border border-gray-200 rounded-xl px-4 py-3 focus:ring-2 focus:ring-indigo-500 outline-none" />
                </div>
                <div>
                  <label className="block text-sm font-medium mb-2 text-gray-700">Taksiran Persalinan (HPL)</label>
                  <input
                    type="date"
                    name="taksiran_persalinan"
                    value={formKehamilan.taksiran_persalinan}
                    onChange={handleChangeKehamilan}
                    className="w-full border border-gray-200 rounded-xl px-4 py-3 focus:ring-2 focus:ring-indigo-500 outline-none bg-gray-50"
                  />
                  <p className="text-xs text-gray-400 mt-1">Otomatis dihitung dari HPHT (Rumus Naegele)</p>
                </div>
                <div>
                  <label className="block text-sm font-medium mb-2 text-gray-700">Usia Kehamilan Saat Ini (minggu)</label>
                  <input
                    type="number"
                    name="uk_kehamilan_saat_ini"
                    value={formKehamilan.uk_kehamilan_saat_ini}
                    onChange={handleChangeKehamilan}
                    placeholder="Contoh: 12"
                    min="0"
                    max="45"
                    className="w-full border border-gray-200 rounded-xl px-4 py-3 focus:ring-2 focus:ring-indigo-500 outline-none"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium mb-2 text-gray-700">Jarak Kehamilan Sebelumnya (bulan)</label>
                  <input
                    type="number"
                    name="jarak_kehamilan_sebelumnya"
                    value={formKehamilan.jarak_kehamilan_sebelumnya}
                    onChange={handleChangeKehamilan}
                    placeholder="Contoh: 24"
                    min="0"
                    className="w-full border border-gray-200 rounded-xl px-4 py-3 focus:ring-2 focus:ring-indigo-500 outline-none"
                  />
                </div>
              </div>
            </div>

            <div className="flex justify-between">
              <button type="button" onClick={handleSkipKehamilan} className="text-gray-500 hover:text-gray-700 px-6 py-3 rounded-xl font-medium transition-colors">
                Lewati, isi nanti →
              </button>
              <button
                type="submit"
                disabled={loading}
                className="bg-gradient-to-r from-indigo-600 to-indigo-700 text-white px-8 py-3 rounded-xl font-semibold shadow-lg hover:shadow-indigo-300/40 transform transition-all hover:-translate-y-0.5 flex items-center gap-2 disabled:opacity-50"
              >
                {loading ? <Loader2 className="animate-spin" size={18} /> : <Save size={18} />}
                {loading ? "Menyimpan..." : "Simpan Data Kehamilan"}
              </button>
            </div>
          </form>
        )}

        {/* Step 3: Success */}
        {step === 3 && (
          <div className="bg-white/80 backdrop-blur-xl rounded-2xl shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-white/50 p-12 text-center">
            <div className="w-20 h-20 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-6">
              <CheckCircle2 size={40} className="text-green-500" />
            </div>
            <h2 className="text-2xl font-bold text-gray-900 mb-2">Data Berhasil Disimpan!</h2>
            <p className="text-gray-500 mb-8">Data ibu dan kehamilan telah berhasil ditambahkan ke sistem.</p>
            <p className="text-sm text-gray-400">Mengalihkan ke halaman detail...</p>
          </div>
        )}
      </div>
    </MainLayout>
  );
}

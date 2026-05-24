import React, { useEffect, useState, useMemo } from "react";
import { useParams } from "react-router-dom";
import MainLayout from "../../components/Layout/MainLayout";
import { PelayananGiziService } from "../../services/Pelayanan-gizi-anak";
import { 
  Plus, Baby, Loader2, Check, X, Save, 
  Utensils, Droplets, Info, ChevronRight, Calendar
} from 'lucide-react';

const PelayananGiziIndex = () => {
  const { id: anakId } = useParams();
  
  // --- STATE MANAGEMENT ---
  const [riwayat, setRiwayat] = useState([]);
  const [loading, setLoading] = useState(true);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [submitting, setSubmitting] = useState(false);

  const authUser = useMemo(() => {
    try {
      const storedUser = localStorage.getItem('user');
      return storedUser ? JSON.parse(storedUser) : { id: 0, nama: 'Petugas' };
    } catch {
      return { id: 0, nama: 'Petugas' };
    }
  }, []);

  const initialForm = {
    bulan_ke: 1,
    asi: {
      frekuensi_menyusui: "",
      posisi_menyusui: "baik",
      asiperah: "tidak" 
    },
    mpasi: {
      sudah_mpasi: false,
      varian_mpasi: [],
      jumlah_makan: "",
      frekuensi_makan: {
        makanan_utama: "",
        makanan_selingan: ""
      }
    }
  };

  const [formData, setFormData] = useState(initialForm);

  // --- LOGIC FETCH & TABEL ---
  const kolomBulan = ["0", "1", "2", "3", "4", "5", "6 - 8", "9 - 11", "12 - 23", "23 - 59"];

  const fetchRiwayat = async () => {
    setLoading(true);
    try {
      const data = await PelayananGiziService.getByAnakId(anakId);
      setRiwayat(Array.isArray(data) ? data : []);
    } catch (err) {
      console.error("Error fetching data:", err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { if (anakId) fetchRiwayat(); }, [anakId]);

  const isMatchBulan = (bulanData, labelKolom) => {
    if (labelKolom.includes("-")) {
      const [min, max] = labelKolom.split("-").map(s => parseInt(s.trim()));
      return bulanData >= min && bulanData <= max;
    }
    return bulanData === parseInt(labelKolom);
  };

  const getCellContent = (labelKolom, fn, type = "check") => {
    const match = riwayat.find(item => isMatchBulan(item.bulan, labelKolom));
    if (!match) return null;
    const val = fn(match);
    if (val === undefined || val === null || val === false) return null;
    if (type === "text") return val;
    return "checkmark";
  };

  // --- FORM HANDLERS ---
// --- FORM HANDLERS ---
const requestPayload = useMemo(() => {
  // Format string frekuensi makan agar sesuai: "3x utama, 2x selingan"
  const formatFrekuensi = () => {
    const utama = formData.mpasi.frekuensi_makan.makanan_utama || "0";
    const selingan = formData.mpasi.frekuensi_makan.makanan_selingan || "0";
    // Menghapus kata "/hari" jika ada, agar hasilnya bersih seperti "3x"
    const cleanUtama = utama.replace('/hari', '').toLowerCase();
    const cleanSelingan = selingan.replace('/hari', '').toLowerCase();
    return `${cleanUtama} utama, ${cleanSelingan} selingan`;
  };

  return {
    anak_id: parseInt(anakId),
    tanggal: new Date().toISOString().split('T')[0], // Menghasilkan "2026-04-22"
    tenaga_kesehatan_id: parseInt(authUser.id || authUser.user_id || 0),
    bulan_ke: parseInt(formData.bulan_ke),
    lokasi: authUser.lokasi || "Puskesmas Medan", // Sesuaikan dengan data user atau hardcode

    asi: {
      frekuensi_menyusui: parseInt(formData.asi.frekuensi_menyusui) || 0,
      posisi_menyusui: formData.asi.posisi_menyusui,
      asiperah: formData.asi.asiperah // Sesuai key "asiperah" di JSON kamu
    },

    mpasi: {
      diberikan_mp_asi: formData.mpasi.sudah_mpasi,
      variasi_mpasi: formData.mpasi.varian_mpasi.map(v => v.toLowerCase()), // Lowercase agar konsisten
      jumlah_makan_perporsi: formData.mpasi.jumlah_makan || "-",
      frekuensi_makan_perhari: formData.mpasi.sudah_mpasi ? formatFrekuensi() : "-"
    }
  };
}, [formData, anakId, authUser]);

  const handleSave = async () => {
  // Validasi sederhana sebelum kirim
  if (formData.asi.frekuensi_menyusui === "") {
    alert("Mohon isi frekuensi menyusui.");
    return;
  }

  setSubmitting(true);
  try {
    // Mengirim payload yang sudah sesuai format JSON target
    await PelayananGiziService.create(requestPayload);
    
    // Feedback sukses
    alert("Data Pelayanan Gizi Berhasil Disimpan.");
    
    // Reset dan tutup modal
    setIsModalOpen(false);
    setFormData(initialForm);
    fetchRiwayat();
  } catch (err) {
    const errorMsg = err.response?.data?.message || err.message;
    alert("Gagal menyimpan data: " + errorMsg);
  } finally {
    setSubmitting(false);
  }
};
  return (
    <MainLayout>
      <div className="max-w-7xl mx-auto p-4 md:p-8 bg-slate-50 min-h-screen font-sans">
        
        {/* HEADER SECTION */}
        <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-6 mb-8">
          <div>
            <nav className="flex items-center gap-2 text-xs font-semibold text-slate-400 uppercase tracking-wider mb-2">
              <span>Rekam Medis</span>
              <ChevronRight size={12} />
              <span className="text-blue-600">Monitoring Gizi</span>
            </nav>
            <h1 className="text-3xl font-bold text-slate-800 tracking-tight flex items-center gap-3">
              <Baby className="text-blue-600" size={32} />
              Monitoring Gizi & Nutrisi
            </h1>
            <p className="text-slate-500 text-sm mt-1">Pantau perkembangan asupan nutrisi anak secara berkala.</p>
          </div>
          <button 
            onClick={() => setIsModalOpen(true)}
            className="flex items-center gap-2 bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-xl font-bold text-sm shadow-md transition-all active:scale-95"
          >
            <Plus size={18} /> Tambah Data Pelayanan
          </button>
        </div>

        {/* TABLE VIEW */}
        {loading ? (
          <div className="flex flex-col items-center justify-center py-32 bg-white rounded-3xl border border-slate-200">
            <Loader2 className="animate-spin text-blue-600 mb-4" size={40} />
            <p className="text-slate-400 text-sm font-medium">Memproses data riwayat...</p>
          </div>
        ) : (
          <div className="bg-white rounded-2xl shadow-sm border border-slate-200 overflow-hidden">
            <div className="overflow-x-auto">
              <table className="w-full text-left border-collapse">
                <thead>
                  <tr className="bg-slate-50 text-slate-600 text-[11px] uppercase tracking-wider border-b border-slate-200">
                    <th colSpan="2" className="p-5 font-bold border-r border-slate-100">Indikator Pemantauan</th>
                    {kolomBulan.map(b => (
                      <th key={b} className="p-3 text-center border-r border-slate-100 w-24">Bulan {b}</th>
                    ))}
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-100">
                  <SectionHeader label="Pola Pemberian ASI" />
                  <DataRow label="Frekuensi Menyusui (Kali/Hari)" type="text" kolom={kolomBulan} getContent={getCellContent} fn={(d) => d.ASI?.frekuensi_menyusui} />
                  <DataRow label="Posisi Menyusui Sudah Baik" type="check" kolom={kolomBulan} getContent={getCellContent} fn={(d) => d.ASI?.posisi_menyusui === "baik"} />
                  <DataRow label="Diberikan ASI Perah (ASIP)" type="check" kolom={kolomBulan} getContent={getCellContent} fn={(d) => d.ASI?.asi_perah === "ya"} />

                  <SectionHeader label="Status & Variasi MPASI" />
                  <DataRow label="Sudah Mendapat MPASI" type="check" kolom={kolomBulan} getContent={getCellContent} fn={(d) => d.MPASI?.diberikan_mp_asi === true} />
                  <DataRow label="Variasi: Karbohidrat" type="check" kolom={kolomBulan} getContent={getCellContent} fn={(d) => d.MPASI?.variasi_mpasi?.some(v => ["nasi", "beras", "bubur", "makanan pokok"].includes(v.toLowerCase()))} />
                  <DataRow label="Variasi: Protein Hewani/Nabati" type="check" kolom={kolomBulan} getContent={getCellContent} fn={(d) => d.MPASI?.variasi_mpasi?.some(v => ["lauk", "protein", "ayam", "ikan", "telur"].includes(v.toLowerCase()))} />
                  <DataRow label="Variasi: Sayur & Buah" type="check" kolom={kolomBulan} getContent={getCellContent} fn={(d) => d.MPASI?.variasi_mpasi?.some(v => ["sayur", "buah"].includes(v.toLowerCase()))} />
                  
                  <SectionHeader label="Porsi & Jadwal Makan" />
                  <DataRow label="Jumlah Porsi per Makan" type="text" kolom={kolomBulan} getContent={getCellContent} fn={(d) => d.MPASI?.jumlah_makan_perporsi} />
                  <DataRow label="Frekuensi Makan per Hari" type="text" kolom={kolomBulan} getContent={getCellContent} fn={(d) => d.MPASI?.frekuensi_makan_perhari} />
                </tbody>
              </table>
            </div>
          </div>
        )}

        {/* FORM MODAL */}
        {isModalOpen && (
          <div className="fixed inset-0 z-[100] flex items-center justify-center p-4 bg-slate-900/40 backdrop-blur-sm overflow-y-auto">
            <div className="bg-white w-full max-w-4xl rounded-3xl shadow-2xl overflow-hidden flex flex-col max-h-[90vh] animate-in fade-in zoom-in duration-200">
              
              {/* MODAL HEADER */}
              <div className="px-8 py-6 border-b border-slate-100 flex justify-between items-center bg-white sticky top-0 z-10">
                <div>
                  <h2 className="text-xl font-bold text-slate-800">Form Input Pelayanan Gizi</h2>
                  <p className="text-xs text-slate-400 mt-1 uppercase font-bold tracking-widest">ID Anak: {anakId} • Petugas: {authUser.nama}</p>
                </div>
                <button onClick={() => setIsModalOpen(false)} className="p-2 hover:bg-slate-100 rounded-full transition-colors text-slate-400">
                  <X size={20} />
                </button>
              </div>

              {/* MODAL BODY */}
              <div className="p-8 overflow-y-auto custom-scrollbar bg-slate-50/30">
                
                {/* INFO BANNER */}
                <div className="flex items-start gap-4 bg-blue-50 p-4 rounded-2xl border border-blue-100 mb-8">
                  <Info size={20} className="text-blue-600 shrink-0 mt-0.5" />
                  <div className="text-sm text-blue-800 leading-relaxed">
                    <strong>Informasi:</strong> Data yang Anda masukkan akan digunakan oleh sistem AI untuk menghasilkan saran medis dan jadwal kunjungan berikutnya secara otomatis.
                  </div>
                </div>

                <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
                  
                  {/* LEFT COLUMN: BASIC & ASI */}
                  <div className="space-y-6">
                    <section className="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm">
                      <h4 className="text-sm font-bold text-slate-800 mb-4 flex items-center gap-2">
                        <Calendar size={18} className="text-blue-500" /> Waktu Kunjungan
                      </h4>
                      <div className="space-y-1">
                        <label className="text-[11px] font-bold text-slate-400 uppercase tracking-wider">Bulan Ke-</label>
                        <select 
                          className="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-2.5 text-sm font-semibold outline-none focus:ring-2 ring-blue-100 transition-all"
                          value={formData.bulan_ke}
                          onChange={(e) => setFormData({...formData, bulan_ke: e.target.value})}
                        >
                          {[...Array(60)].map((_, m) => <option key={m} value={m}>Bulan {m}</option>)}
                        </select>
                      </div>
                    </section>

                    <section className="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm space-y-5">
                      <h4 className="text-sm font-bold text-slate-800 mb-2 flex items-center gap-2">
                        <Droplets size={18} className="text-blue-500" /> Pola Pemberian ASI
                      </h4>
                      
                      <div className="space-y-1">
                        <label className="text-[11px] font-bold text-slate-400 uppercase tracking-wider">Frekuensi (Kali/Hari)</label>
                        <input 
                          type="number" placeholder="Contoh: 8" 
                          className="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-2.5 text-sm focus:bg-white focus:ring-2 ring-blue-100 outline-none transition-all" 
                          value={formData.asi.frekuensi_menyusui} 
                          onChange={(e) => setFormData({...formData, asi: {...formData.asi, frekuensi_menyusui: e.target.value}})} 
                        />
                      </div>

                      <div className="grid grid-cols-2 gap-4">
                        <div className="space-y-1">
                          <label className="text-[11px] font-bold text-slate-400 uppercase tracking-wider">Posisi Menyusu</label>
                          <select 
                            className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2.5 text-sm outline-none"
                            value={formData.asi.posisi_menyusui}
                            onChange={(e) => setFormData({...formData, asi: {...formData.asi, posisi_menyusui: e.target.value}})}
                          >
                            <option value="baik">Sudah Baik</option>
                            <option value="tidak">Perlu Perbaikan</option>
                          </select>
                        </div>
                        <div className="space-y-1">
                          <label className="text-[11px] font-bold text-slate-400 uppercase tracking-wider">Gunakan ASIP?</label>
                          <select 
                            className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2.5 text-sm outline-none"
                            value={formData.asi.asiperah}
                            onChange={(e) => setFormData({...formData, asi: {...formData.asi, asiperah: e.target.value}})}
                          >
                            <option value="tidak">Tidak</option>
                            <option value="ya">Ya</option>
                          </select>
                        </div>
                      </div>
                    </section>
                  </div>

                  {/* RIGHT COLUMN: MPASI */}
                  <div className="space-y-6">
                    <section className="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm">
                      <div className="flex items-center justify-between mb-6">
                        <h4 className="text-sm font-bold text-slate-800 flex items-center gap-2">
                          <Utensils size={18} className="text-orange-500" /> Status MPASI
                        </h4>
                        <div className="flex bg-slate-100 p-1 rounded-lg">
                          {[ { l: 'Sudah', v: true }, { l: 'Belum', v: false } ].map(item => (
                            <button 
                              key={item.l}
                              onClick={() => setFormData({...formData, mpasi: {...formData.mpasi, sudah_mpasi: item.v}})}
                              className={`px-4 py-1.5 text-[10px] font-bold rounded-md transition-all ${formData.mpasi.sudah_mpasi === item.v ? 'bg-white text-blue-600 shadow-sm' : 'text-slate-400'}`}
                            >
                              {item.l.toUpperCase()}
                            </button>
                          ))}
                        </div>
                      </div>

                      {formData.mpasi.sudah_mpasi ? (
                        <div className="space-y-6 animate-in fade-in slide-in-from-top-2 duration-300">
                          <div className="space-y-2">
                            <label className="text-[11px] font-bold text-slate-400 uppercase tracking-wider block">Variasi Makanan</label>
                            <div className="flex flex-wrap gap-2">
                              {['Nasi', 'Sayur', 'Buah', 'Lauk Pauk', 'Lemak'].map(item => {
                                const isSelected = formData.mpasi.varian_mpasi.includes(item);
                                return (
                                  <button 
                                    key={item} 
                                    onClick={() => {
                                      const next = isSelected 
                                        ? formData.mpasi.varian_mpasi.filter(i => i !== item) 
                                        : [...formData.mpasi.varian_mpasi, item];
                                      setFormData({...formData, mpasi: {...formData.mpasi, varian_mpasi: next}});
                                    }}
                                    className={`px-3 py-1.5 rounded-lg text-xs font-semibold border transition-all ${isSelected ? 'bg-orange-50 border-orange-200 text-orange-600' : 'bg-white border-slate-200 text-slate-500 hover:bg-slate-50'}`}
                                  >
                                    {isSelected ? '✓ ' : '+ '} {item}
                                  </button>
                                );
                              })}
                            </div>
                          </div>

                          <div className="space-y-4">
                            <div className="space-y-1">
                              <label className="text-[11px] font-bold text-slate-400 uppercase tracking-wider block">Porsi per Makan</label>
                              <select 
                                className="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-2.5 text-sm outline-none focus:ring-2 ring-orange-100 transition-all"
                                value={formData.mpasi.jumlah_makan}
                                onChange={(e) => setFormData({...formData, mpasi: {...formData.mpasi, jumlah_makan: e.target.value}})}
                              >
                                <option value="">Pilih Ukuran Porsi...</option>
                                <option value="2 - 3 sdm (1/2 mangkok ukuran 250 ml)">2 - 3 sdm (1/2 mangkok 250 ml)</option>
                                <option value="1/2 - 3/4 mangkok (ukuran 250 ml)">1/2 - 3/4 mangkok (250 ml)</option>
                                <option value="3/4 - 1 mangkok (ukuran 250 ml)">3/4 - 1 mangkok (250 ml)</option>
                                <option value="1 mangkok (ukuran 250 ml)">1 mangkok (250 ml)</option>
                              </select>
                            </div>

                            <div className="grid grid-cols-2 gap-4">
                              <div className="space-y-1">
                                <label className="text-[11px] font-bold text-slate-400 uppercase tracking-wider block">Makanan Utama</label>
                                <select 
                                  className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2.5 text-sm outline-none focus:ring-2 ring-orange-100"
                                  value={formData.mpasi.frekuensi_makan.makanan_utama}
                                  onChange={(e) => setFormData({...formData, mpasi: {...formData.mpasi, frekuensi_makan: {...formData.mpasi.frekuensi_makan, makanan_utama: e.target.value}}})}
                                >
                                  <option value="">Frekuensi...</option>
                                  <option value="1x/hari">1x / hari</option>
                                  <option value="2x/hari">2x / hari</option>
                                  <option value="3x/hari">3x / hari</option>
                                </select>
                              </div>
                              <div className="space-y-1">
                                <label className="text-[11px] font-bold text-slate-400 uppercase tracking-wider block">Selingan</label>
                                <select 
                                  className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2.5 text-sm outline-none focus:ring-2 ring-orange-100"
                                  value={formData.mpasi.frekuensi_makan.makanan_selingan}
                                  onChange={(e) => setFormData({...formData, mpasi: {...formData.mpasi, frekuensi_makan: {...formData.mpasi.frekuensi_makan, makanan_selingan: e.target.value}}})}
                                >
                                  <option value="">Frekuensi...</option>
                                  <option value="0x/hari">Tidak Ada</option>
                                  <option value="1x/hari">1x / hari</option>
                                  <option value="2x/hari">2x / hari</option>
                                </select>
                              </div>
                            </div>
                          </div>
                        </div>
                      ) : (
                        <div className="py-16 flex flex-col items-center justify-center border-2 border-dashed border-slate-100 rounded-2xl">
                          <Utensils size={32} className="text-slate-200 mb-2" />
                          <p className="text-xs font-semibold text-slate-300 italic">Belum waktunya atau belum diberikan MPASI</p>
                        </div>
                      )}
                    </section>
                  </div>
                </div>
              </div>

              {/* MODAL FOOTER */}
              <div className="p-6 border-t border-slate-100 bg-white flex justify-end items-center gap-3">
                <button 
                  onClick={() => setIsModalOpen(false)} 
                  className="px-6 py-2.5 text-slate-500 font-bold text-sm hover:bg-slate-50 rounded-xl transition-all"
                >
                  Batal
                </button>
                <button 
                  onClick={handleSave} 
                  disabled={submitting} 
                  className="px-8 py-2.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl font-bold text-sm shadow-lg shadow-blue-100 transition-all flex items-center gap-2 disabled:opacity-50"
                >
                  {submitting ? <Loader2 size={18} className="animate-spin" /> : <Save size={18} />}
                  Simpan & Proses AI
                </button>
              </div>
            </div>
          </div>
        )}
      </div>

      <style>{`
        .custom-scrollbar::-webkit-scrollbar { width: 6px; }
        .custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: #e2e8f0; border-radius: 10px; }
      `}</style>
    </MainLayout>
  );
};

// --- SUB-COMPONENTS ---

const SectionHeader = ({ label }) => (
  <tr className="bg-slate-50/50">
    <td colSpan="12" className="px-5 py-3 font-bold text-blue-600 text-[10px] uppercase tracking-widest">{label}</td>
  </tr>
);

const DataRow = ({ label, kolom, type, getContent, fn }) => (
  <tr className="group hover:bg-slate-50 transition-colors border-b border-slate-50">
    <td className="w-1 bg-slate-200 group-hover:bg-blue-400 transition-colors"></td>
    <td className="p-4 font-medium text-slate-700 min-w-[240px] text-sm">{label}</td>
    {kolom.map(bln => {
      const content = getContent(bln, fn, type);
      return (
        <td key={bln} className="p-3 text-center border-r border-slate-50 last:border-r-0">
          {type === "check" ? (
            content === "checkmark" ? (
              <div className="flex justify-center">
                <div className="p-1 bg-green-50 rounded-full">
                  <Check size={16} className="text-green-600 stroke-[3px]" />
                </div>
              </div>
            ) : null
          ) : (
            <span className="font-bold text-blue-600 text-xs">{content || "-"}</span>
          )}
        </td>
      );
    })}
  </tr>
);

export default PelayananGiziIndex;
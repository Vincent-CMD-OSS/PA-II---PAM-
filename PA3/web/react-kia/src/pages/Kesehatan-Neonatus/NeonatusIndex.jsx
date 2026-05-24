import React, { useState, useEffect, useCallback, useMemo } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import MainLayout from "../../components/Layout/MainLayout";
import DynamicInput from "./DynamicInput";
import { neonatusService } from "../../services/Neonatus";
import { Scale, User, Loader2, ClipboardCheck, Stethoscope, AlertCircle, Calendar, Code, Edit3, PlusCircle } from 'lucide-react';

const NeonatusIndex = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  
  const authUser = useMemo(() => {
    try {
      const storedUser = localStorage.getItem('user');
      return storedUser ? JSON.parse(storedUser) : { id: 0, nama: 'Unknown', lokasi: 'Puskesmas' };
    } catch {
      return { id: 0, nama: 'Guest', lokasi: 'Puskesmas' };
    }
  }, []);

  const [activeTab, setActiveTab] = useState('0-6 JAM');
  const [tanggal, setTanggal] = useState(new Date().toISOString().split('T')[0]);
  const [pelayananList, setPelayananList] = useState([]);
  const [formData, setFormData] = useState({});
  const [loading, setLoading] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [showDebug, setShowDebug] = useState(true);
  const [existingRecordId, setExistingRecordId] = useState(null);

  const tabToPeriode = { '0-6 JAM': 1, 'KN1': 2, 'KN2': 3, 'KN3': 4 };

  // --- LOGIKA UTAMA: FETCH DATA BERDASARKAN PERIODE ---
useEffect(() => {
  const loadData = async () => {
    setLoading(true);
    setFormData({});
    setExistingRecordId(null);

    try {
      const periodeId = tabToPeriode[activeTab];
      
      // 1. Load Struktur Form
      const list = await neonatusService.getJenisPelayanan(periodeId);
      setPelayananList(list || []);

      // 2. Load Data Inputan (Gunakan try-catch lokal agar tidak crash)
      try {
        const res = await neonatusService.getPemeriksaanDetail(id, periodeId);
        
        // Pastikan res bukan undefined/null
        if (res) {
          // Jika response berupa array (karena pakai filter query), ambil yang pertama
          const data = Array.isArray(res) ? res[0] : res;
          
          // CEK APAKAH PERIODE COCOK
          if (data && data.periode_id === periodeId) {
            setExistingRecordId(data.id);
            if (data.tanggal) setTanggal(data.tanggal.split('T')[0]);

            const mapped = {};
            if (data.detail_pelayanan) {
              data.detail_pelayanan.forEach(d => {
                mapped[d.jenis_pelayanan_id] = d.nilai;
              });
            }
            setFormData(mapped);
          }
        }
      } catch (innerError) {
        console.log("Info: Data rekam medis belum pernah diisi.");
      }

    } catch (err) {
      console.error("Gagal memuat struktur form:", err);
    } finally {
      setLoading(false);
    }
  };

  if (id) loadData();
}, [activeTab, id]);

  // --- HANDLERS ---
  const handleInputChange = useCallback((itemId, val) => {
    setFormData(prev => ({ ...prev, [itemId]: val }));
  }, []);

  const handleCheckboxChange = useCallback((itemId) => {
  setFormData(prev => {
    const val = prev[itemId];
    const isCurrentlyChecked = val === true || val === "true" || val === 1 || val === "1";
    return { ...prev, [itemId]: !isCurrentlyChecked };
  });
}, []);

  const groups = useMemo(() => {
    const filter = (g) => pelayananList.filter(i => i.group_name?.toLowerCase().includes(g.toLowerCase()));
    return {
      antropometri: filter('antropometri'),
      bbl: filter('bbl'),
      observasi: filter('observasi'),
    };
  }, [pelayananList]);

  const requestPayload = useMemo(() => {
    const nakesId = authUser?.tenaga_kesehatan_id || authUser?.user_id || authUser?.id || 0;
    return {
      anak_id: parseInt(id),
      tanggal: tanggal,
      periode_id: tabToPeriode[activeTab],
      kategori_umur_id: 1,
      lokasi: authUser.lokasi || "Puskesmas Sawo Hutabulu",
      tenaga_kesehatan_id: parseInt(nakesId),
      detail_pelayanan: Object.keys(formData).map(key => ({
        jenis_pelayanan_id: parseInt(key),
        nilai: typeof formData[key] === 'boolean' 
               ? (formData[key] ? "1" : "0") 
               : formData[key].toString(),
        keterangan: ""
      }))
    };
  }, [id, tanggal, activeTab, formData, authUser]);

  const handleFinalSubmit = async () => {
    if (requestPayload.detail_pelayanan.length === 0) return alert("Mohon isi data terlebih dahulu.");

    setSubmitting(true);
    try {
      if (existingRecordId) {
        // UPDATE (PUT)
        await neonatusService.updatePemeriksaan(existingRecordId, requestPayload);
        alert(`✅ Data ${activeTab} Berhasil Diperbarui!`);
      } else {
        // CREATE (POST)
        const res = await neonatusService.savePemeriksaan(requestPayload);
        alert(`✅ Data ${activeTab} Berhasil Disimpan!`);
        // Refresh ID record agar bisa langsung diedit tanpa reload
        if (res?.data?.id) setExistingRecordId(res.data.id);
      }
    } catch (err) {
      alert("❌ Gagal: " + (err.message || "Kesalahan Server"));
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <MainLayout>
      <div className="max-w-6xl mx-auto pb-20 px-4">
        {/* HEADER */}
        <header className="mb-6 flex flex-col lg:flex-row lg:items-center justify-between gap-4 border-b pb-5">
          <div className="flex items-center gap-4">
            <div className="w-12 h-12 bg-blue-900 rounded-2xl flex items-center justify-center text-white shadow-lg">
              <User size={24} />
            </div>
            <div>
              <div className="flex items-center gap-2">
                <h1 className="text-xl font-black text-gray-900 uppercase tracking-tight leading-none">Pemeriksaan Neonatus</h1>
                {existingRecordId ? (
                  <span className="flex items-center gap-1 px-2 py-0.5 bg-amber-100 text-amber-700 text-[9px] font-black rounded border border-amber-200 uppercase">
                    <Edit3 size={10} /> Mode Edit
                  </span>
                ) : (
                  <span className="flex items-center gap-1 px-2 py-0.5 bg-green-100 text-green-700 text-[9px] font-black rounded border border-green-200 uppercase">
                    <PlusCircle size={10} /> Mode Baru
                  </span>
                )}
              </div>
              <p className="text-[10px] text-gray-400 font-bold mt-1.5 uppercase tracking-widest">
                ID Anak: {id} • Petugas: {authUser.nama}
              </p>
            </div>
          </div>

          <div className="flex flex-wrap items-center gap-3">
            <div className="relative">
              <Calendar className="absolute left-3 top-2.5 text-blue-600" size={14} />
              <input 
                type="date" value={tanggal} onChange={(e) => setTanggal(e.target.value)}
                className="pl-9 pr-3 py-1.5 bg-white border border-gray-200 rounded-xl text-[11px] font-bold outline-none focus:ring-2 focus:ring-blue-500/20 shadow-sm"
              />
            </div>
            <div className="bg-gray-100 p-1 rounded-xl flex gap-1 border border-gray-200 shadow-inner">
              {Object.keys(tabToPeriode).map((key) => (
                <button
                  key={key}
                  onClick={() => setActiveTab(key)}
                  className={`px-4 py-1.5 rounded-lg text-[10px] font-bold tracking-wider transition-all ${
                    activeTab === key ? 'bg-white text-blue-600 shadow-sm' : 'text-gray-400 hover:text-gray-600'
                  }`}
                >
                  {key}
                </button>
              ))}
            </div>
          </div>
        </header>

        {loading ? (
          <div className="flex flex-col items-center justify-center py-24 text-center">
            <Loader2 className="w-8 h-8 text-blue-600 animate-spin mb-2" />
            <p className="font-bold text-gray-400 uppercase text-[9px] tracking-widest leading-relaxed">Menyinkronkan Data<br/>Pemeriksaan {activeTab}...</p>
          </div>
        ) : (
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-5">
            {/* VITAL SIGNS */}
            <div className="lg:col-span-4">
              <div className="bg-white p-4 rounded-2xl border border-gray-100 shadow-sm">
                <h3 className="text-[10px] font-black text-blue-600 uppercase tracking-widest mb-4 flex items-center gap-2 border-b pb-2">
                  <Scale size={14} /> Vital Signs
                </h3>
                <div className="space-y-4">
                  {groups.antropometri.map(item => (
                    <DynamicInput key={item.jenis_pelayanan_id} item={item} value={formData[item.jenis_pelayanan_id]} onChange={handleInputChange} />
                  ))}
                </div>
              </div>
            </div>

            {/* TINDAKAN & FISIK */}
            <div className="lg:col-span-8 space-y-5">
              <div className="bg-white p-4 rounded-2xl border border-gray-100 shadow-sm">
                <h3 className="text-[10px] font-black text-green-600 uppercase tracking-widest mb-4 flex items-center gap-2 border-b pb-2">
                  <ClipboardCheck size={14} /> Tindakan Medis
                </h3>
                <div className="grid grid-cols-2 gap-2.5">
                  {groups.bbl.map(item => (
                    <DynamicInput key={item.jenis_pelayanan_id} item={item} value={formData[item.jenis_pelayanan_id]} onToggle={handleCheckboxChange} />
                  ))}
                </div>
              </div>

              <div className="bg-white p-4 rounded-2xl border border-gray-100 shadow-sm">
                <h3 className="text-[10px] font-black text-orange-600 uppercase tracking-widest mb-4 flex items-center gap-2 border-b pb-2">
                  <Stethoscope size={14} /> Pemeriksaan Fisik
                </h3>
                <div className="space-y-4">
                  <div className="grid grid-cols-2 gap-2">
                    {groups.observasi.filter(i => i.tipe_input === 'checkbox').map(item => (
                      <DynamicInput key={item.jenis_pelayanan_id} item={item} value={formData[item.jenis_pelayanan_id]} onToggle={handleCheckboxChange} />
                    ))}
                  </div>
                  {groups.observasi.filter(i => i.tipe_input === 'text').map(item => (
                    <DynamicInput key={item.jenis_pelayanan_id} item={item} value={formData[item.jenis_pelayanan_id]} onChange={handleInputChange} />
                  ))}
                </div>
              </div>
            </div>
          </div>
        )}

        {/* FOOTER Simpan */}
        <div className="mt-8 bg-blue-900 p-4 rounded-xl flex flex-col sm:flex-row items-center justify-between gap-4 shadow-xl text-white">
          <div className="flex items-center gap-3 text-left">
            <AlertCircle size={20} className="text-blue-300" />
            <p className="text-[10px] font-medium italic text-blue-100">
              Data akan {existingRecordId ? 'diperbarui' : 'disimpan baru'} untuk periode {activeTab}
            </p>
          </div>
          <button 
            onClick={handleFinalSubmit} disabled={submitting}
            className="w-full sm:w-auto px-10 py-3 bg-white text-blue-900 rounded-lg font-black text-[10px] uppercase tracking-widest hover:scale-105 active:scale-95 transition-all disabled:opacity-50"
          >
            {submitting ? 'Proses...' : existingRecordId ? 'Simpan Perubahan' : 'Finalisasi & Simpan'}
          </button>
        </div>

        {/* DEBUG PAYLOAD */}
        <div className="mt-10 border-t border-dashed border-gray-200 pt-10">
          <button onClick={() => setShowDebug(!showDebug)} className="text-[10px] font-black text-gray-400 uppercase flex items-center gap-2 mb-4 hover:text-blue-600">
            <Code size={14} /> {showDebug ? 'Sembunyikan Debug' : 'Tampilkan Debug'}
          </button>
          {showDebug && (
            <div className="bg-slate-900 p-6 rounded-3xl shadow-2xl border border-slate-700">
              <pre className="text-green-400 font-mono text-[11px] leading-relaxed overflow-auto max-h-[300px]">
                {JSON.stringify({ 
                  internal_db_id: existingRecordId,
                  periode_active: activeTab,
                  payload_to_send: requestPayload 
                }, null, 2)}
              </pre>
            </div>
          )}
        </div>
      </div>
    </MainLayout>
  );
};

export default NeonatusIndex;
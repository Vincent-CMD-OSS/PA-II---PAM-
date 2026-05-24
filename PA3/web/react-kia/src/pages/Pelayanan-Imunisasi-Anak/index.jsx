import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { Plus, X, Save, Syringe, CheckSquare, Square, Info, Calendar, CheckCircle2, AlertCircle } from 'lucide-react';
import MainLayout from "../../components/Layout/MainLayout";
import { immunizationService } from '../../services/pelayananimunisasi';

const PelayananImunisasi = () => {
  const { id } = useParams(); 
  const [dbData, setDbData] = useState({});
  const [loading, setLoading] = useState(true);
  
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [formData, setFormData] = useState({
    bulan_ke: "0",
    selected_vax_ids: [],
    keterangan: "",
    tanggal: new Date().toISOString().split('T')[0]
  });

  const months = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 18, 23, "23-59"];

  const monthVaccineMapping = {
    "0": [32, 33, 34], "1": [33, 34], "2": [33, 34, 35, 36, 37, 38],
    "3": [33, 34, 35, 36, 37, 38, 39, 40, 41, 42],
    "4": [33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46],
    "5": [33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46],
    "6": [33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46],
    "7": [33, 34, 35, 36, 38, 39, 40, 42, 43, 44, 45],
    "8": [33, 34, 35, 36, 38, 39, 40, 42, 43, 44, 45],
    "9": [33, 34, 35, 36, 38, 39, 40, 42, 43, 44, 45, 47, 49],
    "10": [33, 34, 35, 36, 38, 39, 40, 42, 43, 44, 45, 47, 49, 48],
    "12": [50], "18": [51, 52],
  };

  const vaccineSchedule = [
    { id: 32, name: "Hepatitis B (<24 Jam)", schedule: [0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3] },
    { id: 33, name: "BCG", schedule: [0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2] },
    { id: 34, name: "Polio Tetes 1", schedule: [0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2] },
    { id: 35, name: "DPT-HB-Hib 1", schedule: [3, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2] },
    { id: 36, name: "Polio Tetes 2", schedule: [3, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2] },
    { id: 37, name: "Rotavirus (RV) 1*", schedule: [3, 3, 0, 1, 1, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3] },
    { id: 38, name: "PCV 1", schedule: [3, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2] },
    { id: 39, name: "DPT-HB-Hib 2", schedule: [3, 3, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2] },
    { id: 40, name: "Polio Tetes 3", schedule: [3, 3, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2] },
    { id: 41, name: "Rotavirus (RV) 2*", schedule: [3, 3, 3, 0, 1, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3] },
    { id: 42, name: "PCV 2", schedule: [3, 3, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2] },
    { id: 43, name: "DPT-HB-Hib 3", schedule: [3, 3, 3, 3, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2] },
    { id: 44, name: "Polio Tetes 4", schedule: [3, 3, 3, 3, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2] },
    { id: 45, name: "Polio Suntik (IPV) 1", schedule: [3, 3, 3, 3, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2] },
    { id: 46, name: "Rotavirus (RV) 3*", schedule: [3, 3, 3, 3, 0, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3] },
    { id: 47, name: "Campak-Rubella (MR)", schedule: [3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 1, 1, 2, 2, 2, 2] },
    { id: 49, name: "Polio Suntik (IPV) 2*", schedule: [3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 1, 1, 2, 2, 2, 2] },
    { id: 48, name: "Japanese Encephalitis (JE)*", schedule: [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 1, 2, 2, 2, 2] },
    { id: 50, name: "PCV 3", schedule: [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 1, 1, 1] },
    { id: 51, name: "DPT-HB-Hib Lanjutan", schedule: [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 1, 1] },
    { id: 52, name: "Campak Rubella (MR) Lanjutan", schedule: [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 1, 1] },
  ];

  const fetchData = async () => {
    setLoading(true);
    const data = await immunizationService.getPelayananByAnak(id);
    setDbData(data);
    setLoading(false);
  };

  useEffect(() => { if (id) fetchData(); }, [id]);

  // LOGIKA UTAMA: Cek berdasarkan jenis_pelayanan_id di seluruh data histori anak
  const isVaxAlreadyTaken = (vaxId) => {
    return Object.keys(dbData).some(key => key.split('-')[1] === vaxId.toString());
  };

  // FILTER: Hanya menampilkan vaksin yang dijadwalkan DI BULAN TERSEBUT dan BELUM PERNAH DIAMBIL
  const vaccinesToDisplay = vaccineSchedule.filter(vax => 
    monthVaccineMapping[formData.bulan_ke]?.includes(vax.id) && !isVaxAlreadyTaken(vax.id)
  );

  const handleToggleVax = (vaxId) => {
    setFormData(prev => {
      const isSelected = prev.selected_vax_ids.includes(vaxId);
      return {
        ...prev,
        selected_vax_ids: isSelected 
          ? prev.selected_vax_ids.filter(v => v !== vaxId) 
          : [...prev.selected_vax_ids, vaxId]
      };
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (formData.selected_vax_ids.length === 0) return alert("Pilih minimal satu pelayanan!");
    
    setIsSubmitting(true);
    try {
      const payload = {
        anak_id: parseInt(id),
        bulan_ke: parseInt(formData.bulan_ke),
        detail: formData.selected_vax_ids.map(vaxId => ({
          jenis_pelayanan_id: vaxId,
          keterangan: formData.keterangan
        })),
        created_at: new Date(formData.tanggal).toISOString()
      };
      
      await immunizationService.createPelayanan(payload);
      setIsModalOpen(false);
      setFormData(prev => ({ ...prev, selected_vax_ids: [], keterangan: "" }));
      fetchData();
    } catch (err) {
      alert("Gagal menyimpan data.");
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <MainLayout>
      <div className="p-4 md:p-6 bg-gray-50 min-h-screen">
        <div className="max-w-7xl mx-auto bg-white shadow-xl border border-gray-300 rounded-sm overflow-hidden">
          
          <div className="flex justify-between items-center p-4 border-b-2 border-gray-800 bg-white">
            <h1 className="text-2xl font-bold text-gray-800 uppercase tracking-tighter italic">Pelayanan Imunisasi</h1>
            <button 
              onClick={() => setIsModalOpen(true)}
              className="flex items-center gap-2 bg-blue-600 hover:bg-blue-700 text-white px-5 py-2 rounded font-bold text-xs uppercase shadow-md transition-all active:scale-95"
            >
              <Plus size={16} /> TAMBAH CATATAN
            </button>
          </div>

          <div className="overflow-x-auto">
            {loading ? (
              <div className="p-20 text-center font-bold text-blue-600 animate-pulse uppercase tracking-widest text-sm">Sinkronisasi...</div>
            ) : (
              <table className="w-full border-collapse text-[10px] table-fixed">
                <thead>
                  <tr className="bg-gray-800 text-white uppercase font-bold text-[9px]">
                    <th rowSpan="2" className="border border-gray-400 p-2 w-48 text-left uppercase">Jenis Vaksin</th>
                    <th colSpan={months.length} className="border border-gray-400 p-1 text-center italic tracking-widest">Bulan</th>
                  </tr>
                  <tr className="bg-gray-800 text-white font-bold">
                    {months.map((m, i) => <th key={i} className="border border-gray-400 p-1 w-12 text-center">{m}</th>)}
                  </tr>
                </thead>
                <tbody>
                  <tr className="bg-gray-100 font-bold uppercase text-gray-700 text-[9px]">
                    <td className="border border-gray-400 p-2">Jenis Vaksin</td>
                    <td colSpan={months.length} className="border border-gray-400 p-1 text-center italic font-normal tracking-tighter uppercase">Tanggal Pemberian dan Paraf Petugas</td>
                  </tr>
                  {vaccineSchedule.map((vax) => {
                    const firstRecordKey = Object.keys(dbData).find(k => k.endsWith(`-${vax.id}`));
                    return (
                      <tr key={vax.id} className="hover:bg-blue-50 h-14 transition-colors">
                        <td className="border border-gray-400 p-2 bg-gray-50 font-bold text-gray-700 leading-tight uppercase">
                          {vax.name}
                          <div className="text-[8px] font-normal italic text-gray-400 mt-1 uppercase">
                            Batch: {dbData[firstRecordKey]?.batch || "......"}
                          </div>
                        </td>
                        {months.map((m, mIdx) => {
                          const cellKey = `${m}-${vax.id}`;
                          const cellData = dbData[cellKey];
                          const colors = ["bg-white", "bg-yellow-100", "bg-pink-100", "bg-gray-300"];
                          return (
                            <td key={mIdx} className={`border border-gray-400 text-center relative ${colors[vax.schedule[mIdx]]}`}>
                              {cellData && (
                                <div className="leading-none flex flex-col items-center justify-center animate-in fade-in zoom-in duration-300">
                                  <span className="font-bold text-blue-700 text-[8px] mb-0.5">
                                    {new Date(cellData.tanggal).toLocaleDateString('id-ID', {day:'2-digit', month:'2-digit', year:'2-digit'})}
                                  </span>
                                  <div className="text-blue-600 font-bold text-sm leading-none">✓</div>
                                </div>
                              )}
                            </td>
                          );
                        })}
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            )}
          </div>
        </div>
      </div>

      {/* MODAL CREATE - SMART FILTER */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4 text-sans">
          <div className="bg-white rounded w-full max-w-md overflow-hidden shadow-2xl animate-in zoom-in duration-200 border-t-4 border-blue-600">
            <div className="bg-gray-800 p-4 text-white flex justify-between uppercase font-bold italic text-xs tracking-widest">
              <span className="flex items-center gap-2"><Syringe size={16} className="text-blue-400"/> Input Pelayanan KIA</span>
              <button onClick={() => setIsModalOpen(false)} className="hover:rotate-90 transition-transform"><X size={18}/></button>
            </div>
            
            <form onSubmit={handleSubmit} className="p-6 space-y-4 uppercase font-bold text-[10px]">
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="text-gray-500 mb-1 block tracking-tighter">Bulan Ke-</label>
                  <select 
                    className="w-full border-b-2 p-2 outline-none focus:border-blue-600 bg-gray-50 font-bold text-xs" 
                    value={formData.bulan_ke} 
                    onChange={e => setFormData({...formData, bulan_ke: e.target.value, selected_vax_ids: []})}
                  >
                    {months.map(m => (
                      <option key={m} value={m} disabled={!monthVaccineMapping[m.toString()]}>
                        Bulan {m} {!monthVaccineMapping[m.toString()] ? '(X)' : ''}
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="text-gray-500 mb-1 block tracking-tighter">Tanggal Layanan</label>
                  <div className="flex items-center gap-2 border-b-2 focus-within:border-blue-600">
                    <Calendar size={14} className="text-gray-400" />
                    <input type="date" className="w-full p-2 outline-none font-bold bg-transparent text-xs" value={formData.tanggal} onChange={e => setFormData({...formData, tanggal: e.target.value})} required />
                  </div>
                </div>
              </div>

              {/* LIST VAKSIN - HANYA YANG BELUM DIAMBIL */}
              <div className="bg-gray-50 p-4 rounded border border-gray-200 shadow-inner">
                <div className="flex justify-between items-center mb-3 border-b border-gray-300 pb-2">
                  <label className="text-gray-400 tracking-widest text-[10px]">VAKSIN BELUM DIAMBIL:</label>
                </div>

                <div className="space-y-2 max-h-56 overflow-y-auto pr-2 custom-scrollbar">
                  {vaccinesToDisplay.length > 0 ? (
                    vaccinesToDisplay.map(vax => (
                      <div 
                        key={vax.id} 
                        onClick={() => handleToggleVax(vax.id)}
                        className={`flex items-center gap-3 p-3 rounded-lg border-2 transition-all cursor-pointer
                        ${formData.selected_vax_ids.includes(vax.id) 
                          ? 'bg-blue-600 text-white border-blue-600 shadow-md transform translate-x-1' 
                          : 'bg-white border-gray-100 text-gray-700 hover:border-blue-300'}`}
                      >
                        {formData.selected_vax_ids.includes(vax.id) ? <CheckSquare size={16}/> : <Square size={16}/>}
                        <span className="text-[10px] tracking-tight">{vax.name}</span>
                      </div>
                    ))
                  ) : (
                    <div className="flex flex-col items-center justify-center p-6 text-center space-y-2 bg-green-50 rounded-lg border border-green-100">
                      <CheckCircle2 size={32} className="text-green-500" />
                      <p className="text-green-700 font-bold tracking-normal italic uppercase">
                        Selesai! Semua jadwal vaksin bulan ke-{formData.bulan_ke} sudah tercatat.
                      </p>
                    </div>
                  )}
                </div>
              </div>

              <div>
                <label className="text-gray-500 mb-1 block tracking-tighter">No Batch / Catatan Petugas</label>
                <input type="text" className="w-full border-b-2 p-2 outline-none lowercase font-normal placeholder:italic focus:border-blue-600" placeholder="catatan batch vaksin..." value={formData.keterangan} onChange={e => setFormData({...formData, keterangan: e.target.value})} />
              </div>

              <div className="pt-2">
                <button 
                  disabled={isSubmitting || vaccinesToDisplay.length === 0 || formData.selected_vax_ids.length === 0} 
                  type="submit" 
                  className="w-full bg-blue-600 text-white py-3.5 rounded-xl hover:bg-blue-700 flex justify-center items-center gap-3 transition-all shadow-lg active:scale-95 disabled:bg-gray-300 disabled:shadow-none"
                >
                  {isSubmitting ? "MEMPROSES..." : <><Save size={16}/> SIMPAN ({formData.selected_vax_ids.length}) DATA</>}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </MainLayout>
  );
};

export default PelayananImunisasi;
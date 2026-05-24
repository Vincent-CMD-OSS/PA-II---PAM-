import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { Plus, X, Save, ShieldAlert, Smile } from 'lucide-react';
import MainLayout from "../../components/Layout/MainLayout";
import { dentalService } from '../../services/dentalService';

const PelayananGigi = () => {
  const { id } = useParams();
  const [records, setRecords] = useState([]);
  const [loading, setLoading] = useState(true);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);

  // 1. Pastikan key di sini SAMA dengan yang digunakan di input
  const [formData, setFormData] = useState({
    bulan_ke: "", 
    tanggal: new Date().toISOString().split('T')[0],
    jumlah_gigi: 0,
    gigi_berlubang: 0,
    status_plak: "Bersih"
  });

  const fetchData = async () => {
    setLoading(true);
    try {
      const data = await dentalService.getByAnak(id);
      setRecords(data);
    } catch (error) {
      console.error("Fetch error:", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (id) fetchData();
  }, [id]);

  const handleOpenModal = () => {
    setFormData({
      bulan_ke: "",
      tanggal: new Date().toISOString().split('T')[0],
      jumlah_gigi: 0,
      gigi_berlubang: 0,
      status_plak: "Bersih"
    });
    setIsModalOpen(true);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (Number(formData.gigi_berlubang) > Number(formData.jumlah_gigi)) {
      alert("⚠️ Jumlah gigi berlubang tidak boleh melebihi total gigi!");
      return;
    }

    setIsSubmitting(true);

    // 2. Susun Payload - Pastikan key 'bulan_ke' sesuai dengan tag JSON di Go
    const payload = {
      anak_id: Number(id),
      bulan_ke: Number(formData.bulan_ke),
      tanggal: new Date(formData.tanggal).toISOString(),
      jumlah_gigi: Number(formData.jumlah_gigi),
      gigi_berlubang: Number(formData.gigi_berlubang),
      status_plak: formData.status_plak
    };

    console.group("🚀 DEBUG REQUEST: Simpan Gigi");
    console.log("Payload Dikirim:", payload);
    console.groupEnd();

    try {
      await dentalService.create(payload);
      alert("Data berhasil disimpan!");
      setIsModalOpen(false);
      fetchData();
    } catch (err) {
      // Menampilkan pesan detail dari backend jika ada
      const errorMsg = err.response?.data?.message || "Gagal menyimpan data.";
      alert(`Error: ${errorMsg}`);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <MainLayout>
      <div className="p-4 md:p-6 bg-gray-50 min-h-screen">
        <div className="max-w-6xl mx-auto bg-white shadow-xl border border-gray-200 rounded-sm overflow-hidden text-gray-800">
          
          <div className="bg-white p-5 border-b-4 border-gray-800 flex justify-between items-center">
            <div>
              <h1 className="text-2xl font-black uppercase tracking-tight italic flex items-center gap-2">
                <Smile className="text-green-600" /> Catatan Kesehatan Gigi
              </h1>
              <p className="text-[10px] text-gray-500 font-bold uppercase tracking-widest mt-1 italic">
                Rule-Base AI Active • ID Anak: {id}
              </p>
            </div>
            <button 
              onClick={handleOpenModal}
              className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-md font-bold text-xs uppercase shadow-lg flex items-center gap-2 transition-all active:scale-95"
            >
              <Plus size={18} /> Tambah Pemeriksaan
            </button>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full border-collapse text-center table-fixed min-w-[800px]">
              <thead className="text-[11px] font-bold uppercase tracking-tighter">
                <tr className="bg-gray-700 text-white">
                  <th colSpan="2" className="border border-gray-400 p-2 py-3">Pemeriksaan</th>
                  <th colSpan="2" className="border border-gray-400 p-2">Jumlah Gigi</th>
                  <th colSpan="2" className="border border-gray-400 p-2">Plak</th>
                  <th colSpan="3" className="border border-gray-400 p-2 text-yellow-400">Risiko (By AI)</th>
                </tr>
                <tr className="bg-gray-200 text-gray-700">
                  <th className="border border-gray-400 p-2 w-16 italic">Bulan</th>
                  <th className="border border-gray-400 p-2 w-32 italic">Tanggal</th>
                  <th className="border border-gray-400 p-2">Ada</th>
                  <th className="border border-gray-400 p-2 text-red-600">Berlubang</th>
                  <th className="border border-gray-400 p-2">Bersih</th>
                  <th className="border border-gray-400 p-2">Kotor</th>
                  <th className="border border-gray-400 p-2 bg-pink-50 text-pink-700">Tinggi</th>
                  <th className="border border-gray-400 p-2 bg-orange-50 text-orange-700">Sedang</th>
                  <th className="border border-gray-400 p-2 bg-green-50 text-green-700">Rendah</th>
                </tr>
              </thead>
              <tbody>
                {loading ? (
                  <tr><td colSpan="9" className="p-10 animate-pulse font-bold text-blue-600 uppercase italic">Sinkronisasi data...</td></tr>
                ) : records.length > 0 ? (
                  records.map((row, idx) => (
                    <tr key={idx} className="text-xs font-bold hover:bg-blue-50 transition-colors h-12">
                      <td className="border border-gray-300 p-2">{row.bulan}</td>
                      <td className="border border-gray-300 p-2">
                        {new Date(row.tanggal).toLocaleDateString('id-ID', { day: '2-digit', month: '2-digit', year: 'numeric' })}
                      </td>
                      <td className="border border-gray-300 p-2">{row.jumlah_gigi}</td>
                      <td className="border border-gray-300 p-2 text-red-500">{row.gigi_berlubang}</td>
                      <td className="border border-gray-300 p-2">{row.status_plak === 'Bersih' ? '✓' : ''}</td>
                      <td className="border border-gray-300 p-2">{row.status_plak === 'Kotor' ? '✓' : ''}</td>
                      <td className={`border border-gray-300 p-2 ${row.resiko_gigi_berlubang === 'Tinggi' ? 'bg-pink-100 text-pink-600' : ''}`}>
                        {row.resiko_gigi_berlubang === 'Tinggi' ? '●' : ''}
                      </td>
                      <td className={`border border-gray-300 p-2 ${row.resiko_gigi_berlubang === 'Sedang' ? 'bg-orange-100 text-orange-600' : ''}`}>
                        {row.resiko_gigi_berlubang === 'Sedang' ? '●' : ''}
                      </td>
                      <td className={`border border-gray-300 p-2 ${row.resiko_gigi_berlubang === 'Rendah' ? 'bg-green-100 text-green-600' : ''}`}>
                        {row.resiko_gigi_berlubang === 'Rendah' ? '●' : ''}
                      </td>
                    </tr>
                  ))
                ) : (
                  [...Array(6)].map((_, i) => (
                    <tr key={i} className="h-10 border border-gray-200">
                      {[...Array(9)].map((_, j) => <td key={j} className="border border-gray-200"></td>)}
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>
      </div>

      {/* MODAL FORM */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4">
          <div className="bg-white rounded w-full max-w-md overflow-hidden shadow-2xl border-t-8 border-blue-600">
            <div className="bg-gray-800 p-4 text-white flex justify-between items-center uppercase font-bold italic text-xs">
              <span className="flex items-center gap-2"><ShieldAlert size={16} className="text-yellow-400"/> Input Pemeriksaan</span>
              <button onClick={() => setIsModalOpen(false)}><X size={20}/></button>
            </div>
            
            <form onSubmit={handleSubmit} className="p-6 space-y-4 font-bold text-xs uppercase text-gray-600">
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block mb-1">Bulan Ke-</label>
                  <input 
                    type="number" 
                    className="w-full border-b-2 p-2 outline-none focus:border-blue-600 bg-gray-50" 
                    value={formData.bulan_ke} // FIX: Sebelumnya formData.bulan
                    onChange={e => setFormData({...formData, bulan_ke: e.target.value})} // FIX: Sebelumnya bulan
                    required 
                  />
                </div>
                <div>
                  <label className="block mb-1">Tanggal</label>
                  <input 
                    type="date" 
                    className="w-full border-b-2 p-2 outline-none focus:border-blue-600 bg-gray-50" 
                    value={formData.tanggal} 
                    onChange={e => setFormData({...formData, tanggal: e.target.value})} 
                    required 
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block mb-1">Gigi Ada</label>
                  <input 
                    type="number" 
                    className="w-full border-b-2 p-2 outline-none focus:border-blue-600 bg-gray-50" 
                    value={formData.jumlah_gigi} 
                    onChange={e => setFormData({...formData, jumlah_gigi: e.target.value})} 
                    required 
                  />
                </div>
                <div>
                  <label className="block mb-1 text-red-600">Berlubang</label>
                  <input 
                    type="number" 
                    className="w-full border-b-2 p-2 outline-none focus:border-red-600 bg-gray-50 text-red-600" 
                    value={formData.gigi_berlubang} 
                    onChange={e => setFormData({...formData, gigi_berlubang: e.target.value})} 
                    required 
                  />
                </div>
              </div>

              <div>
                <label className="block mb-2">Status Plak</label>
                <div className="flex gap-6">
                  {['Bersih', 'Kotor'].map(status => (
                    <label key={status} className="flex items-center gap-2 cursor-pointer">
                      <input 
                        type="radio" 
                        name="status_plak" 
                        value={status} 
                        checked={formData.status_plak === status} 
                        onChange={e => setFormData({...formData, status_plak: e.target.value})} 
                        className="w-4 h-4 text-blue-600" 
                      />
                      {status}
                    </label>
                  ))}
                </div>
              </div>

              {/* Preview Debug */}
              <div className="mt-4 p-3 bg-gray-900 rounded-lg border border-gray-700">
                <span className="text-[9px] font-mono text-green-400 uppercase tracking-widest font-bold">JSON Payload Preview:</span>
                <pre className="text-[9px] font-mono text-blue-200 leading-none mt-1">
                  {JSON.stringify({
                    anak_id: Number(id),
                    bulan_ke: Number(formData.bulan_ke),
                    jumlah_gigi: Number(formData.jumlah_gigi),
                    gigi_berlubang: Number(formData.gigi_berlubang),
                    status_plak: formData.status_plak
                  }, null, 2)}
                </pre>
              </div>

              <button 
                disabled={isSubmitting} 
                type="submit" 
                className="w-full bg-blue-600 text-white py-3 rounded-xl hover:bg-blue-700 disabled:bg-gray-400 font-black uppercase tracking-widest transition-all"
              >
                {isSubmitting ? "SINKRONISASI..." : "SIMPAN DATA"}
              </button>
            </form>
          </div>
        </div>
      )}
    </MainLayout>
  );
};

export default PelayananGigi;
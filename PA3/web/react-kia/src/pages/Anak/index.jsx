import React, { useState, useEffect } from "react";
import MainLayout from "../../components/Layout/MainLayout";
import { Link, useNavigate } from "react-router-dom";
import { getAnak, deleteAnak } from "../../services/Anak";
import {
  Plus, Search, Pencil, Trash2, ChevronLeft, ChevronRight,
  Baby, LayoutDashboard, User, Calendar
} from "lucide-react";

export default function AnakListNakes() {
  const navigate = useNavigate();
  const [children, setChildren] = useState([]);
  const [searchTerm, setSearchTerm] = useState("");
  const [loading, setLoading] = useState(true);

  // --- STATE PAGINATION ---
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 10; // Tentukan jumlah data per halaman

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        const res = await getAnak();
        setChildren(res.data || []);
      } catch (error) {
        console.error("Error fetching data:", error);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, []);

  const handleDelete = async (id, name) => {
    if (!window.confirm(`Apakah Anda yakin ingin menghapus data ${name}?`)) return;
    try {
      await deleteAnak(id);
      setChildren((prev) => prev.filter((item) => item.id !== id));
    } catch (error) {
      alert("Gagal menghapus data. Silakan coba lagi.");
    }
  };

  const formatDate = (dateString) => {
    if (!dateString) return "-";
    const date = new Date(dateString);
    return date.toLocaleDateString("id-ID", {
      day: "numeric", month: "long", year: "numeric",
    });
  };

  // --- LOGIC FILTER & PAGINATION ---
  const filteredChildren = children.filter((c) =>
    c.nama?.toLowerCase().includes(searchTerm.toLowerCase()) ||
    c.kehamilan?.ibu?.nama_ibu?.toLowerCase().includes(searchTerm.toLowerCase())
  );

  // Hitung index data
  const indexOfLastItem = currentPage * itemsPerPage;
  const indexOfFirstItem = indexOfLastItem - itemsPerPage;
  const currentItems = filteredChildren.slice(indexOfFirstItem, indexOfLastItem);
  const totalPages = Math.ceil(filteredChildren.length / itemsPerPage);

  // Reset ke halaman 1 jika user mencari sesuatu
  const handleSearchChange = (e) => {
    setSearchTerm(e.target.value);
    setCurrentPage(1);
  };

  return (
    <MainLayout>
      {/* BREADCRUMB */}
      <nav className="flex items-center text-sm text-gray-500 mb-6 gap-2 bg-white p-3 rounded-lg shadow-sm border border-gray-100 w-fit">
        <Link to="/dashboard" className="hover:text-indigo-600 flex items-center gap-1">
          Dashboard
        </Link>
        <ChevronRight size={14} />
        <span className="font-semibold text-indigo-700">Rekam Medis Anak</span>
      </nav>

      <div className="flex flex-col md:flex-row md:items-end justify-between gap-4 mb-8">
        <div>
          <h1 className="text-2xl font-bold text-gray-800 tracking-tight">Daftar Anak</h1>
          <p className="text-gray-500 text-sm">Rekam data pertumbuhan anak secara terpusat.</p>
        </div>
        
        <div className="bg-indigo-600 text-white px-6 py-3 rounded-2xl shadow-lg shadow-indigo-100 flex items-center gap-4">
          <div className="p-2 bg-white/20 rounded-xl">
            <Baby size={24} />
          </div>
          <div>
            <p className="text-[10px] text-indigo-100 font-bold uppercase tracking-wider">Total Data</p>
            <p className="text-2xl font-black">{children.length} <span className="text-sm font-medium">Anak</span></p>
          </div>
        </div>
      </div>

      <div className="bg-white rounded-t-2xl border-x border-t border-gray-100 p-6">
        <div className="flex flex-col md:flex-row justify-between gap-4">
          <div className="relative w-full max-w-md">
            <Search className="absolute left-3 top-1/2 -transform -translate-y-1/2 text-gray-400" size={18} />
            <input
              type="text"
              placeholder="Cari nama anak atau nama ibu..."
              className="pl-10 pr-4 py-2.5 border border-gray-200 rounded-xl w-full focus:ring-2 focus:ring-indigo-500 outline-none transition-all text-sm"
              onChange={handleSearchChange}
            />
          </div>
          <Link
            to="/data-anak/create"
            className="bg-indigo-600 hover:bg-indigo-700 text-white px-6 py-2.5 rounded-xl flex items-center justify-center gap-2 font-bold transition-all shadow-md active:scale-95"
          >
            <Plus size={20} /> Tambah Data Anak
          </Link>
        </div>
      </div>

      <div className="bg-white rounded-b-2xl shadow-sm border border-gray-100 overflow-x-auto">
        <table className="w-full text-left border-collapse">
          <thead>
            <tr className="bg-gray-50/50 border-y border-gray-100 text-gray-500 uppercase text-[10px] tracking-widest font-black">
              <th className="px-6 py-4">Nama Anak</th>
              <th className="px-6 py-4">Jenis Kelamin</th>
              <th className="px-6 py-4">Tanggal Lahir</th>
              <th className="px-6 py-4">Usia</th>
              <th className="px-6 py-4">Nama Ibu</th>
              <th className="px-6 py-4 text-center">Aksi</th>
            </tr>
          </thead>

          <tbody className="divide-y divide-gray-50">
            {loading ? (
              [...Array(3)].map((_, i) => (
                <tr key={i} className="animate-pulse">
                  <td colSpan="6" className="p-6 text-center">Memuat data...</td>
                </tr>
              ))
            ) : currentItems.length === 0 ? (
              <tr>
                <td colSpan="6" className="text-center py-20">
                    <p className="text-gray-400">Tidak ada data ditemukan</p>
                </td>
              </tr>
            ) : (
              currentItems.map((child) => (
                <tr key={child.id} className="hover:bg-indigo-50/20 transition-colors group">
                  <td className="px-6 py-4 font-bold text-gray-800 text-sm">{child.nama}</td>
                  <td className="px-6 py-4">
                     <span className={`px-3 py-1 rounded-full text-[10px] font-bold uppercase border ${
                        child.jenis_kelamin === 'laki-laki' ? 'bg-blue-50 text-blue-700 border-blue-100' : 'bg-pink-50 text-pink-700 border-pink-100'
                     }`}>
                        {child.jenis_kelamin}
                     </span>
                  </td>
                  <td className="px-6 py-4 text-xs">{formatDate(child.tanggal_lahir)}</td>
                  <td className="px-6 py-4 text-xs font-bold">{child.usia_teks || "-"}</td>
                  <td className="px-6 py-4 text-sm font-semibold">{child.kehamilan?.ibu?.nama_ibu || "-"}</td>
                  <td className="px-6 py-4">
                    <div className="flex items-center justify-center gap-2">
                       <Link to={`/data-anak/dashboard/${child.id}`} className="bg-indigo-600 text-white px-3 py-1.5 rounded-lg text-xs font-bold shadow-sm active:scale-95">
                         Pantau
                       </Link>
                       <Link to={`/data-anak/edit/${child.id}`} className="p-1.5 text-gray-400 hover:text-amber-600"><Pencil size={14}/></Link>
                       <button onClick={() => handleDelete(child.id, child.nama)} className="p-1.5 text-gray-400 hover:text-red-600"><Trash2 size={14}/></button>
                    </div>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>

        {/* --- UI CONTROLS PAGINATION --- */}
        <div className="flex items-center justify-between px-6 py-4 bg-gray-50/50 border-t border-gray-100">
          <p className="text-xs text-gray-500 font-medium">
            Menampilkan <span className="text-indigo-600">{indexOfFirstItem + 1}</span> - <span className="text-indigo-600">{Math.min(indexOfLastItem, filteredChildren.length)}</span> dari <span className="text-indigo-600">{filteredChildren.length}</span> data
          </p>
          
          <div className="flex items-center gap-2">
            <button
              onClick={() => setCurrentPage(prev => Math.max(prev - 1, 1))}
              disabled={currentPage === 1}
              className="p-2 rounded-lg border border-gray-200 bg-white text-gray-600 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed transition-all"
            >
              <ChevronLeft size={16} />
            </button>
            
            <div className="flex gap-1">
              {[...Array(totalPages)].map((_, i) => (
                <button
                  key={i}
                  onClick={() => setCurrentPage(i + 1)}
                  className={`w-8 h-8 rounded-lg text-xs font-bold transition-all ${
                    currentPage === i + 1 
                    ? "bg-indigo-600 text-white shadow-md shadow-indigo-100" 
                    : "bg-white border border-gray-200 text-gray-600 hover:bg-gray-50"
                  }`}
                >
                  {i + 1}
                </button>
              ))}
            </div>

            <button
              onClick={() => setCurrentPage(prev => Math.min(prev + 1, totalPages))}
              disabled={currentPage === totalPages || totalPages === 0}
              className="p-2 rounded-lg border border-gray-200 bg-white text-gray-600 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed transition-all"
            >
              <ChevronRight size={16} />
            </button>
          </div>
        </div>
      </div>
    </MainLayout>
  );
}
import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import MainLayout from "../../components/Layout/MainLayout";
import { getKependudukanList, deleteKependudukan } from "../../services/kependudukan";
import { Plus, Edit, Trash2, Search, ChevronLeft, ChevronRight } from "lucide-react";

export default function KependudukanList() {
  const [data, setData] = useState([]);
  const [search, setSearch] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 10;
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      const res = await getKependudukanList();
      setData(res);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (id, nama) => {
    if (window.confirm(`Hapus data ${nama}?`)) {
      try {
        await deleteKependudukan(id);
        fetchData();
      } catch (err) {
        alert("Gagal menghapus");
      }
    }
  };

  const filtered = data.filter((item) =>
    item.nama_lengkap?.toLowerCase().includes(search.toLowerCase()) ||
    item.nik?.includes(search)
  );
  const totalPages = Math.ceil(filtered.length / itemsPerPage);
  const currentItems = filtered.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

  return (
    <MainLayout>
      <div className="p-6">
        <div className="flex justify-between items-center mb-6">
          <h1 className="text-2xl font-bold">Manajemen Kartu Keluarga (KK)</h1>
          <Link to="/kependudukan/create" className="bg-indigo-600 text-white px-4 py-2 rounded-lg flex items-center gap-2">
            <Plus size={18} /> Tambah KK
          </Link>
        </div>

        <div className="bg-white rounded-xl shadow-sm overflow-hidden">
          <div className="p-4 border-b">
            <div className="relative w-64">
              <Search className="absolute left-3 top-2.5 text-gray-400" size={18} />
              <input
                type="text"
                placeholder="Cari nama atau NIK"
                className="pl-10 pr-4 py-2 border rounded-lg w-full"
                value={search}
                onChange={(e) => setSearch(e.target.value)}
              />
            </div>
          </div>
          <div className="overflow-x-auto">
            <table className="min-w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-4 py-3 text-left">Nama Lengkap</th>
                  <th className="px-4 py-3 text-left">NIK</th>
                  <th className="px-4 py-3 text-left">No. KK</th>
                  <th className="px-4 py-3 text-left">Dusun</th>
                  <th className="px-4 py-3 text-center">Aksi</th>
                </tr>
              </thead>
              <tbody>
                {loading ? (
                  <tr><td colSpan="5" className="p-6 text-center">Memuat...</td></tr>
                ) : currentItems.length === 0 ? (
                  <tr><td colSpan="5" className="p-6 text-center">Tidak ada data</td></tr>
                ) : (
                  currentItems.map((item) => (
                    <tr key={item.id_kependudukan} className="border-t hover:bg-gray-50">
                      <td className="px-4 py-3">{item.nama_lengkap}</td>
                      <td className="px-4 py-3">{item.nik}</td>
                      <td className="px-4 py-3">{item.no_kk}</td>
                      <td className="px-4 py-3">{item.dusun}</td>
                      <td className="px-4 py-3 text-center space-x-2">
                        <Link to={`/kependudukan/edit/${item.id_kependudukan}`} className="text-amber-600 hover:text-amber-800">
                          <Edit size={18} />
                        </Link>
                        <button onClick={() => handleDelete(item.id_kependudukan, item.nama_lengkap)} className="text-red-600 hover:text-red-800">
                          <Trash2 size={18} />
                        </button>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
          <div className="px-4 py-3 border-t flex justify-between items-center">
            <span className="text-sm text-gray-500">Menampilkan {currentItems.length} dari {filtered.length}</span>
            <div className="flex gap-2">
              <button onClick={() => setCurrentPage(p => Math.max(1, p-1))} disabled={currentPage === 1} className="p-1 rounded border disabled:opacity-50"><ChevronLeft size={18} /></button>
              <span>Halaman {currentPage} dari {totalPages || 1}</span>
              <button onClick={() => setCurrentPage(p => Math.min(totalPages, p+1))} disabled={currentPage === totalPages} className="p-1 rounded border disabled:opacity-50"><ChevronRight size={18} /></button>
            </div>
          </div>
        </div>
      </div>
    </MainLayout>
  );
}
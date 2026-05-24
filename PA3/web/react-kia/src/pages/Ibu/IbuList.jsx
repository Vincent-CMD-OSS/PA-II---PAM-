// src/pages/Ibu/IbuList.jsx
import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import MainLayout from "../../components/Layout/MainLayout";
import { getIbuList } from "../../services/ibu";
import { Plus, Search, ChevronLeft, ChevronRight } from "lucide-react";

const statusBadge = (status) => {
  if (status === "TRIMESTER 1") return "bg-blue-100 text-blue-800";
  if (status === "TRIMESTER 2") return "bg-yellow-100 text-yellow-800";
  if (status === "TRIMESTER 3") return "bg-green-100 text-green-800";
  return "bg-gray-100 text-gray-800";
};

const riskBadge = (risk) => {
  if (risk === "TINGGI") return "bg-red-100 text-red-800";
  if (risk === "SEDANG") return "bg-orange-100 text-orange-800";
  return "bg-green-100 text-green-800";
};

// Hitung usia dari tanggal lahir
const hitungUsia = (tanggalLahir) => {
  if (!tanggalLahir) return "-";
  const today = new Date();
  const birth = new Date(tanggalLahir);
  let age = today.getFullYear() - birth.getFullYear();
  const m = today.getMonth() - birth.getMonth();
  if (m < 0 || (m === 0 && today.getDate() < birth.getDate())) age--;
  return age;
};

export default function IbuList() {
  const [ibuList, setIbuList] = useState([]);
  const [search, setSearch] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 10;
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetch = async () => {
      try {
        const data = await getIbuList();
        setIbuList(data);
      } catch (err) {
        console.error(err);
      } finally {
        setLoading(false);
      }
    };
    fetch();
  }, []);

  const filtered = ibuList.filter((ibu) => ibu.kependudukan?.nama_lengkap?.toLowerCase().includes(search.toLowerCase()));
  const totalPages = Math.ceil(filtered.length / itemsPerPage);
  const currentItems = filtered.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

  const totalIbu = ibuList.length;
  const totalHamil = ibuList.filter((i) => i.status_kehamilan?.startsWith("TRIMESTER")).length;
  const totalRisikoTinggi = ibuList.filter((i) => i.risiko_tinggi === true).length;

  return (
    <MainLayout>
      <div className="p-6">
        {/* Header Stats */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
          <div className="bg-white rounded-xl shadow-sm p-4 border-l-4 border-indigo-500">
            <p className="text-gray-500 text-sm">TOTAL IBU TERDAFTAR</p>
            <p className="text-2xl font-bold">{totalIbu.toLocaleString()}</p>
          </div>
          <div className="bg-white rounded-xl shadow-sm p-4 border-l-4 border-green-500">
            <p className="text-gray-500 text-sm">IBU SEDANG HAMIL</p>
            <p className="text-2xl font-bold">{totalHamil}</p>
          </div>
          <div className="bg-white rounded-xl shadow-sm p-4 border-l-4 border-red-500">
            <p className="text-gray-500 text-sm">RESIKO TINGGI</p>
            <p className="text-2xl font-bold">{totalRisikoTinggi}</p>
          </div>
        </div>

        {/* Search & Add Button */}
        <div className="flex flex-wrap justify-between items-center gap-4 mb-6">
          <div className="relative w-full max-w-md">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={18} />
            <input type="text" placeholder="Cari Nama Ibu..." className="pl-10 pr-4 py-2 border border-gray-200 rounded-xl w-full focus:ring-2 focus:ring-indigo-500 outline-none" value={search} onChange={(e) => setSearch(e.target.value)} />
          </div>
          <Link to="/data-ibu/create" className="bg-indigo-600 hover:bg-indigo-700 text-white px-5 py-2 rounded-xl flex items-center gap-2 font-bold">
            <Plus size={20} /> Tambah Data Ibu Baru
          </Link>
        </div>

        {/* Table */}
        <div className="bg-white rounded-xl shadow-sm overflow-hidden">
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Nama Ibu</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Resiko</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Usia</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Kehamilan</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Kunjungan Terakhir</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Dusun</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status Gizi</th>
                  <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase">Aksi</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {loading ? (
                  <tr>
                    <td colSpan="9" className="p-6 text-center">
                      Memuat...
                    </td>
                  </tr>
                ) : currentItems.length === 0 ? (
                  <tr>
                    <td colSpan="9" className="p-6 text-center">
                      Tidak ada data
                    </td>
                  </tr>
                ) : (
                  currentItems.map((ibu) => (
                    <tr key={ibu.id_ibu} className="hover:bg-gray-50">
                      <td className="px-6 py-4">
                        <div className="font-medium text-gray-900">{ibu.kependudukan?.nama_lengkap || "-"}</div>
                        <div className="text-xs text-gray-500">ID: {ibu.id_ibu}</div>
                      </td>
                      <td className="px-6 py-4">
                        <span className={`px-2 py-1 text-xs rounded-full ${statusBadge(ibu.status_kehamilan)}`}>{ibu.status_kehamilan || "-"}</span>
                      </td>
                      <td className="px-6 py-4">
                        <span className={`px-2 py-1 text-xs rounded-full ${riskBadge(ibu.risiko_tinggi ? "TINGGI" : "RENDAH")}`}>{ibu.risiko_tinggi ? "TINGGI" : "RENDAH"}</span>
                      </td>
                      <td className="px-6 py-4 text-sm">{ibu.kependudukan?.tanggal_lahir ? hitungUsia(ibu.kependudukan.tanggal_lahir) + " Tahun" : "-"}</td>
                      <td className="px-6 py-4 text-sm">{ibu.status_kehamilan || "-"}</td>
                      <td className="px-6 py-4 text-sm">-</td>
                      <td className="px-6 py-4 text-sm">{ibu.kependudukan?.dusun || "-"}</td>
                      <td className="px-6 py-4 text-sm">-</td>
                      <td className="px-6 py-4 text-right">
                        <Link to={`/data-ibu/${ibu.id_ibu}`} className="text-indigo-600 hover:text-indigo-800 text-sm font-medium mr-2">
                          Detail
                        </Link>
                        <Link to={`/data-ibu/${ibu.id_ibu}/edit`} className="text-amber-600 hover:text-amber-800 text-sm font-medium">
                          Edit
                        </Link>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>

          {/* Pagination */}
          <div className="px-6 py-4 border-t flex justify-between items-center">
            <span className="text-sm text-gray-500">
              Menampilkan {currentItems.length} dari {filtered.length} data
            </span>
            <div className="flex gap-2">
              <button onClick={() => setCurrentPage((p) => Math.max(1, p - 1))} disabled={currentPage === 1} className="p-2 rounded-lg border disabled:opacity-50">
                <ChevronLeft size={16} />
              </button>
              <span className="px-2">
                Halaman {currentPage} dari {totalPages || 1}
              </span>
              <button onClick={() => setCurrentPage((p) => Math.min(totalPages, p + 1))} disabled={currentPage === totalPages} className="p-2 rounded-lg border disabled:opacity-50">
                <ChevronRight size={16} />
              </button>
            </div>
          </div>
        </div>
      </div>
    </MainLayout>
  );
}

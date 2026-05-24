// src/pages/Ibu/PemeriksaanKehamilanList.jsx
import React, { useEffect, useState } from "react";
import { useParams, useNavigate, Link } from "react-router-dom";
import MainLayout from "../../components/Layout/MainLayout";
import { getKehamilanByIbuId } from "../../services/kehamilan";
import { getPemeriksaanKehamilanByKehamilanId } from "../../services/pemeriksaanKehamilan";
import { Plus, ArrowLeft, Calendar, MapPin, ChevronRight } from "lucide-react";

export default function PemeriksaanKehamilanList() {
  const { id } = useParams(); // ID Ibu
  const navigate = useNavigate();
  const [kehamilan, setKehamilan] = useState(null);
  const [examinations, setExaminations] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const kehamilanList = await getKehamilanByIbuId(id);
        if (kehamilanList.length > 0) {
          const aktif = kehamilanList[0];
          setKehamilan(aktif);
          const data = await getPemeriksaanKehamilanByKehamilanId(aktif.id);
          // Sort by Kunjungan Ke
          setExaminations(data.sort((a, b) => a.kunjungan_ke - b.kunjungan_ke));
        }
      } catch (err) {
        console.error("Gagal memuat data pemeriksaan:", err);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, [id]);

  if (loading) return <MainLayout><div className="p-6 text-center">Memuat data...</div></MainLayout>;

  return (
    <MainLayout>
      <div className="p-6 max-w-5xl mx-auto">
        <div className="flex items-center justify-between mb-6">
          <div className="flex items-center gap-4">
            <button onClick={() => navigate(-1)} className="p-2 rounded-full hover:bg-gray-100">
              <ArrowLeft size={20} />
            </button>
            <div>
              <h1 className="text-2xl font-bold">Pemeriksaan Rutin (ANC)</h1>
              <p className="text-gray-500">Mencatat kunjungan K1 sampai K6 dan pemeriksaan rutin lainnya.</p>
            </div>
          </div>
          <Link 
            to={`/data-ibu/${id}/pemeriksaan-rutin/baru`}
            className="bg-indigo-600 text-white px-4 py-2 rounded-lg flex items-center gap-2 hover:bg-indigo-700 transition"
          >
            <Plus size={18} /> Tambah Pemeriksaan
          </Link>
        </div>

        {!kehamilan ? (
          <div className="bg-yellow-50 border border-yellow-200 p-6 rounded-xl text-center">
            <p className="text-yellow-700">Data kehamilan aktif tidak ditemukan. Pastikan data pendaftaran kehamilan sudah diisi.</p>
          </div>
        ) : examinations.length === 0 ? (
          <div className="bg-white border-2 border-dashed border-gray-200 p-12 rounded-xl text-center">
            <Calendar className="mx-auto text-gray-300 mb-4" size={48} />
            <h3 className="text-lg font-medium text-gray-900">Belum Ada Riwayat Pemeriksaan</h3>
            <p className="text-gray-500 mb-6">Klik tombol di atas untuk mencatat kunjungan pertama (ANC).</p>
            <Link 
              to={`/data-ibu/${id}/pemeriksaan-rutin/baru`}
              className="inline-flex items-center gap-2 text-indigo-600 font-semibold hover:underline"
            >
              Mulai mencatat sekarang <ChevronRight size={18} />
            </Link>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {examinations.map((exam) => (
              <div key={exam.id_periksa} className="bg-white rounded-xl shadow-sm border border-gray-100 hover:shadow-md transition-shadow p-5 flex flex-col justify-between">
                <div>
                  <div className="flex justify-between items-start mb-4">
                    <span className="bg-indigo-100 text-indigo-700 text-xs font-bold px-2.5 py-1 rounded-full uppercase">
                      Kunjungan {exam.kunjungan_ke}
                    </span>
                    <span className="text-xs text-gray-400 font-medium">{exam.trimester}</span>
                  </div>
                  
                  <div className="space-y-3 mb-6">
                    <div className="flex items-center gap-3 text-gray-600">
                      <Calendar size={16} className="text-indigo-400" />
                      <span className="text-sm font-medium">
                        {exam.tanggal_periksa ? new Date(exam.tanggal_periksa).toLocaleDateString("id-ID", { day: 'numeric', month: 'long', year: 'numeric' }) : "-"}
                      </span>
                    </div>
                    <div className="flex items-center gap-3 text-gray-600">
                      <MapPin size={16} className="text-indigo-400" />
                      <span className="text-sm truncate">{exam.tempat_periksa || "Lokasi tidak dicatat"}</span>
                    </div>
                  </div>

                  <div className="grid grid-cols-2 gap-4 border-t pt-4 border-gray-50">
                    <div>
                      <p className="text-[10px] text-gray-400 uppercase font-bold mb-0.5">Berat Badan</p>
                      <p className="text-sm font-bold text-gray-700">{exam.berat_badan || "-"} Kg</p>
                    </div>
                    <div>
                      <p className="text-[10px] text-gray-400 uppercase font-bold mb-0.5">Tekanan Darah</p>
                      <p className="text-sm font-bold text-gray-700">{exam.tekanan_darah || "-"}</p>
                    </div>
                  </div>
                </div>

                <Link 
                  to={`/data-ibu/${id}/pemeriksaan-rutin/${exam.id_periksa}`}
                  className="mt-6 w-full text-center py-2 text-sm font-semibold text-indigo-600 border border-indigo-100 rounded-lg hover:bg-indigo-50 transition"
                >
                  Lihat Detail / Edit
                </Link>
              </div>
            ))}
          </div>
        )}
      </div>
    </MainLayout>
  );
}

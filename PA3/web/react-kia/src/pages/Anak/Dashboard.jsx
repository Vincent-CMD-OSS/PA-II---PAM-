import React, { useState, useEffect } from "react";
import { useParams, Link } from "react-router-dom";
import MainLayout from "../../components/Layout/MainLayout";
import { getAnakById } from "../../services/Anak";
import { 
  XAxis, YAxis, CartesianGrid, Tooltip, 
  ResponsiveContainer, AreaChart, Area 
} from "recharts";

import { 
  ChevronLeft, Baby, Ruler, Activity, Calendar, User, 
  Plus, X, Apple, Syringe, TrendingUp, Smile
} from "lucide-react";

export default function AnakDashboard() {
  const { id } = useParams();
  const [child, setChild] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [isModalOpen, setIsModalOpen] = useState(false);

  useEffect(() => {
    const fetchDetailData = async () => {
      try {
        setLoading(true);
        const res = await getAnakById(id);
        setChild(res.data || res); 
      } catch (err) {
        setError("Gagal mengambil data anak.");
      } finally {
        setLoading(false);
      }
    };
    fetchDetailData();
  }, [id]);

  if (loading) return <MainLayout><div className="p-10 text-center font-medium text-gray-400">Memuat...</div></MainLayout>;
  if (error) return <MainLayout><div className="p-10 text-center text-red-500">{error}</div></MainLayout>;

  const growthData = child?.pertumbuhan || [];
  const isLaki = child?.jenis_kelamin?.toLowerCase() === "laki-laki";
  const themeColor = isLaki ? "#3b82f6" : "#ec4899";

  const menuInput = [
    { title: "Kesehatan Bayi", subtitle: "(0 - 28 Hari)", icon: <Baby size={32} />, link: `/data-anak/neonatus/${id}` },
    { title: "Gizi & Obat Cacing", icon: <Apple size={32} />, link: `/data-anak/pelayanan-gizi/${id}` },
    { title: "Imunisasi", icon: <Syringe size={32} />, link: `/data-anak/imunisasi/${id}`, active: true },
    { title: "Kesehatan Gigi", icon: <Smile size={32} />, link: `/data-anak/gigi/${id}` },
    { title: "Tumbuh Kembang", icon: <TrendingUp size={32} />, link: `/data-anak/tumbuh-kembang/${id}` },
    { title: "Pencatatan LILA", icon: <Ruler size={32} />, link: `/data-anak/lila/${id}` },
    { title: "Pertumbuhan", subtitle: "(0-2 Thn)", icon: <Smile size={32} />, link: `/data-anak/pertumbuhan-kecil/${id}` },
    { title: "Pertumbuhan", subtitle: "(2-5 Thn)", icon: <User size={32} />, link: `/data-anak/pertumbuhan-besar/${id}` },
  ];

  return (
    <MainLayout>
      {/* HEADER: Lebih rapat */}
      <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-6">
        <div>
          <Link to="/daftar-anak" className="flex items-center gap-1.5 text-xs text-gray-400 hover:text-indigo-600 mb-1 transition-all">
            <ChevronLeft size={14} /> Kembali
          </Link>
          <h1 className="text-2xl font-bold text-gray-800 tracking-tight">{child.nama}</h1>
        </div>
        <button 
          onClick={() => setIsModalOpen(true)}
          className="bg-indigo-600 hover:bg-indigo-700 text-white px-5 py-2.5 rounded-xl flex items-center gap-2 text-sm font-semibold shadow-md transition-all active:scale-95"
        >
          <Plus size={18} /> Input Data
        </button>
      </div>

      {/* STAT CARDS: Lebih ramping */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-3 mb-6">
        <StatCard icon={<Calendar size={20}/>} label="Usia" value={child.usia_teks || "-"} color="orange" />
        <StatCard icon={<User size={20}/>} label="Ibu" value={child.kehamilan?.ibu?.nama_ibu || "-"} color="indigo" />
        <StatCard icon={<Activity size={20}/>} label="BB" value={`${growthData[growthData.length-1]?.berat_badan || 0} kg`} color="green" />
        <StatCard icon={<Ruler size={20}/>} label="TB" value={`${growthData[growthData.length-1]?.tinggi_badan || 0} cm`} color="purple" />
      </div>

      {/* GRAFIK: Ukuran standar */}
      <div className="bg-white p-5 rounded-2xl border border-gray-100 shadow-sm h-[320px]">
        <h3 className="font-bold text-gray-700 text-sm mb-6 flex items-center gap-2">
            <div className={`w-1 h-4 rounded-full ${isLaki ? 'bg-blue-500' : 'bg-pink-500'}`}></div>
            Grafik Berat Badan
        </h3>
        <ResponsiveContainer width="100%" height="85%">
          <AreaChart data={growthData}>
            <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f3f4f6" />
            <XAxis dataKey="bulan" fontSize={11} tickMargin={8} axisLine={false} tickLine={false} />
            <YAxis fontSize={11} axisLine={false} tickLine={false} />
            <Tooltip contentStyle={{ borderRadius: '12px', border: 'none', fontSize: '12px', boxShadow: '0 4px 12px rgba(0,0,0,0.1)' }} />
            <Area type="monotone" dataKey="berat_badan" stroke={themeColor} fillOpacity={0.1} fill={themeColor} strokeWidth={3} />
          </AreaChart>
        </ResponsiveContainer>
      </div>

      {/* MODAL: Versi Ringkas (Compact) */}
     {isModalOpen && (
  <div className="fixed inset-0 z-[999] flex items-center justify-center p-6">
    {/* Overlay */}
    <div 
      className="absolute inset-0 bg-black/20 backdrop-blur-[2px]" 
      onClick={() => setIsModalOpen(false)}
    ></div>

    {/* Container Modal */}
    <div className="relative bg-[#F3F4F6] w-full max-w-lg rounded-[40px] p-8 shadow-2xl animate-in fade-in zoom-in duration-200">
      
      {/* Tombol Close (Opsional, di gambar tidak ada tapi bagus untuk UX) */}
      <button 
    onClick={() => setIsModalOpen(false)}
    className="absolute -top-0 -right-0    z-[1000] bg-white text-gray-800 p-2 rounded-full shadow-lg border border-gray-100 hover:bg-gray-50 transition-all active:scale-90"
  >
    <X size={20} strokeWidth={3} />
  </button>

      {/* Grid Menu */}
      <div className="grid grid-cols-2 gap-5">
        {menuInput.map((item, idx) => (
          <Link 
            key={idx} 
            to={item.link}
            className={`
              relative bg-white p-6 rounded-[28px] flex flex-col items-center text-center justify-center gap-3 
              transition-all duration-200 group shadow-sm hover:shadow-md active:scale-95
              ${item.active ? 'border-[3px] border-blue-400' : 'border-[3px] border-transparent'}
            `}
          >
            {/* Icon Box */}
            <div className="text-blue-600 transition-transform group-hover:scale-110">
              {item.icon}
            </div>

            {/* Text Box */}
            <div className="flex flex-col items-center">
              <span className="text-[15px] font-bold text-gray-900 leading-tight">
                {item.title}
              </span>
              {item.subtitle && (
                <span className="text-[14px] font-bold text-gray-900 mt-1">
                  {item.subtitle}
                </span>
              )}
            </div>
          </Link>
        ))}
      </div>
    </div>
  </div>
)}
    </MainLayout>
  );
}

function StatCard({ icon, label, value, color }) {
  const colors = {
    orange: "bg-orange-50 text-orange-500",
    indigo: "bg-indigo-50 text-indigo-500",
    green: "bg-green-50 text-green-500",
    purple: "bg-purple-50 text-purple-500",
  };
  return (
    <div className="bg-white p-3.5 rounded-xl border border-gray-100 flex items-center gap-3">
      <div className={`p-2 rounded-lg ${colors[color]}`}>{icon}</div>
      <div className="overflow-hidden">
        <p className="text-[10px] font-bold text-gray-400 uppercase tracking-tight">{label}</p>
        <p className="text-sm font-bold text-gray-800 truncate">{value}</p>
      </div>
    </div>
  );
}
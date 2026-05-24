// src/components/Layout/Header.jsx
import { useState, useRef, useEffect } from "react";
import { useLocation } from "react-router-dom";
import { LogOut, ChevronDown, User } from "lucide-react";
import { getCurrentUser, logout } from "../../services/auth";

const headerByPath = (pathname) => {
  if (pathname === "/dashboard" || pathname === "/dashboard/admin") {
    return {
      title: "Ringkasan Desa",
      subtitle: "Pantau kesehatan ibu dan anak secara menyeluruh di wilayah desa Anda.",
      variant: "hero",
    };
  }

  if (pathname.startsWith("/data-ibu")) {
    return {
      title: "Data Ibu",
      subtitle: "Kelola data ibu hamil, nifas, dan catatan pelayanan secara terpadu.",
      variant: "hero",
    };
  }

  if (pathname.startsWith("/daftar-anak") || pathname.startsWith("/data-anak")) {
    return {
      title: "Data Anak",
      subtitle: "Pantau pertumbuhan, pelayanan, dan riwayat kesehatan anak.",
      variant: "hero",
    };
  }

  if (pathname.startsWith("/kependudukan")) {
    return {
      title: "Manajemen Kartu Keluarga",
      subtitle: "Kelola data keluarga dan anggota penduduk di wilayah desa.",
      variant: "hero",
    };
  }

  if (pathname === "/monitoring") {
    return {
      title: "Monitoring Kesehatan",
      subtitle: "Lihat rekap wilayah, risiko tinggi, dan prioritas kunjungan lapangan.",
      variant: "hero",
    };
  }

  if (pathname === "/laporan") {
    return {
      title: "Laporan",
      subtitle: "Tinjau ringkasan program KIA dan capaian indikator layanan.",
      variant: "hero",
    };
  }

  if (pathname.startsWith("/dashboard/admin/tenaga-kesehatan")) {
    return {
      title: "Manajemen Bidan & Kader",
      subtitle: "Tetapkan penduduk sebagai bidan/kader, kelola profil, aktif-nonaktifkan status, dan buat akun login.",
      note: "Catatan: pilihan penduduk diambil dari dropdown penduduk eligible agar tidak perlu input ID manual.",
      variant: "hero",
    };
  }

  if (pathname.startsWith("/dashboard/admin/manajemen-keluarga")) {
    return {
      title: "Manajemen Profil Keluarga",
      subtitle: "Kelola data kartu keluarga dan detail anggota keluarga.",
      variant: "hero",
    };
  }

  if (pathname.startsWith("/dashboard/admin/akun-keluarga")) {
    return {
      title: "Pembuatan Akun Keluarga",
      subtitle: "Buat akun login keluarga secara langsung dari data kependudukan.",
      variant: "hero",
    };
  }

  if (pathname.startsWith("/dashboard/admin/jadwal-layanan")) {
    return {
      title: "Jadwal Layanan",
      subtitle: "Kelola daftar posyandu sebagai referensi jadwal layanan kesehatan.",
      variant: "hero",
    };
  }

  if (pathname.startsWith("/dashboard/admin/informasi-umum")) {
    return {
      title: "CRUD Edukasi",
      subtitle: "Kelola konten edukasi yang ditampilkan di aplikasi mobile.",
      variant: "hero",
    };
  }

  return {
    title: "KIA Cerdas",
    subtitle: "Sistem layanan kesehatan ibu dan anak untuk wilayah desa.",
    variant: "default",
  };
};

const formatRole = (role) => {
  const normalized = (role || "").toString().trim().toLowerCase();
  if (normalized === "admin") return "Admin";
  if (normalized === "bidan") return "Bidan";
  return "Petugas Medis";
};

const Header = () => {
  const user = getCurrentUser();
  const location = useLocation();
  const pageHeader = headerByPath(location.pathname);
  const [isDropdownOpen, setIsDropdownOpen] = useState(false);
  const dropdownRef = useRef(null);

  // Menutup dropdown saat klik di luar area profil
  useEffect(() => {
    const handleClickOutside = (event) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
        setIsDropdownOpen(false);
      }
    };
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  const handleLogout = () => {
    logout();
    window.location.href = "/login"; // Redirect ke login setelah logout
  };

  return (
    <header className="px-8 py-6 border-b border-gray-100 bg-white relative z-50">
      <div className="bg-gradient-to-r from-blue-700 via-cyan-600 to-teal-600 text-white rounded-2xl p-6 shadow-lg flex flex-col md:flex-row md:items-start justify-between gap-4">
        <div className="min-w-0">
          <h1 className="text-2xl md:text-3xl font-bold">{pageHeader.title}</h1>
          <p className="text-cyan-100 mt-2 text-sm md:text-base">{pageHeader.subtitle}</p>
          {pageHeader.note && (
            <p className="text-cyan-100 mt-2 text-xs md:text-sm">{pageHeader.note}</p>
          )}
        </div>

        <div className="relative md:flex-shrink-0" ref={dropdownRef}>
          <button
            onClick={() => setIsDropdownOpen(!isDropdownOpen)}
            className={`flex items-center gap-3 p-1.5 pr-3 rounded-2xl transition-all duration-200 border ${
              isDropdownOpen ? "bg-white/20 border-white/30" : "border-white/20 hover:bg-white/15"
            }`}
          >
            <div className="w-10 h-10 rounded-full bg-white/20 flex items-center justify-center text-white font-bold">
              {user?.name?.charAt(0) || "B"}
            </div>

            <div className="text-left hidden sm:block">
              <p className="text-xs font-bold text-white leading-none">{user?.name || "Bidan Desa"}</p>
              <p className="text-[10px] text-cyan-100 mt-1">{formatRole(user?.role)}</p>
            </div>

            <ChevronDown
              size={16}
              className={`text-cyan-100 transition-transform duration-200 ${isDropdownOpen ? "rotate-180" : ""}`}
            />
          </button>

          {isDropdownOpen && (
            <div className="absolute right-0 mt-2 w-52 bg-white rounded-2xl shadow-xl border border-slate-100 py-2 animate-in fade-in zoom-in duration-200 origin-top-right">
              <div className="px-4 py-2 border-b border-slate-50 mb-1">
                <p className="text-xs text-slate-400">Masuk sebagai</p>
                <p className="text-sm font-semibold text-slate-800 truncate">{user?.email || "admin@kia.com"}</p>
              </div>

              <button className="w-full flex items-center gap-3 px-4 py-2.5 text-sm text-slate-600 hover:bg-slate-50 transition-colors">
                <User size={18} className="text-slate-400" />
                <span>Profil Saya</span>
              </button>

              <button
                onClick={handleLogout}
                className="w-full flex items-center gap-3 px-4 py-2.5 text-sm text-red-500 hover:bg-red-50 transition-colors"
              >
                <LogOut size={18} />
                <span className="font-medium">Keluar</span>
              </button>
            </div>
          )}
        </div>
      </div>
    </header>
  );
};

export default Header;
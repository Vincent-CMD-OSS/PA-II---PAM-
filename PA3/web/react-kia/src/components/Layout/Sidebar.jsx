// src/components/Layout/Sidebar.jsx
import { useMemo, useState } from "react";
import { NavLink } from "react-router-dom";
import { getCurrentUser, getUserRedirectRoute, isAdminUser } from "../../services/auth";
import {
  ChevronDown,
  LayoutGrid, 
  Users, 
  Baby, 
  Activity, 
  BarChart3, 
  Settings, 
  ShieldPlus,
  UserCheck,
  UserPlus,
  BriefcaseMedical,
  CalendarDays,
  BookOpen
} from "lucide-react";

const Sidebar = () => {
  const user = getCurrentUser();
  const isAdmin = isAdminUser(user);
  const dashboardPath = getUserRedirectRoute(user);
  const [isFamilyMenuOpen, setIsFamilyMenuOpen] = useState(false);

  const bidanMenuItems = [
    { path: "/data-ibu", name: "Data Ibu", icon: Users },
    { path: "/daftar-anak", name: "Data Anak", icon: Baby },
    { path: "/dashboard/admin/informasi-umum", name: "Edukasi", icon: BookOpen },
    { path: "/kependudukan", name: "Manajemen KK", icon: UserCheck },
    { path: "/monitoring", name: "Monitoring", icon: Activity },
    { path: "/laporan", name: "Laporan", icon: BarChart3 },
  ];

  const adminFamilyMenuItems = useMemo(
    () => [
      { path: "/dashboard/admin/manajemen-keluarga", name: "Manajemen KK", icon: UserCheck },
      { path: "/dashboard/admin/akun-keluarga", name: "Buat Akun", icon: UserPlus },
    ],
    []
  );

  const adminContentMenuItems = useMemo(
    () => [
      { path: "/dashboard/admin/informasi-umum", name: "Informasi Umum", icon: Activity },
    ],
    []
  );

  const menuItems = [
    { path: dashboardPath, name: "Dashboard", icon: LayoutGrid },
    ...(isAdmin ? [] : bidanMenuItems),
  ];

  const settingsMenu = { path: "/pengaturan", name: "Pengaturan", icon: Settings };

  return (
    <aside className="w-72 h-screen bg-white border-r border-gray-100 flex flex-col p-6">
      {/* Header Logo */}
      <div className="flex items-center gap-3 mb-10">
        <div className="bg-blue-600 p-2 rounded-xl text-white shadow-lg shadow-blue-100">
          <ShieldPlus size={28} />
        </div>
        <div>
          <h1 className="text-lg font-bold text-slate-800 leading-tight">KIA Cerdas</h1>
          <p className="text-xs text-slate-400">Dashboard </p>
        </div>
      </div>

      <p className="text-[10px] font-bold text-slate-400 uppercase tracking-widest mb-4 ml-2">
        Menu utama
      </p>

      {/* Navigasi */}
      <nav className="flex-1 space-y-1 overflow-y-auto pr-2 custom-scrollbar">
        {menuItems.map((item) => (
          <NavLink
            key={item.path}
            to={item.path}
            className={({ isActive }) =>
              `flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 group ${
                isActive 
                  ? "bg-blue-50 text-blue-600 font-semibold" 
                  : "text-slate-500 hover:bg-gray-50 hover:text-slate-700"
              }`
            }
          >
            {({ isActive }) => (
              <>
                <item.icon 
                  size={20} 
                  className={isActive ? "text-blue-600" : "text-slate-400 group-hover:text-slate-600"} 
                />
                <span className="truncate">{item.name}</span>
              </>
            )}
          </NavLink>
        ))}

        {isAdmin && (
          <div className="pt-2">
            <NavLink
              to="/dashboard/admin/tenaga-kesehatan"
              className={({ isActive }) =>
                `flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 group ${
                  isActive
                    ? "bg-blue-50 text-blue-600 font-semibold"
                    : "text-slate-500 hover:bg-gray-50 hover:text-slate-700"
                }`
              }
            >
              {({ isActive }) => (
                <>
                  <BriefcaseMedical
                    size={20}
                    className={isActive ? "text-blue-600" : "text-slate-400 group-hover:text-slate-600"}
                  />
                  <span className="truncate">Mengelola Profile Bidan & Kader</span>
                </>
              )}
            </NavLink>

           

            <button
              type="button"
              onClick={() => setIsFamilyMenuOpen((prev) => !prev)}
              className="w-full flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 text-slate-500 hover:bg-gray-50 hover:text-slate-700"
            >
              <UserCheck size={20} className="text-slate-400" />
              <span className="flex-1 text-left truncate">Mengelola Profile Keluarga</span>
              <ChevronDown
                size={16}
                className={`transition-transform duration-200 ${isFamilyMenuOpen ? "rotate-180" : "rotate-0"}`}
              />
            </button>

            {isFamilyMenuOpen && (
              <div className="mt-1 space-y-1 pl-5 border-l border-slate-200 ml-5">
                {adminFamilyMenuItems.map((item) => (
                  <NavLink
                    key={item.path}
                    to={item.path}
                    className={({ isActive }) =>
                      `flex items-center gap-3 px-3 py-2 rounded-lg transition-all duration-200 group text-sm ${
                        isActive
                          ? "bg-blue-50 text-blue-600 font-semibold"
                          : "text-slate-500 hover:bg-gray-50 hover:text-slate-700"
                      }`
                    }
                  >
                    {({ isActive }) => (
                      <>
                        <item.icon
                          size={16}
                          className={isActive ? "text-blue-600" : "text-slate-400 group-hover:text-slate-600"}
                        />
                        <span className="truncate">{item.name}</span>
                      </>
                    )}
                  </NavLink>
                ))}
              </div>
            )}

            <div className="pt-2">
              <p className="px-4 pb-2 text-[10px] font-bold uppercase tracking-widest text-slate-400">Konten Edukasi</p>
              {adminContentMenuItems.map((item) => (
                <NavLink
                  key={item.path}
                  to={item.path}
                  className={({ isActive }) =>
                    `flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 group ${
                      isActive
                        ? "bg-blue-50 text-blue-600 font-semibold"
                        : "text-slate-500 hover:bg-gray-50 hover:text-slate-700"
                    }`
                  }
                >
                  {({ isActive }) => (
                    <>
                      <item.icon
                        size={20}
                        className={isActive ? "text-blue-600" : "text-slate-400 group-hover:text-slate-600"}
                      />
                      <span className="truncate">{item.name}</span>
                    </>
                  )}
                </NavLink>
              ))}
            </div>
          </div>
        )}

         <NavLink
              to="/dashboard/admin/jadwal-layanan"
              className={({ isActive }) =>
                `flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 group ${
                  isActive
                    ? "bg-blue-50 text-blue-600 font-semibold"
                    : "text-slate-500 hover:bg-gray-50 hover:text-slate-700"
                }`
              }
            >
              {({ isActive }) => (
                <>
                  <CalendarDays
                    size={20}
                    className={isActive ? "text-blue-600" : "text-slate-400 group-hover:text-slate-600"}
                  />
                  <span className="truncate">Jadwal Layanan</span>
                </>
              )}
            </NavLink>

        <NavLink
          key={settingsMenu.path}
          to={settingsMenu.path}
          className={({ isActive }) =>
            `flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 group ${
              isActive
                ? "bg-blue-50 text-blue-600 font-semibold"
                : "text-slate-500 hover:bg-gray-50 hover:text-slate-700"
            }`
          }
        >
          {({ isActive }) => (
            <>
              <settingsMenu.icon
                size={20}
                className={isActive ? "text-blue-600" : "text-slate-400 group-hover:text-slate-600"}
              />
              <span className="truncate">{settingsMenu.name}</span>
            </>
          )}
        </NavLink>
      </nav>

      {/* Footer Info Wilayah */}
      <div className="mt-auto pt-6">
        <div className="bg-slate-50 rounded-2xl p-4 border border-slate-100">
          <h4 className="text-sm font-bold text-slate-800">Wilayah aktif</h4>
          <p className="text-[11px] text-slate-500 mt-1 leading-relaxed">
            Desa Suka Maju · 4 posyandu aktif · sinkron terakhir 08.10 WIB
          </p>
        </div>
      </div>
    </aside>
  );
};

export default Sidebar;
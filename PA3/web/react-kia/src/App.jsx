// src/App.jsx
import React from "react";
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";

import Dashboard from "./pages/Dashboard";
import PrivateRoute from "./routes/Private-routes";
import AdminRoute from "./routes/AdminRoute";
import AdminAkunKeluargaCreate from "./pages/Admin/AkunKeluargaCreate";
import AkunKeluargaManagement from "./pages/Admin/AkunKeluargaManagement";
import TenagaKesehatanManagement from "./pages/Admin/TenagaKesehatanManagement";
import JadwalLayanan from "./pages/Admin/JadwalLayanan";
import InformasiUmumList from "./pages/InformasiUmum/InformasiUmumList";
import InformasiUmumForm from "./pages/InformasiUmum/InformasiUmumForm";

// Data Ibu
import IbuList from "./pages/Ibu/IbuList";
import IbuDetail from "./pages/Ibu/IbuDetail";
import IbuEdit from "./pages/Ibu/IbuEdit";
import SkriningPreeklampsia from "./pages/Ibu/SkriningPreeklampsia";
import PemeriksaanFisik from "./pages/Ibu/PemeriksaanFisik";
import GrafikEvaluasiKehamilan from "./pages/Ibu/GrafikEvaluasiKehamilan";
import GrafikPeningkatanBB from "./pages/Ibu/GrafikPeningkatanBB";
import RencanaPersalinan from "./pages/Ibu/RencanaPersalinan";
import PelayananNifas from "./pages/Ibu/PelayananNifas";
import EvaluasiKesehatanIbu from "./pages/Ibu/EvaluasiKesehatanIbu";
import PemeriksaanDokterT1 from "./pages/Ibu/PemeriksaanDokterT1";
import PemeriksaanLabJiwa from "./pages/Ibu/PemeriksaanLabJiwa";
import CatatanPelayanan from "./pages/Ibu/CatatanPelayanan";
import PemeriksaanDokterT3 from "./pages/Ibu/PemeriksaanDokterT3";
import PemeriksaanLanjutanT3 from "./pages/Ibu/PemeriksaanLanjutanT3";
import RujukanPage from "./pages/Ibu/Rujukan";
import SkriningDMGestasional from "./pages/Ibu/SkriningDMGestasional";
import PelayananPersalinan from "./pages/Ibu/PelayananPersalinan";
import PemeriksaanKehamilanList from "./pages/Ibu/PemeriksaanKehamilanList";
import PemeriksaanKehamilanForm from "./pages/Ibu/PemeriksaanKehamilanForm";
import RujukanDashboard from "./pages/Ibu/RujukanDashboard";

// Data Anak (sudah ada)
import AnakListNakes from "./pages/Anak";
import CreateAnak from "./pages/Anak/create";
import EditAnak from "./pages/Anak/edit";
import DetailAnak from "./pages/Anak/detail";
// Monitoring & Laporan
import Monitoring from "./pages/Monitoring";
import Laporan from "./pages/Laporan";
import IbuCreate from "./pages/Ibu/IbuCreate";
import KependudukanList from "./pages/Kependudukan/KependudukanList";
import KependudukanCreate from "./pages/Kependudukan/KependudukanCreate";
import KependudukanEdit from "./pages/Kependudukan/KependudukanEdit";

import AnakDashboard from "./pages/Anak/Dashboard"
import PelayananGiziIndex from "./pages/Pelayanan-Gizi-Anak/index"
// import PrivateRoute from "./routes/Private-routes";
import NeonatusIndex from "./pages/Kesehatan-Neonatus/NeonatusIndex"
import PelayananGiziCreate from "./pages/Pelayanan-Gizi-Anak/create";


const HomeRedirect = () => {
  return <Navigate to="/dashboard" replace />;
};

function App() {
  return (
    <BrowserRouter>
      <Routes>
        {/* PUBLIC */}
        <Route path="/login" element={<Navigate to="/dashboard" replace />} />

        {/* PROTECTED */}
        <Route element={<PrivateRoute />}>
          <Route path="/dashboard" element={<Dashboard />} />
          {/* // tambahkan route */}
          <Route path="/kependudukan" element={<KependudukanList />} />
          <Route path="/kependudukan/create" element={<KependudukanCreate />} />
          <Route path="/kependudukan/edit/:id" element={<KependudukanEdit />} />
          {/* Data Ibu */}
          <Route path="/data-ibu/create" element={<IbuCreate />} />
          <Route path="/data-ibu" element={<IbuList />} />
          <Route path="/data-ibu/:id" element={<IbuDetail />} />
          <Route path="/data-ibu/:id/edit" element={<IbuEdit />} />
          <Route path="/data-ibu/:id/skrining-preeklampsia" element={<SkriningPreeklampsia />} />
          <Route path="/data-ibu/:id/pemeriksaan-fisik" element={<PemeriksaanFisik />} />
          <Route path="/data-ibu/:id/grafik-evaluasi" element={<GrafikEvaluasiKehamilan />} />
          <Route path="/data-ibu/:id/grafik-bb" element={<GrafikPeningkatanBB />} />
          <Route path="/data-ibu/:id/rencana-persalinan" element={<RencanaPersalinan />} />
          <Route path="/data-ibu/:id/pelayanan-nifas" element={<PelayananNifas />} />
          <Route path="/data-ibu/:id/evaluasi-kesehatan" element={<EvaluasiKesehatanIbu />} />
          <Route path="/data-ibu/:id/pemeriksaan-dokter-t1" element={<PemeriksaanDokterT1 />} />
          <Route path="/data-ibu/:id/pemeriksaan-lab-jiwa" element={<PemeriksaanLabJiwa />} />
          <Route path="/data-ibu/:id/catatan-pelayanan" element={<CatatanPelayanan />} />
          <Route path="/data-ibu/:id/pemeriksaan-dokter-t3" element={<PemeriksaanDokterT3 />} />
          <Route path="/data-ibu/:id/pemeriksaan-lanjutan-t3" element={<PemeriksaanLanjutanT3 />} />
          <Route path="/data-ibu/:id/rujukan" element={<RujukanPage />} />
          <Route path="/data-ibu/:id/skrining-dm-gestasional" element={<SkriningDMGestasional />} />
          <Route path="/data-ibu/:id/pelayanan-persalinan" element={<PelayananPersalinan />} />
          <Route path="/data-ibu/:id/pemeriksaan-rutin" element={<PemeriksaanKehamilanList />} />
          <Route path="/data-ibu/:id/pemeriksaan-rutin/:periksaId" element={<PemeriksaanKehamilanForm />} />
          <Route path="/daftar-rujukan" element={<RujukanDashboard />} />
          

          {/* Data Anak (sudah ada) */}
          <Route path="/daftar-anak" element={<AnakListNakes />} />
          <Route path="/data-anak/create" element={<CreateAnak />} />
          <Route path="/data-anak/edit/:id" element={<EditAnak />} />
          <Route path="/data-anak/:id" element={<DetailAnak />} />

          {/* Monitoring & Laporan */}
          <Route path="/monitoring" element={<Monitoring />} />
          <Route path="/laporan" element={<Laporan />} />
        </Route>

        <Route element={<AdminRoute />}>
          <Route path="/dashboard/admin" element={<Dashboard />} />
          <Route path="/dashboard/admin/akun-keluarga" element={<AdminAkunKeluargaCreate />} />
          <Route path="/dashboard/admin/manajemen-keluarga" element={<AkunKeluargaManagement />} />
          <Route path="/dashboard/admin/tenaga-kesehatan" element={<TenagaKesehatanManagement />} />
          <Route path="/dashboard/admin/jadwal-layanan" element={<JadwalLayanan />} />
          <Route path="/dashboard/admin/informasi-umum" element={<InformasiUmumList />} />
          <Route path="/dashboard/admin/informasi-umum/create" element={<InformasiUmumForm />} />
          <Route path="/dashboard/admin/informasi-umum/edit/:id" element={<InformasiUmumForm />} />
        </Route>

          <Route path="/data-anak/dashboard/:id" element= {<AnakDashboard/>} />
          <Route path="/data-anak/neonatus/:id" element= {<NeonatusIndex/>} />    

          <Route path="/data-anak/pelayanan-gizi/:id" element= {<PelayananGiziIndex/>}></Route>
          <Route path="/data-anak/pelayanan-gizi/:id/create" element={<PelayananGiziCreate/>}></Route>
        

        <Route path="/" element={<HomeRedirect />} />
        <Route path="*" element={<HomeRedirect />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
// src/pages/Laporan.jsx
import React, { useState } from "react";
import MainLayout from "../components/Layout/MainLayout";
import { exportLaporanIbu, exportLaporanAnak } from "../services/laporan";
import { FileDown, Download } from "lucide-react";

export default function Laporan() {
  const [loadingIbu, setLoadingIbu] = useState(false);
  const [loadingAnak, setLoadingAnak] = useState(false);

  const handleExport = async (type) => {
    try {
      if (type === "ibu") {
        setLoadingIbu(true);
        const blob = await exportLaporanIbu();
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement("a");
        a.href = url;
        a.download = "laporan_data_ibu.xlsx";
        a.click();
        window.URL.revokeObjectURL(url);
      } else {
        setLoadingAnak(true);
        const blob = await exportLaporanAnak();
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement("a");
        a.href = url;
        a.download = "laporan_data_anak.xlsx";
        a.click();
        window.URL.revokeObjectURL(url);
      }
    } catch (err) {
      alert("Gagal mengekspor laporan");
    } finally {
      if (type === "ibu") setLoadingIbu(false);
      else setLoadingAnak(false);
    }
  };

  return (
    <MainLayout>
      <div className="p-6 max-w-4xl mx-auto">
        <h1 className="text-2xl font-bold mb-6">Laporan</h1>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div className="bg-white rounded-xl shadow-sm p-6 text-center">
            <FileDown size={48} className="mx-auto text-indigo-600 mb-4" />
            <h2 className="text-xl font-semibold mb-2">Laporan Data Ibu</h2>
            <p className="text-gray-500 mb-4">Ekspor data ibu hamil beserta detail kehamilan</p>
            <button onClick={() => handleExport("ibu")} disabled={loadingIbu} className="bg-indigo-600 text-white px-4 py-2 rounded-lg flex items-center justify-center gap-2 w-full">
              <Download size={18} /> {loadingIbu ? "Memproses..." : "Ekspor Laporan Ibu"}
            </button>
          </div>
          <div className="bg-white rounded-xl shadow-sm p-6 text-center">
            <FileDown size={48} className="mx-auto text-green-600 mb-4" />
            <h2 className="text-xl font-semibold mb-2">Laporan Data Anak</h2>
            <p className="text-gray-500 mb-4">Ekspor data anak beserta riwayat kesehatan</p>
            <button onClick={() => handleExport("anak")} disabled={loadingAnak} className="bg-green-600 text-white px-4 py-2 rounded-lg flex items-center justify-center gap-2 w-full">
              <Download size={18} /> {loadingAnak ? "Memproses..." : "Ekspor Laporan Anak"}
            </button>
          </div>
        </div>
      </div>
    </MainLayout>
  );
}
import React, { useEffect, useState } from "react";
import { CalendarDays, Loader2, Plus, RefreshCw } from "lucide-react";
import MainLayout from "../../components/Layout/MainLayout";
import {
  adminTenagaErrorMessage,
  createPosyanduAdmin,
  listPosyanduAdmin,
} from "../../services/adminTenagaKesehatan";

const cardClass = "bg-white rounded-2xl shadow-sm border border-slate-100";

const JadwalLayanan = () => {
  const [search, setSearch] = useState("");
  const [posyanduList, setPosyanduList] = useState([]);
  const [namaPosyandu, setNamaPosyandu] = useState("");
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [errorMessage, setErrorMessage] = useState("");
  const [successMessage, setSuccessMessage] = useState("");

  const resetNotice = () => {
    setErrorMessage("");
    setSuccessMessage("");
  };

  const loadPosyandu = async (searchValue = "") => {
    setLoading(true);
    try {
      const response = await listPosyanduAdmin({ search: searchValue });
      setPosyanduList(Array.isArray(response?.data) ? response.data : []);
    } catch (error) {
      setErrorMessage(adminTenagaErrorMessage(error, "Gagal memuat daftar posyandu"));
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadPosyandu();
  }, []);

  const handleSearch = async (e) => {
    e.preventDefault();
    resetNotice();
    await loadPosyandu(search.trim());
  };

  const handleCreate = async (e) => {
    e.preventDefault();
    resetNotice();

    const nama = namaPosyandu.trim();
    if (!nama) {
      setErrorMessage("Nama posyandu wajib diisi");
      return;
    }

    setSaving(true);
    try {
      await createPosyanduAdmin({ nama });
      setNamaPosyandu("");
      await loadPosyandu(search.trim());
      setSuccessMessage("Data posyandu berhasil ditambahkan");
    } catch (error) {
      setErrorMessage(adminTenagaErrorMessage(error, "Gagal menambahkan posyandu"));
    } finally {
      setSaving(false);
    }
  };

  return (
    <MainLayout>
      <div className="space-y-6">
        {errorMessage && <div className="rounded-xl bg-red-50 border border-red-200 px-4 py-3 text-red-700 text-sm">{errorMessage}</div>}
        {successMessage && <div className="rounded-xl bg-emerald-50 border border-emerald-200 px-4 py-3 text-emerald-700 text-sm">{successMessage}</div>}

        <section className={`${cardClass} p-5`}>
          <h2 className="text-lg font-semibold text-slate-800">Tambah Posyandu</h2>
          <p className="text-sm text-slate-500 mt-1">Data posyandu ini dipakai sebagai referensi jadwal layanan.</p>

          <form onSubmit={handleCreate} className="mt-4 flex flex-col md:flex-row gap-3">
            <input
              type="text"
              value={namaPosyandu}
              onChange={(e) => setNamaPosyandu(e.target.value)}
              placeholder="Contoh: Posyandu Mawar 1"
              className="w-full rounded-xl border border-slate-200 px-3 py-2"
            />
            <button
              type="submit"
              disabled={saving}
              className="inline-flex items-center justify-center gap-2 rounded-xl bg-blue-600 text-white px-4 py-2 hover:bg-blue-700 disabled:opacity-60"
            >
              <Plus size={16} />
              {saving ? "Menyimpan..." : "Tambah"}
            </button>
          </form>
        </section>

        <section className={`${cardClass} p-5`}>
          <div className="flex flex-col md:flex-row md:items-end gap-3 md:justify-between">
            <div className="w-full md:max-w-md">
              <label className="text-sm text-slate-600">Cari Posyandu</label>
              <form onSubmit={handleSearch} className="mt-1 flex gap-2">
                <input
                  type="text"
                  value={search}
                  onChange={(e) => setSearch(e.target.value)}
                  placeholder="Ketik nama posyandu"
                  className="w-full rounded-xl border border-slate-200 px-3 py-2"
                />
                <button
                  type="submit"
                  className="rounded-xl bg-slate-100 text-slate-700 px-4 py-2 hover:bg-slate-200"
                >
                  Cari
                </button>
              </form>
            </div>

            <button
              type="button"
              onClick={() => loadPosyandu(search.trim())}
              className="inline-flex items-center gap-2 rounded-xl bg-slate-100 text-slate-700 px-4 py-2 hover:bg-slate-200"
            >
              <RefreshCw size={16} />
              Muat Ulang
            </button>
          </div>

          <div className="mt-4 rounded-2xl border border-slate-200 overflow-hidden">
            <table className="min-w-full text-sm">
              <thead className="bg-slate-50 text-slate-600">
                <tr>
                  <th className="text-left px-4 py-3 font-semibold w-24">ID</th>
                  <th className="text-left px-4 py-3 font-semibold">Nama Posyandu</th>
                  <th className="text-left px-4 py-3 font-semibold w-40">Kategori</th>
                </tr>
              </thead>
              <tbody>
                {loading ? (
                  <tr>
                    <td className="px-4 py-8 text-slate-500" colSpan={3}>
                      <div className="flex items-center gap-2">
                        <Loader2 size={16} className="animate-spin" />
                        Memuat data...
                      </div>
                    </td>
                  </tr>
                ) : posyanduList.length === 0 ? (
                  <tr>
                    <td className="px-4 py-8 text-slate-500" colSpan={3}>
                      Belum ada data posyandu.
                    </td>
                  </tr>
                ) : (
                  posyanduList.map((item) => (
                    <tr key={item.id} className="border-t border-slate-100">
                      <td className="px-4 py-3 text-slate-700">{item.id}</td>
                      <td className="px-4 py-3 text-slate-800 font-medium">{item.nama || "-"}</td>
                      <td className="px-4 py-3 text-slate-600">
                        <span className="inline-flex items-center gap-1 rounded-full bg-blue-50 text-blue-700 px-2 py-1 text-xs">
                          <CalendarDays size={12} />
                          Jadwal Layanan
                        </span>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </section>
      </div>
    </MainLayout>
  );
};

export default JadwalLayanan;

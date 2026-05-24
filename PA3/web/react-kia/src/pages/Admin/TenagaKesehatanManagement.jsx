import React, { useEffect, useState } from "react";
import { Loader2, Save, X } from "lucide-react";
import MainLayout from "../../components/Layout/MainLayout";
import {
  adminTenagaErrorMessage,
  createBidanAdmin,
  createKaderAdmin,
  listEligiblePendudukAdmin,
  listPosyanduAdmin,
  listBidanAdmin,
  listKaderAdmin,
  updateBidanAdmin,
  updateKaderAdmin,
} from "../../services/adminTenagaKesehatan";

const cardClass = "bg-white rounded-2xl shadow-sm border border-slate-100";

const emptyBidanForm = {
  penduduk_id: "",
  no_str: "",
  no_sipb: "",
  status: "aktif",
};

const emptyKaderForm = {
  penduduk_id: "",
  posyandu_id: "",
  status: "aktif",
};

const toNullableInt = (value) => {
  const parsed = Number(value);
  return Number.isFinite(parsed) && parsed > 0 ? parsed : null;
};

const toInt = (value) => {
  const parsed = Number(value);
  return Number.isFinite(parsed) && parsed > 0 ? parsed : 0;
};

const formatPendudukLabel = (item) => {
  if (!item) return "";
  return `${item.nama_lengkap} - ${item.nik}${item.desa ? ` (${item.desa})` : ""}`;
};

const formatPosyanduLabel = (item) => {
  if (!item) return "";
  return item.nama || "";
};

const getStatusColor = (status) => {
  if (status === "aktif") return "bg-emerald-100 text-emerald-800";
  return "bg-slate-100 text-slate-700";
};

const LookupField = ({
  label,
  placeholder,
  value,
  onChange,
  options,
  loading,
  emptyText,
  selectedLabel,
  onClear,
  onPick,
  renderOptionLabel,
  renderOptionMeta,
}) => {
  const hasQuery = value.trim().length > 0;

  return (
    <div className="space-y-2">
      <div>
        <label className="text-sm font-medium text-slate-700">{label}</label>
        <input
          className="mt-2 rounded-xl border border-slate-200 px-3 py-2 w-full"
          placeholder={placeholder}
          value={value}
          onChange={(e) => onChange(e.target.value)}
        />
      </div>

      {selectedLabel && (
        <div className="flex flex-wrap items-center gap-2 rounded-xl border border-blue-100 bg-blue-50 px-3 py-2 text-sm text-blue-700">
          <span className="font-medium">Terpilih:</span>
          <span className="truncate">{selectedLabel}</span>
          <button type="button" className="ml-auto text-blue-600 hover:text-blue-800" onClick={onClear}>
            Hapus
          </button>
        </div>
      )}

      {hasQuery && (
        <div className="rounded-xl border border-slate-200 bg-white shadow-sm overflow-hidden">
          <div className="px-3 py-2 border-b border-slate-100 text-xs font-medium text-slate-500">
            Pilih dari hasil pencarian di bawah
          </div>
          <div className="max-h-56 overflow-y-auto">
            {loading ? (
              <div className="px-3 py-4 text-sm text-slate-500">Memuat hasil...</div>
            ) : options.length > 0 ? (
              options.map((item) => (
                <button
                  key={item.id}
                  type="button"
                  onClick={() => onPick(item)}
                  className="w-full text-left px-3 py-3 border-b border-slate-100 last:border-b-0 hover:bg-slate-50"
                >
                  <div className="text-sm font-medium text-slate-800">{renderOptionLabel(item)}</div>
                  <div className="text-xs text-slate-500 mt-1">{renderOptionMeta(item)}</div>
                </button>
              ))
            ) : (
              <div className="px-3 py-4 text-sm text-slate-500">{emptyText}</div>
            )}
          </div>
        </div>
      )}
    </div>
  );
};

const TenagaKesehatanManagement = () => {
  const [activeTab, setActiveTab] = useState("bidan");
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [errorMessage, setErrorMessage] = useState("");
  const [successMessage, setSuccessMessage] = useState("");

  const [bidanList, setBidanList] = useState([]);
  const [kaderList, setKaderList] = useState([]);
  const [eligibleBidan, setEligibleBidan] = useState([]);
  const [eligibleKader, setEligibleKader] = useState([]);
  const [posyanduList, setPosyanduList] = useState([]);

  const [bidanSearch, setBidanSearch] = useState("");
  const [kaderSearch, setKaderSearch] = useState("");
  const [posyanduSearch, setPosyanduSearch] = useState("");

  const [bidanForm, setBidanForm] = useState(emptyBidanForm);
  const [kaderForm, setKaderForm] = useState(emptyKaderForm);

  const [editingBidanId, setEditingBidanId] = useState(null);
  const [editingKaderId, setEditingKaderId] = useState(null);
  const [bidanEdit, setBidanEdit] = useState({ no_str: "", no_sipb: "", status: "aktif" });
  const [kaderEdit, setKaderEdit] = useState({ posyandu_id: "", status: "aktif" });

  const resetNotice = () => {
    setErrorMessage("");
    setSuccessMessage("");
  };

  const loadBidan = async () => {
    const response = await listBidanAdmin();
    setBidanList(Array.isArray(response?.data) ? response.data : []);
  };

  const loadKader = async () => {
    const response = await listKaderAdmin();
    setKaderList(Array.isArray(response?.data) ? response.data : []);
  };

  const loadEligiblePenduduk = async (role, search = "") => {
    const response = await listEligiblePendudukAdmin({ role, search });
    return Array.isArray(response?.data) ? response.data : [];
  };

  const loadPosyandu = async (search = "") => {
    const response = await listPosyanduAdmin({ search });
    return Array.isArray(response?.data) ? response.data : [];
  };

  const selectedBidan = eligibleBidan.find((item) => String(item.id) === String(bidanForm.penduduk_id));
  const selectedKader = eligibleKader.find((item) => String(item.id) === String(kaderForm.penduduk_id));
  const selectedPosyandu = posyanduList.find((item) => String(item.id) === String(kaderForm.posyandu_id));

  const handleBidanQueryChange = (value) => {
    setBidanSearch(value);
    setBidanForm((prev) => ({ ...prev, penduduk_id: "" }));
  };

  const handleKaderQueryChange = (value) => {
    setKaderSearch(value);
    setKaderForm((prev) => ({ ...prev, penduduk_id: "" }));
  };

  const handlePosyanduQueryChange = (value) => {
    setPosyanduSearch(value);
    setKaderForm((prev) => ({ ...prev, posyandu_id: "" }));
  };

  const pickBidan = (item) => {
    setBidanForm((prev) => ({ ...prev, penduduk_id: String(item.id) }));
    setBidanSearch(formatPendudukLabel(item));
  };

  const pickKader = (item) => {
    setKaderForm((prev) => ({ ...prev, penduduk_id: String(item.id) }));
    setKaderSearch(formatPendudukLabel(item));
  };

  const pickPosyandu = (item) => {
    setKaderForm((prev) => ({ ...prev, posyandu_id: String(item.id) }));
    setPosyanduSearch(formatPosyanduLabel(item));
  };

  const clearBidanSelection = () => {
    setBidanForm((prev) => ({ ...prev, penduduk_id: "" }));
    setBidanSearch("");
  };

  const clearKaderSelection = () => {
    setKaderForm((prev) => ({ ...prev, penduduk_id: "" }));
    setKaderSearch("");
  };

  const clearPosyanduSelection = () => {
    setKaderForm((prev) => ({ ...prev, posyandu_id: "" }));
    setPosyanduSearch("");
  };

  const reloadByTab = async (tab = activeTab) => {
    setLoading(true);
    try {
      if (tab === "bidan") {
        await loadBidan();
        setEligibleBidan(await loadEligiblePenduduk("bidan", bidanSearch));
      } else {
        await loadKader();
        setEligibleKader(await loadEligiblePenduduk("kader", kaderSearch));
        setPosyanduList(await loadPosyandu(posyanduSearch));
      }
    } catch (error) {
      setErrorMessage(adminTenagaErrorMessage(error, "Gagal memuat data tenaga kesehatan"));
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    reloadByTab(activeTab);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [activeTab]);

  useEffect(() => {
    if (activeTab !== "bidan") return;
    const timeoutId = setTimeout(async () => {
      try {
        setEligibleBidan(await loadEligiblePenduduk("bidan", bidanSearch));
      } catch (error) {
        setErrorMessage(adminTenagaErrorMessage(error, "Gagal mencari penduduk bidan"));
      }
    }, 300);

    return () => clearTimeout(timeoutId);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [activeTab, bidanSearch]);

  useEffect(() => {
    if (activeTab !== "kader") return;
    const timeoutId = setTimeout(async () => {
      try {
        setEligibleKader(await loadEligiblePenduduk("kader", kaderSearch));
      } catch (error) {
        setErrorMessage(adminTenagaErrorMessage(error, "Gagal mencari penduduk kader"));
      }
    }, 300);

    return () => clearTimeout(timeoutId);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [activeTab, kaderSearch]);

  useEffect(() => {
    if (activeTab !== "kader") return;
    const timeoutId = setTimeout(async () => {
      try {
        setPosyanduList(await loadPosyandu(posyanduSearch));
      } catch (error) {
        setErrorMessage(adminTenagaErrorMessage(error, "Gagal memuat data posyandu"));
      }
    }, 300);

    return () => clearTimeout(timeoutId);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [activeTab, posyanduSearch]);

  const handleCreateBidan = async (e) => {
    e.preventDefault();
    resetNotice();

    const pendudukID = toInt(bidanForm.penduduk_id);
    if (!pendudukID) {
      setErrorMessage("penduduk_id wajib diisi");
      return;
    }

    setSaving(true);
    try {
      await createBidanAdmin({
        penduduk_id: pendudukID,
        no_str: bidanForm.no_str.trim(),
        no_sipb: bidanForm.no_sipb.trim(),
        status: bidanForm.status,
      });
      setBidanForm(emptyBidanForm);
      await loadBidan();
      setEligibleBidan(await loadEligiblePenduduk("bidan", bidanSearch));
      setSuccessMessage("Data bidan berhasil ditambahkan");
    } catch (error) {
      setErrorMessage(adminTenagaErrorMessage(error, "Gagal menambah bidan"));
    } finally {
      setSaving(false);
    }
  };

  const handleCreateKader = async (e) => {
    e.preventDefault();
    resetNotice();

    const pendudukID = toInt(kaderForm.penduduk_id);
    if (!pendudukID) {
      setErrorMessage("penduduk_id wajib diisi");
      return;
    }

    setSaving(true);
    try {
      await createKaderAdmin({
        penduduk_id: pendudukID,
        posyandu_id: toNullableInt(kaderForm.posyandu_id),
        status: kaderForm.status,
      });
      setKaderForm(emptyKaderForm);
      await loadKader();
      setEligibleKader(await loadEligiblePenduduk("kader", kaderSearch));
      setPosyanduList(await loadPosyandu(posyanduSearch));
      setSuccessMessage("Data kader berhasil ditambahkan");
    } catch (error) {
      setErrorMessage(adminTenagaErrorMessage(error, "Gagal menambah kader"));
    } finally {
      setSaving(false);
    }
  };

  const startEditBidan = (item) => {
    setEditingBidanId(item.id);
    setBidanEdit({
      no_str: item.no_str || "",
      no_sipb: item.no_sipb || "",
      status: item.status || "aktif",
    });
  };

  const cancelEditBidan = () => {
    setEditingBidanId(null);
    setBidanEdit({ no_str: "", no_sipb: "", status: "aktif" });
  };

  const startEditKader = (item) => {
    setEditingKaderId(item.id);
    setKaderEdit({
      posyandu_id: item.posyandu_id || "",
      status: item.status || "aktif",
    });
  };

  const cancelEditKader = () => {
    setEditingKaderId(null);
    setKaderEdit({ posyandu_id: "", status: "aktif" });
  };

  const saveEditBidan = async () => {
    if (!editingBidanId) return;
    resetNotice();
    setSaving(true);
    try {
      await updateBidanAdmin(editingBidanId, {
        no_str: bidanEdit.no_str.trim(),
        no_sipb: bidanEdit.no_sipb.trim(),
        status: bidanEdit.status,
      });
      setEditingBidanId(null);
      await loadBidan();
      setEligibleBidan(await loadEligiblePenduduk("bidan", bidanSearch));
      setSuccessMessage("Data bidan berhasil diperbarui");
    } catch (error) {
      setErrorMessage(adminTenagaErrorMessage(error, "Gagal memperbarui bidan"));
    } finally {
      setSaving(false);
    }
  };

  const saveEditKader = async () => {
    if (!editingKaderId) return;
    resetNotice();
    setSaving(true);
    try {
      await updateKaderAdmin(editingKaderId, {
        posyandu_id: toNullableInt(kaderEdit.posyandu_id),
        status: kaderEdit.status,
      });
      setEditingKaderId(null);
      await loadKader();
      setEligibleKader(await loadEligiblePenduduk("kader", kaderSearch));
      setPosyanduList(await loadPosyandu(posyanduSearch));
      setSuccessMessage("Data kader berhasil diperbarui");
    } catch (error) {
      setErrorMessage(adminTenagaErrorMessage(error, "Gagal memperbarui kader"));
    } finally {
      setSaving(false);
    }
  };

  const renderBidan = () => (
    <div className="space-y-4">
      <form onSubmit={handleCreateBidan} className={`${cardClass} p-4`}>
        <div className="grid grid-cols-1 xl:grid-cols-12 gap-3 items-start">
          <div className="xl:col-span-5 min-w-0">
            <LookupField
              label="Cari dan Pilih Penduduk Bidan"
              placeholder="Ketik nama atau NIK penduduk..."
              value={bidanSearch}
              onChange={handleBidanQueryChange}
              options={eligibleBidan}
              loading={loading}
              emptyText="Tidak ada penduduk yang cocok"
              selectedLabel={selectedBidan ? formatPendudukLabel(selectedBidan) : ""}
              onClear={clearBidanSelection}
              onPick={pickBidan}
              renderOptionLabel={formatPendudukLabel}
              renderOptionMeta={(item) => `${item.nik}${item.desa ? ` • ${item.desa}` : ""}`}
            />
            <input type="hidden" value={bidanForm.penduduk_id} readOnly />
          </div>

          <div className="xl:col-span-2 min-w-0">
            <label className="text-sm font-medium text-slate-700">No STR</label>
            <input
              className="mt-2 rounded-xl border border-slate-200 px-3 py-2 w-full"
              placeholder="no_str"
              value={bidanForm.no_str}
              onChange={(e) => setBidanForm((p) => ({ ...p, no_str: e.target.value }))}
            />
          </div>

          <div className="xl:col-span-2 min-w-0">
            <label className="text-sm font-medium text-slate-700">No SIPB</label>
            <input
              className="mt-2 rounded-xl border border-slate-200 px-3 py-2 w-full"
              placeholder="no_sipb"
              value={bidanForm.no_sipb}
              onChange={(e) => setBidanForm((p) => ({ ...p, no_sipb: e.target.value }))}
            />
          </div>

          <div className="xl:col-span-2 min-w-0">
            <label className="text-sm font-medium text-slate-700">Status</label>
            <select
              className="mt-2 rounded-xl border border-slate-200 px-3 py-2 w-full"
              value={bidanForm.status}
              onChange={(e) => setBidanForm((p) => ({ ...p, status: e.target.value }))}
            >
              <option value="aktif">aktif</option>
              <option value="nonaktif">nonaktif</option>
            </select>
          </div>

          <div className="xl:col-span-1 min-w-0 xl:self-end">
            <button type="submit" disabled={saving} className="rounded-xl bg-blue-600 text-white px-4 py-2 hover:bg-blue-700 w-full">
              Simpan
            </button>
          </div>
        </div>
      </form>

      <div className={`${cardClass} p-4 overflow-x-auto`}>
        <table className="min-w-full text-sm">
          <thead>
            <tr className="text-left text-slate-500 border-b border-slate-200">
              <th className="py-2 pr-3">Nama</th>
              <th className="py-2 pr-3">NIK</th>
              <th className="py-2 pr-3">Kecamatan</th>
              <th className="py-2 pr-3">Desa</th>
              <th className="py-2 pr-3">STR</th>
              <th className="py-2 pr-3">SIPB</th>
              <th className="py-2 pr-3">Status</th>
              <th className="py-2 pr-3">Aksi</th>
            </tr>
          </thead>
          <tbody>
            {bidanList.map((item) => (
              <tr key={item.id} className="border-b border-slate-100">
                <td className="py-2 pr-3">{item.nama_lengkap}</td>
                <td className="py-2 pr-3">{item.nik}</td>
                <td className="py-2 pr-3">{item.kecamatan || "-"}</td>
                <td className="py-2 pr-3">{item.desa || "-"}</td>
                <td className="py-2 pr-3">
                  {editingBidanId === item.id ? (
                    <input className="rounded-lg border border-slate-200 px-2 py-1" value={bidanEdit.no_str} onChange={(e) => setBidanEdit((p) => ({ ...p, no_str: e.target.value }))} />
                  ) : item.no_str || "-"}
                </td>
                <td className="py-2 pr-3">
                  {editingBidanId === item.id ? (
                    <input className="rounded-lg border border-slate-200 px-2 py-1" value={bidanEdit.no_sipb} onChange={(e) => setBidanEdit((p) => ({ ...p, no_sipb: e.target.value }))} />
                  ) : item.no_sipb || "-"}
                </td>
                <td className="py-2 pr-3">
                  {editingBidanId === item.id ? (
                    <select
                      className="rounded-lg border border-slate-200 px-2 py-1"
                      value={bidanEdit.status}
                      onChange={(e) => setBidanEdit((p) => ({ ...p, status: e.target.value }))}
                    >
                      <option value="aktif">aktif</option>
                      <option value="nonaktif">nonaktif</option>
                    </select>
                  ) : (
                    <span className={`inline-flex items-center px-3 py-1 rounded-lg text-xs font-medium ${getStatusColor(item.status)}`}>
                      {item.status}
                    </span>
                  )}
                </td>
                <td className="py-2 pr-3">
                  <div className="flex flex-wrap gap-2">
                    {editingBidanId === item.id ? (
                      <>
                        <button className="rounded-lg bg-emerald-600 text-white px-2 py-1 inline-flex items-center gap-1" onClick={saveEditBidan}>
                          <Save size={14} /> Simpan
                        </button>
                        <button className="rounded-lg bg-slate-100 text-slate-700 px-2 py-1 inline-flex items-center gap-1" onClick={cancelEditBidan}>
                          <X size={14} />
                        </button>
                      </>
                    ) : (
                      <button className="rounded-lg bg-slate-100 text-slate-700 px-2 py-1" onClick={() => startEditBidan(item)}>
                        Edit
                      </button>
                    )}
                  </div>
                </td>
              </tr>
            ))}
            {bidanList.length === 0 && (
              <tr>
                <td colSpan={8} className="py-4 text-center text-slate-500">Belum ada data bidan</td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );

  const renderKader = () => (
    <div className="space-y-4">
      <form onSubmit={handleCreateKader} className={`${cardClass} p-4`}>
        <div className="grid grid-cols-1 xl:grid-cols-12 gap-3 items-start">
          <div className="xl:col-span-5 min-w-0">
            <LookupField
              label="Cari dan Pilih Penduduk Kader"
              placeholder="Ketik nama atau NIK penduduk..."
              value={kaderSearch}
              onChange={handleKaderQueryChange}
              options={eligibleKader}
              loading={loading}
              emptyText="Tidak ada penduduk yang cocok"
              selectedLabel={selectedKader ? formatPendudukLabel(selectedKader) : ""}
              onClear={clearKaderSelection}
              onPick={pickKader}
              renderOptionLabel={formatPendudukLabel}
              renderOptionMeta={(item) => `${item.nik}${item.desa ? ` • ${item.desa}` : ""}`}
            />
            <input type="hidden" value={kaderForm.penduduk_id} readOnly />
          </div>

          <div className="xl:col-span-5 min-w-0">
            <LookupField
              label="Cari dan Pilih Posyandu"
              placeholder="Ketik nama posyandu..."
              value={posyanduSearch}
              onChange={handlePosyanduQueryChange}
              options={posyanduList}
              loading={loading}
              emptyText="Tidak ada posyandu yang cocok"
              selectedLabel={selectedPosyandu ? formatPosyanduLabel(selectedPosyandu) : ""}
              onClear={clearPosyanduSelection}
              onPick={pickPosyandu}
              renderOptionLabel={formatPosyanduLabel}
              renderOptionMeta={(item) => `ID ${item.id}`}
            />
            <input type="hidden" value={kaderForm.posyandu_id} readOnly />
          </div>

          <div className="xl:col-span-1 min-w-0">
            <label className="text-sm font-medium text-slate-700">Status</label>
            <select
              className="mt-2 rounded-xl border border-slate-200 px-3 py-2 w-full"
              value={kaderForm.status}
              onChange={(e) => setKaderForm((p) => ({ ...p, status: e.target.value }))}
            >
              <option value="aktif">aktif</option>
              <option value="nonaktif">nonaktif</option>
            </select>
          </div>

          <div className="xl:col-span-1 min-w-0 xl:self-end">
            <button type="submit" disabled={saving} className="rounded-xl bg-blue-600 text-white px-4 py-2 hover:bg-blue-700 w-full">
              Simpan
            </button>
          </div>
        </div>
      </form>

      <div className={`${cardClass} p-4 overflow-x-auto`}>
        <table className="min-w-full text-sm">
          <thead>
            <tr className="text-left text-slate-500 border-b border-slate-200">
              <th className="py-2 pr-3">Nama</th>
              <th className="py-2 pr-3">NIK</th>
              <th className="py-2 pr-3">Kecamatan</th>
              <th className="py-2 pr-3">Desa</th>
              <th className="py-2 pr-3">Posyandu</th>
              <th className="py-2 pr-3">Status</th>
              <th className="py-2 pr-3">Aksi</th>
            </tr>
          </thead>
          <tbody>
            {kaderList.map((item) => (
              <tr key={item.id} className="border-b border-slate-100">
                <td className="py-2 pr-3">{item.nama_lengkap}</td>
                <td className="py-2 pr-3">{item.nik}</td>
                <td className="py-2 pr-3">
                  {item.kecamatan || "-"}
                </td>
                <td className="py-2 pr-3">
                  {item.desa || "-"}
                </td>
                <td className="py-2 pr-3">
                  {editingKaderId === item.id ? (
                    <select className="rounded-lg border border-slate-200 px-2 py-1 w-40" value={kaderEdit.posyandu_id || ""} onChange={(e) => setKaderEdit((p) => ({ ...p, posyandu_id: e.target.value }))}>
                      <option value="">Tidak dipilih</option>
                      {posyanduList.map((posyandu) => (
                        <option key={posyandu.id} value={posyandu.id}>
                          {posyandu.nama}
                        </option>
                      ))}
                    </select>
                  ) : item.posyandu_id || "-"}
                </td>
                <td className="py-2 pr-3">
                  {editingKaderId === item.id ? (
                    <select
                      className="rounded-lg border border-slate-200 px-2 py-1"
                      value={kaderEdit.status}
                      onChange={(e) => setKaderEdit((p) => ({ ...p, status: e.target.value }))}
                    >
                      <option value="aktif">aktif</option>
                      <option value="nonaktif">nonaktif</option>
                    </select>
                  ) : (
                    <span className={`inline-flex items-center px-3 py-1 rounded-lg text-xs font-medium ${getStatusColor(item.status)}`}>
                      {item.status}
                    </span>
                  )}
                </td>
                <td className="py-2 pr-3">
                  <div className="flex flex-wrap gap-2">
                    {editingKaderId === item.id ? (
                      <>
                        <button className="rounded-lg bg-emerald-600 text-white px-2 py-1 inline-flex items-center gap-1" onClick={saveEditKader}>
                          <Save size={14} /> Simpan
                        </button>
                        <button className="rounded-lg bg-slate-100 text-slate-700 px-2 py-1 inline-flex items-center gap-1" onClick={cancelEditKader}>
                          <X size={14} />
                        </button>
                      </>
                    ) : (
                      <button className="rounded-lg bg-slate-100 text-slate-700 px-2 py-1" onClick={() => startEditKader(item)}>
                        Edit
                      </button>
                    )}
                  </div>
                </td>
              </tr>
            ))}
            {kaderList.length === 0 && (
              <tr>
                <td colSpan={7} className="py-4 text-center text-slate-500">Belum ada data kader</td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );

  return (
    <MainLayout>
      <div className="space-y-6">
        {errorMessage && <div className="rounded-xl bg-red-50 border border-red-200 px-4 py-3 text-red-700 text-sm">{errorMessage}</div>}
        {successMessage && <div className="rounded-xl bg-emerald-50 border border-emerald-200 px-4 py-3 text-emerald-700 text-sm">{successMessage}</div>}

        <section className={`${cardClass} p-3 flex gap-2`}>
          <button className={`px-4 py-2 rounded-xl text-sm font-medium ${activeTab === "bidan" ? "bg-blue-600 text-white" : "bg-slate-100 text-slate-700"}`} onClick={() => setActiveTab("bidan")}>Bidan</button>
          <button className={`px-4 py-2 rounded-xl text-sm font-medium ${activeTab === "kader" ? "bg-blue-600 text-white" : "bg-slate-100 text-slate-700"}`} onClick={() => setActiveTab("kader")}>Kader</button>
          <button className="ml-auto px-4 py-2 rounded-xl text-sm bg-slate-100 text-slate-700" onClick={() => reloadByTab()} disabled={loading || saving}>
            {loading ? <span className="inline-flex items-center gap-2"><Loader2 size={14} className="animate-spin" /> Memuat...</span> : "Muat Ulang"}
          </button>
        </section>

        {activeTab === "bidan" ? renderBidan() : renderKader()}
      </div>
    </MainLayout>
  );
};

export default TenagaKesehatanManagement;

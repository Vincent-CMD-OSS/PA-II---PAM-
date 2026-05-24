import React, { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import MainLayout from "../../components/Layout/MainLayout";
import { getKehamilanByIbuId } from "../../services/kehamilan";
import { getGrafikBBByKehamilanId, createGrafikBB, updateGrafikBB } from "../../services/grafikBB";
import { Line } from "react-chartjs-2";
import { Save, ArrowLeft } from "lucide-react";

export default function GrafikPeningkatanBB() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [kehamilan, setKehamilan] = useState(null);

  // Data State
  const [grafikBB, setGrafikBB] = useState(null);
  const [grafikBBList, setGrafikBBList] = useState([]);

  const [formBB, setFormBB] = useState({
    bb_pra_kehamilan_kg: "",
    imt_pra_kehamilan: "",
    kategori_imt_pra_kehamilan: "",
    rekomendasi_peningkatan_bb_min: "",
    rekomendasi_peningkatan_bb_max: "",
    minggu_kehamilan: "",
    peningkatan_bb_kg: "",
  });

  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const kehamilanList = await getKehamilanByIbuId(id);
        if (kehamilanList.length > 0) {
          const aktif = kehamilanList[0];
          setKehamilan(aktif);

          // Fetch data grafik peningkatan BB
          const dataBB = await getGrafikBBByKehamilanId(aktif.id);
          if (dataBB && dataBB.length > 0) {
            setGrafikBBList(dataBB);
            const bb = dataBB[0];
            setGrafikBB(bb);
            setFormBB({
              bb_pra_kehamilan_kg: bb.bb_pra_kehamilan_kg ?? "",
              imt_pra_kehamilan: bb.imt_pra_kehamilan ?? "",
              kategori_imt_pra_kehamilan: bb.kategori_imt_pra_kehamilan || "",
              rekomendasi_peningkatan_bb_min: bb.rekomendasi_peningkatan_bb_min ?? "",
              rekomendasi_peningkatan_bb_max: bb.rekomendasi_peningkatan_bb_max ?? "",
              minggu_kehamilan: bb.minggu_kehamilan ?? "",
              peningkatan_bb_kg: bb.peningkatan_bb_kg ?? "",
            });
          }
        }
      } catch (err) {
        console.error(err);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, [id]);

  const handleChangeBB = (e) => setFormBB((prev) => ({ ...prev, [e.target.name]: e.target.value }));

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!kehamilan) return;
    setSaving(true);
    try {
      const payloadBB = {
        ...formBB,
        kehamilan_id: kehamilan.id,
        bb_pra_kehamilan_kg: parseFloat(formBB.bb_pra_kehamilan_kg) ?? null,
        imt_pra_kehamilan: parseFloat(formBB.imt_pra_kehamilan) ?? null,
        rekomendasi_peningkatan_bb_min: parseFloat(formBB.rekomendasi_peningkatan_bb_min) ?? null,
        rekomendasi_peningkatan_bb_max: parseFloat(formBB.rekomendasi_peningkatan_bb_max) ?? null,
        minggu_kehamilan: parseInt(formBB.minggu_kehamilan) ?? null,
        peningkatan_bb_kg: parseFloat(formBB.peningkatan_bb_kg) ?? null,
      };
      if (grafikBB) await updateGrafikBB(grafikBB.id_grafik, payloadBB);
      else await createGrafikBB(payloadBB);

      alert("Data grafik peningkatan berat badan berhasil disimpan");
    } catch (err) {
      console.error(err);
      alert("Gagal menyimpan data grafik peningkatan berat badan");
    } finally {
      setSaving(false);
    }
  };

  // Build chart data from actual data
  const buildChartData = () => {
    if (grafikBBList.length > 0) {
      const sorted = [...grafikBBList].sort((a, b) => (a.minggu_kehamilan || 0) - (b.minggu_kehamilan || 0));
      return {
        labels: sorted.map((g) => g.minggu_kehamilan || 0),
        datasets: [
          {
            label: "Peningkatan BB (kg)",
            data: sorted.map((g) => g.peningkatan_bb_kg || null),
            borderColor: "#10b981",
            backgroundColor: "rgba(16, 185, 129, 0.1)",
            fill: true,
            tension: 0.3,
            pointRadius: 5,
            pointBackgroundColor: "#10b981",
          },
          {
            label: "Rekomendasi Min (kg)",
            data: sorted.map((g) => g.rekomendasi_peningkatan_bb_min || null),
            borderColor: "#f59e0b",
            borderDash: [5, 5],
            fill: false,
            tension: 0.3,
            pointRadius: 3,
            pointBackgroundColor: "#f59e0b",
          },
          {
            label: "Rekomendasi Max (kg)",
            data: sorted.map((g) => g.rekomendasi_peningkatan_bb_max || null),
            borderColor: "#ef4444",
            borderDash: [5, 5],
            fill: false,
            tension: 0.3,
            pointRadius: 3,
            pointBackgroundColor: "#ef4444",
          },
        ],
      };
    }
    // Fallback jika belum ada data
    return {
      labels: [0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40],
      datasets: [
        { label: "Peningkatan BB (kg)", data: [], borderColor: "#10b981", fill: false },
        { label: "Rekomendasi Min (kg)", data: [], borderColor: "#f59e0b", borderDash: [5, 5], fill: false },
        { label: "Rekomendasi Max (kg)", data: [], borderColor: "#ef4444", borderDash: [5, 5], fill: false },
      ],
    };
  };

  if (loading)
    return (
      <MainLayout>
        <div className="p-6">Memuat...</div>
      </MainLayout>
    );

  return (
    <MainLayout>
      <div className="p-6 max-w-5xl mx-auto">
        <div className="flex items-center gap-4 mb-6">
          <button onClick={() => navigate(-1)} className="p-2 rounded-full hover:bg-gray-100 transition-colors">
            <ArrowLeft size={20} />
          </button>
          <div>
            <h1 className="text-2xl font-bold text-gray-900">Grafik Peningkatan Berat Badan</h1>
            <p className="text-gray-500">Pemantauan peningkatan berat badan ibu selama kehamilan berdasarkan IMT pra-kehamilan.</p>
          </div>
        </div>

        {/* Info BB Pra-Kehamilan */}
        {grafikBB && (
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
            <div className="bg-white rounded-xl shadow-sm p-4 border-l-4 border-emerald-500">
              <p className="text-sm text-gray-500">BB Pra-Kehamilan</p>
              <p className="text-2xl font-bold text-emerald-700">
                {grafikBB.bb_pra_kehamilan_kg || "-"} <span className="text-sm font-normal">kg</span>
              </p>
            </div>
            <div className="bg-white rounded-xl shadow-sm p-4 border-l-4 border-blue-500">
              <p className="text-sm text-gray-500">IMT Pra-Kehamilan</p>
              <p className="text-2xl font-bold text-blue-700">
                {grafikBB.imt_pra_kehamilan || "-"} <span className="text-sm font-normal">({grafikBB.kategori_imt_pra_kehamilan || "-"})</span>
              </p>
            </div>
            <div className="bg-white rounded-xl shadow-sm p-4 border-l-4 border-amber-500">
              <p className="text-sm text-gray-500">Rekomendasi Peningkatan</p>
              <p className="text-2xl font-bold text-amber-700">
                {grafikBB.rekomendasi_peningkatan_bb_min || "-"} - {grafikBB.rekomendasi_peningkatan_bb_max || "-"} <span className="text-sm font-normal">kg</span>
              </p>
            </div>
          </div>
        )}

        {/* Grafik Peningkatan BB */}
        <div className="bg-white rounded-xl shadow-sm p-6 mb-6">
          <h3 className="font-semibold mb-4 text-emerald-700">Grafik Peningkatan Berat Badan Ibu</h3>
          <div className="h-72">
            <Line
              data={buildChartData()}
              options={{
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                  legend: { position: "top" },
                },
                scales: {
                  x: { title: { display: true, text: "Minggu Kehamilan" } },
                  y: { title: { display: true, text: "Berat Badan (kg)" } },
                },
              }}
            />
          </div>
          {grafikBBList.length === 0 && <p className="text-center text-gray-400 text-sm mt-2">Belum ada data. Isi form di bawah untuk menampilkan grafik.</p>}
        </div>

        <form onSubmit={handleSubmit} className="space-y-6">
          {/* Data Peningkatan BB */}
          <div className="bg-white rounded-xl shadow-sm p-6">
            <h3 className="font-semibold mb-4 text-emerald-700">Data Peningkatan Berat Badan</h3>
            <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">BB Pra-Kehamilan (kg)</label>
                <input type="number" step="0.1" name="bb_pra_kehamilan_kg" value={formBB.bb_pra_kehamilan_kg} onChange={handleChangeBB} className="w-full border rounded px-3 py-2" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">IMT</label>
                <input type="number" step="0.1" name="imt_pra_kehamilan" value={formBB.imt_pra_kehamilan} onChange={handleChangeBB} className="w-full border rounded px-3 py-2" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Kategori IMT</label>
                <select name="kategori_imt_pra_kehamilan" value={formBB.kategori_imt_pra_kehamilan} onChange={handleChangeBB} className="w-full border rounded px-3 py-2">
                  <option value="">-- Pilih --</option>
                  <option value="Underweight">Underweight (&lt;18.5)</option>
                  <option value="Normal">Normal (18.5-24.9)</option>
                  <option value="Overweight">Overweight (25-29.9)</option>
                  <option value="Obesitas">Obesitas (≥30)</option>
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Minggu Kehamilan</label>
                <input type="number" name="minggu_kehamilan" value={formBB.minggu_kehamilan} onChange={handleChangeBB} className="w-full border rounded px-3 py-2" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Peningkatan BB (kg)</label>
                <input type="number" step="0.1" name="peningkatan_bb_kg" value={formBB.peningkatan_bb_kg} onChange={handleChangeBB} className="w-full border rounded px-3 py-2" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Rekomendasi Min (kg)</label>
                <input type="number" step="0.1" name="rekomendasi_peningkatan_bb_min" value={formBB.rekomendasi_peningkatan_bb_min} onChange={handleChangeBB} className="w-full border rounded px-3 py-2" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Rekomendasi Max (kg)</label>
                <input type="number" step="0.1" name="rekomendasi_peningkatan_bb_max" value={formBB.rekomendasi_peningkatan_bb_max} onChange={handleChangeBB} className="w-full border rounded px-3 py-2" />
              </div>
            </div>
          </div>

          <button type="submit" disabled={saving} className="bg-emerald-600 text-white px-4 py-2 rounded-lg flex items-center gap-2 hover:bg-emerald-700 transition-colors">
            <Save size={18} /> {saving ? "Menyimpan..." : "Simpan Data Berat Badan"}
          </button>
        </form>
      </div>
    </MainLayout>
  );
}

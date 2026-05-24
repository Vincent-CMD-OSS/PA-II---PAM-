// src/pages/Dashboard.jsx
import MainLayout from "../components/Layout/MainLayout";

const icons = {
  home: <svg width="16" height="16" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z" /><polyline points="9,22 9,12 15,12 15,22" /></svg>,
  users: <svg width="16" height="16" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2" /><circle cx="9" cy="7" r="4" /><path d="M23 21v-2a4 4 0 00-3-3.87" /><path d="M16 3.13a4 4 0 010 7.75" /></svg>,
  growth: <svg width="16" height="16" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><polyline points="23,6 13.5,15.5 8.5,10.5 1,18" /><polyline points="17,6 23,6 23,12" /></svg>,
  heart: <svg width="16" height="16" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z" /></svg>,
  calendar: <svg width="16" height="16" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2" ry="2" /><line x1="16" y1="2" x2="16" y2="6" /><line x1="8" y1="2" x2="8" y2="6" /><line x1="3" y1="10" x2="21" y2="10" /></svg>,
  report: <svg width="16" height="16" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z" /><polyline points="14,2 14,8 20,8" /><line x1="16" y1="13" x2="8" y2="13" /><line x1="16" y1="17" x2="8" y2="17" /><polyline points="10,9 9,9 8,9" /></svg>,
  preg: <svg width="20" height="20" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10" /><path d="M12 8v4l3 3" /></svg>,
  baby: <svg width="20" height="20" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><path d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" /></svg>,
  imm: <svg width="20" height="20" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><path d="M22 11.08V12a10 10 0 11-5.93-9.14" /><polyline points="22,4 12,14.01 9,11.01" /></svg>,
  sched: <svg width="20" height="20" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2" ry="2" /><line x1="16" y1="2" x2="16" y2="6" /><line x1="8" y1="2" x2="8" y2="6" /><line x1="3" y1="10" x2="21" y2="10" /></svg>,
  search: <svg width="16" height="16" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8" /><path d="M21 21l-4.35-4.35" /></svg>,
  sync: <svg width="16" height="16" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><polyline points="23,4 23,10 17,10" /><polyline points="1,20 1,14 7,14" /><path d="M3.51 9a9 9 0 0114.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0020.49 15" /></svg>,
  warn: <svg width="16" height="16" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><path d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z" /><line x1="12" y1="9" x2="12" y2="13" /><line x1="12" y1="17" x2="12.01" y2="17" /></svg>,
};



const statCards = [
  {
    label: "Ibu Hamil Aktif",
    value: "45",
    icon: icons.preg,
    iconBg: "#eff6ff",
    iconColor: "#3b82f6",
    sub1: { text: "5 Risiko Tinggi", color: "#ef4444", bg: "#fef2f2" },
    sub2: { text: "12 Trimester 3", color: "#f59e0b", bg: "#fffbeb" },
  },
  {
    label: "Balita Terdaftar",
    value: "182",
    icon: icons.baby,
    iconBg: "#f0fdf4",
    iconColor: "#10b981",
    sub1: { text: "8 Perlu Perhatian", color: "#f59e0b", bg: "#fffbeb" },
    sub2: { text: "17% Normal", color: "#10b981", bg: "#f0fdf4" },
  },
  {
    label: "Capaian Imunisasi Dasar",
    value: "78%",
    icon: icons.imm,
    iconBg: "#f0fdf4",
    iconColor: "#10b981",
    sub1: { text: "+5% Bulan ini", color: "#10b981", bg: "#f0fdf4" },
    sub2: { text: "24 Bayi lengkap", color: "#64748b", bg: "#f8fafc" },
  },
  {
    label: "Jadwal Pelayanan",
    value: "12",
    icon: icons.sched,
    iconBg: "#eff6ff",
    iconColor: "#3b82f6",
    sub1: { text: "4 Posyandu minggu ini", color: "#3b82f6", bg: "#eff6ff" },
    sub2: { text: "8 Kunjungan rumah", color: "#64748b", bg: "#f8fafc" },
  },
];

const kpiData = [
  { label: "Kunjungan Ibu Hamil (K4)", value: 72, target: 88, color: "#3b82f6" },
  { label: "Persalinan di Fasilitas Kesehatan", value: 95, target: 100, color: "#10b981" },
  { label: "Kunjungan Nifas (KF Lengkap)", value: 88, target: 90, color: "#10b981" },
  { label: "Bayi Mendapat ASI Eksklusif", value: 64, target: 80, color: "#ef4444" },
  { label: "Balita Ditimbang (D/S)", value: 85, target: 90, color: "#f59e0b" },
];

const posyanduData = [
  { nama: "Posyandu Mawar 1", dusun: "Dusun I", hamil: 12, balita: 45, kader: "5 Orang" },
  { nama: "Posyandu Mawar 2", dusun: "Dusun II", hamil: 15, balita: 50, kader: "4 Orang" },
  { nama: "Posyandu Melati 1", dusun: "Dusun III", hamil: 8, balita: 35, kader: "5 Orang" },
  { nama: "Posyandu Melati 2", dusun: "Dusun IV", hamil: 10, balita: 52, kader: "4 Orang" },
];

const risks = [
  {
    name: "Ny. Rini Martina (Kehamilan Risti)",
    detail: "Usia kandungan 34 mg dengan riwayat hipertensi. Jadwal periksa terlambat 3 hari.",
    color: "#ef4444",
    bg: "#fef2f2",
    border: "#fecaca",
  },
  {
    name: "An. Budi Saputra (T T)",
    detail: "Berat badan tidak naik dalam 2 bulan berturut-turut. Rujuk ke puskesmas segera.",
    color: "#f59e0b",
    bg: "#fffbeb",
    border: "#fde68a",
  },
  {
    name: "Ny. Siti Aminah",
    detail: "Belum melakukan Kunjungan Nifas (KF-1) hari ke-3 pasca persalinan.",
    color: "#f59e0b",
    bg: "#fffbeb",
    border: "#fde68a",
  },
  {
    name: "5 Balita Terlambat Imunisasi",
    detail: "Imunisasi vaksin Rubella terlambat lebih dari 1 bulan dari jadwal.",
    color: "#8b5cf6",
    bg: "#f5f3ff",
    border: "#ddd6fe",
  },
];

const activities = [
  { date: "15", month: "JUN", title: "Posyandu Mawar 1", time: "08:00 - 12:00 WIB" },
  { date: "16", month: "JUN", title: "Posyandu Melati 2", time: "08:30 - 12:00 WIB" },
  { date: "18", month: "JUN", title: "Kunjungan Rumah (2 Ibu Nifas)", time: "Dusun I & II" },
];

function ProgressBar({ value, color }) {
  return (
    <div style={{ position: "relative", height: 8, background: "#e2e8f0", borderRadius: 4, overflow: "hidden" }}>
      <div
        style={{
          position: "absolute",
          left: 0,
          top: 0,
          height: "100%",
          width: `${value}%`,
          background: color,
          borderRadius: 4,
          transition: "width 0.8s ease",
        }}
      />
    </div>
  );
}

function StatCard({ label, value, icon, iconBg, iconColor, sub1, sub2 }) {
  return (
    <div style={{ background: "#fff", borderRadius: 10, padding: "14px 16px", border: "1px solid #e2e8f0" }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: 8 }}>
        <div style={{ fontSize: 12, color: "#64748b", fontWeight: 500, lineHeight: 1.3 }}>{label}</div>
        <div
          style={{
            width: 32,
            height: 32,
            background: iconBg,
            borderRadius: 8,
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            color: iconColor,
            flexShrink: 0,
          }}
        >
          {icon}
        </div>
      </div>
      <div style={{ fontSize: 28, fontWeight: 700, color: "#0f172a", marginBottom: 10 }}>{value}</div>
      <div style={{ display: "flex", gap: 6, flexWrap: "wrap" }}>
        <span style={{ fontSize: 10.5, fontWeight: 600, color: sub1.color, background: sub1.bg, padding: "3px 7px", borderRadius: 4 }}>{sub1.text}</span>
        <span style={{ fontSize: 10.5, fontWeight: 600, color: sub2.color, background: sub2.bg, padding: "3px 7px", borderRadius: 4 }}>{sub2.text}</span>
      </div>
    </div>
  );
}

export default function Dashboard() {
  return (
    <MainLayout>
      <div style={{ background: "#f0f4f8", borderRadius: 14, border: "1px solid #e2e8f0", overflow: "hidden" }}>
        <div style={{ padding: "16px 20px" }}>
          <div style={{ display: "flex", gap: 10, alignItems: "center", justifyContent: "flex-end", flexWrap: "wrap", marginBottom: 16 }}>
            <div style={{ display: "flex", alignItems: "center", gap: 6, background: "#f8fafc", border: "1px solid #e2e8f0", borderRadius: 7, padding: "7px 12px" }}>
              {icons.search}
              <input
                placeholder="Cari nama atau NIK"
                style={{ border: "none", outline: "none", background: "transparent", fontSize: 12.5, color: "#475569", width: 150 }}
              />
            </div>
            <button
              style={{
                display: "flex",
                alignItems: "center",
                gap: 6,
                background: "#2563eb",
                color: "#fff",
                border: "none",
                borderRadius: 7,
                padding: "7px 14px",
                fontSize: 12.5,
                fontWeight: 600,
                cursor: "pointer",
              }}
            >
              {icons.sync} Sinkron Data
            </button>
          </div>

          <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit,minmax(220px,1fr))", gap: 12, marginBottom: 16 }}>
            {statCards.map((s) => <StatCard key={s.label} {...s} />)}
          </div>

          <div className="grid grid-cols-1 xl:grid-cols-[minmax(0,1fr)_320px] gap-3">
            <div style={{ display: "grid", gridTemplateColumns: "minmax(0,1fr)", gap: 12 }}>
              <div style={{ background: "#fff", borderRadius: 10, padding: "16px", border: "1px solid #e2e8f0" }}>
                <h2 style={{ fontSize: 14, fontWeight: 700, color: "#0f172a" }}>Capaian Indikator Kinerja</h2>
                <p style={{ fontSize: 11.5, color: "#64748b", marginTop: 2, marginBottom: 14 }}>
                  Persentase pencapaian program KIA di Desa Suka Maju bulan ini.
                </p>
                <div style={{ display: "flex", flexDirection: "column", gap: 12 }}>
                  {kpiData.map((k) => (
                    <div key={k.label}>
                      <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 5, gap: 10 }}>
                        <span style={{ fontSize: 12.5, color: "#374151", fontWeight: 500 }}>{k.label}</span>
                        <div style={{ display: "flex", gap: 8, alignItems: "center" }}>
                          <span style={{ fontSize: 13, fontWeight: 700, color: "#0f172a" }}>{k.value}%</span>
                          <span style={{ fontSize: 10.5, color: "#94a3b8" }}>/ Target {k.target}%</span>
                        </div>
                      </div>
                      <ProgressBar value={k.value} color={k.color} />
                    </div>
                  ))}
                </div>
              </div>

              <div style={{ background: "#fff", borderRadius: 10, border: "1px solid #e2e8f0", overflowX: "auto" }}>
                <div style={{ padding: "14px 16px", borderBottom: "1px solid #e2e8f0" }}>
                  <h2 style={{ fontSize: 14, fontWeight: 700, color: "#0f172a" }}>Sebaran per Posyandu</h2>
                  <p style={{ fontSize: 11.5, color: "#64748b", marginTop: 2 }}>
                    Data sasaran aktif pada 4 posyandu di wilayah kerja.
                  </p>
                </div>
                <table style={{ width: "100%", borderCollapse: "collapse", minWidth: 740 }}>
                  <thead>
                    <tr style={{ background: "#f8fafc" }}>
                      {["Nama Posyandu", "Dusun / Wilayah", "Ibu Hamil", "Balita", "Kader Aktif", "Status"].map((h) => (
                        <th key={h} style={{ padding: "9px 14px", textAlign: "left", fontSize: 11.5, fontWeight: 600, color: "#64748b", borderBottom: "1px solid #e2e8f0" }}>
                          {h}
                        </th>
                      ))}
                    </tr>
                  </thead>
                  <tbody>
                    {posyanduData.map((p, i) => (
                      <tr key={p.nama} style={{ borderBottom: i < posyanduData.length - 1 ? "1px solid #f1f5f9" : "none" }}>
                        <td style={{ padding: "10px 14px", fontSize: 12.5, fontWeight: 600, color: "#0f172a" }}>{p.nama}</td>
                        <td style={{ padding: "10px 14px", fontSize: 12.5, color: "#475569" }}>{p.dusun}</td>
                        <td style={{ padding: "10px 14px", fontSize: 12.5, color: "#0f172a", fontWeight: 500 }}>{p.hamil}</td>
                        <td style={{ padding: "10px 14px", fontSize: 12.5, color: "#0f172a", fontWeight: 500 }}>{p.balita}</td>
                        <td style={{ padding: "10px 14px", fontSize: 12.5, color: "#475569" }}>{p.kader}</td>
                        <td style={{ padding: "10px 14px" }}>
                          <span style={{ background: "#f0fdf4", color: "#16a34a", fontWeight: 600, fontSize: 11, padding: "3px 10px", borderRadius: 20 }}>
                            Aktif
                          </span>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>

            <div style={{ display: "flex", flexDirection: "column", gap: 12 }}>
              <div style={{ background: "#fff", borderRadius: 10, padding: "14px 16px", border: "1px solid #e2e8f0" }}>
                <h2 style={{ fontSize: 14, fontWeight: 700, color: "#0f172a" }}>Peringatan & Risiko</h2>
                <p style={{ fontSize: 11, color: "#64748b", marginTop: 2, marginBottom: 12 }}>
                  Sasaran yang memerlukan perhatian segera.
                </p>
                <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
                  {risks.map((r) => (
                    <div key={r.name} style={{ background: r.bg, border: `1px solid ${r.border}`, borderRadius: 8, padding: "10px 12px" }}>
                      <div style={{ display: "flex", gap: 8, alignItems: "flex-start" }}>
                        <div style={{ color: r.color, marginTop: 1, flexShrink: 0 }}>{icons.warn}</div>
                        <div>
                          <div style={{ fontSize: 12, fontWeight: 700, color: "#0f172a", marginBottom: 3 }}>{r.name}</div>
                          <div style={{ fontSize: 11, color: "#475569", lineHeight: 1.5 }}>{r.detail}</div>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>

              <div style={{ background: "#fff", borderRadius: 10, padding: "14px 16px", border: "1px solid #e2e8f0" }}>
                <h2 style={{ fontSize: 14, fontWeight: 700, color: "#0f172a" }}>Aktivitas Terdekat</h2>
                <p style={{ fontSize: 11, color: "#64748b", marginTop: 2, marginBottom: 12 }}>
                  Jadwal posyandu dan kunjungan minggu ini.
                </p>
                <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
                  {activities.map((a, i) => (
                    <div
                      key={`${a.date}-${a.title}`}
                      style={{
                        display: "flex",
                        gap: 10,
                        alignItems: "center",
                        padding: "8px 0",
                        borderBottom: i < activities.length - 1 ? "1px solid #f1f5f9" : "none",
                      }}
                    >
                      <div
                        style={{
                          width: 38,
                          height: 42,
                          background: "#eff6ff",
                          borderRadius: 8,
                          display: "flex",
                          flexDirection: "column",
                          alignItems: "center",
                          justifyContent: "center",
                          flexShrink: 0,
                        }}
                      >
                        <span style={{ fontSize: 15, fontWeight: 700, color: "#2563eb", lineHeight: 1 }}>{a.date}</span>
                        <span style={{ fontSize: 9, fontWeight: 600, color: "#3b82f6", letterSpacing: "0.05em" }}>{a.month}</span>
                      </div>
                      <div style={{ flex: 1 }}>
                        <div style={{ fontSize: 12.5, fontWeight: 600, color: "#0f172a" }}>{a.title}</div>
                        <div style={{ fontSize: 11, color: "#64748b", marginTop: 2 }}>{a.time}</div>
                      </div>
                      <button style={{ fontSize: 11, color: "#2563eb", fontWeight: 600, background: "transparent", border: "none", cursor: "pointer" }}>
                        Detail
                      </button>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </MainLayout>
  );
}
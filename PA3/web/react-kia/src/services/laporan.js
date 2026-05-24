import api from "./api";

export const exportLaporanIbu = async () => {
  const res = await api.get("/tenaga-kesehatan/laporan/ibu", {
    responseType: "blob",
  });
  return res.data;
};

export const exportLaporanAnak = async () => {
  const res = await api.get("/tenaga-kesehatan/laporan/anak", {
    responseType: "blob",
  });
  return res.data;
};
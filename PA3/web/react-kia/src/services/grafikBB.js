import api from "./api";

const BASE_BB = "/tenaga-kesehatan/grafik-peningkatan-bb";
const BASE_PENJELASAN = "/tenaga-kesehatan/penjelasan-hasil-grafik";

// ==================== GRAFIK PENINGKATAN BERAT BADAN ====================
export const getGrafikBBByKehamilanId = async (kehamilanId) => {
  const res = await api.get(`${BASE_BB}?kehamilan_id=${kehamilanId}`);
  return res.data.data;
};
export const createGrafikBB = async (data) => {
  const res = await api.post(BASE_BB, data);
  return res.data.data;
};
export const updateGrafikBB = async (id, data) => {
  const res = await api.put(`${BASE_BB}/${id}`, data);
  return res.data.data;
};

// ==================== PENJELASAN HASIL GRAFIK ====================
export const getPenjelasanByKehamilanId = async (kehamilanId) => {
  const res = await api.get(`${BASE_PENJELASAN}?kehamilan_id=${kehamilanId}`);
  return res.data.data;
};
export const createPenjelasan = async (data) => {
  const res = await api.post(BASE_PENJELASAN, data);
  return res.data.data;
};
export const updatePenjelasan = async (id, data) => {
  const res = await api.put(`${BASE_PENJELASAN}/${id}`, data);
  return res.data.data;
};

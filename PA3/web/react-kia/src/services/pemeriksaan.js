import api from "./api";

const BASE = "/tenaga-kesehatan/pemeriksaan-kehamilan";

export const getPemeriksaanByKehamilanId = async (kehamilanId) => {
  const res = await api.get(`${BASE}?kehamilan_id=${kehamilanId}`);
  return res.data.data;
};

export const createPemeriksaan = async (data) => {
  const res = await api.post(BASE, data);
  return res.data.data;
};

export const updatePemeriksaan = async (id, data) => {
  const res = await api.put(`${BASE}/${id}`, data);
  return res.data.data;
};
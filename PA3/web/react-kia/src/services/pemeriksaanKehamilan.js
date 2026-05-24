import api from "./api";

const BASE = "/tenaga-kesehatan/pemeriksaan-kehamilan";

export const getPemeriksaanKehamilanByKehamilanId = async (kehamilanId) => {
  const res = await api.get(`${BASE}?kehamilan_id=${kehamilanId}`);
  return res.data.data;
};

export const getPemeriksaanKehamilanById = async (id) => {
  const res = await api.get(`${BASE}/${id}`);
  return res.data.data;
};

export const createPemeriksaanKehamilan = async (data) => {
  const res = await api.post(BASE, data);
  return res.data.data;
};

export const updatePemeriksaanKehamilan = async (id, data) => {
  const res = await api.put(`${BASE}/${id}`, data);
  return res.data.data;
};

export const deletePemeriksaanKehamilan = async (id) => {
  const res = await api.delete(`${BASE}/${id}`);
  return res.data;
};

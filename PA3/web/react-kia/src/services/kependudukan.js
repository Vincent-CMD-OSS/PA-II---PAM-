import api from "./api";

const BASE = "/tenaga-kesehatan/kependudukan";

export const getKependudukanList = async () => {
  const res = await api.get(BASE);
  return res.data.data;
};

export const getKependudukanById = async (id) => {
  const res = await api.get(`${BASE}/${id}`);
  return res.data.data;
};

export const createKependudukan = async (data) => {
  const res = await api.post(BASE, data);
  return res.data.data;
};

export const updateKependudukan = async (id, data) => {
  const res = await api.put(`${BASE}/${id}`, data);
  return res.data.data;
};

export const deleteKependudukan = async (id) => {
  const res = await api.delete(`${BASE}/${id}`);
  return res.data;
};
// src/services/ibu.js
import api from "./api";

const BASE = "/tenaga-kesehatan/ibu";

export const getIbuList = async () => {
  const res = await api.get(BASE);
  return res.data.data;
};

export const getIbuById = async (id) => {
  const res = await api.get(`${BASE}/${id}`);
  return res.data.data;
};

export const createIbu = async (data) => {
  // data.id_kependudukan harus number, sudah di-convert di komponen
  const res = await api.post(BASE, data);
  return res.data.data;
};

export const updateIbu = async (id, data) => {
  const res = await api.put(`${BASE}/${id}`, data);
  return res.data.data;
};

export const deleteIbu = async (id) => {
  const res = await api.delete(`${BASE}/${id}`);
  return res.data;
};
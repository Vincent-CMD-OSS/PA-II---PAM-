// src/services/Anak.js
import api from "./api";

const BASE = "/tenaga-kesehatan/anak";

export const getAnak = async () => {
  const res = await api.get(BASE);
  return res.data;
};

export const createAnak = async (data) => {
  const res = await api.post(BASE, data);
  return res.data;
};

export const updateAnak = async (id, data) => {
  const res = await api.put(`${BASE}/${id}`, data);
  return res.data;
};

export const getAnakById = async (id) => {
  const res = await api.get(`${BASE}/${id}`);
  return res.data;
};

export const deleteAnak = async (id) => {
  const res = await api.delete(`${BASE}/${id}`);
  return res.data;
};
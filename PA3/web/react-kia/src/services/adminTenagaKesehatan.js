import api from "./api";

const normalizeMessage = (message) => {
  if (Array.isArray(message)) {
    return message.join(", ");
  }
  return message || "";
};

export const adminTenagaErrorMessage = (error, fallbackMessage = "Terjadi kesalahan") => {
  const message = error?.response?.data?.message;
  const normalized = normalizeMessage(message);
  return normalized || fallbackMessage;
};

export const listEligiblePendudukAdmin = async (params = {}) => {
  const response = await api.get("/admin/penduduk/eligible", { params });
  return response.data;
};

export const listPosyanduAdmin = async (params = {}) => {
  const response = await api.get("/admin/posyandu", { params });
  return response.data;
};

export const createPosyanduAdmin = async (payload) => {
  const response = await api.post("/admin/posyandu", payload);
  return response.data;
};

export const listBidanAdmin = async (params = {}) => {
  const response = await api.get("/admin/bidan", { params });
  return response.data;
};

export const createBidanAdmin = async (payload) => {
  const response = await api.post("/admin/bidan", payload);
  return response.data;
};

export const updateBidanAdmin = async (id, payload) => {
  const response = await api.put(`/admin/bidan/${id}`, payload);
  return response.data;
};

export const updateStatusBidanAdmin = async (id, status) => {
  const response = await api.patch(`/admin/bidan/${id}/status`, { status });
  return response.data;
};

export const createAkunBidanAdmin = async (id, payload) => {
  const response = await api.post(`/admin/bidan/${id}/akun`, payload);
  return response.data;
};

export const listKaderAdmin = async (params = {}) => {
  const response = await api.get("/admin/kader", { params });
  return response.data;
};

export const createKaderAdmin = async (payload) => {
  const response = await api.post("/admin/kader", payload);
  return response.data;
};

export const updateKaderAdmin = async (id, payload) => {
  const response = await api.put(`/admin/kader/${id}`, payload);
  return response.data;
};

export const updateStatusKaderAdmin = async (id, status) => {
  const response = await api.patch(`/admin/kader/${id}/status`, { status });
  return response.data;
};

export const createAkunKaderAdmin = async (id, payload) => {
  const response = await api.post(`/admin/kader/${id}/akun`, payload);
  return response.data;
};

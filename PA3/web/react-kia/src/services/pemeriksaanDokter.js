import api from "./api";

const BASE_DOKTER_T1 = "/tenaga-kesehatan/pemeriksaan-dokter-t1";
const BASE_DOKTER_T3 = "/tenaga-kesehatan/pemeriksaan-dokter-t3";
const BASE_LANJUTAN_T3 = "/tenaga-kesehatan/pemeriksaan-lanjutan-t3";
const BASE_LAB_JIWA = "/tenaga-kesehatan/pemeriksaan-lab-jiwa";

// ==================== PEMERIKSAAN DOKTER TRIMESTER 1 ====================
export const getDokterT1ByKehamilanId = async (kehamilanId) => {
  const res = await api.get(`${BASE_DOKTER_T1}?kehamilan_id=${kehamilanId}`);
  return res.data.data;
};
export const createDokterT1 = async (data) => {
  const res = await api.post(BASE_DOKTER_T1, data);
  return res.data.data;
};
export const updateDokterT1 = async (id, data) => {
  const res = await api.put(`${BASE_DOKTER_T1}/${id}`, data);
  return res.data.data;
};

// ==================== PEMERIKSAAN DOKTER TRIMESTER 3 ====================
export const getDokterT3ByKehamilanId = async (kehamilanId) => {
  const res = await api.get(`${BASE_DOKTER_T3}?kehamilan_id=${kehamilanId}`);
  return res.data.data;
};
export const createDokterT3 = async (data) => {
  const res = await api.post(BASE_DOKTER_T3, data);
  return res.data.data;
};
export const updateDokterT3 = async (id, data) => {
  const res = await api.put(`${BASE_DOKTER_T3}/${id}`, data);
  return res.data.data;
};

// ==================== PEMERIKSAAN LANJUTAN TRIMESTER 3 ====================
export const getLanjutanT3ByKehamilanId = async (kehamilanId) => {
  const res = await api.get(`${BASE_LANJUTAN_T3}?kehamilan_id=${kehamilanId}`);
  return res.data.data;
};
export const createLanjutanT3 = async (data) => {
  const res = await api.post(BASE_LANJUTAN_T3, data);
  return res.data.data;
};
export const updateLanjutanT3 = async (id, data) => {
  const res = await api.put(`${BASE_LANJUTAN_T3}/${id}`, data);
  return res.data.data;
};

// ==================== PEMERIKSAAN LABORATORIUM & JIWA ====================
export const getLabJiwaByKehamilanId = async (kehamilanId) => {
  const res = await api.get(`${BASE_LAB_JIWA}?kehamilan_id=${kehamilanId}`);
  return res.data.data;
};
export const createLabJiwa = async (data) => {
  const res = await api.post(BASE_LAB_JIWA, data);
  return res.data.data;
};
export const updateLabJiwa = async (id, data) => {
  const res = await api.put(`${BASE_LAB_JIWA}/${id}`, data);
  return res.data.data;
};

import api from "./api";

const BASE_RENCANA = "/tenaga-kesehatan/rencana-persalinan";
const BASE_RINGKASAN = "/tenaga-kesehatan/ringkasan-persalinan";
const BASE_RIWAYAT = "/tenaga-kesehatan/riwayat-proses-melahirkan";
const BASE_KETERANGAN = "/tenaga-kesehatan/keterangan-lahir";

export const getRencanaByKehamilanId = async (kehamilanId) => {
  const res = await api.get(`${BASE_RENCANA}?kehamilan_id=${kehamilanId}`);
  return res.data.data;
};
export const createRencana = async (data) => {
  const res = await api.post(BASE_RENCANA, data);
  return res.data.data;
};
export const updateRencana = async (id, data) => {
  const res = await api.put(`${BASE_RENCANA}/${id}`, data);
  return res.data.data;
};

export const getRingkasanByKehamilanId = async (kehamilanId) => {
  const res = await api.get(`${BASE_RINGKASAN}?kehamilan_id=${kehamilanId}`);
  return res.data.data;
};
export const createRingkasan = async (data) => {
  const res = await api.post(BASE_RINGKASAN, data);
  return res.data.data;
};

export const getRiwayatByKehamilanId = async (kehamilanId) => {
  const res = await api.get(`${BASE_RIWAYAT}?kehamilan_id=${kehamilanId}`);
  return res.data.data;
};
export const createRiwayat = async (data) => {
  const res = await api.post(BASE_RIWAYAT, data);
  return res.data.data;
};

export const getKeteranganByIbuId = async (ibuId) => {
  const res = await api.get(`${BASE_KETERANGAN}?ibu_id=${ibuId}`);
  return res.data.data;
};
export const createKeterangan = async (data) => {
  const res = await api.post(BASE_KETERANGAN, data);
  return res.data.data;
};
import api from "./api"; // Impor instance axios yang ada interceptor-nya

export const neonatusService = {
  // 1. Ambil jenis pelayanan berdasarkan periode (Metadata Form)
  getJenisPelayanan: async (periodeId) => {
    try {
      const response = await api.get("/tenaga-kesehatan/jenis-pelayanan", {
        params: {
          kategori_umur_id: 1,
          periode_id: periodeId
        }
      });
      return response.data.data;
    } catch (error) {
      throw error.response?.data || error.message;
    }
  },

  // 2. Simpan data pemeriksaan baru (Create)
  savePemeriksaan: async (payload) => {
    try {
      const response = await api.post("/tenaga-kesehatan/Neonatus", payload);
      return response.data;
    } catch (error) {
      throw error.response?.data || error.message;
    }
  },

  // 3. Ambil data pemeriksaan yang sudah ada (Get Detail)
  // Digunakan untuk mengisi kembali form saat ingin edit
 // src/services/Neonatus.js

getPemeriksaanDetail: async (anakId, periodeId) => {
  try {
    const response = await api.get(`/tenaga-kesehatan/Neonatus`, {
      params: { 
        anak_id: anakId, 
        periode_id: periodeId 
      }
    });
    
    // Cek strukturnya: apakah di response.data.data atau langsung di response.data
    const finalData = response.data.data || response.data;
    console.log("📡 [Service] Data dari Server:", finalData);
    return finalData;

  } catch (error) {
    // Jika error 404 (data belum ada), jangan throw error besar, return null saja
    if (error.response?.status === 404) return null;
    throw error.response?.data || error.message;
  }
},
  // 4. Update data pemeriksaan (Edit)
  // Biasanya butuh ID unik dari record pemeriksaan tersebut
  updatePemeriksaan: async (pemeriksaanId, payload) => {
    try {
      const response = await api.put(`/tenaga-kesehatan/Neonatus/${pemeriksaanId}`, payload);
      return response.data;
    } catch (error) {
      throw error.response?.data || error.message;
    }
  }
};
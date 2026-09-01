import axios from 'axios';

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'http://localhost:5285/api',
});

let currentToken = null;

export function setAuthToken(token) {
  currentToken = token;
}

api.interceptors.request.use((config) => {
  if (currentToken) {
    config.headers.Authorization = `Bearer ${currentToken}`;
  }
  return config;
});

export default api;

//JWT token har request ke saath automatically jana chahiye
//warna Task endpoints 401 denge kyunke [Authorize] laga hua hai unpe.
import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:5285/api',
});

export default api;
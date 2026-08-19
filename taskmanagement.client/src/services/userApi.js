import api from './api';

export const getUsers = () => api.get('/users');
export const getCurrentUser = () => api.get('/users/me');
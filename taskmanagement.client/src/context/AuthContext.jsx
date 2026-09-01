import { createContext, useContext, useState } from 'react';
import { setAuthToken } from '../services/api';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [token, setToken] = useState(null);
  const [role, setRole] = useState(null);

  const login = (newToken, newRole) => {
    setToken(newToken);
    setRole(newRole);
    setAuthToken(newToken);
  };

  const logout = () => {
    setToken(null);
    setRole(null);
    setAuthToken(null);
  };

  return (
    <AuthContext.Provider value={{ token, role, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}
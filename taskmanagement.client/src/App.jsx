import { useState } from 'react'
import './App.css';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { useAuth } from './context/AuthContext';
import AdminSetup from './pages/AdminSetup';
import Login from './pages/Login';
import Signup from './pages/Signup';
import ProtectedRoute from './components/ProtectedRoute';
import Navbar from './components/Navbar';


function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/setup" element={<AdminSetup />} />
        <Route path="/login" element={<Login />} />
        <Route path="/signup" element={<Signup />} />
        <Route
          path="/dashboard"
          element={
            <ProtectedRoute>
              <>

                <Navbar />
                <div>Dashboard (coming soon)</div>
              </>

            </ProtectedRoute>

          }
        />
        <Route path="/" element={<Navigate to="/login" />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
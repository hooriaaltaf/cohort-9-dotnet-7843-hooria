import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import Login from './pages/Login';
import Signup from './pages/Signup';
import ProtectedRoute from './components/ProtectedRoute';
import Navbar from './components/Navbar';
import Dashboard from './pages/Dashboard';
import TaskList from './pages/TaskList';
import NewTask from './pages/NewTask';
import TaskDetail from './pages/TaskDetail';
import EditTask from './pages/EditTask';
import Profile from './pages/Profile';
import './App.css';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/signup" element={<Signup />} />

        <Route
          path="/dashboard"
          element={
            <ProtectedRoute>
              <>
                <Navbar />
                <Dashboard />
              </>
            </ProtectedRoute>
          }
        />

        <Route
          path="/tasks"
          element={
            <ProtectedRoute>
              <>
                <Navbar />
                <TaskList />
              </>
            </ProtectedRoute>
          }
        />

        <Route
          path="/tasks/new"
          element={
            <ProtectedRoute>
              <>
                <Navbar />
                <NewTask />
              </>
            </ProtectedRoute>
          }
        />

        <Route
          path="/tasks/:id"
          element={
            <ProtectedRoute>
              <>
                <Navbar />
                <TaskDetail />
              </>
            </ProtectedRoute>
          }
        />

        <Route
          path="/tasks/:id/edit"
          element={
            <ProtectedRoute>
              <>
                <Navbar />
                <EditTask />
              </>
            </ProtectedRoute>
          }
        />

        <Route
  path="/profile"
  element={
    <ProtectedRoute>
      <>
        <Navbar />
        <Profile />
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
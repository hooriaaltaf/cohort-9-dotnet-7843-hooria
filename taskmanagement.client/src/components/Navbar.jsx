import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

export default function Navbar() {
  const { logout } = useAuth();
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  return (
    <nav className="bg-white border-b border-gray-200 px-6 py-3 flex items-center justify-between shadow-sm">
      <div className="flex items-center gap-2">
        <div className="w-7 h-7 bg-indigo-600 rounded-lg flex items-center justify-center">
          <span className="text-white text-xs font-bold">T</span>
        </div>
        <span className="font-semibold text-gray-800 text-base">TaskFlow</span>
      </div>

      <div className="flex items-center gap-6">
        <Link to="/dashboard" className="text-sm text-gray-600 hover:text-indigo-600 font-medium transition-colors">
          Dashboard
        </Link>
        <Link to="/tasks" className="text-sm text-gray-600 hover:text-indigo-600 font-medium transition-colors">
          Tasks
        </Link>
        <Link to="/profile" className="text-sm text-gray-600 hover:text-indigo-600 font-medium transition-colors">
          Profile
        </Link>
        <button
          onClick={handleLogout}
          className="text-sm bg-red-50 text-red-600 hover:bg-red-100 px-3 py-1.5 rounded-lg font-medium transition-colors"
        >
          Logout
        </button>
      </div>
    </nav>
  );
}
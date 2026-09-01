import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { getCurrentUser, getUsers } from '../services/userApi';
import { useAuth } from '../context/AuthContext';

export default function Profile() {
  const { logout, role } = useAuth();
  const navigate = useNavigate();
  const isAdmin = role === 'Admin';

  const [user, setUser] = useState(null);
  const [allUsers, setAllUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    setLoading(true);
    setError('');
    try {
      const userResponse = await getCurrentUser();
      setUser(userResponse.data);
      if (isAdmin) {
        const usersResponse = await getUsers();
        setAllUsers(usersResponse.data);
      }
    } catch (err) {
      setError(err.response?.data?.message || 'Failed to load profile.');
    } finally {
      setLoading(false);
    }
  };

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  if (loading) return (
    <div className="flex items-center justify-center min-h-[200px]">
      <p className="text-gray-500 text-sm">Loading profile...</p>
    </div>
  );

  if (error) return (
    <div className="max-w-2xl mx-auto mt-6">
      <div className="bg-red-50 text-red-600 text-sm px-4 py-3 rounded-lg">{error}</div>
    </div>
  );

  return (
    <div className="max-w-2xl mx-auto px-4 py-6">
      <h2 className="text-xl font-semibold text-gray-900 mb-1">My Profile</h2>
      <p className="text-sm text-gray-500 mb-6">Your account details</p>

      {user && (
        <div className="bg-white border border-gray-200 rounded-2xl p-6 shadow-sm mb-6">
          <div className="flex items-center gap-4 mb-6">
            <div className="w-12 h-12 bg-indigo-100 rounded-full flex items-center justify-center">
              <span className="text-indigo-600 font-semibold text-lg">
                {user.username?.charAt(0).toUpperCase()}
              </span>
            </div>
            <div>
              <p className="font-semibold text-gray-900">{user.username}</p>
              <p className="text-sm text-gray-500">{user.email}</p>
            </div>
            <span className={`ml-auto text-xs font-medium px-2.5 py-1 rounded-full ${
              user.role === 'Admin'
                ? 'bg-purple-100 text-purple-700'
                : 'bg-gray-100 text-gray-600'
            }`}>
              {user.role}
            </span>
          </div>

          <button
            onClick={handleLogout}
            className="w-full bg-red-50 hover:bg-red-100 text-red-600 font-medium py-2 rounded-lg text-sm transition-colors"
          >
            Logout
          </button>
        </div>
      )}

      {isAdmin && allUsers.length > 0 && (
        <div className="bg-white border border-gray-200 rounded-2xl shadow-sm overflow-hidden">
          <div className="px-6 py-4 border-b border-gray-100">
            <h3 className="text-base font-semibold text-gray-800">All Users</h3>
            <p className="text-sm text-gray-500">{allUsers.length} registered users</p>
          </div>
          <div className="divide-y divide-gray-100">
            {allUsers.map((u) => (
              <div key={u.id} className="flex items-center gap-3 px-6 py-3">
                <div className="w-8 h-8 bg-gray-100 rounded-full flex items-center justify-center">
                  <span className="text-gray-600 text-sm font-medium">
                    {u.username?.charAt(0).toUpperCase()}
                  </span>
                </div>
                <div className="flex-1">
                  <p className="text-sm font-medium text-gray-800">{u.username}</p>
                  <p className="text-xs text-gray-500">{u.email}</p>
                </div>
                <span className={`text-xs font-medium px-2 py-0.5 rounded-full ${
                  u.role === 'Admin'
                    ? 'bg-purple-100 text-purple-700'
                    : 'bg-gray-100 text-gray-600'
                }`}>
                  {u.role}
                </span>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
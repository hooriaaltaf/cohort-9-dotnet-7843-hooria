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

  if (loading) return <p>Loading profile...</p>;
  if (error) return <p style={{ color: 'red' }}>{error}</p>;
  if (!user) return null;

  return (
    <div style={{ maxWidth: 600, margin: '20px auto' }}>
      <h2>My Profile</h2>

      <table cellPadding="6" style={{ width: '100%', marginBottom: 20 }}>
        <tbody>
          <tr><td><strong>Username</strong></td><td>{user.username}</td></tr>
          <tr><td><strong>Email</strong></td><td>{user.email}</td></tr>
          <tr><td><strong>Role</strong></td><td>{user.role}</td></tr>
        </tbody>
      </table>

      <button onClick={handleLogout} style={{ marginBottom: 24 }}>Logout</button>

      {isAdmin && (
        <>
          <h3>All Users</h3>
          <table border="1" cellPadding="8" style={{ width: '100%', borderCollapse: 'collapse' }}>
            <thead>
              <tr>
                <th>Username</th>
                <th>Email</th>
                <th>Role</th>
              </tr>
            </thead>
            <tbody>
              {allUsers.map((u) => (
                <tr key={u.id}>
                  <td>{u.username}</td>
                  <td>{u.email}</td>
                  <td>{u.role}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </>
      )}
    </div>
  );
}
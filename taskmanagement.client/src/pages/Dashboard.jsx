import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { getDashboard } from '../services/taskApi';
import { useAuth } from '../context/AuthContext';

export default function Dashboard() {
  const { role } = useAuth();
  const navigate = useNavigate();
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  const isAdmin = role === 'Admin';

  useEffect(() => {
    fetchDashboard();
  }, []);

  const fetchDashboard = async () => {
    setLoading(true);
    setError('');
    try {
      const response = await getDashboard();
      setData(response.data);
    } catch (err) {
      setError(err.response?.data?.message || 'Failed to load dashboard.');
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <p>Loading dashboard...</p>;
  if (error) return <p style={{ color: 'red' }}>{error}</p>;
  if (!data) return null;

  return (
    <div style={{ maxWidth: 700, margin: '20px auto' }}>
      <h2>Dashboard</h2>

      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 12, marginBottom: 24 }}>
        <StatCard label="Pending" value={data.pendingCount} onClick={() => navigate('/tasks?status=Pending')} />
        <StatCard label="In Progress" value={data.inProgressCount} onClick={() => navigate('/tasks?status=InProgress')} />
        <StatCard label="Completed" value={data.completedCount} onClick={() => navigate('/tasks?status=Completed')} />
      </div>

      {isAdmin && (
        <>
          <h3>Admin Overview</h3>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 12 }}>
            <StatCard label="Total Users" value={data.totalUsers} onClick={() => navigate('/profile')} />
            <StatCard label="Total Tasks" value={data.totalTasks} onClick={() => navigate('/tasks')} />
            <StatCard label="Deleted Tasks" value={data.deletedTasksCount} onClick={null} />
          </div>
        </>
      )}
    </div>
  );
}

function StatCard({ label, value, onClick }) {
  return (
    <div
      onClick={onClick || undefined}
      style={{
        border: '1px solid #ddd',
        borderRadius: 8,
        padding: 16,
        textAlign: 'center',
        cursor: onClick ? 'pointer' : 'default',
        transition: 'box-shadow 0.15s',
      }}
      onMouseEnter={(e) => { if (onClick) e.currentTarget.style.boxShadow = '0 2px 8px rgba(0,0,0,0.1)'; }}
      onMouseLeave={(e) => { e.currentTarget.style.boxShadow = 'none'; }}
    >
      <p style={{ fontSize: 13, color: '#666', margin: '0 0 6px' }}>{label}</p>
      <p style={{ fontSize: 24, fontWeight: 600, margin: 0 }}>{value}</p>
    </div>
  );
}
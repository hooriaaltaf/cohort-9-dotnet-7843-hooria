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

  if (loading) return (
    <div className="flex items-center justify-center min-h-[200px]">
      <p className="text-gray-500 text-sm">Loading dashboard...</p>
    </div>
  );

  if (error) return (
    <div className="max-w-2xl mx-auto mt-6">
      <div className="bg-red-50 text-red-600 text-sm px-4 py-3 rounded-lg">{error}</div>
    </div>
  );

  return (
    <div className="max-w-3xl mx-auto px-4 py-6">
      <h2 className="text-xl font-semibold text-gray-900 mb-1">Dashboard</h2>
      <p className="text-sm text-gray-500 mb-6">
        {isAdmin ? 'Organisation-wide overview' : 'Your task summary'}
      </p>

      <div className="grid grid-cols-3 gap-4 mb-8">
        <StatCard
          label="Pending"
          value={data.pendingCount}
          color="bg-yellow-50 border-yellow-200 text-yellow-700"
          onClick={() => navigate('/tasks?status=Pending')}
        />
        <StatCard
          label="In Progress"
          value={data.inProgressCount}
          color="bg-blue-50 border-blue-200 text-blue-700"
          onClick={() => navigate('/tasks?status=InProgress')}
        />
        <StatCard
          label="Completed"
          value={data.completedCount}
          color="bg-green-50 border-green-200 text-green-700"
          onClick={() => navigate('/tasks?status=Completed')}
        />
      </div>

      {isAdmin && (
        <>
          <h3 className="text-base font-semibold text-gray-800 mb-3">Admin Overview</h3>
          <div className="grid grid-cols-3 gap-4">
            <StatCard
              label="Total Users"
              value={data.totalUsers}
              color="bg-indigo-50 border-indigo-200 text-indigo-700"
              onClick={() => navigate('/profile')}
            />
            <StatCard
              label="Total Tasks"
              value={data.totalTasks}
              color="bg-purple-50 border-purple-200 text-purple-700"
              onClick={() => navigate('/tasks')}
            />
            <StatCard
              label="Deleted Tasks"
              value={data.deletedTasksCount}
              color="bg-gray-50 border-gray-200 text-gray-600"
              onClick={null}
            />
          </div>
        </>
      )}
    </div>
  );
}

function StatCard({ label, value, color, onClick }) {
  return (
    <div
      onClick={onClick || undefined}
      className={`border rounded-xl p-5 text-center ${color} ${onClick ? 'cursor-pointer hover:shadow-md transition-shadow' : ''}`}
    >
      <p className="text-xs font-medium uppercase tracking-wide mb-2 opacity-70">{label}</p>
      <p className="text-3xl font-bold">{value}</p>
    </div>
  );
}
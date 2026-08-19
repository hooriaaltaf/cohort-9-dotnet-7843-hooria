import { useEffect, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { getTasks } from '../services/taskApi';

const statusOptions = ['Pending', 'InProgress', 'Completed'];

export default function TaskList() {
  const [tasks, setTasks] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [searchText, setSearchText] = useState('');
  const navigate = useNavigate();
  const [searchParams, setSearchParams] = useSearchParams();
  const statusFilter = searchParams.get('status') || '';

  useEffect(() => {
    fetchTasks();
  }, []);

  const fetchTasks = async () => {
    setLoading(true);
    setError('');
    try {
      const response = await getTasks();
      setTasks(response.data);
    } catch (err) {
      setError(err.response?.data?.message || 'Failed to load tasks.');
    } finally {
      setLoading(false);
    }
  };

  const handleStatusChange = (e) => {
    const value = e.target.value;
    if (value) {
      setSearchParams({ status: value });
    } else {
      setSearchParams({});
    }
  };

  const clearFilters = () => {
    setSearchParams({});
    setSearchText('');
  };

  if (loading) return (
    <div className="flex items-center justify-center min-h-[200px]">
      <p className="text-gray-500 text-sm">Loading tasks...</p>
    </div>
  );

  if (error) return (
    <div className="max-w-4xl mx-auto mt-6">
      <div className="bg-red-50 text-red-600 text-sm px-4 py-3 rounded-lg">{error}</div>
    </div>
  );

  const filteredTasks = tasks
    .filter((t) => (statusFilter ? t.status === statusFilter : true))
    .filter((t) => t.assignedToUsername.toLowerCase().includes(searchText.toLowerCase()));

  return (
    <div className="max-w-5xl mx-auto px-4 py-6">
      <div className="flex items-center justify-between mb-4">
        <div>
          <h2 className="text-xl font-semibold text-gray-900">My Tasks</h2>
          <p className="text-sm text-gray-500">Manage and track your tasks</p>
        </div>
        <button
          onClick={() => navigate('/tasks/new')}
          className="bg-indigo-600 hover:bg-indigo-700 text-white text-sm font-medium px-4 py-2 rounded-lg transition-colors"
        >
          + New Task
        </button>
      </div>

      <div className="flex gap-3 mb-4">
        <input
          type="text"
          placeholder="Search by assigned username..."
          value={searchText}
          onChange={(e) => setSearchText(e.target.value)}
          className="flex-1 border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
        />
        <select
          value={statusFilter}
          onChange={handleStatusChange}
          className="border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
        >
          <option value="">All statuses</option>
          {statusOptions.map((s) => (
            <option key={s} value={s}>{s}</option>
          ))}
        </select>
        {(statusFilter || searchText) && (
          <button
            onClick={clearFilters}
            className="text-sm text-gray-500 hover:text-gray-700 border border-gray-300 rounded-lg px-3 py-2 transition-colors"
          >
            Clear
          </button>
        )}
      </div>

      {filteredTasks.length === 0 ? (
        <div className="text-center py-16 text-gray-400">
          {statusFilter || searchText
            ? <p className="text-sm">No tasks match your filters.</p>
            : (
              <div>
                <p className="text-lg font-medium text-gray-500 mb-1">No tasks yet</p>
                <p className="text-sm">You don't have any tasks. Click <strong>+ New Task</strong> to get started.</p>
              </div>
            )
          }
        </div>
      ) : (
        <div className="overflow-x-auto rounded-xl border border-gray-200">
          <table className="w-full text-sm">
            <thead className="bg-gray-50 border-b border-gray-200">
              <tr>
                {['Title', 'Status', 'Priority', 'Category', 'Due Date', 'Assigned To', ''].map((h) => (
                  <th key={h} className="text-left px-4 py-3 text-xs font-medium text-gray-500 uppercase tracking-wide">
                    {h}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {filteredTasks.map((task) => (
                <tr key={task.id} className="hover:bg-gray-50 transition-colors">
                  <td className="px-4 py-3 font-medium text-gray-800">{task.title}</td>
                  <td className="px-4 py-3">
                    <StatusBadge status={task.status} />
                  </td>
                  <td className="px-4 py-3">
                    <PriorityBadge priority={task.priority} />
                  </td>
                  <td className="px-4 py-3 text-gray-600">{task.categoryName}</td>
                  <td className="px-4 py-3 text-gray-600">{new Date(task.dueDate).toLocaleDateString()}</td>
                  <td className="px-4 py-3 text-gray-600">{task.assignedToUsername}</td>
                  <td className="px-4 py-3">
                    <button
                      onClick={() => navigate(`/tasks/${task.id}`)}
                      className="text-indigo-600 hover:text-indigo-800 text-sm font-medium"
                    >
                      View →
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}

function StatusBadge({ status }) {
  const colors = {
    Pending: 'bg-yellow-100 text-yellow-700',
    InProgress: 'bg-blue-100 text-blue-700',
    Completed: 'bg-green-100 text-green-700',
  };
  return (
    <span className={`text-xs font-medium px-2 py-1 rounded-full ${colors[status] || 'bg-gray-100 text-gray-600'}`}>
      {status}
    </span>
  );
}

function PriorityBadge({ priority }) {
  const colors = {
    Low: 'bg-gray-100 text-gray-600',
    Medium: 'bg-orange-100 text-orange-700',
    High: 'bg-red-100 text-red-700',
  };
  return (
    <span className={`text-xs font-medium px-2 py-1 rounded-full ${colors[priority] || 'bg-gray-100 text-gray-600'}`}>
      {priority}
    </span>
  );
}
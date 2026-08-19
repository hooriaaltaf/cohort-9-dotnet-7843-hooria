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

  if (loading) return <p>Loading tasks...</p>;
  if (error) return <p style={{ color: 'red' }}>{error}</p>;

  const filteredTasks = tasks
    .filter((t) => (statusFilter ? t.status === statusFilter : true))
    .filter((t) => t.assignedToUsername.toLowerCase().includes(searchText.toLowerCase()));

  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 16 }}>
        <h2>My Tasks</h2>
        <button onClick={() => navigate('/tasks/new')}>+ New Task</button>
      </div>

      <div style={{ display: 'flex', gap: 12, alignItems: 'center', marginBottom: 16 }}>
        <input
          type="text"
          placeholder="Search by username..."
          value={searchText}
          onChange={(e) => setSearchText(e.target.value)}
          style={{ padding: 6, flex: 1 }}
        />

        <select value={statusFilter} onChange={handleStatusChange} style={{ padding: 6 }}>
          <option value="">All statuses</option>
          {statusOptions.map((s) => (
            <option key={s} value={s}>{s}</option>
          ))}
        </select>

        {(statusFilter || searchText) && (
          <button onClick={clearFilters}>Clear filters</button>
        )}
      </div>

      {filteredTasks.length === 0 ? (
        <p>No tasks match your filters.</p>
      ) : (
        <table border="1" cellPadding="8" style={{ width: '100%', borderCollapse: 'collapse' }}>
          <thead>
            <tr>
              <th>Title</th>
              <th>Status</th>
              <th>Priority</th>
              <th>Category</th>
              <th>Due Date</th>
              <th>Assigned To</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {filteredTasks.map((task) => (
              <tr key={task.id}>
                <td>{task.title}</td>
                <td>{task.status}</td>
                <td>{task.priority}</td>
                <td>{task.categoryName}</td>
                <td>{new Date(task.dueDate).toLocaleDateString()}</td>
                <td>{task.assignedToUsername}</td>
                <td>
                  <button onClick={() => navigate(`/tasks/${task.id}`)}>View</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}
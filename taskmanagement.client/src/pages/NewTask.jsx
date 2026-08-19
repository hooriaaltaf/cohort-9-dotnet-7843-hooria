import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { createTask, getCategories } from '../services/taskApi';
import { getUsers } from '../services/userApi';
import { useAuth } from '../context/AuthContext';

export default function NewTask() {
  const navigate = useNavigate();
  const { role } = useAuth();

  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [priority, setPriority] = useState(1);
  const [categoryId, setCategoryId] = useState('');
  const [dueDate, setDueDate] = useState('');
  const [assignedToUserId, setAssignedToUserId] = useState('');

  const [categories, setCategories] = useState([]);
  const [users, setUsers] = useState([]);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);

  const isAdmin = role === 'Admin';

  useEffect(() => {
    loadFormData();
  }, []);

  const loadFormData = async () => {
    try {
      const catResponse = await getCategories();
      setCategories(catResponse.data);
      if (catResponse.data.length > 0) {
        setCategoryId(catResponse.data[0].id);
      }

      if (isAdmin) {
        const userResponse = await getUsers();
        setUsers(userResponse.data);
      }
    } catch (err) {
      setError('Failed to load form data.');
    } finally {
      setLoading(false);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');

    const payload = {
      title,
      description,
      priority: Number(priority),
      categoryId: Number(categoryId),
      dueDate,
      ...(isAdmin && assignedToUserId ? { assignedToUserId: Number(assignedToUserId) } : {}),
    };

    try {
      await createTask(payload);
      navigate('/dashboard');
    } catch (err) {
      setError(err.response?.data?.message || 'Failed to create task.');
    }
  };

  if (loading) return <p>Loading form...</p>;

  return (
    <div style={{ maxWidth: 480, margin: '20px auto' }}>
      <h2>New Task</h2>
      {error && <p style={{ color: 'red' }}>{error}</p>}

      <form onSubmit={handleSubmit}>
        <div style={{ marginBottom: 12 }}>
          <label>Title</label>
          <input
            type="text"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            required
            style={{ width: '100%' }}
          />
        </div>

        <div style={{ marginBottom: 12 }}>
          <label>Description</label>
          <textarea
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            style={{ width: '100%', minHeight: 70 }}
          />
        </div>

        <div style={{ display: 'flex', gap: 12, marginBottom: 12 }}>
          <div style={{ flex: 1 }}>
            <label>Priority</label>
            <select value={priority} onChange={(e) => setPriority(e.target.value)} style={{ width: '100%' }}>
              <option value={0}>Low</option>
              <option value={1}>Medium</option>
              <option value={2}>High</option>
            </select>
          </div>

          <div style={{ flex: 1 }}>
            <label>Category</label>
            <select value={categoryId} onChange={(e) => setCategoryId(e.target.value)} style={{ width: '100%' }}>
              {categories.map((cat) => (
                <option key={cat.id} value={cat.id}>{cat.name}</option>
              ))}
            </select>
          </div>
        </div>

        <div style={{ marginBottom: 12 }}>
          <label>Due Date</label>
          <input
            type="date"
            value={dueDate}
            onChange={(e) => setDueDate(e.target.value)}
            required
            style={{ width: '100%' }}
          />
        </div>

        {isAdmin && (
          <div style={{ marginBottom: 16, padding: 10, background: '#f0f0ff', borderRadius: 6 }}>
            <label>Assign to (Admin only)</label>
            <select
              value={assignedToUserId}
              onChange={(e) => setAssignedToUserId(e.target.value)}
              style={{ width: '100%' }}
            >
              <option value="">Myself</option>
              {users.map((u) => (
                <option key={u.id} value={u.id}>{u.username}</option>
              ))}
            </select>
          </div>
        )}

        <div style={{ display: 'flex', gap: 10, justifyContent: 'flex-end' }}>
          <button type="button" onClick={() => navigate('/dashboard')}>Cancel</button>
          <button type="submit">Create Task</button>
        </div>
      </form>
    </div>
  );
}
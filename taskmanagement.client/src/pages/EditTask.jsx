import { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { getTaskById, updateTask, getCategories } from '../services/taskApi';

const statusOptions = [
  { value: 0, label: 'Pending' },
  { value: 1, label: 'InProgress' },
  { value: 2, label: 'Completed' },
];

const priorityOptions = [
  { value: 0, label: 'Low' },
  { value: 1, label: 'Medium' },
  { value: 2, label: 'High' },
];

export default function EditTask() {
  const { id } = useParams();
  const navigate = useNavigate();

  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [status, setStatus] = useState(0);
  const [priority, setPriority] = useState(1);
  const [categoryId, setCategoryId] = useState('');
  const [dueDate, setDueDate] = useState('');

  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    loadData();
  }, [id]);

  const loadData = async () => {
    setLoading(true);
    setError('');
    try {
      const [taskResponse, catResponse] = await Promise.all([
        getTaskById(id),
        getCategories(),
      ]);

      const task = taskResponse.data;
      setTitle(task.title);
      setDescription(task.description);
      setStatus(statusOptions.find(s => s.label === task.status)?.value ?? 0);
      setPriority(priorityOptions.find(p => p.label === task.priority)?.value ?? 1);
      setDueDate(task.dueDate.split('T')[0]);

      setCategories(catResponse.data);
      const matchedCategory = catResponse.data.find(c => c.name === task.categoryName);
      setCategoryId(matchedCategory ? matchedCategory.id : catResponse.data[0]?.id ?? '');
    } catch (err) {
      setError(err.response?.data?.message || 'Failed to load task.');
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
      status: Number(status),
      priority: Number(priority),
      categoryId: Number(categoryId),
      dueDate,
    };

    try {
      await updateTask(id, payload);
      navigate(`/tasks/${id}`);
    } catch (err) {
      setError(err.response?.data?.message || 'Failed to update task.');
    }
  };

  if (loading) return <p>Loading task...</p>;

  return (
    <div style={{ maxWidth: 480, margin: '20px auto' }}>
      <h2>Edit Task</h2>
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
            <label>Status</label>
            <select value={status} onChange={(e) => setStatus(e.target.value)} style={{ width: '100%' }}>
              {statusOptions.map(s => (
                <option key={s.value} value={s.value}>{s.label}</option>
              ))}
            </select>
          </div>

          <div style={{ flex: 1 }}>
            <label>Priority</label>
            <select value={priority} onChange={(e) => setPriority(e.target.value)} style={{ width: '100%' }}>
              {priorityOptions.map(p => (
                <option key={p.value} value={p.value}>{p.label}</option>
              ))}
            </select>
          </div>
        </div>

        <div style={{ marginBottom: 12 }}>
          <label>Category</label>
          <select value={categoryId} onChange={(e) => setCategoryId(e.target.value)} style={{ width: '100%' }}>
            {categories.map((cat) => (
              <option key={cat.id} value={cat.id}>{cat.name}</option>
            ))}
          </select>
        </div>

        <div style={{ marginBottom: 16 }}>
          <label>Due Date</label>
          <input
            type="date"
            value={dueDate}
            onChange={(e) => setDueDate(e.target.value)}
            required
            style={{ width: '100%' }}
          />
        </div>

        <div style={{ display: 'flex', gap: 10, justifyContent: 'flex-end' }}>
          <button type="button" onClick={() => navigate(`/tasks/${id}`)}>Cancel</button>
          <button type="submit">Save Changes</button>
        </div>
      </form>
    </div>
  );
}
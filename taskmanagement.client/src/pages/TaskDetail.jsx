import { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { getTaskById, deleteTask } from '../services/taskApi';
import { useAuth } from '../context/AuthContext';

export default function TaskDetail() {
  const { id } = useParams();
  const navigate = useNavigate();
  const { role } = useAuth();

  const [task, setTask] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    fetchTask();
  }, [id]);

  const fetchTask = async () => {
    setLoading(true);
    setError('');
    try {
      const response = await getTaskById(id);
      setTask(response.data);
    } catch (err) {
      setError(err.response?.data?.message || 'Failed to load task.');
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async () => {
    if (!window.confirm('Are you sure you want to delete this task?')) return;
    try {
      await deleteTask(id);
      navigate('/dashboard');
    } catch (err) {
      setError(err.response?.data?.message || 'Failed to delete task.');
    }
  };

  if (loading) return <p>Loading task...</p>;
  if (error) return <p style={{ color: 'red' }}>{error}</p>;
  if (!task) return null;

  return (
    <div style={{ maxWidth: 500, margin: '20px auto' }}>
      <button onClick={() => navigate('/tasks')}>← Back to tasks</button>

      <h2>{task.title}</h2>
      <p style={{ color: '#555' }}>{task.description}</p>

      <table cellPadding="6" style={{ width: '100%', marginTop: 16 }}>
        <tbody>
          <tr><td><strong>Status</strong></td><td>{task.status}</td></tr>
          <tr><td><strong>Priority</strong></td><td>{task.priority}</td></tr>
          <tr><td><strong>Category</strong></td><td>{task.categoryName}</td></tr>
          <tr><td><strong>Due Date</strong></td><td>{new Date(task.dueDate).toLocaleDateString()}</td></tr>
          <tr><td><strong>Assigned To</strong></td><td>{task.assignedToUsername}</td></tr>
          <tr><td><strong>Created By</strong></td><td>{task.createdByUsername}</td></tr>
        </tbody>
      </table>

      <div style={{ display: 'flex', gap: 10, marginTop: 20 }}>
        <button onClick={() => navigate(`/tasks/${id}/edit`)}>Edit</button>
        <button onClick={handleDelete} style={{ color: 'red' }}>Delete</button>
      </div>
    </div>
  );
}
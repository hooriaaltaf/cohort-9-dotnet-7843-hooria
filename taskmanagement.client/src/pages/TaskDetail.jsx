import { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { getTaskById, deleteTask } from '../services/taskApi';

export default function TaskDetail() {
  const { id } = useParams();
  const navigate = useNavigate();
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
      navigate('/tasks');
    } catch (err) {
      setError(err.response?.data?.message || 'Failed to delete task.');
    }
  };

  if (loading) return (
    <div className="flex items-center justify-center min-h-[200px]">
      <p className="text-gray-500 text-sm">Loading task...</p>
    </div>
  );

  if (error) return (
    <div className="max-w-xl mx-auto mt-6">
      <div className="bg-red-50 text-red-600 text-sm px-4 py-3 rounded-lg">{error}</div>
    </div>
  );

  if (!task) return null;

  return (
    <div className="max-w-xl mx-auto px-4 py-6">
      <button
        onClick={() => navigate('/tasks')}
        className="text-sm text-gray-500 hover:text-gray-700 mb-4 flex items-center gap-1"
      >
        ← Back to tasks
      </button>

      <div className="bg-white border border-gray-200 rounded-2xl p-6 shadow-sm">
        <h2 className="text-xl font-semibold text-gray-900 mb-1">{task.title}</h2>
        <p className="text-sm text-gray-500 mb-6">{task.description}</p>

        <div className="grid grid-cols-2 gap-4 text-sm">
          <DetailRow label="Status" value={task.status} />
          <DetailRow label="Priority" value={task.priority} />
          <DetailRow label="Category" value={task.categoryName} />
          <DetailRow label="Due Date" value={new Date(task.dueDate).toLocaleDateString()} />
          <DetailRow label="Assigned To" value={task.assignedToUsername} />
          <DetailRow label="Created By" value={task.createdByUsername} />
        </div>

        <div className="flex gap-3 mt-6 pt-4 border-t border-gray-100">
          <button
            onClick={() => navigate(`/tasks/${id}/edit`)}
            className="flex-1 border border-gray-300 text-gray-700 hover:bg-gray-50 font-medium py-2 rounded-lg text-sm transition-colors"
          >
            Edit
          </button>
          <button
            onClick={handleDelete}
            className="flex-1 bg-red-50 text-red-600 hover:bg-red-100 font-medium py-2 rounded-lg text-sm transition-colors"
          >
            Delete
          </button>
        </div>
      </div>
    </div>
  );
}

function DetailRow({ label, value }) {
  return (
    <div className="bg-gray-50 rounded-lg px-3 py-2">
      <p className="text-xs text-gray-400 font-medium uppercase tracking-wide mb-0.5">{label}</p>
      <p className="text-gray-800 font-medium">{value}</p>
    </div>
  );
}
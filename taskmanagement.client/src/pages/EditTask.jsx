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

  if (loading) return (
    <div className="flex items-center justify-center min-h-[200px]">
      <p className="text-gray-500 text-sm">Loading task...</p>
    </div>
  );

  return (
    <div className="max-w-lg mx-auto px-4 py-6">
      <button
        onClick={() => navigate(`/tasks/${id}`)}
        className="text-sm text-gray-500 hover:text-gray-700 mb-4 flex items-center gap-1"
      >
        ← Back to task
      </button>

      <div className="bg-white border border-gray-200 rounded-2xl p-6 shadow-sm">
        <h2 className="text-xl font-semibold text-gray-900 mb-1">Edit Task</h2>
        <p className="text-sm text-gray-500 mb-6">Update the task details</p>

        {error && (
          <div className="bg-red-50 text-red-600 text-sm px-3 py-2 rounded-lg mb-4">{error}</div>
        )}

        <form onSubmit={handleSubmit} className="flex flex-col gap-4">
          <FormField label="Title">
            <input
              type="text"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              required
              className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
            />
          </FormField>

          <FormField label="Description">
            <textarea
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 min-h-[80px] resize-none"
            />
          </FormField>

          <div className="grid grid-cols-2 gap-4">
            <FormField label="Status">
              <select
                value={status}
                onChange={(e) => setStatus(e.target.value)}
                className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
              >
                {statusOptions.map(s => (
                  <option key={s.value} value={s.value}>{s.label}</option>
                ))}
              </select>
            </FormField>

            <FormField label="Priority">
              <select
                value={priority}
                onChange={(e) => setPriority(e.target.value)}
                className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
              >
                {priorityOptions.map(p => (
                  <option key={p.value} value={p.value}>{p.label}</option>
                ))}
              </select>
            </FormField>
          </div>

          <FormField label="Category">
            <select
              value={categoryId}
              onChange={(e) => setCategoryId(e.target.value)}
              className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
            >
              {categories.map((cat) => (
                <option key={cat.id} value={cat.id}>{cat.name}</option>
              ))}
            </select>
          </FormField>

          <FormField label="Due Date">
            <input
              type="date"
              value={dueDate}
              onChange={(e) => setDueDate(e.target.value)}
              required
              className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
            />
          </FormField>

          <div className="flex gap-3 pt-2">
            <button
              type="button"
              onClick={() => navigate(`/tasks/${id}`)}
              className="flex-1 border border-gray-300 text-gray-700 hover:bg-gray-50 font-medium py-2 rounded-lg text-sm transition-colors"
            >
              Cancel
            </button>
            <button
              type="submit"
              className="flex-1 bg-indigo-600 hover:bg-indigo-700 text-white font-medium py-2 rounded-lg text-sm transition-colors"
            >
              Save Changes
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

function FormField({ label, children }) {
  return (
    <div>
      <label className="block text-sm font-medium text-gray-700 mb-1">{label}</label>
      {children}
    </div>
  );
}
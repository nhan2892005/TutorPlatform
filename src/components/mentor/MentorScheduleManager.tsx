"use client";

import { useState, useEffect } from 'react';
import { Calendar, Clock, Plus, Trash2, Edit2, X, Check } from 'lucide-react';
import toast from 'react-hot-toast';

interface Schedule {
  id: number;
  date: string;
  startTime: string;
  endTime: string;
  dayOfWeek: string;
}

const MentorScheduleManager = () => {
  const [schedules, setSchedules] = useState<Schedule[]>([]);
  const [loading, setLoading] = useState(true);
  const [showAddForm, setShowAddForm] = useState(false);
  const [editingId, setEditingId] = useState<number | null>(null);
  const [savingId, setSavingId] = useState<number | null>(null);
  const [deletingId, setDeletingId] = useState<number | null>(null);

  const [formData, setFormData] = useState({
    date: '',
    startTime: '09:00',
    endTime: '10:00'
  });

  const [editForm, setEditForm] = useState({
    startTime: '09:00',
    endTime: '10:00'
  });

  // Fetch schedules on mount
  useEffect(() => {
    loadSchedules();
  }, []);

  const loadSchedules = async () => {
    try {
      setLoading(true);
      const res = await fetch('/api/mentor/schedule');
      
      if (!res.ok) {
        const error = await res.json();
        throw new Error(error.error || 'Failed to load schedules');
      }

      const data = await res.json();
      setSchedules(data.schedules || []);
    } catch (error) {
      console.error('Error loading schedules:', error);
      toast.error((error as any)?.message || 'Lỗi khi tải lịch');
    } finally {
      setLoading(false);
    }
  };

  const handleAddSchedule = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!formData.date || !formData.startTime || !formData.endTime) {
      toast.error('Vui lòng điền đầy đủ thông tin');
      return;
    }

    if (formData.startTime >= formData.endTime) {
      toast.error('Thời gian bắt đầu phải nhỏ hơn thời gian kết thúc');
      return;
    }

    try {
      setSavingId(-1);
      const res = await fetch('/api/mentor/schedule', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          date: formData.date,
          startTime: formData.startTime,
          endTime: formData.endTime
        })
      });

      const data = await res.json();

      if (!res.ok) {
        throw new Error(data.error || 'Failed to add schedule');
      }

      toast.success('Thêm lịch thành công!');
      setFormData({ date: '', startTime: '09:00', endTime: '10:00' });
      setShowAddForm(false);
      await loadSchedules();
    } catch (error) {
      console.error('Error adding schedule:', error);
      toast.error((error as any)?.message || 'Lỗi khi thêm lịch');
    } finally {
      setSavingId(null);
    }
  };

  const handleUpdateSchedule = async (scheduleId: number) => {
    if (!editForm.startTime || !editForm.endTime) {
      toast.error('Vui lòng điền đầy đủ thông tin');
      return;
    }

    if (editForm.startTime >= editForm.endTime) {
      toast.error('Thời gian bắt đầu phải nhỏ hơn thời gian kết thúc');
      return;
    }

    try {
      setSavingId(scheduleId);
      const res = await fetch(`/api/mentor/schedule/${scheduleId}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          startTime: editForm.startTime,
          endTime: editForm.endTime
        })
      });

      const data = await res.json();

      if (!res.ok) {
        throw new Error(data.error || 'Failed to update schedule');
      }

      toast.success('Cập nhật lịch thành công!');
      setEditingId(null);
      await loadSchedules();
    } catch (error) {
      console.error('Error updating schedule:', error);
      toast.error((error as any)?.message || 'Lỗi khi cập nhật lịch');
    } finally {
      setSavingId(null);
    }
  };

  const handleDeleteSchedule = async (scheduleId: number) => {
    if (!confirm('Bạn chắc chắn muốn xóa lịch này?')) {
      return;
    }

    try {
      setDeletingId(scheduleId);
      const res = await fetch(`/api/mentor/schedule/${scheduleId}`, {
        method: 'DELETE'
      });

      const data = await res.json();

      if (!res.ok) {
        throw new Error(data.error || 'Failed to delete schedule');
      }

      toast.success('Xóa lịch thành công!');
      await loadSchedules();
    } catch (error) {
      console.error('Error deleting schedule:', error);
      toast.error((error as any)?.message || 'Lỗi khi xóa lịch');
    } finally {
      setDeletingId(null);
    }
  };

  const startEditingSchedule = (schedule: Schedule) => {
    setEditingId(schedule.id);
    setEditForm({
      startTime: schedule.startTime.substring(0, 5),
      endTime: schedule.endTime.substring(0, 5)
    });
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center p-8">
        <div className="animate-spin">
          <Clock className="h-8 w-8 text-blue-600" />
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-4xl mx-auto p-6">
      <div className="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-6">
        {/* Header */}
        <div className="flex items-center justify-between mb-6">
          <div className="flex items-center space-x-3">
            <Calendar className="h-8 w-8 text-blue-600" />
            <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
              Quản lý lịch làm việc
            </h1>
          </div>
          {!showAddForm && (
            <button
              onClick={() => setShowAddForm(true)}
              className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg flex items-center gap-2 transition-colors"
            >
              <Plus className="h-4 w-4" />
              Thêm lịch
            </button>
          )}
        </div>

        {/* Add Form */}
        {showAddForm && (
          <div className="mb-6 p-4 bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800 rounded-lg">
            <h2 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
              Thêm lịch làm việc mới
            </h2>
            <form onSubmit={handleAddSchedule} className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                {/* Date */}
                <div>
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                    Ngày <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="date"
                    value={formData.date}
                    onChange={(e) => setFormData({ ...formData, date: e.target.value })}
                    min={new Date().toISOString().split('T')[0]}
                    className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>

                {/* Start Time */}
                <div>
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                    Giờ bắt đầu <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="time"
                    value={formData.startTime}
                    onChange={(e) => setFormData({ ...formData, startTime: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>

                {/* End Time */}
                <div>
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                    Giờ kết thúc <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="time"
                    value={formData.endTime}
                    onChange={(e) => setFormData({ ...formData, endTime: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
              </div>

              <div className="flex gap-2 pt-4">
                <button
                  type="submit"
                  disabled={savingId === -1}
                  className="flex-1 bg-blue-600 hover:bg-blue-700 disabled:bg-blue-400 text-white px-4 py-2 rounded-lg transition-colors disabled:cursor-not-allowed"
                >
                  {savingId === -1 ? 'Đang thêm...' : 'Thêm lịch'}
                </button>
                <button
                  type="button"
                  onClick={() => setShowAddForm(false)}
                  className="flex-1 bg-gray-300 hover:bg-gray-400 dark:bg-gray-600 dark:hover:bg-gray-700 text-gray-900 dark:text-white px-4 py-2 rounded-lg transition-colors"
                >
                  Hủy
                </button>
              </div>
            </form>
          </div>
        )}

        {/* Schedules List */}
        <div className="space-y-3">
          {schedules.length === 0 ? (
            <div className="text-center py-12">
              <Calendar className="h-12 w-12 text-gray-300 dark:text-gray-600 mx-auto mb-3" />
              <p className="text-gray-600 dark:text-gray-400">
                Bạn chưa thiết lập lịch làm việc. Hãy thêm lịch của bạn!
              </p>
            </div>
          ) : (
            schedules.map((schedule) => (
              <div
                key={schedule.id}
                className="flex items-center justify-between p-4 bg-gray-50 dark:bg-gray-700 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-600 transition-colors"
              >
                {editingId === schedule.id ? (
                  // Edit Mode
                  <div className="flex-1 flex items-center gap-4">
                    <div className="flex-1">
                      <p className="text-sm font-medium text-gray-900 dark:text-white">
                        {new Date(schedule.date).toLocaleDateString('vi-VN')} - {schedule.dayOfWeek}
                      </p>
                      <div className="flex items-center gap-3 mt-2">
                        <input
                          type="time"
                          value={editForm.startTime}
                          onChange={(e) => setEditForm({ ...editForm, startTime: e.target.value })}
                          className="px-2 py-1 border border-gray-300 dark:border-gray-600 rounded bg-white dark:bg-gray-600 text-gray-900 dark:text-white"
                        />
                        <span className="text-gray-600 dark:text-gray-400">-</span>
                        <input
                          type="time"
                          value={editForm.endTime}
                          onChange={(e) => setEditForm({ ...editForm, endTime: e.target.value })}
                          className="px-2 py-1 border border-gray-300 dark:border-gray-600 rounded bg-white dark:bg-gray-600 text-gray-900 dark:text-white"
                        />
                      </div>
                    </div>
                    <div className="flex gap-2">
                      <button
                        onClick={() => handleUpdateSchedule(schedule.id)}
                        disabled={savingId === schedule.id}
                        className="p-2 bg-green-600 hover:bg-green-700 disabled:bg-green-400 text-white rounded-lg transition-colors"
                        title="Lưu"
                      >
                        <Check className="h-4 w-4" />
                      </button>
                      <button
                        onClick={() => setEditingId(null)}
                        className="p-2 bg-gray-400 hover:bg-gray-500 text-white rounded-lg transition-colors"
                        title="Hủy"
                      >
                        <X className="h-4 w-4" />
                      </button>
                    </div>
                  </div>
                ) : (
                  // View Mode
                  <>
                    <div className="flex-1">
                      <p className="text-sm font-medium text-gray-900 dark:text-white">
                        {new Date(schedule.date).toLocaleDateString('vi-VN')} - {schedule.dayOfWeek}
                      </p>
                      <div className="flex items-center gap-2 mt-1 text-gray-600 dark:text-gray-400">
                        <Clock className="h-4 w-4" />
                        <span className="text-sm">
                          {schedule.startTime.substring(0, 5)} - {schedule.endTime.substring(0, 5)}
                        </span>
                      </div>
                    </div>
                    <div className="flex gap-2">
                      <button
                        onClick={() => startEditingSchedule(schedule)}
                        className="p-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-colors"
                        title="Chỉnh sửa"
                      >
                        <Edit2 className="h-4 w-4" />
                      </button>
                      <button
                        onClick={() => handleDeleteSchedule(schedule.id)}
                        disabled={deletingId === schedule.id}
                        className="p-2 bg-red-600 hover:bg-red-700 disabled:bg-red-400 text-white rounded-lg transition-colors disabled:cursor-not-allowed"
                        title="Xóa"
                      >
                        <Trash2 className="h-4 w-4" />
                      </button>
                    </div>
                  </>
                )}
              </div>
            ))
          )}
        </div>

        {/* Summary */}
        {schedules.length > 0 && (
          <div className="mt-6 p-4 bg-green-50 dark:bg-green-900/20 border border-green-200 dark:border-green-800 rounded-lg">
            <h3 className="text-sm font-medium text-green-900 dark:text-green-100">
              📅 Tóm tắt lịch làm việc
            </h3>
            <p className="text-sm text-green-800 dark:text-green-200 mt-1">
              Bạn có <strong>{schedules.length}</strong> khung giờ làm việc được thiết lập. 
              Mentee có thể đặt lịch với bạn trong những khung giờ này.
            </p>
          </div>
        )}
      </div>
    </div>
  );
};

export default MentorScheduleManager;

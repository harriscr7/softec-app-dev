import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:softec_project/models/task_model.dart';
import 'package:softec_project/providers/task_provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Task? _draggedTask;

  // Custom calendar format with 2-week option
  CalendarFormat _calendarFormat = CalendarFormat.week;
  final Map<CalendarFormat, String> _availableFormats = {
    CalendarFormat.month: 'Month',
    CalendarFormat.twoWeeks: '2 Weeks',
    CalendarFormat.week: 'Week',
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed:
                () => setState(() {
                  _focusedDay = DateTime.now();
                  _selectedDay = _focusedDay;
                }),
          ),
          // Custom format selector
          PopupMenuButton<CalendarFormat>(
            icon: const Icon(Icons.view_week),
            onSelected: (format) => setState(() => _calendarFormat = format),
            itemBuilder:
                (context) =>
                    _availableFormats.entries.map((entry) {
                      return PopupMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            availableCalendarFormats: _availableFormats,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() => _calendarFormat = format);
            },
            onPageChanged: (focusedDay) => _focusedDay = focusedDay,
            eventLoader:
                (day) =>
                    tasks
                        .where((task) => isSameDay(task.dueDate, day))
                        .toList(),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${events.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
          // Change this in your DragTarget widget
          Expanded(
            child: DragTarget<DateTime>(
              onAcceptWithDetails: (details) {
                if (_draggedTask != null) {
                  _moveTaskToDate(
                    _draggedTask!,
                    details.data,
                  ); // Use details.data to get the DateTime
                }
              },
              builder: (context, candidateData, rejectedData) {
                return _buildTaskListForSelectedDay(tasks);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskListForSelectedDay(List<Task> tasks) {
    if (_selectedDay == null) return const SizedBox();

    final dayTasks =
        tasks.where((task) => isSameDay(task.dueDate, _selectedDay!)).toList();

    return ReorderableListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: dayTasks.length,
      itemBuilder: (context, index) {
        final task = dayTasks[index];
        return LongPressDraggable<Task>(
          key: ValueKey(task.id),
          data: task,
          feedback: Material(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _buildTaskItem(task),
            ),
          ),
          childWhenDragging: Container(),
          onDragStarted: () => setState(() => _draggedTask = task),
          onDragEnd: (_) => setState(() => _draggedTask = null),
          child: _buildTaskItem(task),
        );
      },
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < newIndex) newIndex--;
        final task = dayTasks.removeAt(oldIndex);
        dayTasks.insert(newIndex, task);
      },
    );
  }

  Widget _buildTaskItem(Task task) {
    return Card(
      key: ValueKey(task.id),
      child: ListTile(
        title: Text(task.title),
        subtitle: task.description != null ? Text(task.description!) : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _editTask(task),
            ),
            const Icon(Icons.drag_handle),
          ],
        ),
      ),
    );
  }

  Future<void> _moveTaskToDate(Task task, DateTime newDate) async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final updatedTask = task.copyWith(dueDate: newDate);

    try {
      await taskProvider.updateTask(updatedTask, taskProvider.currentUser!);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Task moved successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to move task: ${e.toString()}')),
      );
    }
  }

  void _editTask(Task task) {
    // Navigate to task edit screen
  }
}

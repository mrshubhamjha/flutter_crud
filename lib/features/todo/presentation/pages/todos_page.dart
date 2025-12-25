import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import '../../domain/entities/todo.dart';

class TodosPage extends StatefulWidget {
  final int userId;

  const TodosPage({super.key, required this.userId});

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  final _todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TodoBloc>().add(const LoadTodos());
  }

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Todo'),
        content: TextField(
          controller: _todoController,
          decoration: const InputDecoration(
            hintText: 'Enter todo text',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              _todoController.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_todoController.text.trim().isNotEmpty) {
                context.read<TodoBloc>().add(
                      AddTodo(
                        todo: _todoController.text.trim(),
                        completed: false,
                        userId: widget.userId,
                      ),
                    );
                _todoController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddTodoDialog,
          ),
        ],
      ),
      body: BlocListener<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state is TodoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state is TodoLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TodoError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: TextStyle(color: Colors.red[700]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<TodoBloc>().add(const LoadTodos());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is TodoLoaded) {
              if (state.todos.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline,
                          size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No todos yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap the + button to add one',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<TodoBloc>().add(const LoadTodos());
                },
                child: Column(
                  children: [
                    if (state.total > state.todos.length)
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.blue[50],
                        child: Text(
                          'Showing ${state.todos.length} of ${state.total} todos',
                          style: TextStyle(color: Colors.blue[700]),
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.todos.length,
                        itemBuilder: (context, index) {
                          final todo = state.todos[index];
                          return _TodoItem(
                            todo: todo,
                            onToggle: (completed) {
                              context.read<TodoBloc>().add(
                                    ToggleTodoComplete(
                                      id: todo.id,
                                      completed: completed,
                                    ),
                                  );
                            },
                            onDelete: () {
                              context.read<TodoBloc>().add(
                                    DeleteTodo(todo.id),
                                  );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text('No todos loaded'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TodoItem extends StatelessWidget {
  final TodoEntity todo;
  final Function(bool) onToggle;
  final VoidCallback onDelete;

  const _TodoItem({
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('todo_${todo.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading: Checkbox(
            value: todo.completed,
            onChanged: (value) {
              if (value != null) {
                onToggle(value);
              }
            },
          ),
          title: Text(
            todo.todo,
            style: TextStyle(
              decoration: todo.completed
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              color: todo.completed ? Colors.grey : null,
            ),
          ),
          subtitle: Text('User ID: ${todo.userId}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Todo'),
                  content: Text('Are you sure you want to delete "${todo.todo}"?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        onDelete();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


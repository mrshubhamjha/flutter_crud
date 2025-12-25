import '../entities/todo.dart';

abstract class TodoRepository {
  // Get all todos with pagination
  Future<Map<String, dynamic>> getTodos({
    int? limit,
    int? skip,
  });

  // Get a single todo by id
  Future<TodoEntity> getTodoById(int id);

  // Get todos by user id
  Future<Map<String, dynamic>> getTodosByUserId(int userId);

  // Add a new todo
  Future<TodoEntity> addTodo({
    required String todo,
    required bool completed,
    required int userId,
  });

  // Update a todo
  Future<TodoEntity> updateTodo({
    required int id,
    String? todo,
    bool? completed,
    int? userId,
  });

  // Delete a todo
  Future<TodoEntity> deleteTodo(int id);
}


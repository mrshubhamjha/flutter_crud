import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_remote_datasource.dart';
import '../models/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;

  TodoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> getTodos({int? limit, int? skip}) async {
    final response = await remoteDataSource.getTodos(limit: limit, skip: skip);
    return {
      'todos': response.todos.map((todo) => todo.toEntity()).toList(),
      'total': response.total,
      'skip': response.skip,
      'limit': response.limit,
    };
  }

  @override
  Future<TodoEntity> getTodoById(int id) async {
    final todo = await remoteDataSource.getTodoById(id);
    return todo.toEntity();
  }

  @override
  Future<Map<String, dynamic>> getTodosByUserId(int userId) async {
    final response = await remoteDataSource.getTodosByUserId(userId);
    return {
      'todos': response.todos.map((todo) => todo.toEntity()).toList(),
      'total': response.total,
      'skip': response.skip,
      'limit': response.limit,
    };
  }

  @override
  Future<TodoEntity> addTodo({
    required String todo,
    required bool completed,
    required int userId,
  }) async {
    final request = AddTodoRequest(
      todo: todo,
      completed: completed,
      userId: userId,
    );
    final todoModel = await remoteDataSource.addTodo(request);
    return todoModel.toEntity();
  }

  @override
  Future<TodoEntity> updateTodo({
    required int id,
    String? todo,
    bool? completed,
    int? userId,
  }) async {
    final request = UpdateTodoRequest(
      todo: todo,
      completed: completed,
      userId: userId,
    );
    final todoModel = await remoteDataSource.updateTodo(id, request);
    return todoModel.toEntity();
  }

  @override
  Future<TodoEntity> deleteTodo(int id) async {
    final todo = await remoteDataSource.deleteTodo(id);
    return todo.toEntity();
  }
}


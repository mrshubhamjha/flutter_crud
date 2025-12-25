import 'dart:convert';
import '../../../../core/services/http_service.dart';
import '../models/todo_model.dart';

abstract class TodoRemoteDataSource {
  Future<TodosResponseModel> getTodos({int? limit, int? skip});
  Future<TodoModel> getTodoById(int id);
  Future<TodosResponseModel> getTodosByUserId(int userId);
  Future<TodoModel> addTodo(AddTodoRequest request);
  Future<TodoModel> updateTodo(int id, UpdateTodoRequest request);
  Future<TodoModel> deleteTodo(int id);
}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final HttpService httpService;

  TodoRemoteDataSourceImpl({required this.httpService});

  @override
  Future<TodosResponseModel> getTodos({int? limit, int? skip}) async {
    final queryParams = <String, String>{};
    if (limit != null) queryParams['limit'] = limit.toString();
    if (skip != null) queryParams['skip'] = skip.toString();

    final queryString = queryParams.isEmpty
        ? ''
        : '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}';

    final response = await httpService.get(
      baseUrlKey: 'BASE_AUTH_URL',
      endpoint: '/todos$queryString',
    );

    return TodosResponseModel.fromJson(jsonDecode(response.body));
  }

  @override
  Future<TodoModel> getTodoById(int id) async {
    final response = await httpService.get(
      baseUrlKey: 'BASE_AUTH_URL',
      endpoint: '/todos/$id',
    );

    return TodoModel.fromJson(jsonDecode(response.body));
  }

  @override
  Future<TodosResponseModel> getTodosByUserId(int userId) async {
    final response = await httpService.get(
      baseUrlKey: 'BASE_AUTH_URL',
      endpoint: '/todos/user/$userId',
    );

    return TodosResponseModel.fromJson(jsonDecode(response.body));
  }

  @override
  Future<TodoModel> addTodo(AddTodoRequest request) async {
    final response = await httpService.post(
      baseUrlKey: 'BASE_AUTH_URL',
      endpoint: '/todos/add',
      body: request.toJson(),
    );

    return TodoModel.fromJson(jsonDecode(response.body));
  }

  @override
  Future<TodoModel> updateTodo(int id, UpdateTodoRequest request) async {
    final response = await httpService.put(
      baseUrlKey: 'BASE_AUTH_URL',
      endpoint: '/todos/$id',
      body: request.toJson(),
    );

    return TodoModel.fromJson(jsonDecode(response.body));
  }

  @override
  Future<TodoModel> deleteTodo(int id) async {
    final response = await httpService.delete(
      baseUrlKey: 'BASE_AUTH_URL',
      endpoint: '/todos/$id',
    );

    return TodoModel.fromJson(jsonDecode(response.body));
  }
}


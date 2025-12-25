import '../../domain/entities/todo.dart';

// Request models
class AddTodoRequest {
  final String todo;
  final bool completed;
  final int userId;

  AddTodoRequest({
    required this.todo,
    required this.completed,
    required this.userId,
  });

  Map<String, dynamic> toJson() => {
        'todo': todo,
        'completed': completed,
        'userId': userId,
      };
}

class UpdateTodoRequest {
  final String? todo;
  final bool? completed;
  final int? userId;

  UpdateTodoRequest({
    this.todo,
    this.completed,
    this.userId,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (todo != null) json['todo'] = todo;
    if (completed != null) json['completed'] = completed;
    if (userId != null) json['userId'] = userId;
    return json;
  }
}

// Response models
class TodoModel {
  final int id;
  final String todo;
  final bool completed;
  final int userId;
  final bool? isDeleted;
  final String? deletedOn;

  TodoModel({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
    this.isDeleted,
    this.deletedOn,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      todo: json['todo'] as String,
      completed: json['completed'] as bool,
      userId: json['userId'] as int,
      isDeleted: json['isDeleted'] as bool?,
      deletedOn: json['deletedOn'] as String?,
    );
  }

  // Convert to domain entity
  TodoEntity toEntity() {
    return TodoEntity(
      id: id,
      todo: todo,
      completed: completed,
      userId: userId,
    );
  }
}

class TodosResponseModel {
  final List<TodoModel> todos;
  final int total;
  final int skip;
  final int limit;

  TodosResponseModel({
    required this.todos,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory TodosResponseModel.fromJson(Map<String, dynamic> json) {
    return TodosResponseModel(
      todos: (json['todos'] as List)
          .map((todo) => TodoModel.fromJson(todo as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      skip: json['skip'] is int ? json['skip'] : int.parse(json['skip'].toString()),
      limit: json['limit'] is int ? json['limit'] : int.parse(json['limit'].toString()),
    );
  }
}


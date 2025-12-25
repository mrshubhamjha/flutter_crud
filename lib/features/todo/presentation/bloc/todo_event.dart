import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class LoadTodos extends TodoEvent {
  final int? limit;
  final int? skip;

  const LoadTodos({this.limit, this.skip});

  @override
  List<Object?> get props => [limit, skip];
}

class AddTodo extends TodoEvent {
  final String todo;
  final bool completed;
  final int userId;

  const AddTodo({
    required this.todo,
    required this.completed,
    required this.userId,
  });

  @override
  List<Object?> get props => [todo, completed, userId];
}

class UpdateTodo extends TodoEvent {
  final int id;
  final String? todo;
  final bool? completed;
  final int? userId;

  const UpdateTodo({
    required this.id,
    this.todo,
    this.completed,
    this.userId,
  });

  @override
  List<Object?> get props => [id, todo, completed, userId];
}

class DeleteTodo extends TodoEvent {
  final int id;

  const DeleteTodo(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleTodoComplete extends TodoEvent {
  final int id;
  final bool completed;

  const ToggleTodoComplete({
    required this.id,
    required this.completed,
  });

  @override
  List<Object?> get props => [id, completed];
}


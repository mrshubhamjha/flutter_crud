import 'package:equatable/equatable.dart';
import '../../domain/entities/todo.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object?> get props => [];
}

class TodoInitial extends TodoState {
  const TodoInitial();
}

class TodoLoading extends TodoState {
  const TodoLoading();
}

class TodoLoaded extends TodoState {
  final List<TodoEntity> todos;
  final int total;
  final int skip;
  final int limit;

  const TodoLoaded({
    required this.todos,
    required this.total,
    required this.skip,
    required this.limit,
  });

  @override
  List<Object?> get props => [todos, total, skip, limit];
}

class TodoError extends TodoState {
  final String message;

  const TodoError(this.message);

  @override
  List<Object?> get props => [message];
}


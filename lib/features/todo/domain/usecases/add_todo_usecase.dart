import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class AddTodoUseCase {
  final TodoRepository repository;

  AddTodoUseCase(this.repository);

  Future<TodoEntity> execute({
    required String todo,
    required bool completed,
    required int userId,
  }) async {
    if (todo.trim().isEmpty) {
      throw Exception("Todo text cannot be empty.");
    }
    return await repository.addTodo(
      todo: todo,
      completed: completed,
      userId: userId,
    );
  }
}


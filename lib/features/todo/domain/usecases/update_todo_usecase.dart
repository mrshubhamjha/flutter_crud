import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class UpdateTodoUseCase {
  final TodoRepository repository;

  UpdateTodoUseCase(this.repository);

  Future<TodoEntity> execute({
    required int id,
    String? todo,
    bool? completed,
    int? userId,
  }) async {
    return await repository.updateTodo(
      id: id,
      todo: todo,
      completed: completed,
      userId: userId,
    );
  }
}


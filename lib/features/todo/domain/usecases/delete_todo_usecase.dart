import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class DeleteTodoUseCase {
  final TodoRepository repository;

  DeleteTodoUseCase(this.repository);

  Future<TodoEntity> execute(int id) async {
    return await repository.deleteTodo(id);
  }
}


import '../repositories/todo_repository.dart';

class GetTodosUseCase {
  final TodoRepository repository;

  GetTodosUseCase(this.repository);

  Future<Map<String, dynamic>> execute({int? limit, int? skip}) async {
    return await repository.getTodos(limit: limit, skip: skip);
  }
}


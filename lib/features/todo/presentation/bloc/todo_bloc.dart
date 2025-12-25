import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/todo.dart';
import '../../domain/usecases/get_todos_usecase.dart';
import '../../domain/usecases/add_todo_usecase.dart';
import '../../domain/usecases/update_todo_usecase.dart';
import '../../domain/usecases/delete_todo_usecase.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodosUseCase getTodosUseCase;
  final AddTodoUseCase addTodoUseCase;
  final UpdateTodoUseCase updateTodoUseCase;
  final DeleteTodoUseCase deleteTodoUseCase;

  TodoBloc({
    required this.getTodosUseCase,
    required this.addTodoUseCase,
    required this.updateTodoUseCase,
    required this.deleteTodoUseCase,
  }) : super(const TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<ToggleTodoComplete>(_onToggleTodoComplete);
  }

  Future<void> _onLoadTodos(
    LoadTodos event,
    Emitter<TodoState> emit,
  ) async {
    emit(const TodoLoading());
    try {
      final result = await getTodosUseCase.execute(
        limit: event.limit,
        skip: event.skip,
      );
      emit(TodoLoaded(
        todos: (result['todos'] as List).cast<TodoEntity>(),
        total: result['total'] as int,
        skip: result['skip'] as int,
        limit: result['limit'] as int,
      ));
    } catch (e) {
      emit(TodoError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onAddTodo(
    AddTodo event,
    Emitter<TodoState> emit,
  ) async {
    try {
      await addTodoUseCase.execute(
        todo: event.todo,
        completed: event.completed,
        userId: event.userId,
      );
      // Reload todos after adding
      add(const LoadTodos());
    } catch (e) {
      emit(TodoError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onUpdateTodo(
    UpdateTodo event,
    Emitter<TodoState> emit,
  ) async {
    try {
      await updateTodoUseCase.execute(
        id: event.id,
        todo: event.todo,
        completed: event.completed,
        userId: event.userId,
      );
      // Reload todos after updating
      add(const LoadTodos());
    } catch (e) {
      emit(TodoError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onDeleteTodo(
    DeleteTodo event,
    Emitter<TodoState> emit,
  ) async {
    try {
      await deleteTodoUseCase.execute(event.id);
      // Reload todos after deleting
      add(const LoadTodos());
    } catch (e) {
      emit(TodoError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onToggleTodoComplete(
    ToggleTodoComplete event,
    Emitter<TodoState> emit,
  ) async {
    try {
      await updateTodoUseCase.execute(
        id: event.id,
        completed: event.completed,
      );
      // Reload todos after toggling
      add(const LoadTodos());
    } catch (e) {
      emit(TodoError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}


enum EditTodoStatus { initial, loading, success, failure }

extension EditTodoStatusX on EditTodoStatus {
  bool get isLoadingOrSuccess => [
    EditTodoStatus.loading,
    EditTodoStatus.success,
  ].contains(this);
}

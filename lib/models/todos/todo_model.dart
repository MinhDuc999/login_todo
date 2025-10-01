import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo_model.g.dart';

@JsonSerializable()
class TodoModel extends Equatable{
  final int id;
  final String title;
  final String description;
  final bool isCompleted;

  const TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
  });

  factory TodoModel.create(int id, String title, String description){
    return TodoModel(
        id: id,
        title: title,
        description: description,
        isCompleted: false);
  }

  factory TodoModel.fromJson(Map<String,dynamic> json) => _$TodoModelFromJson(json);

  Map<String,dynamic> toJson() => _$TodoModelToJson(this);

  TodoModel copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id,title,description,isCompleted];
}

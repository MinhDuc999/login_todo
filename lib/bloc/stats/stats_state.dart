import 'package:equatable/equatable.dart';
import 'package:login_todo/models/enums/stats.dart';

class StatsState extends Equatable{
  final StatsStatus status;
  final int completed;
  final int active;

  const StatsState({this.status = StatsStatus.initial, this.completed= 0, this.active = 0});

  @override
  List<Object?> get props => [status,completed,active];

  StatsState copyWith({
    StatsStatus? status,
    int? completed,
    int? active,
}) {
    return StatsState(
      status: status ?? this.status,
      completed: completed ?? this.completed,
      active: active ?? this.active,
    );
  }

}
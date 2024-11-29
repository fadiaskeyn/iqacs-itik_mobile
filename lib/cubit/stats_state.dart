import '../models/stat_response.dart';

abstract class StatsState {}

class StatsInitial extends StatsState {}

class StatsLoading extends StatsState {}

class StatsLoaded extends StatsState {
  final StatResponse stats;

  StatsLoaded(this.stats);
}

class StatsError extends StatsState {
  final String message;

  StatsError(this.message);
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/chart_stats.dart';
import '../service/chart_api_service.dart';

class ChartState {
  final Map<String, ChartStats>? stats;
  final bool isLoading;
  final String? error;

  const ChartState({
    this.stats,
    this.isLoading = true,
    this.error,
  });

  ChartState copyWith({
    Map<String, ChartStats>? stats,
    bool? isLoading,
    String? error,
  }) {
    return ChartState(
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ChartCubit extends Cubit<ChartState> {
  final ChartService apiService;

  ChartCubit(this.apiService) : super(const ChartState(isLoading: true));

  Future<void> fetchChartStats() async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      print("Fetching chart stats..."); // Log fetching
      final stats = await apiService.fetchChartStats();
      print("Fetched stats: $stats"); // Log fetched data
      emit(state.copyWith(stats: stats, isLoading: false));
    } catch (e) {
      print("Error fetching data: $e"); // Log error
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}

import 'package:bloc/bloc.dart';
import '../models/stat_response.dart';
import '../service/api_service.dart';
import 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  final ApiService apiService;

  StatsCubit(this.apiService) : super(StatsInitial());

  Future<void> fetchStats(int idAlat) async {
    emit(StatsLoading());
    try {
      final stats = await apiService.fetchStats(idAlat);
      emit(StatsLoaded(stats));
    } catch (e) {
      emit(StatsError('Failed to fetch data: $e'));
    }
  }
}

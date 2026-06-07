import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:pendar/services/network/mind_check_api.dart';
import 'mindcheck_state.dart';

class MindCheckCubit extends Cubit<MindCheckState> {
  final MindCheckApi _api = MindCheckApi();

  MindCheckCubit() : super(MindCheckState.initial());

  void setMentalHealthIndex(int index) {
    emit(state.copyWith(mentalHealthIndex: index));
  }

  void setDepressionAnswer(int questionIndex, int score) {
    final answers = List<int>.from(state.depressionAnswers);
    answers[questionIndex] = score;
    emit(state.copyWith(depressionAnswers: answers));
  }

  void setAnxietyAnswer(int questionIndex, int score) {
    final answers = List<int>.from(state.anxietyAnswers);
    answers[questionIndex] = score;
    emit(state.copyWith(anxietyAnswers: answers));
  }

  void setStressAnswer(int questionIndex, int score) {
    final answers = List<int>.from(state.stressAnswers);
    answers[questionIndex] = score;
    emit(state.copyWith(stressAnswers: answers));
  }

  void setSleepHours(int hours) {
    emit(state.copyWith(sleepHours: hours));
  }

  void setStudyHours(int hours) {
    emit(state.copyWith(studyHours: hours));
  }

  Future<void> submitMindCheck() async {
    emit(state.copyWith(status: MindCheckStatus.submitting));
    try {
      final result = await _api.submitMindCheck(
        mentalHealthIndex: state.mentalHealthIndex,
        depressionScore: state.depressionScore,
        anxietyScore: state.anxietyScore,
        stressScore: state.stressScore,
        sleepHours: state.sleepHours,
        studyHours: state.studyHours,
      );
      emit(state.copyWith(status: MindCheckStatus.success, result: result));
    } on DioException catch (e) {
      final errorMsg = e.response?.data['error'] ?? 'Terjadi kesalahan koneksi backend';
      emit(state.copyWith(status: MindCheckStatus.error, errorMessage: errorMsg));
    } catch (e) {
      emit(state.copyWith(status: MindCheckStatus.error, errorMessage: e.toString()));
    }
  }

  void reset() {
    emit(MindCheckState.initial());
  }
}

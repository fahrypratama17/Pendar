import 'package:dio/dio.dart';
import 'package:pendar/models/mindcheck_result_model.dart';
import 'package:pendar/services/network/dio_client.dart';

class MindCheckApi {
  final Dio _dio = DioClient().dio;

  /// POST /mind-checks — Submit mind check baru
  Future<MindCheckResultModel> submitMindCheck({
    required int mentalHealthIndex,
    required int depressionScore,
    required int anxietyScore,
    required int stressScore,
    required int sleepHours,
    required int studyHours,
  }) async {
    final response = await _dio.post('/mind-checks', data: {
      'mental_health_index': mentalHealthIndex,
      'depression_score': depressionScore,
      'anxiety_score': anxietyScore,
      'stress_score': stressScore,
      'sleep_hours': sleepHours,
      'study_hours': studyHours,
    });
    
    final dataMap = response.data['data'] as Map<String, dynamic>;
    return MindCheckResultModel.fromPostResponse(dataMap);
  }

  /// GET /mind-checks — Riwayat mind check
  Future<List<MindCheckResultModel>> getMindCheckHistory() async {
    final response = await _dio.get('/mind-checks');
    
    final list = response.data['data'] as List;
    return list
        .map((e) => MindCheckResultModel.fromDbRow(e as Map<String, dynamic>))
        .toList();
  }
}

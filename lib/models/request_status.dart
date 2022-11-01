class RequestStatus {
  final bool success;
  final RequestStatsData data;

  RequestStatus({required this.data, required this.success});

  factory RequestStatus.fromjson(Map<String, dynamic> reqjson) {
    return RequestStatus(data: RequestStatsData.fromjson(reqjson['data']), success: reqjson['success']);
  }
}

class RequestStatsData {
  final int pending;
  final int completed;
  final int rejected;

  RequestStatsData({required this.completed, required this.pending, required this.rejected});

  factory RequestStatsData.fromjson(Map<String, dynamic> json) {
    return RequestStatsData(
        completed: json['completed'], pending: json['pending'], rejected: json['rejected']);
  }
}

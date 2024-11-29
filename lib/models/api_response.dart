class ApiResponse<T> {
  final T? data;
  final String? error;

  ApiResponse({this.data, this.error});

  bool get hasError => error != null;
}

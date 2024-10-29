class ApiError {
  final String codi;
  final String missatge;

  ApiError({required this.codi, required this.missatge});

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      codi: json['codi'],
      missatge: json['missatge'] as String,
    );
  }

  @override
  String toString() {
    return '$codi\n$missatge';
  }
}

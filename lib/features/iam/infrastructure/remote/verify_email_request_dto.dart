class VerifyEmailRequestDto {
  const VerifyEmailRequestDto({required this.email, required this.code});

  final String email;
  final String code;

  Map<String, dynamic> toMap() => {'email': email, 'code': code};
}

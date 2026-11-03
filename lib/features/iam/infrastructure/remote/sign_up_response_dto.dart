class SignUpResponseDto {
  const SignUpResponseDto({required this.email});

  factory SignUpResponseDto.fromJson(Map<String, dynamic> json) =>
      SignUpResponseDto(email: json['email'] as String);

  final String email;
}

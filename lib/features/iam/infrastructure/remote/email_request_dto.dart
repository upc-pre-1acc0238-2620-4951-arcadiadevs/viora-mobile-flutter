/// Body of the requests that only name an email: a new code or a password reset link.
class EmailRequestDto {
  const EmailRequestDto({required this.email});

  final String email;

  Map<String, dynamic> toMap() => {'email': email};
}

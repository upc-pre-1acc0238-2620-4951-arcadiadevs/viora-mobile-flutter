class ResetPasswordRequestDto {
  const ResetPasswordRequestDto({required this.newPassword});

  final String newPassword;

  Map<String, dynamic> toMap() => {'newPassword': newPassword};
}

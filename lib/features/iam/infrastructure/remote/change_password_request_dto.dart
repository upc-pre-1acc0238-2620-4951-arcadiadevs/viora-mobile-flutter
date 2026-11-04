class ChangePasswordRequestDto {
  const ChangePasswordRequestDto({required this.currentPassword, required this.newPassword});

  final String currentPassword;
  final String newPassword;

  Map<String, dynamic> toMap() => {'currentPassword': currentPassword, 'newPassword': newPassword};
}

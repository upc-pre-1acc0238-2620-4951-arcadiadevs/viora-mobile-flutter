class RefreshTokenRequestDto {
  const RefreshTokenRequestDto({required this.refreshToken});

  final String refreshToken;

  Map<String, dynamic> toMap() => {'refreshToken': refreshToken};
}

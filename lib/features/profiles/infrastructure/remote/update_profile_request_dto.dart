class UpdateProfileRequestDto {
  const UpdateProfileRequestDto({
    required this.fullName,
    required this.country,
    required this.phoneNumber,
  });

  final String fullName;
  final String country;
  final String phoneNumber;

  Map<String, dynamic> toMap() =>
      {'fullName': fullName, 'country': country, 'phoneNumber': phoneNumber};
}

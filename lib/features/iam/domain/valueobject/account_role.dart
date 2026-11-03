/// Who an account is for. Each Viora app serves one role.
enum AccountRole {
  producer,
  technicalManager;

  /// The role this app serves: it signs up accounts with it and refuses any other. Access
  /// and payment aren't set up yet, so accounts are active once the email is verified.
  static const app = technicalManager;
}

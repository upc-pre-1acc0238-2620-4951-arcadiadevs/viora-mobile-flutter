/// What the phone kept from the last answer of the server, and when it arrived. Screens show it
/// without a connection with its date, never as just read.
class Kept<T> {
  const Kept(this.value, this.savedAt);

  final T value;
  final DateTime savedAt;
}

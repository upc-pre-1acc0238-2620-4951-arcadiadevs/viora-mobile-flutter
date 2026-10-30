/// "Diana Li" -> "DL".
String initialsOf(String name) => name
    .split(' ')
    .where((part) => part.isNotEmpty)
    .take(2)
    .map((part) => part[0].toUpperCase())
    .join();

/// "Jueves 29 de octubre".
String longDateEs(DateTime date) {
  const weekdays = [
    'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo',
  ];
  const months = [
    'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
  ];
  return '${weekdays[date.weekday - 1]} ${date.day} de ${months[date.month - 1]}';
}

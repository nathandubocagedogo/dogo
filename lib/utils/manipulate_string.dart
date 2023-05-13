String convertFullNameInFirstName({required String name}) {
  if (name.isNotEmpty) {
    final List<String> nameSplitted = name.split(" ");
    return nameSplitted[0];
  } else {
    return "Utilisateur";
  }
}

String capitalize(String text) {
  if (text == null || text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1);
}

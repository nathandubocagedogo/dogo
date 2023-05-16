String convertFullNameInFirstName({required String name}) {
  if (name.isNotEmpty) {
    final List<String> nameSplitted = name.split(" ");
    return nameSplitted[0];
  } else {
    return "Utilisateur";
  }
}

String capitalize({required String text}) {
  if (text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1);
}

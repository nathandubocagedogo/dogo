String convertFullNameInFirstName({required String name}) {
  if (name.isNotEmpty) {
    final List<String> nameSplitted = name.split(" ");
    return nameSplitted[0];
  } else {
    return "Utilisateur";
  }
}

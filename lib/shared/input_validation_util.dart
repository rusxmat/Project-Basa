String? errorTextBookTitle(String text) {
  if (text.isEmpty) {
    return 'Maglagay ng Pamagat ng Libro';
  }
  if (text.length < 3) {
    return 'Ang Pamagat ng Libro ay dapat na may 3 o higit pang mga titik';
  }
  if (text.length > 20) {
    return 'Ang Pamagat ng Libro ay dapat na hindi hihigit sa 20 na titik';
  }

  return null;
}

String? errorTextBookAuthor(String text) {
  if (text.isEmpty) {
    return null;
  }

  if (text.length < 3) {
    return 'Ang Pangalan ng Awtor ay dapat na may 3 o higit pang mga titik';
  }
  if (text.length > 20) {
    return 'Ang Pangalan ng Awtor ay dapat na hindi hihigit sa 20 na titik';
  }

  return null;
}

String? errorTextBookContent(String text) {
  if (text.isEmpty) {
    return 'Ang Pahina ng libro ay hindi maaaring walang laman';
  }

  return null;
}

bool isInputValidBookTitle(String text) {
  return errorTextBookTitle(text) == null;
}

bool isInputValidBookAuthor(String text) {
  return errorTextBookAuthor(text) == null;
}

bool isInputValidBookContent(String text) {
  return errorTextBookContent(text) == null;
}

extension StringExtension on String {
    String capitalize() {
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    }

    String getInitials() {
      var names = split(' ');
      var initials = '';
      int numWords = 2;
      if (names.length < 2) {
        numWords = names.length;
      }
      for (var i = 0; i < numWords; i++) {
        initials += names[i][0];
      }
      return initials.toUpperCase();
    }
}
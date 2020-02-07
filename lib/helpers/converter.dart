import 'package:intl/intl.dart';

class Converter {
  static String shortCount(int count) {
    if (count >= 1000) {
      if (count < 1000000)
        return "${count ~/ 1000}K";
      else if (count < 1000000000) return "${count ~/ 1000000}M";
    }
    return "$count";
  }

  static String timeSince(String time) {
    final duration = DateTime.now().difference(DateTime.parse(time));
    int days = duration.inDays;
    if (days <= 7) return "$days";
    return DateFormat.yMMMMd().format(DateTime.parse(time));
  }

  static String likes(int likes) {
    String likesToShow = "${likes % 1000}";
    likes ~/= 1000;
    if (likes > 0) {
      likesToShow = "${likes % 100},$likesToShow";
      likes ~/= 100;
      if (likes > 0) {
        likesToShow = "${likes % 100},$likesToShow";
        likes ~/= 100;
        if (likes > 0) {
          likesToShow = "${likes % 100},$likesToShow";
          likes ~/= 100;
        }
      }
    }
    return likesToShow;
  }
}

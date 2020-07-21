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

  static String timeSince(String time, {bool isPost = false}) {
    final duration = DateTime.now().difference(DateTime.parse(time));
    int seconds = duration.inSeconds;
    int minutes = duration.inMinutes;
    int hours = duration.inHours;
    int days = duration.inDays;
    int weeks = days ~/ 7;

    if(weeks > 0)
      return isPost ? DateFormat.yMMMMd().format(DateTime.parse(time)) : "$weeks" + "w";

    if(days > 0)
      return isPost ? "$days days" : "$days" + "d";

    if(hours > 0)
      return isPost ? "$hours hours" : "$hours" + "h";

    if(minutes > 0)
      return isPost ? "$minutes minutes" : "$minutes" + "m";

    return isPost ? "$seconds seconds" : "$seconds" + "s";
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

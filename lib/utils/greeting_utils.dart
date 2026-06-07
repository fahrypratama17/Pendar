class GreetingUtils {
  static String getGreeting() {
    final hour =  DateTime.now().hour;

    if (hour >= 4 && hour < 10) {
      return "Good Morning";
    } else if (hour >= 10 && hour < 15) {
      return "Good Afternoon";
    } else if (hour >= 15 && hour < 18) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }
}
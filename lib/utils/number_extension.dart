extension IntExtension on int {
  String kilobytesToLabel() {
    final megaBytes = this ~/ 1024;
    final leftOverKilobytes = this % 1024;
    if (megaBytes > 0 && leftOverKilobytes > 0) {
      return '${megaBytes}Mb, ${leftOverKilobytes}Kb';
    } else if (megaBytes > 0) {
      return '${megaBytes}Mb';
    } else if (leftOverKilobytes > 0) {
      return '${leftOverKilobytes}Kb';
    }
    return '';
  }
}

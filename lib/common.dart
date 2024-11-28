getChatRoomId(String a, String b) {
  if (int.parse(a) > int.parse(b)) {
    return "${a}_$b";
  } else {
    return "${b}_$a";
  }
}

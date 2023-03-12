import 'package:random_avatar/random_avatar.dart';

class AvatarFactory {
  static Map<String, String> avatars = {};

  static String getAvatar(String uid) {
    if (avatars.containsKey(uid)) {
      return avatars[uid]!;
    } else {
      var ret = RandomAvatarString(uid);
      avatars[uid] = ret;
      return ret;
    }
  }
}

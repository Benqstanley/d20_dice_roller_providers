
import 'dart:io';

class AdInfo {
  static get appId => Platform.isIOS ? "ca-app-pub-1987396634848838~4850174643" :
  Platform.isAndroid ? "ca-app-pub-1987396634848838~8239928503" : null;

  static get adId => Platform.isIOS ? "ca-app-pub-1987396634848838/6155996382" :
  Platform.isAndroid ? "ca-app-pub-1987396634848838/1482948466" : null;
}

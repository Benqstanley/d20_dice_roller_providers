
import 'dart:io';

class AdInfo {
  static get appId => Platform.isIOS ? "ca-app-pub-1987396634848838~4850174643" :
  Platform.isAndroid ? "ca-app-pub-1987396634848838~6163256315" : null;

  static get adId => Platform.isIOS ? "ca-app-pub-1987396634848838/6155996382" :
  Platform.isAndroid ? "ca-app-pub-1987396634848838/1926582114" : null;
}

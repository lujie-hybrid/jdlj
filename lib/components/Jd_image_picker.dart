import 'package:jdlj/components/jd_toast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

export 'package:multi_image_picker/src/asset.dart';

class JdImagePicker {
  static String _error;

  static List<Asset> resultList = List<Asset>();

  static Future<List<Asset>> selectImages() async {
    List<Asset> resultList = [];
    try {
      resultList =
          await MultiImagePicker.pickImages(maxImages: 1, enableCamera: true);
    } on PermissionDeniedException catch (e) {
      print(e);
      JdToast.showShortMsg("权限被禁止，请允许权限");
    } on PermissionPermanentlyDeniedExeption catch (e) {
      print(e);
      JdToast.showShortMsg("权限被永久禁止，请去设置开启");
    } on Exception catch (e) {
      _error = e.toString();
      print(_error);
    }
    return resultList;
  }
}

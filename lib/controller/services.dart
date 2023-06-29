import 'package:e_commerce/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MyServices extends GetxService {
  var controller = Get.put(AuthController());
  final box = GetStorage();
  Future init() async {
    box.read('refresh') == null ? null : await controller.refreshtken();
    print('This is refresh :');
    return this;
  }
}

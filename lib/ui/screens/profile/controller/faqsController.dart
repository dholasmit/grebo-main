import 'package:get/get.dart';
import 'package:grebo/core/service/repo/contactRepo.dart';
import 'package:grebo/ui/screens/profile/model/faqsModel.dart';

class FaqsController extends GetxController {
  int page = 1;
  List<ListElement> _getPost = [];

  List<ListElement> get getPost => _getPost;

  set getPost(List<ListElement> value) {
    _getPost = value;
    update();
  }

  FaqsController() {
    page = 1;
  }

  Future<List<ListElement>> fetchFaqs(int offset) async {
    if (offset == 0) page = 1;
    if (page == -1) return [];
    var request = await ContactRepo.fetchFaqs(page);
    getPost = request!.faqsData.list;
    print("+++++++++++++++++++++++${getPost}");

    page = request.faqsData.hasMore ? page + 1 : -1;
    return getPost;
  }
}

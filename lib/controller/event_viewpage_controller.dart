import 'package:get/get.dart';

class EventViewPageController extends GetxController {
  final RxString title = "".obs;
  final Rx<DateTime> from = DateTime(0).obs;
  final Rx<DateTime> to = DateTime(0).obs;

  changeTitle(String t) => title.value = t;
  changeFrom(DateTime frmDate) => from.value = frmDate;
  changeTo(DateTime toDate) => to.value = toDate;

  String? get getTitle => title.value;
  DateTime? get getFrom => from.value;
  DateTime? get getTo => to.value;
}

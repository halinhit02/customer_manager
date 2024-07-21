import 'package:customer_manager/controller/admob_controller.dart';
import 'package:customer_manager/controller/staff_controller.dart';
import 'package:customer_manager/screen/staff/widget/item_staff.dart';
import 'package:customer_manager/screen/staff/widget/staff_add_widget.dart';
import 'package:customer_manager/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../util/dialog_utils.dart';
import '../base/banner_ad_widget.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({Key? key}) : super(key: key);

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {

  @override
  void dispose() {
    super.dispose();
    Get.find<AdmobController>().showInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhân viên'),
        actions: Get.find<AuthController>().isAdmin()
            ? [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: StaffAddWidget(
                            onConfirmed: (staff, password) async {
                          Navigator.of(context).pop();
                          DialogUtils.showLoading();
                          Get.find<AuthController>()
                              .createStaffAccount(staff.email, password)
                              .then((value) async {
                            if (value != null) {
                              staff.id = value.uid;
                              await Get.find<StaffController>().setStaff(staff);
                              DialogUtils.showMessage(
                                  'Bạn đã tạo tài khoản nhân viên thành công!',
                                  isError: false);
                              Get.find<AdmobController>().loadInterstitialAd();
                            } else {
                              Get.back();
                              DialogUtils.showMessage(
                                  AppConstants.errorOccurred);
                            }
                          }).onError((error, stackTrace) {
                            Get.back();
                            DialogUtils.showMessage(error.toString());
                          });
                        }),
                      ),
                    );
                  },
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.add),
                ),
              ]
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {},
                child: GetBuilder<StaffController>(builder: (staffController) {
                  if (staffController.staffList.isEmpty &&
                      !staffController.isLoading) {
                    return const Center(
                      child: Text('Không có dữ liệu.'),
                    );
                  } else if (staffController.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.separated(
                    itemCount: staffController.staffList.length,
                    itemBuilder: (_, index) {
                      return ItemStaff(
                        staff: staffController.staffList[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      indent: 20,
                      endIndent: 20,
                    ),
                  );
                }),
              ),
            ),
            //if (GetPlatform.isMobile) const BannerAdWidget(),
          ],
        ),
      ),
    );
  }
}

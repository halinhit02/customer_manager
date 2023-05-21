import 'dart:async';

import 'package:customer_manager/util/app_constants.dart';
import 'package:customer_manager/util/app_routes.dart';
import 'package:customer_manager/util/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/customer_controller.dart';
import '../../model/customer.dart';
import '../../model/user_action.dart';
import '../base/edit_item_builder.dart';
import '../base/navigate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isEdited = false;
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchEditingController = TextEditingController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.elasticOut);
    } else {
      Timer(const Duration(milliseconds: 400), () => _scrollToBottom());
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Navigate(
              onCreated: () {
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: EditItemBuilder(
                      title: 'Thêm Khách Hàng',
                      onConfirmed: (Customer customer) async {
                        Navigator.of(context).pop();
                        DialogUtils.showLoading();
                        await Get.find<CustomerController>()
                            .setCustomer(customer);
                      },
                    ),
                  ),
                );
              },
              onSearchChanged: (value) {
                Get.find<CustomerController>().searchCustomer(value);
              },
            ),
            const SizedBox(
              height: 15,
            ),
            MediaQuery.of(context).size.width < 420
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 10,
                    ),
                    child: TextField(
                      controller: searchEditingController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide()),
                        hintText:
                            'Nhập họ tên hoặc số điện thoại người dùng...',
                        hintStyle: const TextStyle(fontSize: 14),
                      ),
                      onChanged: (value) {
                        Get.find<CustomerController>().searchCustomer(value);
                      },
                    ),
                  )
                : const SizedBox(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Get.find<CustomerController>().getAllCustomer();
                },
                child: GetBuilder<CustomerController>(
                    builder: (customerController) {
                  if (customerController.customerList.isEmpty && !customerController.isLoading) {
                    return const Center(
                      child: Text('Không có dữ liệu.'),
                    );
                  } else if (customerController.isLoading) {
                   return const Center(
                     child: CircularProgressIndicator(),
                   );
                  }
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            const SubItemBuilder(
                              flex: 4,
                              value: 'Họ tên',
                              isTitle: true,
                            ),
                            const SubItemBuilder(
                              flex: 4,
                              value: 'Điện thoại',
                              isTitle: true,
                            ),
                            const SubItemBuilder(
                              flex: 3,
                              value: 'Địa chỉ',
                              isTitle: true,
                            ),
                            MediaQuery.of(context).size.width < 600
                                ? const SizedBox(
                                    width: 50,
                                  )
                                : Flexible(
                                    flex: 5,
                                    child: Row(),
                                  ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: customerController.customerList.length,
                          controller: _scrollController,
                          itemBuilder: (_, index) {
                            var user = customerController.customerList[index];
                            return ItemBuilder(
                              appUser: user,
                              itemBg: AppConstants.colorItems[index % 6],
                              onItemClicked: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: EditItemBuilder(
                                      title: 'Thông Tin Khách Hàng',
                                      user: user,
                                      userAction: UserAction.delete,
                                      onConfirmed: (Customer customer) async {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                );
                              },
                              onHistoryClicked: () {
                                Get.toNamed(AppRoutes.getHistoryRoute(user.id));
                              },
                              onEditClicked: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: EditItemBuilder(
                                      title: 'Chỉnh Sửa Thông Tin',
                                      userAction: UserAction.edit,
                                      user: user,
                                      onConfirmed: (Customer customer) async {
                                        Navigator.of(context).pop();
                                        DialogUtils.showLoading();
                                        await customerController
                                            .updateCustomer(customer);
                                        Get.back();
                                      },
                                    ),
                                  ),
                                );
                              },
                              onRemoveClicked: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: EditItemBuilder(
                                      title: 'Xóa Khách Hàng',
                                      userAction: UserAction.delete,
                                      user: user,
                                      onConfirmed: (Customer customer) async {
                                        Navigator.of(context).pop();
                                        DialogUtils.showLoading();
                                        await customerController
                                            .deleteCustomer(customer);
                                        Get.back();
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemBuilder extends StatelessWidget {
  const ItemBuilder(
      {Key? key,
      required this.appUser,
      required this.itemBg,
      this.onItemClicked,
      this.onHistoryClicked,
      this.onEditClicked,
      this.onRemoveClicked})
      : super(key: key);

  final Customer appUser;
  final Color itemBg;
  final Function()? onItemClicked;
  final Function()? onHistoryClicked;
  final Function()? onEditClicked;
  final Function()? onRemoveClicked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onItemClicked,
      child: Container(
        color: itemBg,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            SubItemBuilder(
              flex: 4,
              value: appUser.name,
            ),
            SubItemBuilder(
              flex: 4,
              value: appUser.phone,
            ),
            SubItemBuilder(
              flex: 3,
              value: appUser.address,
            ),
            MediaQuery.of(context).size.width < 600
                ? PopupMenuButton<int>(
                    initialValue: -1,
                    onSelected: (int item) {
                      if (item == 0) {
                        onHistoryClicked!();
                      } else if (item == 1) {
                        onEditClicked!();
                      } else {
                        onRemoveClicked!();
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<int>>[
                      const PopupMenuItem<int>(
                        value: 0,
                        child: Text('Lịch sử mua hàng'),
                      ),
                      const PopupMenuItem<int>(
                        value: 1,
                        child: Text('Chỉnh sửa'),
                      ),
                      const PopupMenuItem<int>(
                        value: 2,
                        child: Text('Xóa'),
                      ),
                    ],
                  )
                : Flexible(
                    flex: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          minWidth: 48,
                          onPressed: onHistoryClicked,
                          padding: EdgeInsets.zero,
                          color: Theme.of(context).primaryColor,
                          shape: const CircleBorder(),
                          child: const Icon(
                            Icons.history,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        MaterialButton(
                          minWidth: 48,
                          onPressed: onEditClicked,
                          padding: EdgeInsets.zero,
                          shape: const CircleBorder(),
                          color: Theme.of(context).primaryColor,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        MaterialButton(
                          minWidth: 48,
                          onPressed: onRemoveClicked,
                          padding: EdgeInsets.zero,
                          color: Colors.red,
                          shape: const CircleBorder(),
                          child: const Icon(
                            Icons.delete_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class SubItemBuilder extends StatelessWidget {
  const SubItemBuilder(
      {Key? key, this.value = '', this.flex = 1, this.isTitle = false})
      : super(key: key);

  final String value;
  final int flex;
  final bool isTitle;

  @override
  Widget build(BuildContext context) {
    return Flexible(
        flex: flex,
        child: Center(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontSize: isTitle ? 16 : 15,
              fontWeight: isTitle ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ));
  }
}

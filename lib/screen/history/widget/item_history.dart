import 'package:customer_manager/model/history.dart';
import 'package:flutter/material.dart';

import '../../../util/number_utils.dart';

class ItemHistory extends StatelessWidget {
  const ItemHistory({Key? key, required this.history}) : super(key: key);

  final History history;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                history.description,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(DateTime.fromMillisecondsSinceEpoch(history.time)
                  .toIso8601String()),
            ],
          ),
          Text(
            NumberUtils.formatMoney(history.amount),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

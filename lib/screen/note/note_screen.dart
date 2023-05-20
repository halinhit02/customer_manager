import 'package:flutter/material.dart';

class NoteScreen extends StatelessWidget {
  const NoteScreen({Key? key, required this.note, required this.onDone}) : super(key: key);

  final String note;
  final Function(String) onDone;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    controller.text = note;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      constraints: const BoxConstraints(minHeight: 500, maxHeight: 500, maxWidth: 500),
      child: Column(
        children: [
          Text(
            "Ghi chú",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Nhập ghi chú...',
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              onDone.call(controller.text);
              Navigator.of(context).pop();
            },
            color: Theme.of(context).primaryColor,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: const Text(
                'Lưu lại',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

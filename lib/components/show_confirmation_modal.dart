import 'package:cotrack/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

void showConfirmationModal(
  BuildContext context,
  String questionText,
  Function onConfirm, {
  String headerText = "Confirm",
  String cancelText = "Cancel",
  String confirmText = "Confirm",
  String? additionalText,
}) {
  showMaterialModalBottomSheet(
    isDismissible: true,
    context: context,
    backgroundColor: yColors.background2,
    useRootNavigator: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    ),
    enableDrag: true,
    builder: (context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            height: 5,
            width: 50,
            decoration: BoxDecoration(
              color: yColors.background3,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Center(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    headerText,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: yColors.warn),
                  ),
                )),
          ),
          const Divider(
            color: yColors.background3,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Text(
                  questionText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                if (additionalText != null) ...[
                  Text(
                    additionalText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 20,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yColors.background3,
                  ),
                  onPressed: () {
                    context.pop();
                  },
                  child: Text(cancelText),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    onConfirm();
                    context.pop();
                  },
                  child: Text(confirmText),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}

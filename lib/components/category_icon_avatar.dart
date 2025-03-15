import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cotrack/core/models/models.dart';
import 'package:cotrack/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class CategoryIconAvatar extends StatelessWidget {
  final TransactionCategory category;
  final GestureTapCallback onPressed;
  final bool? showLabel;
  final double? avatarSize;
  final double? iconSize;

  const CategoryIconAvatar({
    super.key,
    required this.category,
    required this.onPressed,
    this.showLabel,
    this.avatarSize = 30,
    this.iconSize = 30,
  });

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: onPressed,
      child: Column(
        children: [
          CircleAvatar(
            radius: avatarSize,
            backgroundColor: yColors.background2,
            child: Icon(
              category.iconItem.icon,
              color: context.primaryColor,
              size: iconSize,
            ),
          ),
          if (showLabel == true)
            SizedBox(
              width: 70,
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Center(
                  child: Text(
                    category.name,
                    style:
                        context.bodySmall!.copyWith(color: context.textTheme.labelMedium!.color),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

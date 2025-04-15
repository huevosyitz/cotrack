import 'package:flutter/material.dart';

class CategoryStats {
  CategoryStats(this.categoryId, this.categoryName, this.totalAmount,
      [this.color]);
  final int categoryId;
  final String categoryName;
  double totalAmount;
  final Color? color;
}

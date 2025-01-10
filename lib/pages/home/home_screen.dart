import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cotrack/components/components.dart';
import 'package:cotrack/core/models/models.dart';
import 'package:cotrack/core/services/services.dart';
import 'package:cotrack/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:watch_it/watch_it.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryList =
        di<TransactionCategoryService>().getTransactionCategories();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(children: [
            FutureBuilder(
                future: categoryList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                        child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator()));
                  }

                  if (snapshot.hasError) {
                    Loggy.error(
                        "Error: ${snapshot.error} ${snapshot.stackTrace}");
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  var list = snapshot.data as List<TransactionCategory>;

                  return SizedBox(
                    width: context.width,
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 20,
                      runSpacing: 30,
                      children: list
                          .take(12)
                          .map((TransactionCategory category) =>
                              CategoryIconAvatar(
                                avatarSize: 50,
                                iconSize: 50,
                                category: category,
                                showLabel: true,
                                onPressed: () {
                                  // context.pushTo(AppRoutes.obrasByCategory,
                                  //     extra: category);
                                },
                              ))
                          .toList(),
                    ),
                  );
                })
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(99)),
        ),
        onPressed: () {
          // context.pushTo(AppRoutes.addCategory);
        },
        child: TouchableOpacity(child: const Icon(yIcons.add)),
      ),
    );
  }
}

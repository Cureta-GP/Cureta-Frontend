import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/qr/view_model/qr_categories_cubit.dart';
import 'package:cureta/features/qr/view_model/qr_categories_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'filter_card.dart';

class CategoryDropdownCard extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  const CategoryDropdownCard({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return FilterCard(
      child: BlocBuilder<QrCategoriesCubit, QrCategoriesState>(
        builder: (context, state) {
          if (state is QrCategoriesLoading) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }

          if (state is QrCategoriesError) {
            return Text(
              'Failed to load categories',
              style: TextStyle(color: colors.error),
            );
          }

          final categories = state is QrCategoriesLoaded
              ? state.categories
              : <String>[];

          if (categories.isEmpty) {
            return const Text('No categories available');
          }

          return DropdownButtonFormField<String?>(
            initialValue: selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Data category',
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text('All categories'),
              ),
              ...categories.map(
                (item) =>
                    DropdownMenuItem<String?>(value: item, child: Text(item)),
              ),
            ],
            onChanged: onChanged,
          );
        },
      ),
    );
  }
}

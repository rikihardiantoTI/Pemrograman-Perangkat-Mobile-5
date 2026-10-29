import 'package:flutter/material.dart';

class FilterBottomSheet extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onSelect;

  const FilterBottomSheet({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filter Kategori', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: categories.map((cat) {
              return ChoiceChip(
                label: Text(cat),
                selected: selectedCategory == cat,
                onSelected: (selected) {
                  onSelect(selected ? cat : 'Semua');
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
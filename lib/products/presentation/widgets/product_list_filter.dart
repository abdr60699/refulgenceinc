import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/sort_filter_provider.dart';

class ProductListFilter extends ConsumerWidget {
  const ProductListFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sort = ref.watch(sortProvider);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for products...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search_rounded, color: Colors.grey[500]),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              onChanged: (value) =>
                  ref.read(filterProvider.notifier).state = value,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<String>(
              dropdownColor: Colors.white,
              value: sort,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey[600]),
              items: const [
                DropdownMenuItem(
                  value: 'none',
                  child: Row(
                    children: [
                      Icon(Icons.sort_rounded, size: 20, color: Colors.grey),
                      SizedBox(width: 12),
                      Text('Default sorting',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'name',
                  child: Row(
                    children: [
                      Icon(Icons.sort_by_alpha_rounded, size: 20),
                      SizedBox(width: 12),
                      Text('Sort by name'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'seller',
                  child: Row(
                    children: [
                      Icon(Icons.person_rounded, size: 20),
                      SizedBox(width: 12),
                      Text('Sort by seller'),
                    ],
                  ),
                ),
              ],
              onChanged: (value) =>
                  ref.read(sortProvider.notifier).state = value!,
            ),
          ),
        ],
      ),
    );
  }
}

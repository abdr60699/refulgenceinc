import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/review_entities.dart';
import '../provider/products_detail_provider.dart';

import '../widgets/product_details_content.dart';
import '../widgets/review_form.dart';
import '../widgets/reviews_list.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final int productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  final _reviewController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Random _random = Random();

  @override
  void dispose() {
    _reviewController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate()) {
      final newReview = Review(
        id: DateTime.now().millisecondsSinceEpoch,
        name: _nameController.text,
        email: _generateRandomEmail(_nameController.text),
        body: _reviewController.text,
        productId: widget.productId,
      );

      try {
        final scaffold = ScaffoldMessenger.of(context);
        scaffold.showSnackBar(
          const SnackBar(
            content: Text('Adding your review...'),
            duration: Duration(seconds: 1),
          ),
        );

        await ref.read(addReviewProvider(newReview).future);

        _reviewController.clear();
        _nameController.clear();

        scaffold.showSnackBar(
          const SnackBar(
            content: Text('Review added successfully!'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            margin: EdgeInsets.all(16),
          ),
        );

        ref.invalidate(productReviewsProvider(widget.productId));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add review: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  String _generateRandomEmail(String name) {
    final domains = [
      'gmail.com',
      'yahoo.com',
      'outlook.com',
      'hotmail.com',
      'example.com'
    ];
    final domain = domains[_random.nextInt(domains.length)];
    final cleanName = name.replaceAll(' ', '').toLowerCase();
    final randomNumbers = _random.nextInt(900) + 100;
    return '$cleanName$randomNumbers@$domain';
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailsProvider(widget.productId));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          'Product Details',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: productAsync.when(
        data: (product) {
          return CustomScrollView(
            slivers: [
              ProductDetailsContent(product: product, ref: ref),
              ReviewsList(productId: widget.productId),
              ReviewForm(
                formKey: _formKey,
                nameController: _nameController,
                reviewController: _reviewController,
                onSubmit: _submitReview,
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load product',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$e',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
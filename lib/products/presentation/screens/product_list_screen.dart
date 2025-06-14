import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../login_register_screen.dart';
import '../provider/paginated_products_provider.dart';
import '../widgets/product_list_app_bar.dart';
import '../widgets/product_list_content.dart';
import '../widgets/product_list_filter.dart';


class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(paginatedProductsProvider.notifier).loadMore();
    }
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginRegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: ProductListAppBar(
        onLogout: () => logout(context),
      ),
      body: Column(
        children: [
          const ProductListFilter(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref.read(paginatedProductsProvider.notifier).refresh();
              },
              child: ProductListContent(
                scrollController: _scrollController,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
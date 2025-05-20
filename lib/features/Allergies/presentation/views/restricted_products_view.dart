import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../core/models/allegries_products/product.dart';
import '../../../../core/models/catogry_details/result.dart';
import '../../../../core/utils/animated_app_bar.dart';
import '../../../../core/utils/app_styles.dart';
import '../../data/manager/allegries_products_cubit/allegries_products_cubit.dart';
import '../../data/manager/allegries_products_cubit/allegries_products_state.dart';
import '../../data/manager/get_all_catogries_cubit/get_all_catogries_cubit.dart';
import '../../data/manager/products_cubit/products_cubit.dart';
import '../widgets/animated_card_widget.dart';
import '../../../settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';

class RestrictedProductsView extends StatefulWidget {
  final String studentId;

  const RestrictedProductsView({
    super.key,
    required this.studentId,
  });

  @override
  State<RestrictedProductsView> createState() => _RestrictedProductsViewState();
}

class _RestrictedProductsViewState extends State<RestrictedProductsView>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late TabController _tabController;
  int _selectedCategoryId = 0;
  bool _isLoading = true;
  bool _isSelectionMode = false;
  final Set<String> _selectedProductIds = {};
  Set<String> _initiallyRestrictedIds = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    // Load categories first
    await context.read<GetAllCatogriesCubit>().getAllCatogries();

    // Load allergies for the student
    await context
        .read<AllergiesProductCubit>()
        .getProductAllergies(widget.studentId);

    // Save initially restricted products
    if (context.read<AllergiesProductCubit>().state is AllergiesLoaded) {
      final restrictedProducts =
          (context.read<AllergiesProductCubit>().state as AllergiesLoaded)
                  .allergiesProducts
                  .result ??
              [];

      _initiallyRestrictedIds = restrictedProducts
          .where((item) => item.product?.id != null)
          .map((item) => item.product!.id!)
          .toSet();
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _toggleSelectionMode() {
    setState(() {
      if (_isSelectionMode) {
        // Exiting selection mode - clear selections
        _selectedProductIds.clear();
      }
      _isSelectionMode = !_isSelectionMode;
    });
  }

  void _toggleProductSelection(String productId) {
    setState(() {
      if (_selectedProductIds.contains(productId)) {
        _selectedProductIds.remove(productId);
      } else {
        _selectedProductIds.add(productId);
      }
    });
  }

  Future<void> _applyChanges() async {
    if (_selectedProductIds.isEmpty) {
      _toggleSelectionMode();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final allergiesCubit = context.read<AllergiesProductCubit>();

    // Determine which products to restrict and which to unrestrict
    Set<String> toRestrict = {};
    Set<String> toUnrestrict = {};

    for (String productId in _selectedProductIds) {
      if (_initiallyRestrictedIds.contains(productId)) {
        // This product was restricted but is now selected to be unrestricted
        toUnrestrict.add(productId);
      } else {
        // This product was not restricted but is now selected to be restricted
        toRestrict.add(productId);
      }
    }

    // Process unrestrictions first
    if (toUnrestrict.isNotEmpty) {
      await allergiesCubit.removeProductAllergies(
        studentId: widget.studentId,
        allergiesProducts: toUnrestrict.toList(),
      );
    }

    // Then process restrictions
    if (toRestrict.isNotEmpty) {
      await allergiesCubit.assignProductAllergies(
        studentId: widget.studentId,
        allergiesProducts: toRestrict.toList(),
      );
    }

    // Reset state
    _selectedProductIds.clear();
    setState(() {
      _isSelectionMode = false;
      _isLoading = false;
    });

    // Reload allergies to get updated data
    await allergiesCubit.getProductAllergies(widget.studentId);

    // Update initially restricted IDs
    if (allergiesCubit.state is AllergiesLoaded) {
      final restrictedProducts =
          (allergiesCubit.state as AllergiesLoaded).allergiesProducts.result ??
              [];

      _initiallyRestrictedIds = restrictedProducts
          .where((item) => item.product?.id != null)
          .map((item) => item.product!.id!)
          .toSet();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDarkMode =
        context.watch<ThemeModeCubit>().currentTheme == ThemeMode.dark;

    return Scaffold(
      appBar: AnimatedCustomAppBar(
        waveColor: isDarkMode ? Colors.indigo : Colors.blue,
        backgroundColor:
            isDarkMode ? Colors.indigo.shade900 : Colors.blue.shade900,
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            if (_isSelectionMode) {
              _toggleSelectionMode();
            } else {
              Navigator.pop(context);
            }
          },
          icon: Icon(_isSelectionMode ? Icons.close : Icons.arrow_back_ios),
        ),
        title: _isSelectionMode
            ? 'Select Products (${_selectedProductIds.length})'
            : 'Restricted Products',
        thereIsIcon: false,
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      body: _buildBody(isDarkMode),
      floatingActionButton: !_isSelectionMode
          ? FloatingActionButton(
              backgroundColor: isDarkMode ? Colors.indigo : Colors.blue,
              onPressed: _toggleSelectionMode,
              child: const Icon(Icons.edit, color: Colors.white),
            )
          : null,
      bottomNavigationBar: _isSelectionMode && _selectedProductIds.isNotEmpty
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              color: isDarkMode ? Colors.indigo.shade900 : Colors.blue.shade900,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.indigo : Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _applyChanges,
                child: Text(
                  'Apply Changes (${_selectedProductIds.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildBody(bool isDarkMode) {
    if (_isLoading) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          LoadingAnimationWidget.hexagonDots(
            size: 50,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          const SizedBox(height: 20),
          Text(
            'Loading categories...',
            style: AppStyles.styleRegular14(),
          ),
        ],
      ));
    }
    return BlocBuilder<GetAllCatogriesCubit, GetAllCatogriesState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, categoriesState) {
        if (categoriesState is GetAllCatogriesLoaded) {
          final categories = categoriesState.catgoryDetails.result ?? [];

          // Update tab controller with correct length if needed
          if (_tabController.length != categories.length) {
            _tabController = TabController(
              length: categories.length,
              vsync: this,
            );

            // Select first category if available
            if (categories.isNotEmpty && _selectedCategoryId == 0) {
              _selectedCategoryId = categories[0].id ?? 0;
              // Load products for the first category
              context
                  .read<ProductsCubit>()
                  .getProducts(catogryIdFilter: _selectedCategoryId);
            }
          }

          return Column(
            children: [
              _buildCategoriesTabBar(categories, isDarkMode),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: categories.map((category) {
                    return CategoryProductsView(
                      categoryId: category.id ?? 0,
                      studentId: widget.studentId,
                      isDarkMode: isDarkMode,
                      isSelectionMode: _isSelectionMode,
                      selectedProductIds: _selectedProductIds,
                      onProductSelected: _toggleProductSelection,
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        }

        return Center(
          child: Text(
            'No categories available',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black87,
              fontSize: 16,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoriesTabBar(
      List<CatogryResult> categories, bool isDarkMode) {
    return Container(
      color: isDarkMode ? Colors.indigo.shade800 : Colors.blue.shade900,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: isDarkMode ? Colors.white : Colors.white,
        unselectedLabelColor:
            isDarkMode ? Colors.white70 : Colors.blue.shade300,
        indicatorColor: isDarkMode ? Colors.white : Colors.blue.shade700,
        tabs: categories.map((category) {
          return Tab(
            child: Text(
              category.name ?? 'Unknown',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ).animate().fadeIn().slideX(begin: 0.05, end: 0);
        }).toList(),
        onTap: (index) {
          if (categories.isNotEmpty && categories[index].id != null) {
            setState(() {
              _selectedCategoryId = categories[index].id!;
            });
            // Load products for the selected category
            context
                .read<ProductsCubit>()
                .getProducts(catogryIdFilter: _selectedCategoryId);
          }
        },
      ),
    );
  }
}

// Separate widget to handle products for each category tab
class CategoryProductsView extends StatefulWidget {
  final int categoryId;
  final String studentId;
  final bool isDarkMode;
  final bool isSelectionMode;
  final Set<String> selectedProductIds;
  final Function(String) onProductSelected;

  const CategoryProductsView({
    super.key,
    required this.categoryId,
    required this.studentId,
    required this.isDarkMode,
    required this.isSelectionMode,
    required this.selectedProductIds,
    required this.onProductSelected,
  });

  @override
  State<CategoryProductsView> createState() => _CategoryProductsViewState();
}

class _CategoryProductsViewState extends State<CategoryProductsView> {
  @override
  void initState() {
    super.initState();
    // Load products for this category when the view is created
    context
        .read<ProductsCubit>()
        .getProducts(catogryIdFilter: widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, productsState) {
        if (productsState is ProductLoading) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingAnimationWidget.hexagonDots(
                size: 50,
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Loading products...',
                style: AppStyles.styleRegular14(),
              ),
            ],
          ));
        }
        if (productsState is ProductsSucess) {
          final products = productsState.getAllProducts.result ?? [];
          if (products.isEmpty) {
            return Center(
              child: Text(
                'No products in this category',
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white70 : Colors.black87,
                  fontSize: 16,
                ),
              ),
            );
          }

          return BlocBuilder<AllergiesProductCubit, AllergiesProductsState>(
            builder: (context, allergiesState) {
              final productModels = products.map((product) {
                return Product(
                  id: product.id ?? '',
                  name: product.name ?? '',
                  description: product.description ?? '',
                  productImg: product.productImg ?? '',
                  price: product.price ?? 0.0,
                  categoryId: product.categoryId ?? 0,
                );
              }).toList();

              return _buildProductsGrid(productModels);
            },
          );
        }

        return Center(
          child: Text(
            'Failed to load products',
            style: TextStyle(
              color: widget.isDarkMode ? Colors.white70 : Colors.black87,
              fontSize: 16,
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductsGrid(List<Product> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product, index);
      },
    );
  }

  Widget _buildProductCard(Product product, int index) {
    final allergiesCubit = context.read<AllergiesProductCubit>();
    final cardColor = widget.isDarkMode ? Colors.blue.shade900 : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black87;

    // Check if this product is in the restricted list
    bool isRestricted = false;
    if (allergiesCubit.state is AllergiesLoaded) {
      final restrictedProducts =
          (allergiesCubit.state as AllergiesLoaded).allergiesProducts.result ??
              [];
      // Check if this product ID exists in the restricted products list
      isRestricted =
          restrictedProducts.any((item) => item.product?.id == product.id);
    }

    // Check if this product is selected
    bool isSelected = widget.selectedProductIds.contains(product.id);

    return AnimatedCard(
      index: index,
      product: product,
      isDarkMode: widget.isDarkMode,
      isRestricted: isRestricted,
      isSelected: isSelected,
      isSelectionMode: widget.isSelectionMode,
      cardColor: cardColor,
      textColor: textColor,
      onTap: () {
        if (widget.isSelectionMode && product.id != null) {
          // In selection mode, add/remove product from selection
          widget.onProductSelected(product.id!);
        }
      },
    );
  }
}

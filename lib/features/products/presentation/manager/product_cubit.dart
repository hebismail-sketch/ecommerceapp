import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/add_product.dart';
import '../../domain/usecases/update_product.dart';
import '../../domain/usecases/delete_product.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProducts getProductsUseCase;
  final AddProduct addProductUseCase;
  final UpdateProduct updateProductUseCase;
  final DeleteProduct deleteProductUseCase;

  ProductCubit({
    required this.getProductsUseCase,
    required this.addProductUseCase,
    required this.updateProductUseCase,
    required this.deleteProductUseCase,
  }) : super(ProductInitial());

  StreamSubscription? _subscription;

  // حفظ القائمة الأصلية للبحث فيها محلياً
  List<ProductEntity> _allProducts = [];

  // دالة جلب المنتجات
  void loadProducts() {
    emit(ProductLoading());
    _subscription?.cancel();
    _subscription = getProductsUseCase.call().listen(
          (products) {
        _allProducts = products;
        emit(ProductSuccess(products));
      },
      onError: (error) {
        emit(ProductFailure(error.toString()));
      },
    );
  }

  // Get product by ID
  ProductEntity? getProductById(String id) {
    try {
      return _allProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }


  void searchProducts(String query) {
    if (state is ProductSuccess || state is ProductLoading) {
      if (query.isEmpty) {
        emit(ProductSuccess(_allProducts));
      } else {
        final filteredProducts = _allProducts.where((product) {
          final nameLower = product.nameEn.toLowerCase();
          final nameArLower = product.nameAr.toLowerCase();
          final searchLower = query.toLowerCase();

          return nameLower.contains(searchLower) || nameArLower.contains(searchLower);
        }).toList();

        emit(ProductSuccess(filteredProducts));
      }
    }
  }


  Future<void> addProduct(ProductEntity product) async {
    try {
      await addProductUseCase.call(product);
    } catch (e) {
      emit(ProductFailure(e.toString()));
    }
  }

  Future<void> updateProduct(String id, ProductEntity product) async {
    try {
      await updateProductUseCase.call(id, product);
    } catch (e) {
      emit(ProductFailure(e.toString()));
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await deleteProductUseCase.call(id);
    } catch (e) {
      emit(ProductFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
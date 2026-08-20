import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/product_cubit.dart';
import '../../domain/entities/product_entity.dart';
import 'add_product_page.dart';

class ManageProductsPage extends StatelessWidget {
  const ManageProductsPage({super.key});
static const String screenRoute='manageProductPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // الانتقال لصفحة إضافة منتج
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProductSuccess) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return ListTile(
                  leading: Image.network(product.image, width: 50),
                  title: Text(product.nameEn),
                  subtitle: Text('${product.price} USD'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context.read<ProductCubit>().deleteProduct(product.id);
                    },
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
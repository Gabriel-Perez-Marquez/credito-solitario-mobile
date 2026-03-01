import 'package:credito_solitario_mobile/core/services/products_service.dart';
import 'package:credito_solitario_mobile/core/services/shopping_cart_service.dart';
import 'package:credito_solitario_mobile/features/profile_page/ui/profile_page_view.dart';
import 'package:credito_solitario_mobile/features/products_page/bloc/products_page_view_bloc.dart';
import 'package:credito_solitario_mobile/features/products_page/ui/product_card.dart';
import 'package:credito_solitario_mobile/features/shopping_cart/bloc/shopping_cart_bloc.dart';
import 'package:credito_solitario_mobile/features/shopping_cart/ui/shopping_cart_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsPageView extends StatefulWidget {
  const ProductsPageView({super.key});

  @override
  State<ProductsPageView> createState() => _ProductsPageViewState();
}

class _ProductsPageViewState extends State<ProductsPageView> {
  late ProductsPageViewBloc productsPageViewBloc;
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    productsPageViewBloc = ProductsPageViewBloc(ProductsService())
      ..add(ProductsPageViewFetchAllEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ShoppingCartBloc(ShoppingCartService()),
            child: const ShoppingCartView(),
          ),
        ),
      );
      return;
    }
    
    if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfilePageView()),
      );
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildCategoryChip(String label, bool isSelected,) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: TextButton(
        onPressed: () {
        },
        style: TextButton.styleFrom(
          backgroundColor: isSelected ? Colors.white : Colors.white.withOpacity(0.15),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF004B93) : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7), // Gris claro del fondo
      body: Column(
        children: [
          // Header principal
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF004B93), // Azul oscuro fiel a la imagen
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fila superior: Título y Notificaciones
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Crédito Solidario',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tu plataforma de ayuda social',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8), 
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.notifications_none, color: Colors.white),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Fila del Buscador y Botón de Filtro
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Buscar productos...',
                                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey[400],
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.tune, color: Colors.white),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Categorías (Carrusel horizontal)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildCategoryChip('Todo', true),
                          _buildCategoryChip('Alimentación', false),
                          _buildCategoryChip('Higiene', false),
                          _buildCategoryChip('Ropa', false),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Subtítulo Catálogo y Ordenar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Catálogo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Text(
                    'Ordenar',
                    style: TextStyle(
                      color: Color(0xFF004B93),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  label: const Icon(
                    Icons.sort, 
                    color: Color(0xFF004B93), 
                    size: 18,
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),

          // Contenido principal (Grid)
          Expanded(
            child: BlocBuilder<ProductsPageViewBloc, ProductsPageViewState>(
              bloc: productsPageViewBloc,
              builder: (context, state) {
                if (state is ProductsPageViewLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF00BFA5)),
                  );
                } else if (state is ProductsPageViewSuccess) {
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.58, 
                    ),
                    itemCount: state.productsList.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        imageUrl: state.productsList[index].urlImagen,
                        productName: state.productsList[index].nombre,
                        price: state.productsList[index].precio,
                        category: state.productsList[index].categoria.toString(), 
                      );
                    },
                  );
                } else if (state is ProductsPageViewError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                        const SizedBox(height: 16),
                        const Text(
                          'Error al cargar productos',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600], fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF00BFA5)),
                );
              },
            ),
          ),
        ],
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF00BFA5),
          unselectedItemColor: Colors.grey[400],
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined), // Cambiado a bag
              activeIcon: Icon(Icons.shopping_bag),
              label: 'Cesta', // Texto ajustado al de la imagen
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Pedidos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:credito_solitario_mobile/core/models/cart_item_response.dart';
import 'package:credito_solitario_mobile/core/models/notificacion_response.dart';
import 'package:credito_solitario_mobile/core/services/notification_service.dart';
import 'package:credito_solitario_mobile/core/services/orders_service.dart';
import 'package:credito_solitario_mobile/core/services/products_service.dart';
import 'package:credito_solitario_mobile/features/orders_page/bloc/orders_page_bloc.dart';
import 'package:credito_solitario_mobile/features/orders_page/ui/orders_page_view.dart';
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
  int _selectedCategoryId = 0;
  String _sortOption = 'Defecto'; 
  RangeValues _priceRange = const RangeValues(0, 5000);
  final NotificationsService _notificationsService = NotificationsService();
  List<NotificationModel> _notificaciones = [];
  bool _isLoadingNotifications = true;

  

  @override
  void initState() {
    super.initState();
    productsPageViewBloc = ProductsPageViewBloc(ProductsService())
      ..add(ProductsPageViewFetchAllEvent());

    _searchController.addListener(() {
      setState(() {}); 
    });  

    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final notis = await _notificationsService.getMyNotifications();
    if (mounted) {
      setState(() {
        _notificaciones = notis;
        _isLoadingNotifications = false;
      });
    }
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
        MaterialPageRoute(builder: (context) => const ShoppingCartView()),
      );
      return;
    }

    if(index == 2){
      Navigator.pushReplacement(
        context, MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => OrdersPageBloc(OrdersService()),
            child: const OrdersPageView(),
          )
        )
      );
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

  

  void _showFilterModal() {
    RangeValues tempRange = _priceRange;
    String tempSortOption = _sortOption;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).padding.bottom + 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Filtros y Orden', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF132F53))),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                  const Divider(height: 32),
                  
                  const Text('Ordenar por', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF132F53))),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSortChip('Defecto', tempSortOption, (val) => setModalState(() => tempSortOption = val)),
                      _buildSortChip('Precio Asc', tempSortOption, (val) => setModalState(() => tempSortOption = val)),
                      _buildSortChip('Precio Desc', tempSortOption, (val) => setModalState(() => tempSortOption = val)),
                      _buildSortChip('Nombre A-Z', tempSortOption, (val) => setModalState(() => tempSortOption = val)),
                    ],
                  ),
                  
                  const SizedBox(height: 32),

                  const Text('Rango de Precio (pts)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF132F53))),
                  const SizedBox(height: 16),
                  RangeSlider(
                    values: tempRange,
                    min: 0,
                    max: 5000,
                    divisions: 100,
                    activeColor: const Color(0xFF00BFA5),
                    inactiveColor: Colors.grey[300],
                    labels: RangeLabels('${tempRange.start.toInt()} pts', '${tempRange.end.toInt()} pts'),
                    onChanged: (values) {
                      setModalState(() => tempRange = values); 
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${tempRange.start.toInt()} pts', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                      Text('${tempRange.end.toInt()} pts', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        
                        setState(() {
                          _priceRange = tempRange;
                          _sortOption = tempSortOption;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF132F53),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Aplicar', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showNotificationsPanel() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final unreadCount = _notificaciones.where((n) => n.isNew).length;
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Notificaciones', 
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF132F53))
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                        child: Text(unreadCount.toString(), style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const Divider(height: 32),
              
             if (_isLoadingNotifications)
                const Center(child: CircularProgressIndicator(color: Color(0xFF00BFA5)))
              else if (_notificaciones.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text('No tienes notificaciones', style: TextStyle(color: Colors.grey)),
                  ),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _notificaciones.length,
                    itemBuilder: (context, index) {
                      final noti = _notificaciones[index];
                      return _buildNotificationItem(
                        icon: Icons.notifications_active_outlined, 
                        title: noti.titulo,
                        message: noti.mensaje,
                        time: noti.fecha,
                        isNew: noti.isNew,
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    ).whenComplete(() {
      _notificationsService.markAllAsRead();

      setState(() {
        _notificaciones = _notificaciones.map((n) {
          return NotificationModel(
            id: n.id,
            titulo: n.titulo,
            mensaje: n.mensaje,
            fecha: n.fecha,
            isNew: false,
          );
        }).toList();
      });
    });
  }

  Widget _buildNotificationItem({
    required IconData icon, 
    required String title, 
    required String message, 
    required String time, 
    required bool isNew
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNew ? const Color(0xFF00BFA5).withOpacity(0.08) : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isNew ? const Color(0xFF00BFA5).withOpacity(0.3) : Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icono circular
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isNew ? const Color(0xFF00BFA5) : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isNew ? Colors.white : Colors.grey[600], size: 20),
          ),
          const SizedBox(width: 16),
          // Textos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title, 
                      style: TextStyle(
                        fontWeight: isNew ? FontWeight.w900 : FontWeight.bold, 
                        fontSize: 15, 
                        color: const Color(0xFF132F53)
                      )
                    ),
                    Text(
                      time, 
                      style: TextStyle(
                        fontSize: 12, 
                        color: isNew ? const Color(0xFF00BFA5) : Colors.grey[500], 
                        fontWeight: isNew ? FontWeight.bold : FontWeight.normal
                      )
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(message, style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String currentSelection, Function(String) onSelect) {
    final isSelected = label == currentSelection;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: const Color(0xFF00BFA5).withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF00BFA5) : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(color: isSelected ? const Color(0xFF00BFA5) : Colors.grey[300]!),
      onSelected: (_) => onSelect(label),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: TextButton(
        onPressed: onTap,
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
      backgroundColor: const Color(0xFFF5F5F7), 
      body: Column(
        children: [
          // Header principal
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF004B93), 
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
                          child: Builder(
                            builder: (context) {
                              final unreadCount = _notificaciones.where((n) => n.isNew).length;
                              
                              return Stack(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.notifications_none, color: Colors.white),
                                    onPressed: _showNotificationsPanel,
                                  ),
                                  if (unreadCount > 0)
                                    Positioned(
                                      right: 8,
                                      top: 8,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          '$unreadCount',
                                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            }
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
                            onPressed: _showFilterModal, 
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Categorías (Carrusel horizontal)
                    BlocBuilder<ProductsPageViewBloc, ProductsPageViewState>(
                      bloc: productsPageViewBloc,
                      builder: (context, state) {
                        if (state is ProductsPageViewSuccess) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                // Botón estático de "Todo"
                                _buildCategoryChip('Todo', _selectedCategoryId == 0, () {
                                  setState(() => _selectedCategoryId = 0);
                                }),
                                // Lista dinámica desde la API
                                ...state.categoriesList.map((categoria) {
                                  return _buildCategoryChip(
                                    categoria.nombre,
                                    _selectedCategoryId == categoria.id,
                                    () {
                                      setState(() => _selectedCategoryId = categoria.id);
                                    },
                                  );
                                }),
                              ],
                            ),
                          );
                        }
                        
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildCategoryChip('Todo', true, () {}),
                            ],
                          ),
                        );
                      },
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
                  final searchText = _searchController.text.toLowerCase();
                  
                  final filteredProducts = state.productsList.where((p) {
                    final matchesCategory = _selectedCategoryId == 0 || p.categoriaId == _selectedCategoryId;
                    final matchesSearch = searchText.isEmpty || 
                                          p.nombre.toLowerCase().contains(searchText) ||
                                          (p.descripcion?.toLowerCase().contains(searchText) ?? false);
                    final matchesPrice = p.precio >= _priceRange.start && p.precio <= _priceRange.end;
                    return matchesCategory && matchesSearch && matchesPrice;
                  }).toList();

                  if (_sortOption == 'Precio Asc') {
                    filteredProducts.sort((a, b) => a.precio.compareTo(b.precio));
                  } else if (_sortOption == 'Precio Desc') {
                    filteredProducts.sort((a, b) => b.precio.compareTo(a.precio));
                  } else if (_sortOption == 'Nombre A-Z') {
                    filteredProducts.sort((a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));
                  }

                  if (filteredProducts.isEmpty) {
                    return RefreshIndicator(
                      color: const Color(0xFF00BFA5),
                      onRefresh: () async {
                        productsPageViewBloc.add(ProductsPageViewFetchAllEvent());
                        await Future.delayed(const Duration(seconds: 1));
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'No se encontraron productos',
                                style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  // GRID DE PRODUCTOS
                  return RefreshIndicator(
                    color: const Color(0xFF00BFA5),
                    onRefresh: () async {
                      productsPageViewBloc.add(ProductsPageViewFetchAllEvent());
                      await Future.delayed(const Duration(seconds: 1));
                      await _loadNotifications();
                    },
                    child: GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.58, 
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        
                        return ProductCard(
                          imageUrl: product.urlImagen,
                          productName: product.nombre,
                          price: product.precio,
                          category: product.categoria?.nombre ?? '', 
                          onAddToCart: () {
                            final cartItem = CartItem(
                              productId: product.id,
                              nombre: product.nombre,
                              precio: product.precio,
                              cantidad: 1,
                              imageUrl: product.urlImagen,
                            );

                            context.read<ShoppingCartBloc>().add(AddItemEvent(cartItem));

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.nombre} añadido a la cesta'),
                                backgroundColor: const Color(0xFF00BFA5),
                                duration: const Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );

                } else if (state is ProductsPageViewError) {
                  return RefreshIndicator(
                    color: const Color(0xFF00BFA5),
                    onRefresh: () async {
                      productsPageViewBloc.add(ProductsPageViewFetchAllEvent());
                      await Future.delayed(const Duration(seconds: 1));
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        alignment: Alignment.center,
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
                      ),
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
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
                builder: (context, state) {
                  int cantidadEnCarrito = state.items.length;

                  if (cantidadEnCarrito > 0) {
                    return Badge(
                      label: Text('$cantidadEnCarrito'),
                      backgroundColor: Colors.red,
                      child: const Icon(Icons.shopping_bag_outlined),
                    );
                  }
                  return const Icon(Icons.shopping_bag_outlined);
                },
              ),
              activeIcon: BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
                builder: (context, state) {
                  int cantidadEnCarrito = state.items.length;

                  if (cantidadEnCarrito > 0) {
                    return Badge(
                      label: Text('$cantidadEnCarrito'),
                      backgroundColor: Colors.red,
                      child: const Icon(Icons.shopping_bag),
                    );
                  }
                  return const Icon(Icons.shopping_bag);
                },
              ),
              label: 'Cesta',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Pedidos',
            ),
            const BottomNavigationBarItem(
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
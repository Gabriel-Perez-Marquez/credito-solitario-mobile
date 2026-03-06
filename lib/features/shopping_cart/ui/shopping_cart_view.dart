import 'package:credito_solitario_mobile/core/models/cart_item_response.dart';
import 'package:credito_solitario_mobile/core/services/auth_storage_service.dart';
import 'package:credito_solitario_mobile/core/services/orders_service.dart';
import 'package:credito_solitario_mobile/core/services/profile_service.dart';
import 'package:credito_solitario_mobile/features/orders_page/bloc/orders_page_bloc.dart';
import 'package:credito_solitario_mobile/features/orders_page/ui/orders_page_view.dart';
import 'package:credito_solitario_mobile/features/products_page/ui/products_page_view.dart';
import 'package:credito_solitario_mobile/features/profile_page/ui/profile_page_view.dart';
import 'package:credito_solitario_mobile/features/shopping_cart/bloc/shopping_cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShoppingCartView extends StatefulWidget {
  const ShoppingCartView({super.key});

  @override
  State<ShoppingCartView> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCartView> {
  final AuthStorageService authStorageService = AuthStorageService();
  final ProfileService _profileService = ProfileService();
  
  int _selectedIndex = 1;
  int _saldoDisponible = 0; 
  int? _clienteId;

  @override
  void initState() {
    super.initState();
    _loadSaldoDisponible();
  }

  Future<void> _loadSaldoDisponible() async {
    try {
      final data = await _profileService.getMyProfile();
      if (!mounted) return;
      
      setState(() {
        final cliente = data['cliente'];
        if (cliente != null) {

          if (cliente['id'] != null) {
            _clienteId = cliente['id'];
          }

          if(cliente['saldo'] != null){
            final saldo = cliente['saldo'];
            if (saldo is int) _saldoDisponible = saldo;
            if (saldo is String) _saldoDisponible = double.tryParse(saldo)?.toInt() ?? 0;
            if (saldo is double) _saldoDisponible = saldo.toInt();
          }

          
        }
      });
    } catch (e) {
      _saldoDisponible = 0;
    }
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProductsPageView()));
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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfilePageView()));
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F6F9),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF132F53)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Mi Carrito',
          style: TextStyle(
            color: Color(0xFF132F53),
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF132F53)),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<ShoppingCartBloc, ShoppingCartState>(
          listener: (context, state) {
            if (state is ShoppingCartError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            } else if (state is ShoppingCartSuccess) {
              // 1. Mostramos el mensaje de éxito
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message), 
                  backgroundColor: const Color(0xFF00BFA5),
                  duration: const Duration(seconds: 2), 
                ),
              );
              
              Future.delayed(const Duration(milliseconds: 300), () {
                if (mounted) {
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => OrdersPageBloc(OrdersService()),
                        child: const OrdersPageView(),
                      )
                    )
                  );
                }
              });
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                _buildSaldoHeader(),
                Expanded(
                  child: state.items.isEmpty
                      ? _buildEmptyCart()
                      : _buildCartList(state),
                ),
                if (state.items.isNotEmpty) _buildBottomCheckout(state),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // --- WIDGETS DE LA INTERFAZ ---

  Widget _buildSaldoHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SALDO DISPONIBLE',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$_saldoDisponible',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF132F53),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'pts',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF132F53)),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList(ShoppingCartState state) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        final item = state.items[index];
        return _buildCartItemCard(item);
      },
    );
  }

  Widget _buildCartItemCard(CartItem item) {
    final int itemTotal = (item.precio * item.cantidad).toInt();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Imagen del producto
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              color: Colors.grey[100], 
              child: Image.network(
                item.imageUrl ?? 'https://via.placeholder.com/150',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                  Container(width: 80, height: 80, color: Colors.grey[200], child: const Icon(Icons.image_not_supported, color: Colors.grey)),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Detalles y botones
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nombre,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF132F53)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Talla Única • Estándar',
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$itemTotal pts',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF132F53)),
                    ),
                    // Selector de cantidad (Estilo pill)
                    Container(
                      height: 36,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          _buildQuantityBtn(
                            icon: Icons.remove, 
                            color: Colors.grey[600]!, 
                            onTap: () {
                              if (item.cantidad > 1) {
                                context.read<ShoppingCartBloc>().add(UpdateQuantityEvent(item.productId, item.cantidad - 1));
                              } else {
                                context.read<ShoppingCartBloc>().add(RemoveItemEvent(item.productId));
                              }
                            }
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              '${item.cantidad}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          _buildQuantityBtn(
                            icon: Icons.add, 
                            color: const Color(0xFF00BFA5), // Verde
                            onTap: () => context.read<ShoppingCartBloc>().add(UpdateQuantityEvent(item.productId, item.cantidad + 1))
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityBtn({required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }

  Widget _buildBottomCheckout(ShoppingCartState state) {
    bool isLoading = state is ShoppingCartLoading;
    final int totalPuntos = state.totalPrice.toInt();
    final int puntosRestantes = _saldoDisponible - totalPuntos;
    final bool saldoInsuficiente = puntosRestantes < 0;

    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal (${state.items.length} productos)',
                style: TextStyle(fontSize: 15, color: Colors.grey[600]),
              ),
              Text(
                '$totalPuntos pts',
                style: TextStyle(fontSize: 15, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Envío
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Envío solidario',
                style: TextStyle(fontSize: 15, color: Colors.grey[600]),
              ),
              const Text(
                'Gratis',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF00BFA5)),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1),
          ),
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Puntos',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF132F53)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Puntos restantes: $puntosRestantes pts',
                    style: TextStyle(
                      fontSize: 13, 
                      color: saldoInsuficiente ? Colors.red : const Color(0xFF00BFA5)
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$totalPuntos',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF132F53)),
                  ),
                  const SizedBox(width: 4),
                  const Text('pts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Botón Confirmar
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: saldoInsuficiente ? Colors.grey : const Color(0xFF00BFA5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              onPressed: (isLoading || saldoInsuficiente) ? null : () => _realizarPedido(),
              child: isLoading
                  ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Confirmar Pedido',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.check_circle_outline, color: Colors.white),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Tu carrito está vacío',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  // --- LÓGICA DE NEGOCIO ---
  Future<void> _realizarPedido() async {
    if (_clienteId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cargando datos del cliente, inténtalo de nuevo...'), 
          backgroundColor: Colors.orange
        ),
      );
      return;
    }

    final token = await authStorageService.getToken(); 
    if (token != null && mounted) {
      context.read<ShoppingCartBloc>().add(
        CheckoutEvent(clienteId: _clienteId!, token: token),
      );
    }
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2)),
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
                int qty = state is ShoppingCartSuccess ? state.items.length : 0;
                if (qty > 0) {
                  return Badge(
                    label: Text('$qty'),
                    backgroundColor: Colors.red,
                    child: const Icon(Icons.shopping_bag_outlined),
                  );
                }
                return const Icon(Icons.shopping_bag_outlined);
              },
            ),
            activeIcon: BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
              builder: (context, state) {
                int qty = state is ShoppingCartSuccess ? state.items.length : 0;
                if (qty > 0) {
                  return Badge(
                    label: Text('$qty'),
                    backgroundColor: Colors.red,
                    child: const Icon(Icons.shopping_bag),
                  );
                }
                return const Icon(Icons.shopping_bag);
              },
            ),
            label: 'Carrito',
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
    );
  }
}
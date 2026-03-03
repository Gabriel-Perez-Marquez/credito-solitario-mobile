import 'package:credito_solitario_mobile/core/models/order_response.dart';
import 'package:credito_solitario_mobile/features/orders_page/bloc/orders_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:credito_solitario_mobile/features/products_page/ui/products_page_view.dart';
import 'package:credito_solitario_mobile/features/shopping_cart/ui/shopping_cart_view.dart';
import 'package:credito_solitario_mobile/features/profile_page/ui/profile_page_view.dart';


class OrdersPageView extends StatefulWidget {
  const OrdersPageView({super.key});

  @override
  State<OrdersPageView> createState() => _OrdersPageViewState();
}

class _OrdersPageViewState extends State<OrdersPageView> {
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    context.read<OrdersPageBloc>().add(FetchOrdersEvent());
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    
    Widget page;
    switch (index) {
      case 0: page = const ProductsPageView(); break;
      case 1: page = const ShoppingCartView(); break;
      case 3: page = const ProfilePageView(); break;
      default: return;
    }
    
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(pageBuilder: (_, __, ___) => page, transitionDuration: Duration.zero),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: BlocBuilder<OrdersPageBloc, OrdersPageState>(
                builder: (context, state) {
                  if (state is OrdersPageLoading || state is OrdersPageInitial) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFF132F53)));
                  } else if (state is OrdersPageError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else if (state is OrdersPageSuccess) {
                    if (state.orders.isEmpty) {
                      return const Center(child: Text('Aún no tienes pedidos', style: TextStyle(fontSize: 18, color: Colors.grey)));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: state.orders.length,
                      itemBuilder: (context, index) {
                        return _buildOrderCard(state.orders[index]);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 30, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mis Pedidos',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF132F53)),
          ),
          const SizedBox(height: 6),
          Text(
            'Seguimiento y estado de tus solicitudes',
            style: TextStyle(fontSize: 15, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    final bool isCompleted = order.isCompleted;
    final int totalItems = order.totalItems;
    final int totalPrice = order.totalPrice.toInt();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pedido #CS-${order.id.toString().padLeft(6, '0')}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF132F53)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_formatDate(order.orderDate)} • $totalItems ${totalItems == 1 ? 'artículo' : 'artículos'}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$totalPrice pts', 
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF132F53)),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isCompleted ? Colors.grey[200] : const Color(0xFFE6F8F3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isCompleted ? 'Finalizado' : 'En curso',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isCompleted ? Colors.grey[600] : const Color(0xFF00BFA5),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          isCompleted ? _buildInactiveTracker() : _buildActiveTracker(),
          
          const SizedBox(height: 20),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isCompleted ? 'Entregado el ${_formatDate(order.orderDate)}' : 'Estimado: Hoy, 18:00',
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              ),
              GestureDetector(
                onTap: () {
                  // Navegar a los detalles del pedido
                },
                child: Row(
                  children: const [
                    Text(
                      'Ver detalle',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF132F53)),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 16, color: Color(0xFF132F53)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTracker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTrackerStep(icon: Icons.shopping_bag, label: 'Pedido\nrealizado', isActive: true),
        _buildTrackerLine(isActive: true),
        _buildTrackerStep(icon: Icons.inventory_2, label: 'En\npreparación', isActive: true),
        _buildTrackerLine(isActive: false),
        _buildTrackerStep(icon: Icons.storefront, label: 'Listo para\nrecoger', isActive: false),
      ],
    );
  }

  Widget _buildInactiveTracker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          _buildDot(true),
          Expanded(child: Container(height: 2, color: const Color(0xFF00BFA5).withOpacity(0.3))),
          _buildDot(true),
          Expanded(child: Container(height: 2, color: const Color(0xFF00BFA5).withOpacity(0.3))),
          _buildDot(true),
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      width: 12, height: 12,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF00BFA5) : Colors.grey[300],
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildTrackerStep({required IconData icon, required String label, required bool isActive}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF132F53) : Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: isActive ? Colors.white : Colors.grey[400], size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: isActive ? const Color(0xFF132F53) : Colors.grey[400],
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildTrackerLine({required bool isActive}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        height: 2,
        color: isActive ? const Color(0xFF132F53) : Colors.grey[300],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF132F53),
        unselectedItemColor: Colors.grey[400],
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), activeIcon: Icon(Icons.shopping_bag), label: 'Carrito'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long), label: 'Pedidos'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
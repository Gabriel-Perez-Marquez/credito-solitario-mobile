import 'package:credito_solitario_mobile/core/models/order_response.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailPageView extends StatelessWidget {
  final OrderModel order;

  const OrderDetailPageView({super.key, required this.order});

  String _formatDate(DateTime date) {
    return DateFormat('d MMM yyyy, HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = order.isCompleted;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF132F53)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detalles del Pedido',
          style: TextStyle(
            color: Color(0xFF132F53),
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderSummaryCard(isCompleted),
            const SizedBox(height: 24),
            const Text(
              'Artículos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF132F53),
              ),
            ),
            const SizedBox(height: 12),
            _buildItemsList(),
            const SizedBox(height: 24),
            _buildPaymentSummary(),
          ],
        ),
      ),
    );
  }

  // Tarjeta superior con la info general del pedido
  Widget _buildOrderSummaryCard(bool isCompleted) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pedido #CS-${order.id.toString().padLeft(6, '0')}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF132F53),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.grey[200] : const Color(0xFFE6F8F3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  order.status?.name ?? 'Desconocido',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isCompleted ? Colors.grey[600] : const Color(0xFF00BFA5),
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1),
          ),
          _buildInfoRow(Icons.calendar_today_outlined, 'Fecha', _formatDate(order.orderDate)),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.shopping_bag_outlined, 'Artículos', '${order.totalItems} unidades'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[500]),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF132F53),
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  // Lista de productos del pedido
  Widget _buildItemsList() {
    return ListView.builder(
      shrinkWrap: true, 
      physics: const NeverScrollableScrollPhysics(),
      itemCount: order.orderItems.length,
      itemBuilder: (context, index) {
        final item = order.orderItems[index];
        final product = item.product;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[100]!),
          ),
          child: Row(
            children: [
              // Imagen del producto
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.grey[100],
                  width: 60,
                  height: 60,
                  child: Image.network(
                    product!.urlImagen ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Detalles del producto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF132F53),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Cant: ${item.quantity}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              // Precio total de esa línea
              Text(
                '${item.totalPrice.toInt()} pts',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF132F53),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Resumen final de costes
  Widget _buildPaymentSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF132F53),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              Text('${order.totalPrice.toInt()} pts', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Envío solidario', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              const Text('Gratis', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF00BFA5))),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF132F53),
                ),
              ),
              Text(
                '${order.totalPrice.toInt()} pts',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF132F53),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
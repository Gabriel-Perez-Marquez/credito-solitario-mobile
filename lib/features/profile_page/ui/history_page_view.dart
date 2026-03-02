import 'package:flutter/material.dart';

class HistoryPageView extends StatelessWidget {
  const HistoryPageView({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos falsos para ver el diseño. Más adelante lo conectarás a tu Bloc.
    final transactions = [
      {'title': 'Sudadera Negra Premium', 'date': '2 Mar 2026', 'pts': '-45', 'status': 'Completado'},
      {'title': 'Bono Bienvenida', 'date': '28 Feb 2026', 'pts': '+100', 'status': 'Completado'},
      {'title': 'Sudadera Beige Minimal', 'date': '15 Feb 2026', 'pts': '-44', 'status': 'Pendiente'},
      {'title': 'Sudadera Gris Essential', 'date': '10 Feb 2026', 'pts': '-40', 'status': 'Completado'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Historial de Transacciones',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final tx = transactions[index];
          final isPositive = tx['pts']!.startsWith('+');
          final isPending = tx['status'] == 'Pendiente';

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                // Icono dinámico según si es ingreso o gasto
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isPositive ? Colors.green[50] : Colors.blue[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPositive ? Icons.add_task : Icons.shopping_bag_outlined,
                    color: isPositive ? Colors.green : const Color(0xFF004B93),
                  ),
                ),
                const SizedBox(width: 16),
                // Textos
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tx['title']!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tx['date']!,
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
                      ),
                    ],
                  ),
                ),
                // Puntos y Estado
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${tx['pts']} Pts',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: isPositive ? Colors.green : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tx['status']!,
                      style: TextStyle(
                        color: isPending ? Colors.orange : const Color(0xFF00BFA5), 
                        fontSize: 12, 
                        fontWeight: FontWeight.w800
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
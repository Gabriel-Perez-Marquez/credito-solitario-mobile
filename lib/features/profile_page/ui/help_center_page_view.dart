import 'package:flutter/material.dart';

class HelpCenterPageView extends StatelessWidget {
  const HelpCenterPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Centro de Ayuda',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Preguntas Frecuentes',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildFAQItem(
            '¿Cómo consigo Puntos Solidarios?',
            'Obtienes puntos al realizar compras de impacto social o al participar en campañas de donación.',
          ),
          _buildFAQItem(
            '¿Cuánto tardan los envíos?',
            'Los envíos estándar suelen tardar entre 48 y 72 horas hábiles.',
          ),
          _buildFAQItem(
            '¿Puedo devolver un producto?',
            'Sí, tienes 30 días para devolver cualquier producto, siempre que esté en su embalaje original.',
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF004B93),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(Icons.support_agent, color: Colors.white, size: 40),
                const SizedBox(height: 12),
                const Text(
                  '¿Aún necesitas ayuda?',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nuestro equipo de soporte está disponible 24/7.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withOpacity(0.8)),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF004B93),
                  ),
                  child: const Text('Contactar Soporte'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(answer, style: TextStyle(color: Colors.grey[600], height: 1.5)),
        ],
      ),
    );
  }
}
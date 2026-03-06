class NotificationModel {
  final int id;
  final String titulo;
  final String mensaje;
  final bool isNew; 
  final String fecha; 

  NotificationModel({
    required this.id,
    required this.titulo,
    required this.mensaje,
    required this.isNew,
    required this.fecha,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? 'Notificación',
      mensaje: json['mensaje'] ?? '',
      isNew: json['leida'] == 0 || json['leida'] == false, 
      fecha: json['fecha'] ?? json['created_at'] ?? '', 
    );
  }
}
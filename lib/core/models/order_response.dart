class OrderModel {
  final int id;
  final DateTime orderDate;
  final StatusModel? status;
  final List<OrderItemModel> orderItems;

  OrderModel({
    required this.id,
    required this.orderDate,
    this.status,
    required this.orderItems,
  });

  
  int get totalItems {
    return orderItems.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalPrice {
    return orderItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  bool get isCompleted {
    final statusName = status?.name.toLowerCase() ?? '';
    return statusName == 'entregado' || 
           statusName == 'completado' || 
           statusName == 'finalizado';
  }


  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      orderDate: json['fechaPedido'] != null
          ? DateTime.tryParse(json['fechaPedido'].toString()) ?? DateTime.now()
          : DateTime.now(),
      status: json['estado'] != null 
          ? StatusModel.fromJson(json['estado']) 
          : null,
      orderItems: json['lineas_venta'] != null
          ? (json['lineas_venta'] as List)
              .map((i) => OrderItemModel.fromJson(i))
              .toList()
          : [],
    );
  }
}


class StatusModel {
  final int id;
  final String name;

  StatusModel({
    required this.id, 
    required this.name,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      id: json['id'] ?? 0,
      name: json['nombre'] ?? 'Unknown',
    );
  }
}

class OrderItemModel {
  final int id;
  final int quantity;
  final double totalPrice;
  final ProductSummaryModel? product;

  OrderItemModel({
    required this.id,
    required this.quantity,
    required this.totalPrice,
    this.product,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] ?? 0,
      quantity: json['cantidad'] is int 
          ? json['cantidad'] 
          : int.tryParse(json['cantidad'].toString()) ?? 1,
      totalPrice: json['precioTotal'] is double 
          ? json['precioTotal'] 
          : double.tryParse(json['precioTotal'].toString()) ?? 0.0,
      product: json['producto'] != null 
          ? ProductSummaryModel.fromJson(json['producto']) 
          : null,
    );
  }
}

class ProductSummaryModel {
  final int id;
  final String name;
  final String? urlImagen;

  ProductSummaryModel({
    required this.id, 
    required this.name,
    this.urlImagen,
  });

  factory ProductSummaryModel.fromJson(Map<String, dynamic> json) {
    return ProductSummaryModel(
      id: json['id'] ?? 0,
      name: json['nombre'] ?? 'Product',
      urlImagen: json['urlImagen'],
    );
  }
}
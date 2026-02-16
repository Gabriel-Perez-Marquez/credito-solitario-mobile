class Categoria {
  final int id;
  final String nombre;
  final bool activa;
  final String? createdAt;
  final String? updatedAt;

  Categoria({
    required this.id,
    required this.nombre,
    required this.activa,
    this.createdAt,
    this.updatedAt,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      activa: json['activa'] as bool,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'activa': activa,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Product {
  final int id;
  final String nombre;
  final String? descripcion;
  final int? categoriaId;
  final double precio;
  final bool activo;
  final double descuento;
  final int stock;
  final String urlImagen;
  final String? createdAt;
  final String? updatedAt;
  final Categoria? categoria;

  Product({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.categoriaId,
    required this.precio,
    required this.activo,
    required this.descuento,
    required this.stock,
    required this.urlImagen,
    this.createdAt,
    this.updatedAt,
    this.categoria,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      categoriaId: json['categoria_id'] as int?,
      precio: double.parse(json['precio'].toString()),
      activo: json['activo'] as bool,
      descuento: double.parse(json['descuento'].toString()),
      stock: json['stock'] as int,
      urlImagen: json['urlImagen'] as String,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      categoria: json['categoria'] != null
          ? Categoria.fromJson(json['categoria'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'categoria_id': categoriaId,
      'precio': precio.toString(),
      'activo': activo,
      'descuento': descuento.toString(),
      'stock': stock,
      'urlImagen': urlImagen,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'categoria': categoria?.toJson(),
    };
  }

  Product copyWith({
    int? id,
    String? nombre,
    String? descripcion,
    int? categoriaId,
    double? precio,
    bool? activo,
    double? descuento,
    int? stock,
    String? urlImagen,
    String? createdAt,
    String? updatedAt,
    Categoria? categoria,
  }) {
    return Product(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      categoriaId: categoriaId ?? this.categoriaId,
      precio: precio ?? this.precio,
      activo: activo ?? this.activo,
      descuento: descuento ?? this.descuento,
      stock: stock ?? this.stock,
      urlImagen: urlImagen ?? this.urlImagen,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      categoria: categoria ?? this.categoria,
    );
  }
}

class ProductListResponse {
  final List<Product> products;

  ProductListResponse({
    required this.products,
  });

  factory ProductListResponse.fromJson(List<dynamic> json) {
    return ProductListResponse(
      products: json
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  List<dynamic> toJson() {
    return products.map((product) => product.toJson()).toList();
  }
}

# Crédito Solidario Mobile 📱

Crédito Solidario es una plataforma móvil de impacto social diseñada para facilitar la adquisición de productos mediante un sistema de **Puntos Solidarios**. La aplicación permite a los usuarios gestionar su perfil, explorar un catálogo de productos, realizar pedidos y realizar un seguimiento en tiempo real de sus solicitudes.

## 🚀 Tecnologías Utilizadas

* **Framework:** [Flutter](https://flutter.dev/) (v3.x)
* **Gestión de Estado:** [Flutter BLoC](https://pub.dev/packages/flutter_bloc) (Arquitectura BLoC)
* **Comunicación HTTP:** [http](https://pub.dev/packages/http) para consumo de API REST
* **Persistencia Local:** [shared_preferences](https://pub.dev/packages/shared_preferences) para manejo de sesiones y tokens
* **Modelado de Datos:** [Equatable](https://pub.dev/packages/equatable) para comparación de objetos y estados
* **Formateo:** [intl](https://pub.dev/packages/intl) para manejo de fechas y monedas

## 🏗️ Arquitectura del Proyecto

El proyecto sigue una estructura de **Clean Architecture** orientada por características (*features*), lo que facilita la escalabilidad y el mantenimiento:

* **Core:** Contiene los elementos compartidos en toda la app.
* `models/`: Definición de objetos de datos (Órdenes, Productos, Carrito).
* `services/`: Lógica de comunicación con el backend (Auth, API, Notificaciones).
* `interfaces/`: Abstracciones para desacoplamiento.


* **Features:** Módulos específicos de la aplicación.
* `login_page/` & `register_page/`: Flujos de autenticación.
* `products_page/`: Catálogo con filtros y búsqueda.
* `shopping_cart/`: Gestión de artículos y checkout.
* `orders_page/` & `order_detail_page/`: Historial y seguimiento de pedidos.
* `profile_page/`: Gestión de datos personales y seguridad.



## ✨ Características Principales

1. **Autenticación Completa:** Registro de nuevos usuarios con datos de contacto, dirección y login seguro mediante tokens JWT.
2. **Catálogo Dinámico:** Visualización de productos por categorías, búsqueda por texto y filtros por rango de precio.
3. **Sistema de Carrito:** Gestión reactiva de productos, permitiendo añadir, actualizar cantidades o eliminar ítems antes de confirmar la compra.
4. **Checkout con Validación:** Verificación de saldo disponible contra el total de puntos del carrito antes de procesar el pedido.
5. **Seguimiento de Pedidos:** Listado de órdenes con estados (Pendiente, Finalizado) y barra de progreso visual (*Stepper*).
6. **Gestión de Perfil:** Actualización de datos personales, cambio de contraseña y activación de seguridad adicional.
7. **Centro de Notificaciones:** Sistema para recibir actualizaciones sobre el estado de los pedidos y noticias de la plataforma.

## ⚙️ Configuración del Entorno

### Requisitos previos

* Flutter SDK instalado.
* Conexión a la API de Crédito Solidario (por defecto configurada en `http://10.0.2.2:8000/api` para el emulador de Android).

### Instalación

1. Clona el repositorio:
```bash
git clone https://github.com/usuario/credito_solitario_mobile.git

```


2. Instala las dependencias:
```bash
flutter pub get

```


3. Ejecuta la aplicación:
```bash
flutter run

```



## 📂 Estructura de Archivos Relevantes

* `lib/main.dart`: Punto de entrada de la aplicación y configuración de Providers globales (como `ShoppingCartBloc`).
* `lib/core/services/auth_storage_service.dart`: Encargado de persistir el token de seguridad.
* `lib/features/shopping_cart/bloc/shopping_cart_bloc.dart`: Contiene la lógica de negocio para procesar las ventas.

---

© 2024 Crédito Solidario - Transformando el consumo en ayuda social.

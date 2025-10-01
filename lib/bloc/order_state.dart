import 'package:equatable/equatable.dart';
import '../models/menu_item.dart';
import '../models/cart_item.dart';

enum OrderStatus { initial, loading, loaded, checkingOut, success, failure }

class OrderState extends Equatable {
  final OrderStatus status;
  final List<Map<String, dynamic>> restaurantsData;
  final String? selectedRestaurantId;
  final List<MenuItem> menu;
  final List<CartItem> cart;
  final String? errorMessage;

  const OrderState({
    required this.status,
    required this.restaurantsData,
    required this.selectedRestaurantId,
    required this.menu,
    required this.cart,
    required this.errorMessage,
  });

  factory OrderState.initial() => const OrderState(
    status: OrderStatus.initial,
    restaurantsData: [],
    selectedRestaurantId: null,
    menu: [],
    cart: [],
    errorMessage: null,
  );

  OrderState copyWith({
    OrderStatus? status,
    List<Map<String, dynamic>>? restaurantsData,
    String? selectedRestaurantId,
    List<MenuItem>? menu,
    List<CartItem>? cart,
    String? errorMessage,
  }) {
    return OrderState(
      status: status ?? this.status,
      restaurantsData: restaurantsData ?? this.restaurantsData,
      selectedRestaurantId: selectedRestaurantId ?? this.selectedRestaurantId,
      menu: menu ?? this.menu,
      cart: cart ?? this.cart,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, restaurantsData, selectedRestaurantId, menu, cart, errorMessage];
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/menu_item.dart';
import '../models/cart_item.dart';
import '../repository/menu_repository.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final MenuRepository menuRepo;

  OrderBloc({required this.menuRepo}) : super(OrderState.initial()) {
    on<LoadRestaurants>(_onLoad);
    on<SelectRestaurant>(_onSelectRestaurant);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<CheckoutRequested>(_onCheckout);
  }

  Future<void> _onLoad(LoadRestaurants event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      final data = await menuRepo.fetchRestaurants();
      emit(state.copyWith(status: OrderStatus.loaded, restaurantsData: data));
    } catch (e) {
      emit(state.copyWith(status: OrderStatus.failure, errorMessage: e.toString()));
    }
  }

  void _onSelectRestaurant(SelectRestaurant event, Emitter<OrderState> emit) {
    final menu = event.menu
        .map((m) => MenuItem(
      id: m['id'] ?? '0',
      name: m['name'] ?? 'Unknown',
      description: m['description'] ?? '',
      price: (m['price'] is double)
          ? m['price']
          : double.tryParse(m['price'].toString()) ?? 0.0,
      imageUrl: m['imageUrl'] ?? '',
    ))
        .toList();

    emit(state.copyWith(selectedRestaurantId: event.id, menu: menu, cart: []));
  }

  void _onAddToCart(AddToCart event, Emitter<OrderState> emit) {
    final existing = List<CartItem>.from(state.cart);
    final index = existing.indexWhere((c) => c.item.id == event.item.id);

    if (index >= 0) {
      existing[index] =
          existing[index].copyWith(quantity: existing[index].quantity + 1);
    } else {
      existing.add(CartItem(item: event.item, quantity: 1));
    }

    emit(state.copyWith(cart: existing));
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<OrderState> emit) {
    final updated = state.cart.where((c) => c.item.id != event.itemId).toList();
    emit(state.copyWith(cart: updated));
  }

  void _onUpdateQuantity(UpdateQuantity event, Emitter<OrderState> emit) {
    final updated = state.cart
        .map((c) =>
    c.item.id == event.itemId ? c.copyWith(quantity: event.quantity) : c)
        .where((c) => c.quantity > 0)
        .toList();

    emit(state.copyWith(cart: updated));
  }

  Future<void> _onCheckout(
      CheckoutRequested event, Emitter<OrderState> emit) async {
    if (state.cart.isEmpty) {
      emit(state.copyWith(
          status: OrderStatus.failure, errorMessage: 'Cart is empty'));
      return;
    }

    emit(state.copyWith(status: OrderStatus.checkingOut));
    await Future.delayed(const Duration(milliseconds: 600));

    final total =
    state.cart.fold<double>(0, (t, c) => t + c.item.price * c.quantity);
    if (total > 500) {
      emit(state.copyWith(
          status: OrderStatus.failure,
          errorMessage: 'Payment failed. Try again.'));
    } else {
      emit(state.copyWith(status: OrderStatus.success, cart: []));
    }
  }
}

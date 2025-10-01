import 'package:equatable/equatable.dart';
import '../models/menu_item.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class LoadRestaurants extends OrderEvent {
  const LoadRestaurants();
}

class SelectRestaurant extends OrderEvent {
  final String id;
  final List<Map<String, dynamic>> menu;

  const SelectRestaurant({required this.id, required this.menu});

  @override
  List<Object?> get props => [id, menu];
}

class AddToCart extends OrderEvent {
  final MenuItem item;
  const AddToCart({required this.item});

  @override
  List<Object?> get props => [item];
}

class RemoveFromCart extends OrderEvent {
  final String itemId;
  const RemoveFromCart({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

class UpdateQuantity extends OrderEvent {
  final String itemId;
  final int quantity;
  const UpdateQuantity({required this.itemId, required this.quantity});

  @override
  List<Object?> get props => [itemId, quantity];
}

class CheckoutRequested extends OrderEvent {
  const CheckoutRequested();
}

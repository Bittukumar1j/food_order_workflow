import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order_workflow/bloc/order_state.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              final cart = state.cart;
              final total =
              cart.fold<double>(0, (t, c) => t + c.item.price * c.quantity);

              return Column(
                children: [
                  Expanded(
                    child: cart.isEmpty
                        ? const Center(child: Text('Your cart is empty'))
                        : ListView.builder(
                      itemCount: cart.length,
                      itemBuilder: (_, idx) {
                        final c = cart[idx];
                        return ListTile(
                          title: Text(c.item.name),
                          subtitle: Text('₹${c.item.price} x ${c.quantity}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: c.quantity > 1
                                    ? () => context.read<OrderBloc>().add(
                                  UpdateQuantity(
                                    itemId: c.item.id,
                                    quantity: c.quantity - 1,
                                  ),
                                )
                                    : null,
                                icon: const Icon(Icons.remove),
                              ),
                              Text('${c.quantity}'),
                              IconButton(
                                onPressed: () => context.read<OrderBloc>().add(
                                  UpdateQuantity(
                                    itemId: c.item.id,
                                    quantity: c.quantity + 1,
                                  ),
                                ),
                                icon: const Icon(Icons.add),
                              ),
                              IconButton(
                                onPressed: () => context.read<OrderBloc>().add(
                                  RemoveFromCart(itemId: c.item.id),
                                ),
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total: ₹${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: cart.isEmpty || state.status == OrderStatus.checkingOut
                          ? null
                          : () {
                        context
                            .read<OrderBloc>()
                            .add(const CheckoutRequested());
                      },
                      child: state.status == OrderStatus.checkingOut
                          ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Text('Place Order'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

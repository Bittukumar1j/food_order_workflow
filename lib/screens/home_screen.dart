import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order_workflow/bloc/order_state.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/menu_item_tile.dart';
import 'checkout_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Eats'),
        actions: [
          BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              final cartCount =
              state.cart.fold<int>(0, (t, c) => t + c.quantity);
              return IconButton(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_cart_outlined),
                    if (cartCount > 0)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.red,
                          child: Text(
                            '$cartCount',
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CheckoutScreen()),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocConsumer<OrderBloc, OrderState>(
          listenWhen: (prev, cur) =>
          cur.status == OrderStatus.failure ||
              cur.status == OrderStatus.success,
          listener: (context, state) {
            if (state.status == OrderStatus.failure &&
                state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            } else if (state.status == OrderStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Order placed successfully!')),
              );
            }
          },
          builder: (context, state) {
            if (state.status == OrderStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            final restaurants = state.restaurantsData;
            if (restaurants.isEmpty) {
              return const Center(child: Text('No restaurants found'));
            }

            return ListView(
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Popular near you',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                for (var r in restaurants)
                  RestaurantCard(
                    id: r['id'] ?? '0',
                    name: r['name'] ?? 'Unknown',
                    cuisine: r['cuisine'] ?? 'Unknown Cuisine',
                    imageUrl: r['imageUrl'] ?? '',
                    onTap: () {
                      context.read<OrderBloc>().add(SelectRestaurant(
                        id: r['id'],
                        menu: r['menu'] ?? [],
                      ));

                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => DraggableScrollableSheet(
                          expand: false,
                          initialChildSize: 0.8,
                          builder: (context, ctrl) {
                            return Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Text(
                                    r['name'] ?? 'Unknown',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: BlocBuilder<OrderBloc, OrderState>(
                                      builder: (context, state) {
                                        final menu = state.menu;
                                        return ListView.builder(
                                          controller: ctrl,
                                          itemCount: menu.length,
                                          itemBuilder: (_, idx) {
                                            final m = menu[idx];
                                            return MenuItemTile(
                                              menuItem: m,
                                              onAdd: () {
                                                context
                                                    .read<OrderBloc>()
                                                    .add(AddToCart(item: m));
                                              },
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

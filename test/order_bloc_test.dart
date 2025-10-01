import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_order_workflow/bloc/order_bloc.dart';
import 'package:food_order_workflow/bloc/order_event.dart';
import 'package:food_order_workflow/bloc/order_state.dart';
import 'package:food_order_workflow/models/menu_item.dart';
import 'package:food_order_workflow/repository/menu_repository.dart';

void main() {
  group('OrderBloc', () {
    late MenuRepository menuRepo;

    setUp(() {
      menuRepo = MenuRepository();
    });

    blocTest<OrderBloc, OrderState>(
      'initial state is correct',
      build: () => OrderBloc(menuRepo: menuRepo),
      verify: (bloc) {
        expect(bloc.state.status, OrderStatus.initial);
        expect(bloc.state.cart, isEmpty);
        expect(bloc.state.menu, isEmpty);
        expect(bloc.state.restaurantsData, isEmpty);
      },
    );

    blocTest<OrderBloc, OrderState>(
      'adds item to cart',
      build: () => OrderBloc(menuRepo: menuRepo),
      act: (bloc) {
        final item = MenuItem(
          id: 't1',
          name: 'Test Dish',
          description: 'Test Description',
          price: 100.0,
          imageUrl: '',
        );
        bloc.add(AddToCart(item: item));
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<OrderState>().having(
              (state) => state.cart.length,
          'cart length',
          1,
        ),
      ],
      verify: (bloc) {
        final cartItem = bloc.state.cart.first;
        expect(cartItem.item.id, 't1');
        expect(cartItem.quantity, 1);
      },
    );
  });
}

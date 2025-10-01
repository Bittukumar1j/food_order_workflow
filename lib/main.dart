import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/order_bloc.dart';
import 'repository/menu_repository.dart';
import 'screens/home_screen.dart';
import 'bloc/order_event.dart';

void main() {
  runApp(const FoodOrderApp());
}

class FoodOrderApp extends StatelessWidget {
  const FoodOrderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
      OrderBloc(menuRepo: MenuRepository())..add(LoadRestaurants()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Local Eats',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

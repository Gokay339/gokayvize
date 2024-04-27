import 'package:flutter/material.dart';
import 'package:flutter_application_2/bloc/cart/cart_cubit.dart';
import 'package:flutter_application_2/bloc/products/products_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/localizations.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late ProductsCubit productsCubit;
  late CartCubit cartCubit;
  @override
  void initState() {
    super.initState();
    productsCubit = context.read<ProductsCubit>();
    cartCubit = context.read<CartCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).getTranslate("favorites")),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () => GoRouter.of(context).push("/cart"),
              icon: Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      body:
          BlocBuilder<ProductsCubit, ProductsState>(builder: (context, state) {
        return SizedBox.expand(
          child: ListView.builder(
            itemCount: state.favorites.length,
            itemBuilder: (context, index) => Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.all(14),
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.network(
                          state.favorites[index]["photo"].toString(),
                          height: 90,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(state.favorites[index]["name"].toString()),
                            if (productsCubit.isFavorite(
                                state.favorites[index]["id"] as int))
                              IconButton(
                                  onPressed: () {
                                    productsCubit.removeFromFavorites(
                                        state.favorites[index]["id"] as int);
                                  },
                                  icon: Row(
                                    children: [
                                      const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(AppLocalizations.of(context)
                                          .getTranslate("remove-favorite")),
                                    ],
                                  ))
                            else
                              IconButton(
                                  onPressed: () {
                                    productsCubit
                                        .addToFavorites(state.favorites[index]);
                                  },
                                  icon: const Icon(Icons.favorite_border))
                          ],
                        ),
                      ],
                    ),
                    if (state.favorites[index]["in-stock"] as bool)
                      ElevatedButton(
                        onPressed: () {
                          cartCubit.sepeteEkle(
                              id: state.favorites[index]["id"] as int,
                              photo: state.favorites[index]["photo"],
                              ad: state.favorites[index]["name"].toString(),
                              sayi: 1,
                              fiyat: state.favorites[index]["price"] as double);
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(AppLocalizations.of(context)
                                  .getTranslate("cart")),
                              content: Text(AppLocalizations.of(context)
                                  .getTranslate("added-to-cart")),
                              actions: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () =>
                                          GoRouter.of(context).push("/cart"),
                                      child: Text(AppLocalizations.of(context)
                                          .getTranslate("added-to-cart")),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          GoRouter.of(context).pop(),
                                      child: Text(" X "),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text(AppLocalizations.of(context)
                            .getTranslate("add_to_basket")),
                      ),
                    if (state.favorites[index]["in-stock"] as bool)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.check_box),
                              Text(AppLocalizations.of(context)
                                  .getTranslate("in-stock")),
                            ],
                          ),
                          Text(state.favorites[index]["price"].toString() +
                              " TL"),
                        ],
                      )
                    else
                      Row(
                        children: [
                          const Icon(Icons.error),
                          Text(AppLocalizations.of(context)
                              .getTranslate("not-available")),
                        ],
                      ),
                    const Divider()
                  ],
                )),
          ),
        );
      }),
    );
  }
}

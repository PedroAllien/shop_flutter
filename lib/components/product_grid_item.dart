import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/product.dart';
import 'package:shop/utils/app_routes.dart';

class ProductGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(
      context,
      listen:
          false, // Define se escuta ou não as notificações do Provider, utilizado como falso para n~]ao refletir na interface gráfica as mudanças
    );
    final cart = Provider.of<Cart>(
      context,
      listen: false,
    );
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.PRODUCT_DETAIL,
              arguments: product,
            );
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage("assets/images/product-placeholder.png"),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          // child: Image.network(
          //   product.imageUrl,
          //   fit: BoxFit.cover,
          // ),
        ),
        footer: GridTileBar(
          title: Text(
            product.name,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              onPressed: () {
                product.toggleFavourite(
                  auth.token ?? '',
                  auth.userId ?? '',
                );
              },
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          backgroundColor: Colors.black87,
          trailing: IconButton(
              onPressed: () {
                cart.addItem(product);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Produto adicionado com sucesso',
                    ),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'DESFAZER',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).accentColor,
              )),
        ),
      ),
    );
  }
}

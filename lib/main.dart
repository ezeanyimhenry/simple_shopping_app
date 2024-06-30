import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Shopping App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<Product> products = [
    Product('Product 1', 10.0),
    Product('Product 2', 15.0),
    Product('Product 3', 20.0),
  ];
  List<Product> cart = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addToCart(Product product) {
    setState(() {
      cart.add(product);
    });
  }

  void _removeFromCart(Product product) {
    setState(() {
      cart.remove(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      ProductsScreen(products: products, addToCart: _addToCart),
      CheckoutScreen(cart: cart, removeFromCart: _removeFromCart),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Shopping App'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Checkout',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class Product {
  final String name;
  final double price;

  Product(this.name, this.price);
}

class ProductsScreen extends StatelessWidget {
  final List<Product> products;
  final Function(Product) addToCart;

  ProductsScreen({required this.products, required this.addToCart});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(products[index].name),
          subtitle: Text('\$${products[index].price}'),
          trailing: ElevatedButton(
            onPressed: () => addToCart(products[index]),
            child: Text('Add to Cart'),
          ),
        );
      },
    );
  }
}

class CheckoutScreen extends StatelessWidget {
  final List<Product> cart;
  final Function(Product) removeFromCart;

  CheckoutScreen({required this.cart, required this.removeFromCart});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cart.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(cart[index].name),
                subtitle: Text('\$${cart[index].price}'),
                trailing: ElevatedButton(
                  onPressed: () => removeFromCart(cart[index]),
                  child: Text('Remove'),
                ),
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderSuccessfulScreen()),
            );
          },
          child: Text('Order Now'),
        ),
      ],
    );
  }
}

class OrderSuccessfulScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Successful'),
      ),
      body: Center(
        child: Text(
          'Your order was placed successfully!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

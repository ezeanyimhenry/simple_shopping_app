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
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 18.0),
        ),
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
    Product('HD Camera', 1500.0, imagePath: 'assets/images/product1.jpg'),
    Product('Cocacola can drink', 15.0,
        imagePath: 'assets/images/product2.jpg'),
    Product('Rolex Wrist Watch', 250.0,
        imagePath: 'assets/images/product3.jpg'),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} has been added to the cart'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _removeFromCart(Product product) {
    setState(() {
      cart.remove(product);
    });
  }

  void _clearCart() {
    setState(() {
      cart.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      ProductsScreen(products: products, addToCart: _addToCart),
      CheckoutScreen(
        cart: cart,
        removeFromCart: _removeFromCart,
        clearCart: _clearCart,
      ),
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
        selectedItemColor: Color.fromARGB(255, 81, 9, 197),
        onTap: _onItemTapped,
      ),
    );
  }
}

class Product {
  final String name;
  final double price;
  final String imagePath;

  Product(this.name, this.price, {required this.imagePath});
}

class ProductsScreen extends StatelessWidget {
  final List<Product> products;
  final Function(Product) addToCart;

  ProductsScreen({required this.products, required this.addToCart});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(products[index].imagePath),
              ),
              title: Text(
                products[index].name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subtitle: Text(
                '\$${products[index].price}',
                style: TextStyle(color: Colors.green[700], fontSize: 16),
              ),
              trailing: ElevatedButton(
                onPressed: () => addToCart(products[index]),
                child: Text('Add to Cart'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 81, 9, 197),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CheckoutScreen extends StatelessWidget {
  final List<Product> cart;
  final Function(Product) removeFromCart;
  final Function clearCart;

  CheckoutScreen(
      {required this.cart,
      required this.removeFromCart,
      required this.clearCart});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(cart[index].imagePath),
                    ),
                    title: Text(
                      cart[index].name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      '\$${cart[index].price}',
                      style: TextStyle(color: Colors.green[700], fontSize: 16),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () => removeFromCart(cart[index]),
                      child: Text('Remove'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color.fromARGB(255, 143, 29, 9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              clearCart();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OrderSuccessfulScreen()),
              );
            },
            child: Text('Order Now'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Color.fromARGB(255, 81, 9, 197),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              textStyle: TextStyle(fontSize: 18),
            ),
          ),
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

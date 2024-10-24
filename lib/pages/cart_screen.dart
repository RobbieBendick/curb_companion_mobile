import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Dummy data for cart items
  final List<Map<String, dynamic>> _cartItems = [
    {
      'name': 'Item 1',
      'price': 9.99,
      'quantity': 2,
      'image': 'https://source.unsplash.com/random',
    },
    {
      'name': 'Item 2',
      'price': 12.99,
      'quantity': 1,
      'image': 'https://source.unsplash.com/random',
    },
    {
      'name': 'Item 3',
      'price': 5.99,
      'quantity': 3,
      'image': 'https://source.unsplash.com/random',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Items',
            style: TextStyle(fontSize: 24),
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _cartItems.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> cartItem = _cartItems[index];
              return ListTile(
                leading: Image.network(cartItem['image']),
                title: Text(cartItem['name']),
                subtitle: Text('\$${cartItem['price']}'),
                trailing: QuantityCounter(
                  quantity: cartItem['quantity'],
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 180,
                  height: 43,
                  child: ElevatedButton.icon(
                    onPressed: () => {},
                    icon: const Icon(Icons.add, size: 19),
                    label: const Text("Add more items",
                        style: TextStyle(fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
          // Cart Summary
          const CartSummary(
              subtotal: 5, fees: 4, estimatedTax: .10, total: 5 + 4 + .10),
          Divider(
              thickness: 5,
              color: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .color
                  ?.withOpacity(0.4)),
        ],
      ),
    );
  }
}

class QuantityCounter extends StatefulWidget {
  final int quantity;

  const QuantityCounter({
    Key? key,
    required this.quantity,
  }) : super(key: key);

  @override
  State<QuantityCounter> createState() => _QuantityCounterState();
}

class _QuantityCounterState extends State<QuantityCounter> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_quantity == 1)
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                _quantity = 0;
              });
            },
          )
        else
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              setState(() {
                _quantity--;
              });
            },
          ),
        Text(
          '$_quantity',
          style: const TextStyle(fontSize: 16),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              _quantity++;
            });
          },
        ),
      ],
    );
  }
}

class CartSummary extends StatelessWidget {
  final double subtotal;
  final double fees;
  final double estimatedTax;
  final double total;

  const CartSummary({
    Key? key,
    required this.subtotal,
    required this.fees,
    required this.estimatedTax,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Divider(
            color:
                Theme.of(context).textTheme.bodyLarge!.color?.withOpacity(0.4),
            thickness: 5),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.only(top: 8, left: 8, right: 8),
          child: Text(
            'Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Divider(
              color: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .color
                  ?.withOpacity(0.4)),
        ),
        const SizedBox(height: 12),
        _buildRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
        const SizedBox(height: 8),
        _buildRow('Fees', '\$${fees.toStringAsFixed(2)}'),
        const SizedBox(height: 8),
        _buildRow('Estimated tax', '\$${estimatedTax.toStringAsFixed(2)}'),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Divider(
          color: Theme.of(context).textTheme.bodyLarge!.color?.withOpacity(0.4),
        ),
        const SizedBox(height: 17),
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 38,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Continue to Checkout'),
            ),
          ),
        ),
        const SizedBox(height: 17),
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

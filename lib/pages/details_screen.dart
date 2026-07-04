import 'package:ecommerceapp/model/item.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  Item product;

  DetailsScreen({required this.product,super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool isShowMore = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details screen'),centerTitle: true ,
        actions: [
          Row(
            children: [
              Stack(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.shopping_cart),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '8',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Text('\$13', style: TextStyle(fontSize: 17)),
              ),
            ],
          ),
        ],
        leading:
        IconButton(
          onPressed: () {Navigator.pop(context);},
          icon: Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(widget.product.imagePath),
            SizedBox(height: 16),
            Text(
              '\$ ${widget.product.price} ',
              style: TextStyle(fontSize: 33, fontWeight: FontWeight.w900),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.amberAccent.shade100,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'New',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.star, size: 26, color: Colors.yellow),
                    Icon(Icons.star, size: 26, color: Colors.yellow),
                    Icon(Icons.star, size: 26, color: Colors.yellow),
                    Icon(Icons.star, size: 26, color: Colors.yellow),
                    Icon(Icons.star, size: 26, color: Colors.yellow),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 28,
                      color: Colors.lightGreen,
                    ),
                    SizedBox(width: 3),
                    Text(
                      '${widget.product.location}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: Text(
                'Details:',
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.start,
              ),
            ),
            Text(
              'This stylish bag is perfect for everyday use\n'
              'It offers a modern and elegant design\n'
              'Made with high quality materials for durability\n'
              'Lightweight and comfortable to carry all day\n'
              'A perfect choice for any occasion',

              style: TextStyle(fontSize: 22),
              maxLines: isShowMore ? 3 : null,
              overflow: TextOverflow.fade,
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isShowMore = !isShowMore;
                });
              },
              child: Text(isShowMore ? 'show more' : 'show less'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:ecommerceapp/model/item.dart';
import 'package:ecommerceapp/pages/details_screen.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('lib/images/bbb.webp'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  currentAccountPicture: const CircleAvatar(
                    radius: 55,
                    backgroundImage: AssetImage('lib/images/ppp.jpg'),
                  ),
                  accountEmail: const Text('heba@gmail.com'),
                  accountName: const Text(
                    'Heba',
                    style: TextStyle(color: Colors.black),
                  ),
                ),

                ListTile(
                  title: const Text('Home'),
                  leading: const Icon(Icons.home),
                  onTap: () {},
                ),

                ListTile(
                  title: const Text('My Products'),
                  leading: const Icon(Icons.add_shopping_cart),
                  onTap: () {},
                ),

                ListTile(
                  title: const Text('About'),
                  leading: const Icon(Icons.help_center),
                  onTap: () {},
                ),

                ListTile(
                  title: const Text('Logout'),
                  leading: const Icon(Icons.exit_to_app),
                  onTap: () {},
                ),
              ],
            ),

            Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: const Text(
                'Developed by Heba ID 2026',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),

      appBar: AppBar(
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
      ),

      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 33,
        ),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(product: items[index]),
                ),
              );
            },
            child: GridTile(
              footer: GridTileBar(
                trailing: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.add),
                  color: Colors.black,
                ),
                title: Text('   '),
                leading: Text(
                  '\$${items[index].price}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -44,
                    left: -44,
                    bottom: -33,
                    top: -10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(55.0),
                      child: Image.asset(items[index].imagePath),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

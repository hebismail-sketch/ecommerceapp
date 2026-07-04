class Item {
  String imagePath;
  double price;
  String location;

  Item({
    required this.imagePath,
    required this.price,
    required this.location,
  });
}

final List<Item> items = [
  Item(imagePath: 'lib/images/FFF.jpg', price: 12.999,location: 'cario shop'),

  Item(imagePath: 'lib/images/mmm.jpg', price: 12.16,location: 'cario shop'),

  Item(imagePath: 'lib/images/F.webp', price: 55,location: 'cario shop'),
  Item(imagePath: 'lib/images/FF.webp', price: 18.8,location: 'cario shop'),
  Item(imagePath: 'lib/images/FFFF.jpg', price: 99.9,location: 'cario shop'),
  Item(imagePath: 'lib/images/ooo.jpg', price: 12.6,location: 'cario shop'),
  Item(imagePath: 'lib/images/www.jpg', price: 75.2,location: 'cario shop'),
  Item(imagePath: 'lib/images/sss.jpg', price: 12.00,location: 'cario shop'),

];
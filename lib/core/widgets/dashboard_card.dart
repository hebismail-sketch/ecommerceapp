
import 'package:ecommerceapp/features/admin/models/dashboard_item.dart';
import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({super.key, required this.item});

  final DashboardItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => item.page),
          );
        },
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(20),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, size: 45, color: Colors.blue
                ),
                const SizedBox(height: 15),
                Text(item.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
              ],
            ),

          ),
        ));
    }
}

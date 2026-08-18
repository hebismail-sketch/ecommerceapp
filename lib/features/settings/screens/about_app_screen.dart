
import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  static const String screenRoute = 'aboutApp';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('عن التطبيق'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.directions_car,
                size: 90,
              ),

              const SizedBox(height: 20),

              const Text(
                'Car Store',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'تطبيق لبيع وشراء السيارات',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'الإصدار 1.0.0',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'يمكنك من خلال التطبيق استعراض السيارات '
                    'والبحث عنها وإضافتها للمفضلة والسلة '
                    'وإتمام طلب الشراء بسهولة.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
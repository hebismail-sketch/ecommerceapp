import 'package:ecommerceapp/features/cars/models/item.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  final Item product;

  const DetailsScreen({
    required this.product,
    super.key,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool isShowMore = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.details),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Image.network(
                widget.product.image,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    height: 250,
                    child: Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        size: 60,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 18),
              Text(
                '${widget.product.price} ${l10n.egp}',
                style: const TextStyle(
                  fontSize: 33,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.amberAccent.shade100,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      l10n.newItem,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 26,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        size: 26,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        size: 26,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        size: 26,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        size: 26,
                        color: Colors.yellow,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 28,
                        color: Colors.lightGreen,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        widget.product.locationFor(locale),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: Text(
                  l10n.description,
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Text(
                widget.product.descriptionFor(locale),
                style: const TextStyle(
                  fontSize: 22,
                ),
                maxLines: isShowMore ? 3 : null,
                overflow: TextOverflow.ellipsis,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isShowMore = !isShowMore;
                  });
                },
                child: Text(
                  isShowMore ? l10n.showMore : l10n.showLess,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
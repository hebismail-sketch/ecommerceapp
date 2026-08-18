import 'package:cloud_firestore/cloud_firestore.dart';

class SeedData {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addCars() async {

    final snapshot = await firestore.collection('products').get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    final List<Map<String, dynamic>> cars = [
      {
        "order": 1,
        "name": "Toyota Land Cruiser",
        "brand": "Toyota",
        "year": 2024,
        "price": 7200000,
        "location": "معرض النخبة - القاهرة",
        "description":
        "سيارة SUV فاخرة مزودة بمحرك قوي يوفر أداءً استثنائيًا على جميع الطرق.\nتتميز بمقصورة داخلية واسعة مصنوعة من خامات عالية الجودة.\nمزودة بأحدث أنظمة الأمان ومساعدة السائق لقيادة أكثر ثقة.\nتقدم راحة فائقة في الرحلات الطويلة مع نظام تعليق متطور.\nتعد الخيار المثالي للعائلات وعشاق المغامرات والطرق الوعرة.",
        "image":
        "https://res.cloudinary.com/zck3ixaw/image/upload/v1784621284/a9_auvbxg.avif",
      },
      {
        "order": 2,
        "name": "Chevrolet Camaro",
        "brand": "Chevrolet",
        "year": 2023,
        "price": 3800000,
        "location": "معرض النخبة - القاهرة",
        "description":
        "سيارة رياضية بتصميم هجومي يجذب الأنظار من أول نظرة.\nمزودة بمحرك قوي يمنح تسارعًا مذهلًا وأداءً رياضيًا مميزًا.\nالمقصورة الداخلية تجمع بين الراحة والطابع الرياضي العصري.\nتحتوي على شاشة ذكية وأنظمة ترفيه واتصال حديثة.\nمثالية لعشاق السرعة والأداء الرياضي الفاخر.",
        "image":
        "https://res.cloudinary.com/zck3ixaw/image/upload/v1784606400/OIP_fameqd.webp",
      },
      {
        "order": 3,
        "name": "Porsche 911",
        "brand": "Porsche",
        "year": 2024,
        "price": 9800000,
        "location": "معرض النخبة - القاهرة",
        "description":
        "إحدى أشهر السيارات الرياضية الفاخرة في العالم.\nتتميز بمحرك بوكسر توربيني يوفر أداءً استثنائيًا.\nتصميمها الأيقوني يجمع بين الأناقة والانسيابية العالية.\nالمقصورة مزودة بأحدث التقنيات وأنظمة القيادة الذكية.\nتمنح السائق تجربة قيادة رياضية لا مثيل لها.",
        "image":
        "https://res.cloudinary.com/zck3ixaw/image/upload/v1784621214/a8_wpwezd.jpg",
      },
      {
        "order": 4,
        "name": "Audi A6",
        "brand": "Audi",
        "year": 2024,
        "price": 4300000,
        "location": "معرض النخبة - القاهرة",
        "description":
        "سيارة سيدان فاخرة تجمع بين الأداء والأناقة.\nمزودة بتقنيات قيادة حديثة وشاشات رقمية متطورة.\nتوفر مقاعد مريحة ومساحة واسعة لجميع الركاب.\nتتميز بمحرك اقتصادي مع استجابة ممتازة أثناء القيادة.\nخيار رائع للاستخدام اليومي ورجال الأعمال.",
        "image":
        "https://res.cloudinary.com/zck3ixaw/image/upload/v1784620986/a6_i9hzdp.jpg",
      },
      {
        "order": 5,
        "name": "Mercedes-Benz C200",
        "brand": "Mercedes-Benz",
        "year": 2023,
        "price": 4500000,
        "location": "معرض النخبة - القاهرة",
        "description":
        "سيارة سيدان ألمانية تعكس الفخامة والرقي.\nتتميز بمحرك قوي واقتصادي في استهلاك الوقود.\nالمقصورة الداخلية مصنوعة من خامات فاخرة عالية الجودة.\nمزودة بأحدث أنظمة السلامة والقيادة الذكية.\nتوفر تجربة قيادة مريحة وهادئة في جميع الظروف.",
        "image":
        "https://res.cloudinary.com/zck3ixaw/image/upload/v1784620718/q5_k5dbot.jpg",
      },
      {
        "order": 6,
        "name": "Porsche 911 Turbo S",
        "brand": "Porsche",
        "year": 2023,
        "price": 13500000,
        "location": "معرض النخبة - القاهرة",
        "description":
        "واحدة من أسرع سيارات بورش على الإطلاق.\nمزودة بمحرك توين تيربو بقوة تتجاوز 640 حصانًا.\nتنطلق من 0 إلى 100 كم/س في أقل من 3 ثوانٍ.\nتوفر نظام دفع رباعي وثباتًا مذهلًا على السرعات العالية.\nصممت لعشاق الأداء الفائق والفخامة الرياضية.",
        "image":
        "https://res.cloudinary.com/zck3ixaw/image/upload/v1784620636/a4_planxr.jpg",
      },
      {
        "order": 7,
        "name": "Toyota Land Cruiser GR Sport",
        "brand": "Toyota",
        "year": 2023,
        "price": 7600000,
        "location": "معرض النخبة - القاهرة",
        "description":
        "الفئة الرياضية من لاند كروزر بتصميم أكثر قوة.\nمجهزة بأنظمة دفع رباعي متطورة للطرق الصعبة.\nتوفر مقصورة فاخرة مع أحدث وسائل الراحة.\nمزودة بتقنيات سلامة ومساعدة سائق متقدمة.\nمثالية للرحلات الطويلة والقيادة في جميع التضاريس.",
        "image":
        "https://res.cloudinary.com/zck3ixaw/image/upload/v1784620559/q3_vvj0oy.avif",
      },
      {
        "order": 8,
        "name": "Porsche 911 GT3",
        "brand": "Porsche",
        "year": 2024,
        "price": 11200000,
        "location": "معرض النخبة - القاهرة",
        "description":
        "سيارة رياضية مخصصة لعشاق الحلبات والأداء العالي.\nتعتمد على محرك طبيعي التنفس يمنح استجابة مذهلة.\nتتميز بخفة الوزن وانسيابية فائقة أثناء القيادة.\nمزودة بنظام تعليق رياضي يوفر أعلى درجات الثبات.\nتقدم تجربة قيادة احترافية لعشاق السرعة.",
        "image":
        "https://res.cloudinary.com/zck3ixaw/image/upload/v1784620483/f2_ch2pzj.webp",
      },
    ];

    for (int i = 0; i < cars.length; i++) {
      await firestore
          .collection('products')
          .doc('car_${i + 1}')
          .set(cars[i]);
    }


  }
}
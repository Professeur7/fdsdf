import 'package:fashion2/firestore.dart';
import 'package:fashion2/models/specialesPromotions.dart';
import 'package:fashion2/page/gridview/specialePromotion.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpecialPromotions extends StatelessWidget {
  final List<SpecialPromotion> specialPromotions;
  FirebaseManagement _management = Get.put(FirebaseManagement());
  SpecialPromotions({required this.specialPromotions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Promotions Spéciales'),
        backgroundColor: const Color(0xFF09126C),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PublishSpecialPromotionPage(),
              ),
            );
          },
        ),
      ),
      body: FutureBuilder(
        future: _management
            .getPublicationSpreciales(_management.tailleurs.first.token!),
        builder: (context, snapshot) {
          final dataset = snapshot.data ?? [];
          return ListView.builder(
            itemCount: dataset.length,
            itemBuilder: (context, index) {
              return buildSpecialPromotionCard(dataset[index]);
            },
          );
        },
      ),
    );
  }

  Widget buildSpecialPromotionCard(SpecialPromotion specialPromotion) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.network(
              specialPromotion.imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              specialPromotion.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              specialPromotion.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              specialPromotion.date,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

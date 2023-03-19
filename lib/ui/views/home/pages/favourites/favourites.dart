import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/const/app_colors.dart';
import 'package:fitness/ui/responsive/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../bottom_media.dart';

class FavouritesScreen extends StatefulWidget {
  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final box = GetStorage();

  String? userEmail;

  @override
  void initState() {
    userEmail = box.read('email');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favourite items"),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 15),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("user\'s_favourite")
              .doc(userEmail)
              .collection("items")
              .snapshots(),
          builder: (_, snapshot) {
            if (snapshot.hasError)
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: AppColors.amber,
                ),
              );

            if (snapshot.hasData) {
              final docs = snapshot.data!.docs;

              if (snapshot.data!.docs.length == 0) {
                return Center(
                  child: Text("Empty Favourite list",style: TextStyle(

                    fontSize: 25
                  ),),
                );
              } else {
                return Container(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: docs.length,
                      itemBuilder: (_, i) {
                        final data = docs[i].data();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              InkWell(
                                onTap: () {
                                  Map detailsData = {
                                    'type': data['data']['type'],
                                    'item_data': data['data']['item_data'],
                                    'document_id': data['data']['document_id'],
                                  };
                                  Get.to(DetailsScreen(
                                    detailsData: detailsData,
                                  ));
                                  print(data);
                                },
                                child: Container(
                                  height: 150,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        data['data']['item_data']['thumbnail'],
                                        fit: BoxFit.cover,
                                      )),
                                ),
                              ),
                              Positioned(
                                right: 10,
                                top: 10,
                                child: CircleAvatar(
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        size: 18,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          FirebaseFirestore.instance
                                              .collection("user\'s_favourite")
                                              .doc(userEmail)
                                              .collection("items")
                                              .doc(snapshot.data!.docs[i].id)
                                              .delete();
                                        });
                                      }),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width: SizeConfig.screenWidth! - 40.0,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: AppColors.amber.withOpacity(0.8),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text(
                                      data['data']['item_data']['title'],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  width: 100,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.8),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text(
                                      data['data']['item_data']['type'],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                );
              }
            }

            return Center(
                child: CircularProgressIndicator(
              backgroundColor: AppColors.amber,
            ));
          },
        ),
      ),
    );
  }
}

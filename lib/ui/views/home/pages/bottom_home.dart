import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:fitness/const/app_colors.dart';
import 'package:fitness/ui/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BottomHome extends StatefulWidget {
  BottomHome({super.key});

  @override
  State<BottomHome> createState() => _BottomHomeState();
}

class _BottomHomeState extends State<BottomHome> {
  RxBool darkMode = false.obs;
  final box = GetStorage();
  changeTheme(context) {
    if (darkMode.value == false) {
      print('action triggerd');
      Get.changeThemeMode(ThemeMode.light);
    } else {
      print('action triggerd 2');
      Get.changeThemeMode(ThemeMode.dark);
    }
    // Get.changeTheme(
    //   darkMode.value == false
    //       ? AppTheme().lightTheme(context)
    //       : AppTheme().darkTheme(context),
    // );
    // print(darkMode.value);
    box.write('theme', darkMode.value == false ? 'light' : 'dark');
    // print(box.read('theme'));
  }

  @override
  void initState() {
    var theme = box.read('theme');
    if (theme == null) {
      darkMode.value = false;

      print(theme);
    } else if (theme == 'dark') {
      darkMode.value = true;
      print(theme);
    } else {
      darkMode.value = false;
      print(theme);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Obx(
            () => DayNightSwitcher(
              isDarkModeEnabled: darkMode.value,
              onStateChanged: (isDarkModeEnabled) {
                darkMode.value = isDarkModeEnabled;
                changeTheme(context);
              },
            ),
          ),
          SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: ()=>Get.toNamed(favouritesScreen),
            icon: IconTheme(
              data: Theme.of(context).copyWith().iconTheme,
              child: Icon(
                Icons.favorite_outline,
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Newest Videos',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
              ),
              SizedBox(height: 230, child: dataStream('video'))
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Newest Podcast',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
              ),
              SizedBox(
                height: 150,
                child: dataStream('podcast'),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Newest Blogs',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
              ),
              SizedBox(
                height: 190,
                child: dataStream('blog'),
              )
            ],
          ),
        ],
      ),
    );
  }
}

Widget dataStream(type) {
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('items')
        .doc(type)
        .collection("all")
        .orderBy("time_stamp", descending: true)
        .snapshots(),
    builder: (_, snapshot) {
      if (snapshot.hasError) {
        return Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.amber,
          ),
        );
      }
      if (snapshot.hasData) {
        final docs = snapshot.data!.docs;
        return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (_, index) {
              final data = docs[index].data();
              return Padding(
                padding: const EdgeInsets.only(left: 10, top: 5),
                child: InkWell(
                  onTap: () {
                    print('clicked');
                    Map detailsData = {
                      'type': type,
                      'item_data': data,
                      'document_id': docs[index].id,
                    };

                    Get.toNamed(detailsScreen, arguments: detailsData);
                  },
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          data["thumbnail"],
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 20,
                        bottom: 20,
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.maxFinite,
                          height: 30,
                          color: AppColors.amber.withOpacity(0.8),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              data['title'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    
                    
                    ),
                  ),
                ),
              );
            });
      }
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.amber,
        ),
      );
    },
  );
}

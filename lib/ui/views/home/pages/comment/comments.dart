import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/const/app_colors.dart';
import 'package:fitness/ui/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class CommentsScreen extends StatelessWidget {
  Map commentsData;
  CommentsScreen({required this.commentsData});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, size: 22),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('items')
                  .doc(commentsData['type'])
                  .collection('all')
                  .doc(commentsData['documentID'])
                  .snapshots(),
              builder: (_, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.amber,
                    ),
                  );
                }
                ;

                if (snapshot.hasData) {
                  if (snapshot.data!.data()!.containsKey('comments') == false) {
                    return Center(
                      child: Text("Empty List",style: TextStyle(
                        fontSize: 25
                      ),),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!['comments'].length ?? 0,
                        itemBuilder: (_, index) {
                          return ListTile(
                            dense: true,
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  snapshot.data!['comments'][index]['profile']),
                            ),
                            title: Text(
                              snapshot.data!['comments'][index]['comment'],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data!['comments'][index]
                                      ['user_name'],
                                  style: TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.w600),
                                ),
                                Divider()
                              ],
                            ),
                          );
                        });
                  }

                  // print(snapshot.data!['comments']);
                }

                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.amber,
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Container(
                color: Colors.white,
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: TextFormField(
                    controller: commentController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      hintText: 'write your comment',
                      suffixIcon: IconButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              try {
                                final box = GetStorage();
                                var userName = box.read('user_name');
                                var Profile = box.read('profile');
                                var finalData = [
                                  {
                                    'comment': commentController.text,
                                    'user_name': userName,
                                    'profile': Profile,
                                  }
                                ];
                                FirebaseFirestore.instance
                                    .collection('items')
                                    .doc(commentsData['type'])
                                    .collection('all')
                                    .doc(commentsData['documentID'])
                                    .set(
                                  {
                                    'comments': FieldValue.arrayUnion(finalData)
                                  },
                                  SetOptions(
                                    merge: true,
                                  ),
                                );
                                Get.showSnackbar(AppStyles()
                                    .successSnackBar('Comment Added'));
                                commentController.clear();
                              } catch (e) {
                                Get.showSnackbar(AppStyles()
                                    .failedSnackBar('something is wrong'));
                              }
                            }
                          },
                          icon: Icon(
                            Icons.send,
                          )),
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Field can\'t be null';
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

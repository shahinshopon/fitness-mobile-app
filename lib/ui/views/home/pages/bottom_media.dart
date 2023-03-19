import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/const/app_colors.dart';
import 'package:fitness/ui/route/routes.dart';
import 'package:fitness/ui/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BottomMedia extends StatelessWidget {
  const BottomMedia({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            color: Get.isDarkMode == false ? Colors.white : AppColors.dark,
            child: TabBar(
              indicatorColor: AppColors.amber,
              tabs: [
                Tab(
                  text: 'Podcast',
                ),
                Tab(
                  text: 'Video',
                ),
                Tab(
                  text: 'Blog',
                )
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            MediaItem(
              documentName: "podcast",
            ),
            MediaItem(
              documentName: "video",
            ),
            MediaItem(
              documentName: "blog",
            ),
          ],
        ),
      ),
    );
  }
}

class MediaItem extends StatelessWidget {
  String documentName;
  MediaItem({required this.documentName});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("items")
          .doc(documentName)
          .snapshots(),
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          // return Text('Error = ${snapshot.error}');
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.amber,
            ),
          );
        }

        if (snapshot.hasData) {
          var docs = snapshot.data!.data()!['categories'];
          //print('111111111111111 $docs');

          return Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 20),
            child: GridView.builder(
                itemCount: docs.length ?? 0,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (_, i) {
                  // final data = docs[i].data();
                  return InkWell(
                    onTap: () {
                      Map data = {
                        'document_name': documentName,
                        'category_name': docs[i]["category_name"],
                      };
                      Get.toNamed(subCategory, arguments: data);
                    },
                    child: Ink(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            docs[i]['category_img'],
                          ),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.maxFinite,
                          color: AppColors.amber.withOpacity(0.8),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              docs[i]['title'],
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          );
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
}

class SubCategory extends StatelessWidget {
  Map data;
  SubCategory({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data['category_name']),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("items")
            .doc(data['document_name'])
            .collection("all")
            .where(
              "category",
              isEqualTo: data['category_name'],
            )
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasError)
            return Center(
              child: CircularProgressIndicator(),
            );

          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;

            return Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 20),
              child: GridView.builder(
                  itemCount: docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (_, i) {
                    final item = docs[i].data();
                    return InkWell(
                      onTap: () {
                        Map detailsData = {
                          'type': data['document_name'],
                          'item_data': item,
                          'document_id': docs[i].id,
                        };

                        Get.toNamed(detailsScreen, arguments: detailsData);
                      },
                      child: Ink(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage((item["thumbnail"])),
                          ),
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
                                item['title'],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.amber,
            ),
          );
        },
      ),
    );
  }
}

class DetailsScreen extends StatefulWidget {
  Map detailsData;
  DetailsScreen({required this.detailsData});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
// For Audio
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  String? time(Duration duration) {
    String twodigits(int n) => n.toString().padLeft(2, '0');
    final hours = twodigits(duration.inHours);
    final minutes = twodigits(duration.inMinutes.remainder(60));
    final seconds = twodigits(duration.inSeconds.remainder(60));

    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  Future setAudio(data) async {
    audioPlayer.setReleaseMode(ReleaseMode.stop);

    audioPlayer.setSourceUrl(data);
  }

  configureAudio() {
    print(widget.detailsData['item_data']['url']);
    setAudio(widget.detailsData['item_data']['url']);
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (this.mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      if (this.mounted) {
        setState(() {
          duration = newDuration;
        });
      }
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      if (this.mounted) {
        setState(() {
          position = newPosition;
        });
      }
    });
  }

  // For Video
  late VideoPlayerController _videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
  final CustomVideoPlayerSettings _customVideoPlayerSettings =
      const CustomVideoPlayerSettings(
    placeholderWidget: Center(
      child: CircularProgressIndicator(),
    ),
    exitFullscreenOnEnd: true,
    deviceOrientationsAfterFullscreen: [DeviceOrientation.portraitUp],
  );

  configureVideo() {
    _videoPlayerController = VideoPlayerController.network(
      widget.detailsData['item_data']['url'],
    )..initialize().then((value) => setState(() {}));

    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
      customVideoPlayerSettings: _customVideoPlayerSettings,
    );
  }

  // carousel slider
  final RxInt _currentIndex = 0.obs;

  //add to favourite
  final box = GetStorage();
  String? userEmail;

  addtoFavourite() async {
    FirebaseFirestore.instance
        .collection('user\'s_favourite')
        .doc(userEmail)
        .collection("items")
        .doc()
        .set(
          {
            'data': widget.detailsData,
            'document_id': widget.detailsData['document_id'],
          },
        )
        .then((value) => Get.showSnackbar(
            AppStyles().successSnackBar('Added to the favourite.')))
        .catchError((error) => Get.showSnackbar(
            AppStyles().failedSnackBar("Failed to add user: $error")));
  }

  // check favourite
  Stream<QuerySnapshot<Map<String, dynamic>>> checkFav(
      BuildContext context) async* {
    yield* FirebaseFirestore.instance
        .collection("user\'s_favourite")
        .doc(userEmail)
        .collection("items")
        .where('document_id', isEqualTo: widget.detailsData['document_id'])
        .snapshots();
  }

  // //add or remove like
  // Future likeFeature() async {
  //   try {
  //     //if user already like it
  //     if (widget.detailsData['item_data']['total_likes']
  //         .contains(FirebaseAuth.instance.currentUser!.uid.toString())) {
  //       FirebaseFirestore.instance
  //           .collection('items')
  //           .doc(widget.detailsData['type'])
  //           .collection('all')
  //           .doc(widget.detailsData['document_id'])
  //           .update({
  //         'total_likes':
  //             FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
  //       });
  //       setState(() {

  //       });
  //     }
  //     //if user not like it
  //     else {
  //       FirebaseFirestore.instance
  //           .collection('items')
  //           .doc(widget.detailsData['type'])
  //           .collection('all')
  //           .doc(widget.detailsData['document_id'])
  //           .update({
  //         'total_likes':
  //             FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
  //       });
  //       setState(() {

  //       });
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", e.toString(), duration: Duration(seconds: 30));
  //   }
  // }

  @override
  void initState() {
    userEmail = box.read('email');
    // audio initialization
    if (widget.detailsData['type'] == 'podcast') {
      configureAudio();
    }
    // video initialization
    if (widget.detailsData['type'] == 'video') {
      configureVideo();
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.detailsData['type'] == 'podcast') {
      audioPlayer.dispose();
    }
    if (widget.detailsData['type'] == 'video') {
      _customVideoPlayerController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime dt =
        (widget.detailsData['item_data']['time_stamp'] as Timestamp).toDate();
    // current user rating value read
    var ratingBox = box.read(
        '${widget.detailsData['document_id']}-${FirebaseAuth.instance.currentUser!.uid}');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.detailsData['type'].toString().toUpperCase(),
        ),
        actions: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: checkFav(context),
            builder: (context, snapshot) {
              if (snapshot.data == null) return Center(child: Text("Loading"));
              return IconButton(
                icon: snapshot.data!.docs.length == 0
                    ? Icon(
                        Icons.favorite_outline,
                      )
                    : Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                onPressed: () {
                  snapshot.data!.docs.length == 0
                      ? addtoFavourite()
                      : Get.showSnackbar(
                          AppStyles().failedSnackBar('Already Added'));
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Podcast Player
              if (widget.detailsData['type'] == 'podcast')
                Column(
                  children: [
                    Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(
                              widget.detailsData['item_data']['thumbnail'],
                            ),
                            fit: BoxFit.cover),
                      ),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.amber,
                          ),
                          child: IconButton(
                            onPressed: () async {
                              if (isPlaying) {
                                await audioPlayer.pause();
                              } else {
                                await audioPlayer.resume();
                              }
                            },
                            icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow),
                            iconSize: 30,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SliderTheme(
                      data: SliderThemeData(
                        overlayShape: SliderComponentShape.noThumb,
                      ),
                      child: Slider(
                          min: 0,
                          max: duration.inSeconds.toDouble(),
                          value: position.inSeconds.toDouble(),
                          onChanged: (value) async {
                            final position = Duration(seconds: value.toInt());
                            await audioPlayer.seek(position);
                            await audioPlayer.resume();
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(time(position) ?? ''),
                          Text(time(duration) ?? ''),
                        ],
                      ),
                    ),
                  ],
                ),

              // Video Player
              if (widget.detailsData['type'] == 'video')
                AspectRatio(
                  aspectRatio: 1.76,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CustomVideoPlayer(
                      customVideoPlayerController: _customVideoPlayerController,
                    ),
                  ),
                ),

              // Carousel Slider
              if (widget.detailsData['type'] == 'blog')
                Column(
                  children: [
                    SizedBox(
                      height: 140,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CarouselSlider(
                            items:
                                widget.detailsData['item_data']['blog_images']
                                    .map<Widget>((item) => Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(item),
                                                fit: BoxFit.cover),
                                          ),
                                        ))
                                    .toList(),
                            options: CarouselOptions(
                                autoPlay: true,
                                enlargeCenterPage: true,
                                viewportFraction: 1,
                                enlargeStrategy:
                                    CenterPageEnlargeStrategy.height,
                                onPageChanged:
                                    (val, carouselPageChangedReason) {
                                  _currentIndex.value = val;
                                })),
                      ),
                    ),
                    Center(
                      child: Obx(
                        () => DotsIndicator(
                          decorator: DotsDecorator(
                              activeColor: AppColors.amber,
                              size: Size(8, 8),
                              spacing:
                                  EdgeInsets.only(top: 5, left: 3, right: 3)),
                          dotsCount: widget
                              .detailsData['item_data']['blog_images'].length,
                          position: _currentIndex.value.toDouble(),
                        ),
                      ),
                    ),
                  ],
                ),

              Text(
                widget.detailsData['item_data']['title'],
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                widget.detailsData['item_data']['description'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Divider(),
              Text(
                'Uploaded Time: $dt',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue),
              ),
              Divider(),
              //like

              StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('items')
                      .doc(widget.detailsData['type'])
                      .collection('all')
                      .doc(widget.detailsData['document_id'])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        'Total Likes: ${snapshot.data!['total_likes'].length}',
                        // 'Total Likes: ${widget.detailsData['item_data']['total_likes'].length}',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500),
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
              Divider(),
              Row(
                children: [
                  Row(
                    children: [
                      LikeFeature(widget.detailsData['type'],
                          widget.detailsData['document_id']),
                      // StreamBuilder<DocumentSnapshot>(
                      //     stream: FirebaseFirestore.instance
                      //         .collection('items')
                      //         .doc(widget.detailsData['type'])
                      //         .collection('all')
                      //         .doc(widget.detailsData['document_id'])
                      //         .snapshots(),
                      //     builder: (context, snapshot) {
                      //       if (snapshot.hasData) {
                      //         return IconButton(
                      //             onPressed: likeFeature,
                      //             icon: snapshot.data!['total_likes'].contains(
                      //                     FirebaseAuth.instance.currentUser!.uid
                      //                         .toString())
                      //                 ? Icon(
                      //                     Icons.thumb_up,
                      //                   )
                      //                 : Icon(Icons.thumb_up_outlined));
                      //       }
                      //       return Center(child: CircularProgressIndicator());
                      //     }),
                      // IconButton(
                      //     onPressed: likeFeature,
                      //     icon: widget.detailsData['item_data']['total_likes']
                      //             .contains(FirebaseAuth
                      //                 .instance.currentUser!.uid
                      //                 .toString())
                      //         ? Icon(
                      //             Icons.thumb_up,
                      //           )
                      //         : Icon(Icons.thumb_up_outlined)),
                      Text(
                        'Like',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  VerticalDivider(),
                  //comment
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Map commentsData = {
                              'type': widget.detailsData['type'],
                              'documentID': widget.detailsData['document_id'],
                            };
                            Get.toNamed(commentsScreen,
                                arguments: commentsData);
                          },
                          icon: Icon(
                            Icons.comment_outlined,
                          )),
                      InkWell(
                        onTap: () {
                          Map commentsData = {
                            'type': widget.detailsData['type'],
                            'documentID': widget.detailsData['document_id'],
                          };
                          Get.toNamed(commentsScreen, arguments: commentsData);
                        },
                        child: Text(
                          'Comment',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                      )
                    ],
                  )
                ],
              ),
              Divider(),
              //rating
              Row(
                children: [
                  // average rating value
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('items')
                          .doc(widget.detailsData['type'])
                          .collection('all')
                          .doc(widget.detailsData['document_id'])
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!['rating'].values.isNotEmpty) {
                            return Text(
                              'Rating: ${snapshot.data!['rating'].values.fold(0, (p, c) => p + c) / snapshot.data!['rating'].values.length}',
                              // 'Total Likes: ${widget.detailsData['item_data']['total_likes'].length}',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            );
                          } else {
                           return Text('Rating: Not Rated Yet',style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500));
                          }
                        }
                        return Center(child: CircularProgressIndicator());
                      }),
                  // Text(
                  //     'Rating : ${widget.detailsData['item_data']['rating'].fold(0, (p, c) => p + c) / widget.detailsData['item_data']['rating'].length}',
                  //     style:
                  //         TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  SizedBox(
                    width: 20,
                  ),
                  RatingBar.builder(
                    initialRating: ratingBox == null ? 3 : ratingBox,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 30,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      //current user rating update value
                      FirebaseFirestore.instance
                          .collection('items')
                          .doc(widget.detailsData['type'])
                          .collection('all')
                          .doc(widget.detailsData['document_id'])
                          .update({
                        'rating': {
                          '${FirebaseAuth.instance.currentUser!.uid}': rating
                        }
                      });
                      // current user rating value store
                      box.write(
                          '${widget.detailsData['document_id']}-${FirebaseAuth.instance.currentUser!.uid}',
                          rating);
                    },
                  ),
                ],
              ),
              Divider(),
              Flex(
                direction: Axis.vertical,
                children: [
                  Text(
                    'Related Items',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  print(widget.detailsData);
                },
                child: Text('Play'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LikeFeature extends StatefulWidget {
  LikeFeature(this.doc1, this.doc2);
  var doc1, doc2;

  @override
  State<LikeFeature> createState() => _LikeFeatureState();
}

class _LikeFeatureState extends State<LikeFeature> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('items')
          .doc(widget.doc1)
          .collection('all')
          .doc(widget.doc2)
          .snapshots(),
      builder: (context, snapshot) {
        return IconButton(
            onPressed: () {
              try {
                //if user already like it
                if (snapshot.data!['total_likes'].contains(
                    FirebaseAuth.instance.currentUser!.uid.toString())) {
                  FirebaseFirestore.instance
                      .collection('items')
                      .doc(widget.doc1)
                      .collection('all')
                      .doc(widget.doc2)
                      .update({
                    'total_likes': FieldValue.arrayRemove(
                        [FirebaseAuth.instance.currentUser!.uid])
                  });
                  setState(() {});
                }
                //if user not like it
                else {
                  FirebaseFirestore.instance
                      .collection('items')
                      .doc(widget.doc1)
                      .collection('all')
                      .doc(widget.doc2)
                      .update({
                    'total_likes': FieldValue.arrayUnion(
                        [FirebaseAuth.instance.currentUser!.uid])
                  });
                  setState(() {});
                }
              } catch (e) {
                Get.snackbar("Error", e.toString(),
                    duration: Duration(seconds: 3));
              }
            },
            //checker for icon button
            icon: snapshot.hasData? (snapshot.data!['total_likes']
                                   .contains(FirebaseAuth
                                       .instance.currentUser!.uid
                                       .toString()))? Icon(Icons.thumb_up): Icon(Icons.thumb_up_outlined):CircularProgressIndicator());
      },
    );
  }
}

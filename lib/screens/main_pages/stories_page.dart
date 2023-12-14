import 'dart:async';
import 'package:flutter/material.dart';
import 'package:diploma_work/widgets/view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:diploma_work/screens/provider/image_provider/user_provider.dart';

class StoriesPage extends StatefulWidget {
  const StoriesPage({super.key});

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  final TextEditingController searchController = TextEditingController();

  String name = '';
        List<Map<String, dynamic>> stories = [];

  late String _currentDate;

  @override
  void initState() {
    searchController.addListener(() {
      setState(() {});
    });
    super.initState();
    initializeDateFormatting(
        'ru'); // инициализация локализации на русском языке
    loadData();
    _getCurrentDate();
    getStoriesData();
  }

  void _getCurrentDate() {
    setState(() {
      final now = DateTime.now();
      final formatter = DateFormat('EEEE, dd MMMM', 'ru'); // указываем локаль
      _currentDate = formatter.format(now);
    });
  }

  Future<void> loadData() async {
    try {
      final auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      if (user != null) {
        final FirebaseFirestore firestore = FirebaseFirestore.instance;
        final DocumentSnapshot snapshot =
            await firestore.collection('users').doc(user.uid).get();
        setState(() {
          name = snapshot.get('name');
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void getStoriesData() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('stories')
          .get();

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

          if (data != null &&
              data.containsKey('username') &&
              data.containsKey('image_url') && data.containsKey('image')) {
            setState(() {
              stories.add({
                'username': data['username'],
                'image':data['image'],
                'imageUrl': data['image_url'],
              });
            });
          } else {
            print('Invalid document structure: ${doc.id}');
          }
        }
      } else {
        print('No stories found');
      }
    } catch (e) {
      print('Error: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    final String? imageUrl = Provider.of<AvatarProvider>(context).imageUrl;

    return Scaffold(appBar: AppBar(
          automaticallyImplyLeading: false, // Убрать кнопку "назад"

      title: Center(
        child: Text(
                    'Мои сторисы',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
      ),
                backgroundColor: Colors.white,
    ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: imageUrl != null
                            ? NetworkImage(imageUrl) as ImageProvider<Object>
                            : AssetImage('images/logo.png'),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Привет, ${name}",
                          style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.normal),
                        ),
                        Text(
                          _currentDate,
                          style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                       
                        
                      ],
                    ),
                    
                  ],
                ),
                Divider(color: Colors.black, thickness: 1,),
                

                // List of stories as ListTile
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: stories.length,
                  itemBuilder: (context, index) {

                    return Container(
                      margin: EdgeInsets.only(top: 10),
                      child: ListTile(
                        
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            stories[index]['imageUrl'],
                          ),
                        ),
                        title: Text(stories[index]['username']),
                        onTap: () {
                         Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 500),
                              pageBuilder: (_, __, ___) => FadeTransition(
                                opacity: Tween<double>(
                                  begin: 0.0,
                                  end: 1.0,
                                ).animate(
                                  CurvedAnimation(
                                    parent: __,
                                    curve: Curves.easeInOut,
                                  ),
                                ),
                                child: UserProfilePage(
                                  imageUrl: stories[index]['image'],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      
      bottomNavigationBar: BottomNavBar(),
    );
  }
}



class UserProfilePage extends StatelessWidget {
  final String? imageUrl;

  const UserProfilePage({Key? key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.black), // Черная стрелка "назад"

        backgroundColor: Colors.white,
        title: Text('User Profile', style: TextStyle(color: Colors.black),),
      ),
      body: Center(
        child: imageUrl != null
            ? Image.network(imageUrl!) // Display the 'image' here
            : Placeholder(), // Placeholder if imageUrl is null
      ),
    );
  }
}
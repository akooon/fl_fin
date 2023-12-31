import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:diploma_work/screens/news_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diploma_work/model/firebase_data.dart';
import 'package:shimmer/shimmer.dart';

class ForegroundWidget extends StatefulWidget {
  const ForegroundWidget({super.key, required this.searchController});

  final TextEditingController searchController;

  @override
  State<ForegroundWidget> createState() => _ForegroundWidgetState();
}

class _ForegroundWidgetState extends State<ForegroundWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('foregrounds').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: List.generate(
                      5, // Adjust the number of shimmering items as needed
                      (index) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 238, 240, 241),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 250,
                                color: Colors.grey, // Placeholder color
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: 200,
                                height: 14,
                                color: Colors.grey, // Placeholder color
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: 100,
                                height: 14,
                                color: Colors.grey, // Placeholder color
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: 150,
                                height: 14,
                                color: Colors.grey, // Placeholder color
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: 120,
                                height: 14,
                                color: Colors.grey, // Placeholder color
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: 340,
                                height: 40,
                                color: Colors.grey, // Placeholder color
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              default:
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children:
                        snapshot.data!.docs.where((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      String name = data['name'].toLowerCase();
                      String location = data['location'].toLowerCase();
                      String searchTerm =
                          widget.searchController.text.toLowerCase();
                      RegExp regExp = RegExp(searchTerm, unicode: true);

                      return name.contains(searchTerm) ||
                          location.contains(searchTerm);
                    }).map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      FirebaseData firebaseData = FirebaseData(
                          image: data['image_url'],
                          name: data['name'],
                          playersQuantity: data['playersQuantity'],
                          location: data['location'],
                          coatingType: data['coatingType'],
                          description: data['description'],
                          price: data['price']);
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 238, 240, 241)),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                child: Image.network(
                                  data['image_url'],
                                  width: double.infinity,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Text(
                                    data['name'],
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Container(
                                  margin: EdgeInsets.only(right: 20),
                                  child: Image.asset(
                                    'images/check.png',
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 18,
                                ),
                                Image.asset(
                                  'images/placeholder.png',
                                  height: 20,
                                  width: 20,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  data['location'],
                                  style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      color: Colors.black.withOpacity(0.5)),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                           
                            const SizedBox(
                              height: 10,
                            ),
                           
                            const SizedBox(
                              height: 10,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NewsPage(
                                      firebaseData: firebaseData,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color(0xFF646AFF),
                                ),
                                width: 340,
                                height: 40,
                                child: Center(
                                    child: Text(
                                  'ЧИТАТЬ ДАЛЕЕ',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
            }
          },
        ),
      ],
    );
  }
}

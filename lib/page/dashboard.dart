import 'dart:io';

import 'package:fashion2/page/gridview/pageAbout.dart';
import 'package:fashion2/page/gridview/pageJob.dart';
import 'package:fashion2/page/gridview/pagePapers.dart';
import 'package:fashion2/page/pageDrawer.dart';
import 'package:fashion2/page/profileAtelierPage.dart';
import 'package:fashion2/page/search.dart';
import 'package:flutter/material.dart';
import 'package:fashion2/widgets/atelierRegisterScreen.dart';

import 'gridview/pageModels.dart';
import 'gridview/pagePdf.dart';
import 'gridview/pageQuiz.dart';

class Dashboard extends StatefulWidget {
  final File? selectedImage;
  const Dashboard({super.key,this.selectedImage});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {



  var height, width;

  List  imgData = [
    "assets/images/models.png",
    "assets/images/stock.png",
    "assets/images/paiement.png",
    "assets/images/apointment.png",
    "assets/images/media.png",
    "assets/images/clients.png",
  ];

  List titles = [
    "Models",
    "Stock",
    "Paiement",
    "Rendez-vous",
    "Publication",
    "Client"
  ];

  List<Widget> pages = [
    PageModels(), // Remplacez PageOne, PageTwo, etc. par vos propres widgets de page
    StockManagementPage(),
    InvoiceAndAccountingPage(),
    AppointmentAndSchedulingPage(),
    MarketingAndPromotionPage(),
    CustomerInformationPage(),
  ];

  @override
  Widget build(BuildContext context) {
   height = MediaQuery.of(context).size.height;
   width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFF09126C),
          height: height,
          width: width,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF09126C)
                ),
                height: height * 0.19,
                width: width,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 35,
                        left: 20,
                        right: 20
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: (){
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PageDrawer(), // Remplacez PageDefault par votre widget de page par défaut
                                  ),
                                );
                            },
                            child: Icon(
                              Icons.sort,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          Text(
                            "Dashboard",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileAtelierPage()));
                              // Naviguer vers la nouvelle page de profil ici
                              // Vous devez définir votre propre logique de navigation
                              // Par exemple, vous pouvez utiliser Navigator pour naviguer vers la nouvelle page.
                            },
                            child:
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                image: widget.selectedImage != null
                                    ? DecorationImage(
                                  image: FileImage(widget.selectedImage!),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                              ),
                            )
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage()));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 20,
                          left: 20,
                          right: 20
                        ),
                        child: Container(
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white,
                              width: 1.4
                            ),
                            borderRadius: BorderRadius.circular(25)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Icon(Icons.search, color: Colors.grey),
                                  ),
                                  Text(
                                    "Search...",
                                    style: TextStyle(
                                        color: Colors.grey
                                    ),
                                  )
                                ],
                              ),

                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(25)
                                ),
                                height: 40,
                                width: 80,
                                child: Center(
                                  child: Text(
                                    "Recherche",
                                    style: TextStyle(
                                      color: Colors.white
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Padding(
                    //     padding: EdgeInsets.only(
                    //       top: 10,
                    //       left: 10,
                    //     ),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: [
                    //       Text(
                    //           "Dashboard",
                    //         style: TextStyle(
                    //           fontSize: 20,
                    //           color: Colors.white,
                    //           fontWeight: FontWeight.w500,
                    //           letterSpacing: 1,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  height: height * 0.81,
                  width: width,
                  padding: EdgeInsets.only(
                    bottom: 10
                  ),
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.1,
                        mainAxisSpacing: 25,
                      ),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: imgData.length,
                      itemBuilder: (context, index){
                        return InkWell(
                          onTap: (){
                              if (index >= 0 && index < pages.length) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => pages[index]),
                                );
                              }
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 20
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                )
                              ]
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(imgData[index],
                                  width: 100,
                                ),
                                Text(
                                    titles[index],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold

                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


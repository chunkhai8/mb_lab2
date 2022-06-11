import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'class def/tutor.dart';
import 'constants.dart';

class Tutors extends StatefulWidget {
  const Tutors({Key? key}) : super(key: key);

  @override
  State<Tutors> createState() => _TutorsState();
}

class _TutorsState extends State<Tutors> {
  List<Tutor> tutorList = <Tutor>[];
  String titlecenter = "Loading...";
  var numofpage, curpage = 1;
  var color;
  late double screenHeight, screenWidth, resWidth;

  @override
  void initState() {
    super.initState();
      _loadtutors(1);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 400) {
      resWidth = screenWidth*0.5;
      //rowcount = 2;
    } else {
      resWidth = screenWidth * 0.25;
      //rowcount = 3;
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          title: const Text('Tutors'),
        ),
        body: tutorList.isEmpty 
        ? Center(
          child: Text(titlecenter,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))
        ): Column(
            children: [
           const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text("Tutors Available",
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 1,
                  children: List.generate(tutorList.length, (index) {
                    return Card(
                      child: Column(
                        children: [
                          Flexible(
                            flex:5,
                            child: CachedNetworkImage(
                                  imageUrl: CONSTANTS.server +
                                      "/mytutor/asset/tutors/" + 
                                      tutorList[index].tutorid.toString() +
                                      '.jpg',
                                  fit: BoxFit.cover,
                                  width: resWidth,
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                            ),
                          ),
                          Flexible(
                            flex:5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment:CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    "Name: "+
                                    tutorList[index].tutorname.toString(),
                                    style: const TextStyle(
                                    fontSize: 14),
                                  ),
                                  Text(
                                    "Email: "+
                                    tutorList[index].tutoremail.toString(),
                                    style: const TextStyle(
                                    fontSize: 14,)
                                  ),
                                  Text(
                                    "Phone number: "+
                                    tutorList[index].tutorphone.toString(),
                                    style: const TextStyle(
                                    fontSize: 14),
                                  ),
                                  Text(
                                    "Description: "+
                                    tutorList[index].tutordescription.toString(),
                                    style: const TextStyle(
                                    fontSize: 13),
                                  ),
                                ]
                              ),
                            ),
                          ),
                        ]
                      )
                    );
              }
              ))),
              SizedBox(
                  height: 30,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numofpage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if ((curpage - 1) == index) {
                        color = Colors.lightGreen;
                      } else {
                        color = Colors.grey;
                      }
                      return SizedBox(
                        width: 40,
                        child: TextButton(
                            onPressed: () => {_loadtutors(index + 1)},
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(color: color),
                            )),
                      );
                    },
                  ),
                ),
          ],
        ),
          
    );
  }

  void _loadtutors(int pageno) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
          Uri.parse(CONSTANTS.server + "/mytutor/load_tutor.php"),
          body: {
            'pageno': pageno.toString(),
            }).then((response) {
      var jsondata = jsonDecode(response.body);
      //print(jsondata);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);
        if (extractdata['tutors'] != null) {
           tutorList = <Tutor>[];
          extractdata['tutors'].forEach((v) {
            tutorList.add(Tutor.fromJson(v));
          });
        } else {
          titlecenter = "No Tutor Available";
          tutorList.clear();
         }
        setState(() {});
         } else {
        //do something
        titlecenter = "No Tutor Available";
        tutorList.clear();
        setState(() {});
      
        }
  });
  }
}
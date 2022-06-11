import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'class def/subject.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;

class Subjects extends StatefulWidget {
  const Subjects({Key? key}) : super(key: key);

  @override
  State<Subjects> createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  List<Subject> subjectList = <Subject>[];
  String titlecenter = "Loading...";
  var numofpage, curpage = 1;
  var color;
  late double screenHeight, screenWidth, resWidth;

  @override
  void initState() {
    super.initState();
      _loadSubjects(1);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth*0.60;
      //rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      //rowcount = 3;
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          title: const Text('Subjects'),
        ),
        body: subjectList.isEmpty 
        ? Center(
          child: Text(titlecenter,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))
        ): Column(
            children: [
           const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text("Subjects Available",
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 1,
                  children: List.generate(subjectList.length, (index) {
                    return Card(
                      child: Column(
                            children: [
                              Flexible(
                                flex: 5,
                                child: CachedNetworkImage(
                                  imageUrl: CONSTANTS.server +
                                      "/mytutor/asset/courses/" +
                                      subjectList[index].subjectid.toString() +
                                      '.png',
                                  fit: BoxFit.cover,
                                  width: resWidth,
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Flexible(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment:CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      "Course name: " +
                                      subjectList[index].subjectname.toString(),
                                      style: const TextStyle(
                                          fontSize: 14,fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Price: RM" +
                                          subjectList[index].subjectprice.toString() +
                                          " / " +
                                          subjectList[index].subjectsessions.toString() +
                                          " hours",
                                      style: const TextStyle(
                                        fontSize: 12),
                                    ),
                                    Text(
                                      "Teach by tutor " +
                                          subjectList[index].tutorid.toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "Rating: " +
                                          subjectList[index].subjectrating.toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "Description: "+
                                      subjectList[index].subjectdescription.toString(),
                                      style: const TextStyle(
                                      fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
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
                            onPressed: () => {_loadSubjects(index + 1)},
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

  void _loadSubjects(int pageno) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
          Uri.parse(CONSTANTS.server + "/mytutor/load_subject.php"),
          body: {
            'pageno': pageno.toString(),
            }).then((response) {
      var jsondata = jsonDecode(response.body);
      //print(jsondata);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);
        if (extractdata['subjects'] != null) {
           subjectList = <Subject>[];
          extractdata['subjects'].forEach((v) {
            subjectList.add(Subject.fromJson(v));
          });
        } else {
          titlecenter = "No Subject Available";
          subjectList.clear();
         }
        setState(() {});
         } else {
        //do something
        titlecenter = "No Subject Available";
        subjectList.clear();
        setState(() {});
      
        }
  });
  }
}
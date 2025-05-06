import 'package:flutter/material.dart';

class Home extends StatefulWidget{
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: (){}, child: Icon(Icons.add, color: Colors.white,),),
      body: Container(
        margin: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
        child: Column(
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Student",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  "Attendance",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.0,),
            Material(
              elevation: 5.0,
              child: Container(
                padding: EdgeInsets.only(left: 20.0,top: 10.0,bottom: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              Row(
              children: const [
            Text(
            "Student Name :",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Text(
              "M.Achidus Syiblih",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ],
  ),
),
            )
          ],
        ),
      ),
    );
  }
}
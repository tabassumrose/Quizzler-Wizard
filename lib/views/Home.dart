import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizzler_app/helper/functions.dart';
import 'package:quizzler_app/main.dart';
import 'package:quizzler_app/services/database.dart';
import 'package:quizzler_app/views/create_quiz.dart';
import 'package:quizzler_app/views/play_quiz.dart';
import 'package:quizzler_app/widget/widgets.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream quizStream;
  DatabaseService databaseService = new DatabaseService();

  Widget quizList(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder(
        stream: quizStream,
        builder: (context,snapshot){
          return snapshot.data == null
              ? Container():
              ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index){
                  return QuizTile(
                    imgUrl: snapshot.data.documents[index].data["quizImgurl"],
                    desc: snapshot.data.documents[index].data["quizDesc"],
                    title: snapshot.data.documents[index].data["quizTitle"],
                    quizid: snapshot.data.documents[index].data["quizId"],
                  );
                });
        },
      ),
    );
  }

  @override
  void initState() {
    databaseService.getQuizezData().then((val){
      setState((){
        quizStream = val;
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        actions: [
          FlatButton.icon(
            onPressed: () {
              FirebaseAuth.instance.signOut();
                HelperFunctions.saveUserLoggedInDetails(isLoggedin: false);

              Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
            },
            icon: Icon(
              Icons.person_outline,
              color: Colors.blue,

            ),
            label: Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
            ))
        ],
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: quizList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => CreateQuiz()
          ));
        },
      ),
    );
  }
}


class QuizTile extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String desc;
  final String quizid;
  QuizTile({@required this.imgUrl,
            @required this.title,
            @required this.desc,
            @required this.quizid});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context)  => PlayQuiz(
            quizid
          )
        ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        height: 150,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(imgUrl,width: MediaQuery.of(context).size.width - 48, fit: BoxFit.cover,)),
            Container(

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),color: Colors.black26,
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(title, style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),),

                SizedBox(height: 6,),
                Text(desc, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),),
              ],),
            )
          ],
        ),
      ),
    );
  }
}
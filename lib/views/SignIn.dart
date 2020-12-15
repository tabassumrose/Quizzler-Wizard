import 'package:flutter/material.dart';
import 'package:quizzler_app/helper/functions.dart';
import 'package:quizzler_app/services/auth.dart';
import 'package:quizzler_app/views/Home.dart';
import 'package:quizzler_app/widget/widgets.dart';

import 'SignUp.dart';
class SignIn extends StatefulWidget {

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String email, password;
  AuthService authService = new AuthService();

  bool _isLoading = false;

  signIn() async {
    if(_formKey.currentState.validate()){

      setState(() {
        _isLoading = true;
      });
      await authService.signInEmailAndPass(email, password).then((val){
          if(val != null) {
            setState(() {
              _isLoading = false;
            });
            HelperFunctions.saveUserLoggedInDetails(isLoggedin: true);
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => Home()
            ));
          }
        });
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: _isLoading ? Container(
        child: Center(
        child: CircularProgressIndicator(),
        ),
      ) : Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Spacer(),
              TextFormField(
                validator: (val){ return val.isEmpty ? "enter Emailid" : null;
                },
                decoration: InputDecoration(
                  hintText: "Email"
                ),
                onChanged: (val){
                  email = val;
                },
              ),
              SizedBox(height: 6,),
              TextFormField(
                obscureText: true,
                validator: (val){ return val.isEmpty ? "enter password" : null;
                },
                decoration: InputDecoration(
                    hintText: "Password"
                ),
                onChanged: (val){
                password = val;
                },
                  ),
              SizedBox(height: 24,),
              
              
              GestureDetector(
                onTap:  (){
                signIn();
                },
                  child: blueButton(
                      context: context,
                      label: "Sign In"),
              ),
              
              
              SizedBox(height:18,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ", style: TextStyle(fontSize: 16),),
                  GestureDetector(
                      onTap: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUp()
                        ));
                      },
                      child: Text("Sign Up ", style: TextStyle(fontSize: 16, decoration: TextDecoration.underline),)),
                ],
              ),


              SizedBox(height:80,),
            ],
          ),
        ),
      ),
    );
  }
}
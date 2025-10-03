import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/views/auth/register_screen.dart';

import '../../viewmodels/auth_viewmodel.dart';
import '../game_view.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AuthViewModel>(context);

    if (vm.currentUser != null) {
      return const GameView(); // user logged in
    }

    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Login",style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600
                        ),),
                        SizedBox(height: 50,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Email"),
                            SizedBox(height: 10,),
                            TextFormField(
                              controller: emailCtrl,
                              validator: (value) {
                                if(value!.isEmpty){
                                  return 'Please enter your email';
                                }
                                else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                else{
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Email",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Color(0XFF4866F0).withOpacity(0.1),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Text("Password"),
                            SizedBox(height: 10,),
                            TextFormField(
                              obscureText:  true,
                              controller: passCtrl,
                              validator: (value) {
                                if(value!.isEmpty){
                                  return 'Please enter your password';
                                }else if(value.length < 6){
                                  return "Password should be at least 6 characters long.";
                                }
                                else{
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Color(0XFF4866F0).withOpacity(0.1),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(onPressed: (){
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  //   return ForgotPasswordScreen();
                                  // },));
                                }, child: Text("Forgot Password")),
                              ],
                            ),
                            SizedBox(height: 48,),
                            TextButton(onPressed: (){
                              if(_formKey.currentState!.validate()) {
                                // signIn();
                              }
                            },
                                style: TextButton.styleFrom(
                                  fixedSize: Size(MediaQuery.of(context).size.width, 52),
                                  backgroundColor: Color(0XFF4866F0),
                                ),
                                child: Text("Login",style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: 20
                                ),)),
                            SizedBox(height: 30,),
                            Center(child: Text("OR",style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 14
                            ),)),
                            SizedBox(height: 30,),
                            TextButton(onPressed: () async{
                              try{
                                // await UserService().googleSaveUser();
                                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                //   return Navbar();
                                // },));
                              }catch(error){
                                print("Error : $error");
                                  showDialog(context: context, barrierDismissible: false,builder: (context) => AlertDialog(
                                    title: const Text('Error'),
                                    content: Text('Error signing in with google: $error'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),);
                                }
                            },
                                style: TextButton.styleFrom(
                                    fixedSize: Size(MediaQuery.of(context).size.width, 52),
                                    backgroundColor: Colors.grey.shade300,
                                    side: BorderSide(
                                        color: Colors.grey
                                    )
                                ),
                                child: Image.asset("assets/images/google.png",height: 30,)),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("Haven't an account"),
                                TextButton(onPressed: (){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                    return RegisterScreen();
                                  },));
                                }, child: Text("Register")),
                              ],
                            ),
                            SizedBox(height: 50,),
                          ],
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

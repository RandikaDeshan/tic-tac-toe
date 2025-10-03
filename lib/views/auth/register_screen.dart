import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/views/game_view.dart';
import 'package:tic_tac_toe/views/home_page.dart';

import '../../viewmodels/auth_viewmodel.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AuthViewModel>(context);
    return Scaffold(
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator()) :
      SafeArea(
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
                        Text("Sign Up",style: TextStyle(
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
                              controller: _emailController,
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
                              controller: _passwordController,
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
                              obscureText: true,
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
                            SizedBox(height: 20,),
                            Text("Confirm Password"),
                            SizedBox(height: 10,),
                            TextFormField(
                              controller: _confirmPasswordController,
                              validator: (value) {
                                if(value!.isEmpty){
                                  return 'Please re-enter your password';
                                }else if(value.length < 6){
                                  return "Password should be at least 6 characters long.";
                                }else if(_passwordController.text != _confirmPasswordController.text){
                                  return "Password and Confirm Password should be similar";
                                }
                                else{
                                  return null;
                                }
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: "Confirm Password",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Color(0XFF4866F0).withOpacity(0.1),
                              ),
                            ),
                            SizedBox(height: 48,),
                            TextButton(onPressed: () async{
                              if(_formKey.currentState!.validate()){
                                await vm.registerWithEmail(_emailController.text, _passwordController.text);
                                if (vm.errorMessage == null && vm.currentUser != null) {
                                  if (!mounted) return;
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const HomePage()),
                                  );
                                } else {
                                  if (!mounted) return;
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text("Registration Failed"),
                                      content: Text(vm.errorMessage ?? "Unknown error"),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text("OK"),
                                        )
                                      ],
                                    ),
                                  );
                                }
                              }
                            },
                                style: TextButton.styleFrom(
                                  fixedSize: Size(MediaQuery.of(context).size.width, 52),
                                  backgroundColor: Color(0XFF4866F0),
                                ),
                                child: Text("Register",style: TextStyle(
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
                                await vm.signInWithGoogle();
                                if (vm.errorMessage == null && vm.currentUser != null) {
                                  if (!mounted) return;
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const HomePage()),
                                  );
                                } else {
                                  if (!mounted) return;
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text("Registration Failed"),
                                      content: Text(vm.errorMessage ?? "Unknown error"),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text("OK"),
                                        )
                                      ],
                                    ),
                                  );
                                }
                              }catch(error){
                                print("Error : $error");
                                if(mounted){
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
                                Text("Already have an account"),
                                TextButton(onPressed: (){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                    return LoginScreen();
                                  },));
                                }, child: Text("Login")),
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

import 'package:flutter/material.dart';
import 'package:interactive_forms_with_rive/core/component/dialog/loading_dialog.dart';
import 'package:interactive_forms_with_rive/core/theme/app_color.dart';
import 'package:interactive_forms_with_rive/module/home/presentation/home_screen.dart';
import 'package:rive/rive.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String validEmail = "Dandi@gmail.com";
  String validPassword = "12345";

  /// input form controller
  FocusNode emailFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();

  FocusNode passwordFocusNode = FocusNode();
  TextEditingController passwordController = TextEditingController();

  FocusNode confirmpasswordFocusNode = FocusNode();
  TextEditingController confirmpasswordController = TextEditingController();

  /// rive controller and input
  StateMachineController? controller;

  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;

  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  @override
  void initState() {
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordFocus);
    confirmpasswordFocusNode.addListener(confirmpasswordFocus) ;
    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(emailFocus);
    passwordFocusNode.removeListener(passwordFocus);
    confirmpasswordFocusNode.removeListener(confirmpasswordFocus);
    super.dispose();
  }

  void emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void passwordFocus() {
    isHandsUp?.change(passwordFocusNode.hasFocus);
  }

  void confirmpasswordFocus() {
    isHandsUp?.change(confirmpasswordFocusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    print("Build Called Again");
    return Scaffold(
      backgroundColor: AppColor.greenit,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Container(
              height: 100,
              width: 100,
              padding: const EdgeInsets.all(16),
              // decoration: const BoxDecoration(
              //   color: Color(0xFF164652),
              //   // shape: BoxShape.circle,
              // ),
              child: const Image(
                image: AssetImage("assets/avatar.png"),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "WELCOME",
              style: TextStyle (fontSize: 40, color: Color(0xffffd4d4) , fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 250,
              width: 250,
              child: RiveAnimation.asset(
                "assets/animated_login_character.riv",
                fit: BoxFit.fitHeight,
                stateMachines: const ["Login Machine"],
                onInit: (artboard) {
                  controller = StateMachineController.fromArtboard(
                    artboard,

                    /// from rive, you can see it in rive editor
                    "Login Machine",
                  );
                  // artboard.forEachComponent((child) {
                  //   if(child == 'Fill'){
                  //     Fill fill = child;
                  //     // shape.fills..paint.color = AppColor.greenit;
                  //     fill.paint.color
                  //   }
                  // });
                  if (controller == null) return;

                  artboard.addController(controller!);
                  isChecking = controller?.findInput("isChecking");
                  numLook = controller?.findInput("numLook");
                  isHandsUp = controller?.findInput("isHandsUp");
                  trigSuccess = controller?.findInput("trigSuccess");
                  trigFail = controller?.findInput("trigFail");
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColor.blockit,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: TextField(
                      focusNode: emailFocusNode,
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Email",
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                      onChanged: (value) {
                        numLook?.change(value.length.toDouble());
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: TextField(
                      focusNode: passwordFocusNode,
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: " Set Password",
                      ),
                      obscureText: true,
                      style: Theme.of(context).textTheme.bodyMedium,
                      onChanged: (value) {},
                    ),
                  ),


                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: TextField(
                      focusNode: confirmpasswordFocusNode,
                      controller: confirmpasswordController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: " Confirm Password",
                      ),
                      obscureText: true,
                      style: Theme.of(context).textTheme.bodyMedium,
                      onChanged: (value) {},
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,

                    child: Padding(
                      padding: EdgeInsets.only(top: 15),

                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomeScreen()),
                          );
                        },
                      child :Text ("Already Registered, Login",
                        style: TextStyle(
                          fontSize: 15,
                          color:  Colors.blue[900],
                          fontWeight: FontWeight.bold,

                        ),
                      ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 64,
                    child: ElevatedButton(
                      onPressed: () async {
                        emailFocusNode.unfocus();
                        passwordFocusNode.unfocus();
                        confirmpasswordFocusNode.unfocus();

                        final email = emailController.text;
                        final password = passwordController.text;
                        final confirmpassword = confirmpasswordController.text;

                        if(email == "" ){
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                         content: Text(" email required "),
                         ));
                         trigFail?.change(true);
                         }
                         else if( password == ""){
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                         content: Text(" password required "),
                         ));
                         trigFail?.change(true);
                         }
                         else if (password != confirmpassword) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Password do not match with Confirm Password "),
                                ));
                                trigFail?.change(true);
                              }
                         else if (validatePassword(password) != null){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(validatePassword(password)),
                          ));
                          trigFail?.change(true);
                        }


                        else {
                          showLoadingDialog(context);
                          await Future.delayed(
                            const Duration(milliseconds: 2000),
                          );
                          if (mounted) Navigator.pop(context);
                          try {
                            final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(" Registration Complete "),
                            ));
                            trigSuccess?.change(true);
                            Future.delayed(const Duration(milliseconds: 3000), () {
                              setState(() {
                              });
                              Route route = MaterialPageRoute(builder: (context) => HomeScreen());
                              Navigator.pushReplacement(context, route);

                            });

                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              print('The password provided is too weak.');
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(" Weak Password "),
                              ));
                              trigFail?.change(true);
                            }
                            else if(!ChechValidEmail(email)){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Invalid gmail form"),
                              ));
                              trigFail?.change(true);
                            }
                            else if (e.code == 'email-already-in-use') {
                              print('The account already exists for that email.');
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(" Email Already Exists "),
                              ));
                              trigFail?.change(true);
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(" Authentication ERROR "),
                            ));
                            trigFail?.change(true);
                            print(e);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text("sign up"),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
ChechValidEmail( String email) {
  String pattern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
  RegExp regExp = new RegExp(pattern);

  return regExp.hasMatch(email);
}
validatePassword(String value) {
  if (value.length < 8) {
    return 'Password must be at least 8 characters';
  }
  if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$').hasMatch(value)) {
    return 'Password must contain at least one letter, one number, and one special character';
  }
  if (RegExp(r'(.)\1{2,}').hasMatch(value)) {
    return 'Password should not contain 3 or more repeating characters';
  }
  return null;
}
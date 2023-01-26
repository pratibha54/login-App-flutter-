import 'package:flutter/material.dart';
import 'package:interactive_forms_with_rive/core/component/dialog/loading_dialog.dart';
import 'package:interactive_forms_with_rive/core/theme/app_color.dart';
import 'package:interactive_forms_with_rive/module/home/presentation/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rive/rive.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // String validEmail = "Dandi@gmail.com";
  // String validPassword = "12345";

  /// input form controller
  FocusNode emailFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();

  FocusNode passwordFocusNode = FocusNode();
  TextEditingController passwordController = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

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
    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(emailFocus);
    passwordFocusNode.removeListener(passwordFocus);
    super.dispose();
  }

  void emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void passwordFocus() {
    isHandsUp?.change(passwordFocusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    print("Build Called Again");
    return Scaffold(
      backgroundColor: AppColor.colourit,
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
              //   color: Colors.white,
              //   shape: BoxShape.circle,
              // ),
              child: const Image(
                image: AssetImage("assets/avatar.png"),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "WELCOME",
              textAlign: TextAlign.center,
              style: TextStyle (fontSize: 40, color: Color(0xffffd4d4) , fontWeight: FontWeight.bold),
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
                        hintText: "Password",
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

                       child:InkWell(
                         onTap: () {
                           Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context) => RegistrationScreen()),
                           );
                         },
                       child :Text ("Not Register, SignUp",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue[900],
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

                        final email = emailController.text;
                        final password = passwordController.text;

                        if(email == "" ){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(" email required "),
                          ));
                          trigFail?.change(true);
                        }
                        else if(!ChechValidEmail(email)){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Invalid gmail form"),
                          ));
                          trigFail?.change(true);
                        }
                        else if( password == ""){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(" password required "),
                          ));
                          trigFail?.change(true);
                        }
                        else{


                        showLoadingDialog(context);
                        await Future.delayed(
                          const Duration(milliseconds: 2000),
                        );
                        if (mounted) Navigator.pop(context);


                        try {
                          final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: email,
                              password: password
                          );
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(" User is loged in  "),
                          ));
                          trigSuccess?.change(true);
                          Future.delayed(const Duration(milliseconds: 3000), () {
                            setState(() {
                            });
                            Route route = MaterialPageRoute(builder: (context) => HomeScreen());
                            Navigator.pushReplacement(context, route);

                          });

                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            print('No user found for that email.');
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(" No user found for that email "),
                            ));
                            trigFail?.change(true);
                          } else if (e.code == 'wrong-password') {
                            print('Wrong password provided for that user.');
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(" Wrong password provided "),
                            ));
                            trigFail?.change(true);
                          }
                        }
                        }

                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text("Login"),
                    ),
                  ),

                  const SizedBox(height: 15,),
                  Padding(
                    padding: EdgeInsets.fromLTRB(25 , 8, 25, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.black,
                            thickness: 0.5,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('OR',
                          style : TextStyle(
                            fontWeight: FontWeight.w500,
                          )),

                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.black,
                            thickness: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),

                      ) ,
                      primary: AppColor.googleit,
                      onPrimary: Colors.white,
                    ),
                    onPressed: () async{
                      emailFocusNode.unfocus();
                      passwordFocusNode.unfocus();

                      await signInWithGoogle();
                      FirebaseAuth.instance
                          .authStateChanges().listen((event) {
                            if ( event == null ){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(" Login failed "),
                              ));
                              trigFail?.change(true);
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(" Welcome, " + event.displayName.toString()),
                              ));
                              trigSuccess?.change(true);
                            }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Image(
                            image: AssetImage("assets/google.png"),
                            height: 25,
                            width: 25,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 24, right: 8 , ),
                            child: Text(
                              'Sign in with Google',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

    ],
    ),
    ),
        ],
    ),
    ),
    );
  }
}
signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn(
      scopes: <String>["email"]).signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

ChechValidEmail( String email) {
  String pattern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
  RegExp regExp = new RegExp(pattern);

  return regExp.hasMatch(email);
}
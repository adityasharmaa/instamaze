import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {

  static const route = "/sign_up_screen";

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();

  final _border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)),
    borderSide: BorderSide(color: Colors.grey[300]),
  );

  Widget _textField(String hint, bool obscured, TextEditingController controller) {
    
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 20,
      ),
      child: TextField(
        decoration: InputDecoration(
          disabledBorder: _border,
          border: _border,
          focusedBorder: _border,
          enabledBorder: _border,
          filled: true,
          fillColor: Colors.grey[100],
          hintText: hint,
        ),
        obscureText: obscured,
        controller: controller,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.longestSide;

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 50,
            ),
            _textField("Email", false, _emailController),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              child: InkWell(
                child: Container(
                  height: _height * 0.06,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: Text(
                      "Next",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                onTap: (){},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

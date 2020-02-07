import 'package:flutter/material.dart';
import 'package:insta/providers/accounts_suggestion_provider.dart';
import 'package:insta/providers/current_user_provider.dart';
import 'package:insta/screens/screen_selector.dart';
import 'package:insta/widgets/blue_button.dart';
import 'package:insta/widgets/suggested_account.dart';
import 'package:provider/provider.dart';

class AccountsSuggestionScreen extends StatefulWidget {
  static const route = "/accounts_suggestion_screen";
  @override
  _AccountsSuggestionScreenState createState() =>
      _AccountsSuggestionScreenState();
}

class _AccountsSuggestionScreenState extends State<AccountsSuggestionScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAccounts();
  }

  void _fetchAccounts() {
    Future.delayed(Duration(milliseconds: 0), () async {
      await Provider.of<AccountsSuggestionProvider>(context, listen: false)
          .getSuggestions();
      setState(() {
        _isLoading = false;
      });
    });
  }

  bool _disableButton(){
    final currentUser = Provider.of<CurrentUserProvider>(context);
    bool disable =  currentUser.account.following == null ? true : currentUser.account.following.isEmpty ? true : false;
    return disable;
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.longestSide;
    final _suggestions = Provider.of<AccountsSuggestionProvider>(context, listen: false).suggestedAccounts;
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                SizedBox(
                  height: _height * 0.88,
                  child: ListView.separated(
                    separatorBuilder: (_,i) => i == 0 ? SizedBox() : Divider(),
                    itemCount: _suggestions.length + 1,
                    itemBuilder: (_,i) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: i == 0 ? SuggestedAccount(null) : SuggestedAccount(_suggestions[i-1]),
                    ),
                  ),
                ),
                Container(
                  height: _height * 0.12,
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      Divider(height: 0),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: BlueButton(
                          label: "Done",
                          action: () {
                            Navigator.of(context).pushReplacementNamed(
                                ScreenSelector.route);
                          },
                          disable: _disableButton(),
                        ),
                      ),
                      Text(
                        "Follow at least one account to continue",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

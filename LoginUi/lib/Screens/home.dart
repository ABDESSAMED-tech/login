import 'package:LoginUi/Screens/Login.dart';
import 'package:LoginUi/Services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = new FlutterSecureStorage();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readToken();
  }

  void readToken() async {
    String token = await this.storage.read(key: 'token');
    Provider.of<Auth>(context, listen: false).tryToken(token: token);
    print(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home page"),
      ),
      body: Center(
        child: Text("Home  Page "),
      ),
      drawer: Drawer(child: Consumer<Auth>(builder: (context, auth, child) {
        if (!auth.authenticated) {
          return ListView(children: [
            ListTile(
              title: Text("Login"),
              leading: Icon(Icons.person),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginSecreen()));
              },
            ),
            ListTile(
              title: Text("SignUp"),
              leading: Icon(Icons.person_add),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginSecreen()));
              },
            )
          ]);
        } else {
          try {
            return ListView(
              children: [
                DrawerHeader(
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(auth.user.avatar),
                        radius: 40,
                      ),
                      SizedBox(height: 10),
                      Text(
                        auth.user.name,
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        auth.user.email,
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                  ),
                ),
                ListTile(
                  title: Text("Logout"),
                  leading: Icon(Icons.exit_to_app),
                  onTap: () {
                    Provider.of<Auth>(context, listen: false).Logout();
                  },
                ),
                ListTile(
                  title: Text("About As"),
                  leading: Icon(Icons.info),
                  onTap: () {},
                ),
              ],
            );
          } catch (e) {
            print(e);
          }
        }
      })),
    );
  }
}

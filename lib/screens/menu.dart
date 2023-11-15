import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/widgets/left_drawer.dart';
import 'package:shopping_list/widgets/shop_card.dart';
import 'package:shopping_list/screens/shoplist_form.dart';
import 'package:shopping_list/screens/login.dart';
import 'package:shopping_list/screens/list_product.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  final List<ShopItem> items = [
    ShopItem("Lihat Produk", Icons.checklist),
    ShopItem("Tambah Produk", Icons.add_shopping_cart),
    ShopItem("Logout", Icons.logout),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: const Text('Shopping List'),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),

        drawer: const LeftDrawer(),

        body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text(
                      'PBP Shop',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GridView.count(
                    primary: true,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    children: items.map((ShopItem item) {
                      return ShopCard(item);
                    }).toList(),
                  ),
                ],
              ),
            )));
  }
// This widget is the home page of your application. It is stateful, meaning
// that it has a State object (defined below) that contains fields that affect
// how it looks.

// This class is the configuration for the state. It holds the values (in this
// case the title) provided by the parent (in this case the App widget) and
// used by the build method of the State. Fields in a Widget subclass are
// always marked "final".
}

class ShopCard extends StatelessWidget {
  final ShopItem item;

  const ShopCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    // TODO: implement build
    return Material(
        color: Colors.indigo,
        child: InkWell(
            onTap: () async {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content: Text("Kamu telah menekan tombol ${item.name}")));
              // Navigate ke route yang sesuai (tergantung jenis tombol)
              if (item.name == "Tambah Produk") {
                // TODO: Gunakan Navigator.push untuk melakukan navigasi ke MaterialPageRoute yang mencakup ShopFormPage.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShopFormPage()
                  ),
                );
              }
              else if (item.name == "Lihat Produk") {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => const ProductPage()));
              }
// statement if sebelumnya
// tambahkan else if baru seperti di bawah ini
              else if (item.name == "Logout") {
               final response = await request.logout(
                // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                //   "http://127.0.0.1:8000/auth/logout/"
                 "http://thirza-ahmad-tutorial.pbp.cs.ui.ac.id/auth/logout/"
               );
                  String message = response["message"];
                if (response['status']) {
                  String uname = response["username"];
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("$message Sampai jumpa, $uname."),
                    ));
                    Navigator.pushReplacement(
                           context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                       );
                } else {
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("$message"),
                ) );
              }
              }

            },
            child: Container(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item.icon, color: Colors.white, size: 30.0),
                      const Padding(padding: EdgeInsets.all(3)),
                      Text(
                        item.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                )
            )
        )
    );
  }
}

import 'dart:io';
import 'dart:ui';

import 'package:contact_app/helpers/contact_helper.dart';
import 'package:contact_app/ui/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions{orderAZ, orderZA}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();
    _getAllCOntacts();
  }

  void _getAllCOntacts(){
    helper.getAllContacts().then((l) {
      setState(() {
        contacts = l;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text(("Ordenar de A-Z")),
                value: OrderOptions.orderAZ,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text(("Ordenar de Z-A")),
                value: OrderOptions.orderZA,
              ),
            ],
            onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: contacts.length,
        itemBuilder: (context, idx) {
          return _contactCard(context, idx);
        },
      ),
    );
  }

  void _orderList( OrderOptions result){
    switch(result){
      case OrderOptions.orderAZ:
        contacts.sort( (a,b){
         return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderZA:
        contacts.sort( (a,b){
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {});
  }
  Widget _contactCard(BuildContext buildContext, int idx) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: contacts[idx].img != null
                          ? FileImage(File(contacts[idx].img))
                          : AssetImage("images/person.png"),
                     fit: BoxFit.cover ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contacts[idx].name ?? " s/n",
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      contacts[idx].email ?? "s/e",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      contacts[idx].phone ?? "s/t",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: (){
        _showOptions(context, idx);
      },
    );
  }
  void _showOptions(BuildContext context, int idx ){
    showModalBottomSheet(context: context, builder: (context){
      return BottomSheet(
        onClosing: (){},
        builder: (context){
        return Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize:  MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: FlatButton(
                  child: Text("Ligar", style: TextStyle(color: Colors.red, fontSize:  20.0),
                  ),
                  onPressed: (){
                    launch("tel:${contacts[idx].phone}");
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: FlatButton(
                  child: Text("Editar", style: TextStyle(color: Colors.red, fontSize:  20.0),
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                    _showContactPage( contact: contacts[idx]);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: FlatButton(
                  child: Text("Excluir", style: TextStyle(color: Colors.red, fontSize:  20.0),
                  ),
                  onPressed: (){
                      Navigator.pop(context);
                      setState(() {
                        helper.deleteContact(contacts[idx].id);
                        contacts.removeAt(idx);
                      });
                  },
                ),
              ),
            ],
          ),
        );  
        },
      );
    });
  }

  void _showContactPage({Contact contact}) async{
    final resContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contact: contact,
                )));
    if( resContact  != null ){
      if( contact != null ){
        await helper.updateContact(resContact);
      }else{
        await helper.saveContact(resContact);
      }
      _getAllCOntacts();
    }
  }
}

import 'dart:io';

import 'package:agenda_de_contatos/helpers/contact_helper.dart';
import 'package:agenda_de_contatos/ui/contact_page.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ContactHelper helper = ContactHelper();

  List<Contact> contactList = List();

  @override
  void initState() {
    super.initState();
    _loadContact();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos'),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: _showContactPage,
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemCount: contactList.length,
        itemBuilder: _contactsCard,
        padding: EdgeInsets.all(10.0),
      ),
    );
  }

  Widget _contactsCard(BuildContext context, int index) {
    Contact contato = contactList[index];
    return GestureDetector(
      onTap: () {
        _showContactPage(contact: contactList[index]);
      },
      child: Card(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: contato.img != null
                              ? FileImage(File(contato.img))
                              : AssetImage('images/contact.jpg'))),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        contato.name ?? '',
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        contato.phone ?? '',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Text(
                        contato.email ?? '',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _loadContact() {
    helper.getAll().then((list) {
      setState(() {
        contactList = list;
      });
    });
  }

  _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contact: contact,
                )));
    if(recContact != null){
      if(contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _loadContact();
    }
  }


}

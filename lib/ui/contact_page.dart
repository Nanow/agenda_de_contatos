import 'dart:io';
import 'dart:async';
import 'package:agenda_de_contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _editContact;
  bool _userEdited = false;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  final _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editContact = Contact();
    } else {
      _editContact = Contact.fromMap(widget.contact.toMap());

      _nameController.text = _editContact.name;
      _emailController.text = _editContact.email;
      _phoneController.text = _editContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            centerTitle: true,
            title: Text(_editContact.name ?? 'Novo Contato'),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            child: Icon(Icons.save),
            onPressed: () {
              if (_editContact.name.isNotEmpty && _editContact.name != null) {
                Navigator.pop(context, _editContact);
              } else {
                FocusScope.of(context).requestFocus(_nameFocus);
              }
            },
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    ImagePicker.pickImage(source: ImageSource.gallery).then((file){
                      if (file == null) return;
                      setState(() {
                        _editContact.img = file.path;
                      });
                    });
                  },
                  child: Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: _editContact.img != null
                                ? FileImage(File(_editContact.img))
                                : AssetImage('images/contact.jpg'))),
                  ),
                ),
                TextField(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  decoration: InputDecoration(labelText: 'Nome'),
                  keyboardType: TextInputType.text,
                  onChanged: (text) {
                    _userEdited = true;
                    setState(() {
                      _editContact.name = text;
                    });
                  },
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  onChanged: (text) {
                    _userEdited = true;
                    _editContact.email = text;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                  onChanged: (text) {
                    _userEdited = true;
                    _editContact.phone = text;
                  },
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
        ));
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Descartar Alterações?'),
              content: Text('Se sair as alterações serão perdidadas'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('Descartar'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vcard_app/providers/contact_provider.dart';
import 'package:vcard_app/utils/helper.dart';


// This is Contact details page,
// When a user click a Contact from home page then user redirect on this page
// on ths page user can see Contact details
//

class ContactDetailsPage extends StatefulWidget {
  static const String routeName ="/contact";
  const ContactDetailsPage({super.key});

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  int id = 0;

  @override
  void didChangeDependencies() {
    id = ModalRoute.of(context)!.settings.arguments as int;

    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Details"),),
      body: Consumer<ContactProvider>(
        builder: (context, provider, child) => FutureBuilder(
          future: provider.getContact(id),
          builder: (context, snapshot) {
          if(snapshot.hasData){
            final contact = snapshot.data;
            return ListView(
              children: [
                Image.file(File(contact!.image), width: double.infinity, height: 250,fit: BoxFit.cover,),
                ListTile(
                  title: Text(contact.name),
                ),
                ListTile(
                  title: Text(contact.mobile),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: (){
                        _smsContact(contact.mobile);
                      }, icon: const Icon(Icons.sms)),
                      IconButton(onPressed: (){
                        _callContcat(contact.mobile);
                      }, icon: const Icon(Icons.phone)),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(contact.email.isEmpty ? "Not Found!" : contact.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: contact.email.isNotEmpty? (){
                        _smsContact(contact.mobile);
                      }:null,
                      icon: const Icon(Icons.email)),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(contact.email.isEmpty ? "Not Found!" : contact.website),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: contact.website.isNotEmpty ?(){
                         _mailContact(contact.website);
                         }:null,
                        icon: const Icon(Icons.open_in_browser),)
                    ],
                  ),
                ),
                ListTile(
                  title: Text(contact.email.isEmpty ? "Not Found!" : contact.company),
                ),
                ListTile(
                  title: Text(contact.email.isEmpty ? "Not Found!" : contact.designation),
                ),
                ListTile(
                  title: Text(contact.email.isEmpty ? "Not Found!" : contact.address),
                ),
              ],
            );
          }
          if(snapshot.hasError){
            return const Center(child: Text("Fail to fatch Data"),);
          }
          return const Center(child: Text("Please wait!!"),);
        },),
      ),
    );
  }

  void _smsContact(String mobile) async {
    final url = 'sms:$mobile';
    if(await canLaunchUrlString(url)){
      await launchUrlString(url);
    }else{
      showMsg(context, "Cannot perform this task");
    }
  }

  void _callContcat(String mobile)async {
    final url = 'tel:$mobile';
    if(await canLaunchUrlString(url)){
      await launchUrlString(url);
    }else{
      showMsg(context, "Cannot perform this task");
    }
  }
  void _mailContact(String website)async {
    final url = 'https:$website';
    if(await canLaunchUrlString(url)){
      await launchUrlString(url);
    }else{
      showMsg(context, "Cannot perform this task");
    }
  }
}

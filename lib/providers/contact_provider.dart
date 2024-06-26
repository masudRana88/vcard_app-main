import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:vcard_app/db/db_helper.dart';

import '../models/contact_model.dart';

class ContactProvider extends ChangeNotifier{

List<ContactModel> contactList = [];
List<ContactModel> allFavoritItem = [];
final db = DbHelper();


Future<void> getContactList()async{
  contactList = await db.getAllContact();
  notifyListeners();
}

void addFavorit(ContactModel contact){
  allFavoritItem.add(contact);
  notifyListeners();
}
void deleteFavorit(ContactModel contact){
  allFavoritItem.remove(contact);
  notifyListeners();
}
void getAllFavorit(){
  allFavoritItem = contactList.where((cotact)=> cotact.favrite == true).toList();
  notifyListeners();
}

Future<ContactModel> getContact(int id)async{
  return await db.getContact(id);
}

Future<int> addContact(ContactModel contact)async{
  final rowid = await db.insertContact(contact);
  // add in ContactList
  if(rowid > 0){
    contact.id = rowid;
    contactList.add(contact);
    notifyListeners();
  }
  return rowid;
}

Future<int> removeContact(ContactModel contact)async{
  final rowId = await db.deleteContact(contact.id);
  if(rowId > 0){
    contactList.remove(contact);
    notifyListeners();
  }
  return rowId;
}

Future<int> update(ContactModel contact)async{
  final rowId = await db.update(contact);
  if(rowId > 0){
    int index = contactList.indexWhere((ContactModel element) => element.id == contact.id);
    contactList.removeAt(index);
    contactList.insert(index,contact);
    notifyListeners();
  }
  return 0;

}

}
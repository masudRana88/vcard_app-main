import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:vcard_app/models/contact_model.dart';

class DbHelper{

  final String _createTableContact = '''create table $tbContact(
  $tbContactColId integer primary key autoincrement,
  $tbContactColName text,
  $tbContactColMobile text,
  $tbContactColEmail text,
  $tbContactCollSteedAddress text,
  $tbContactColCompany text,
  $tbContactColDesignation text,
  $tbContactCollWebsite text,
  $tbContactCollImage text,
  $tbContactCollFavrite integer)''';


  Future<Database> _open() async{
    final root = await getDatabasesPath();
    final dbPath = p.join(root, "contact.db");
    return openDatabase(dbPath, version: 1, onCreate: (db, version) {
      db.execute(_createTableContact);
    });
  }

  Future<int> insertContact(ContactModel contactModel) async {
    final db = await _open();
    return db.insert(tbContact, contactModel.toMap());
  }

  Future<List<ContactModel>> getAllContact() async{
    final db = await _open();
    final mapList = await db.query(tbContact);
    return List.generate(mapList.length, (index) => ContactModel.formMap(mapList[index]));
  }

  Future<ContactModel> getContact(int id) async{
    final db = await _open();
    final mapList = await db.query(tbContact,where: "$tbContactColId = ?",whereArgs: [id]);
    return ContactModel.formMap(mapList.first);
  }

  Future<int> deleteContact(int id)async{
    final db = await _open();
    return await db.delete(tbContact,where: "$tbContactColId = ?",whereArgs: [id]);
  }
   Future<int> update(ContactModel contact)async{
    final db = await _open();
    return await db.update(tbContact,contact.toMap(),where: "$tbContactColId = ?",whereArgs: [contact.id] );
   }

}
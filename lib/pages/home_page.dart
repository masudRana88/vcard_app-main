
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vcard_app/models/contact_model.dart';
import 'package:vcard_app/pages/contact_details_page.dart';
import 'package:vcard_app/pages/scan_page.dart';
import 'package:vcard_app/providers/contact_provider.dart';
import 'package:vcard_app/utils/helper.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedItem = 0;
  bool isFirstLoad = true;

  @override
  void didChangeDependencies() {
    if(isFirstLoad && selectedItem == 0){
      Provider.of<ContactProvider>(context,listen: false).getContactList();
      isFirstLoad = false;
    }
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedItem == 0 ? "All Contact": "Favorite"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.pushNamed(context, ScanPage.routeName);
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        notchMargin: 10,
        clipBehavior: Clip.antiAlias,
        shape: const CircularNotchedRectangle(),
        child: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 235, 221, 255),
          currentIndex: selectedItem,
          onTap: (index) {
            setState(() {
              selectedItem = index;
              if(selectedItem == 1){
                Provider.of<ContactProvider>(context,listen: false).getAllFavorit();
              }
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.person, size: 30,), label: "All"),
            BottomNavigationBarItem(icon: Icon(Icons.favorite,size: 30,), label: "All"),
          ],
        ),
      ),
      body: Consumer<ContactProvider>(
        builder: (context, provider, _) {
          if(selectedItem == 0 && provider.contactList.isEmpty){
            return const Center(child: Text("Your contact List is Emty"),);
          }
          if(selectedItem == 1 && provider.allFavoritItem.isEmpty){
            return const Center(child: Text("No Favorite Contact"),);
          }
          return ListView.builder(
            itemCount: selectedItem == 0 ? provider.contactList.length : provider.allFavoritItem.length,
            itemBuilder: (context, index) {
              final contact = selectedItem == 0 ? provider.contactList[index]: provider.allFavoritItem[index];
              return Dismissible(
                key: Key(contact.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  padding: const EdgeInsets.only(right: 20),
                  alignment: Alignment.centerRight,
                  child: const Icon(Icons.delete_forever,color: Colors.white,),
                ),
                confirmDismiss: _showConfirmDialog,
                onDismissed: (direction){
                    provider.removeContact(contact);
                    showMsg(context, "Contact is deleted");
                },
                child: ListTile(
                  onTap: (){
                    Navigator.pushNamed(context, ContactDetailsPage.routeName,arguments: contact.id);
                  },
                  shape: const Border(bottom: BorderSide(width: 0.1)),
                  title: Text(contact.name),
                  trailing: IconButton(
                    icon: Icon(contact.favrite ? Icons.favorite : Icons.favorite_border),
                    onPressed: (){
                      provider.update(contact.copyWith(favrite: contact.favrite? false: true));
                      if(contact.favrite){
                        setState(() {
                          provider.deleteFavorit(contact);
                        });
                      }
                  },
                    ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<bool?> _showConfirmDialog(DismissDirection direction) {

    return showDialog(context: context, builder: (context) =>  AlertDialog(
      title: const Text("Delete"),
      content: const  Text("Are you sure to delete this contact"),
      actions: [
        OutlinedButton(
          child: const Text("No"),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        OutlinedButton(
          child: const Text("Yes"),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    ),);

  }



}

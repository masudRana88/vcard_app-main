import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vcard_app/models/contact_model.dart';
import 'package:vcard_app/pages/form_page.dart';
import 'package:vcard_app/utils/constants.dart';

// This is Scan page
// when a user wants to add a new contact and click Add button( Bottom navigation bar ) from home page then user redirect on this page
// Scan page will be scan Card form gallery or camera and

class ScanPage extends StatefulWidget {
  static const String routeName = "/scan";
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool _isLoding = false;
  List<String> lines = [];
  String name = '', mobile = '', email= '', address = '', company = '', designation = '', website = '',image= "";
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text("Scan Page"),actions: [
        TextButton(onPressed: _createContactFromScanValues, child: Text("NEXT"))
      ],),
      body: ListView(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(onPressed: (){
              _getImage(ImageSource.camera);
            }, icon: const Icon(Icons.photo_camera),label: const Text("Capture"),),
            TextButton.icon(onPressed: (){
              _getImage(ImageSource.gallery);
            }, icon: const Icon(Icons.photo_library),label: const Text("Gallery"),),
          ],
        ),
        const SizedBox(height: 20,),
        if(_isLoding)
         const Center(
            child: CircularProgressIndicator(),
          ),

        if (lines.isNotEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  DropTargetItem(property: ContactProperty.name, onDrop: _getPropertyValue),
                  DropTargetItem(property: ContactProperty.mobile, onDrop: _getPropertyValue),
                  DropTargetItem(property: ContactProperty.company, onDrop: _getPropertyValue),
                  DropTargetItem(property: ContactProperty.designation, onDrop: _getPropertyValue),
                  DropTargetItem(property: ContactProperty.email, onDrop: _getPropertyValue),
                  DropTargetItem(property: ContactProperty.website, onDrop: _getPropertyValue),
                  DropTargetItem(property: ContactProperty.address, onDrop: _getPropertyValue),
                ],
              ),
            ),
          ),
        if (lines.isNotEmpty)
          const Padding(padding: EdgeInsets.all(8.0),child: Text(dragInstruction),),
          // Dragable Items ////////
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              children: lines.map((line) => LineItem(line: line)).toList(),
            ),
          )
      ],)
    );
  }


  // get Image and Text form Card
  void _getImage(ImageSource source) async {
    final xFile = await ImagePicker().pickImage(source: source);
    if(xFile != null){
      _startLoder(true);
      image = xFile.path;
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final recognizedText = await textRecognizer.processImage(InputImage.fromFile(File(image)));
      List<String> tempList= [];
      for ( var block in recognizedText.blocks){
        for (var line in block.lines){
          tempList.add(line.text);
        }
      }
      setState(() {
        lines = tempList;
        _isLoding = false;
      });
    }
  }
  // start Loder
  void _startLoder(bool status){
    if(status){
      setState(() {
        _isLoding = true;
      });
    }
  }

  // Get Property Value from Dragable Items
  _getPropertyValue(String property, String value) {
    switch(property){
      case ContactProperty.name:
        name = value;
        break;
      case ContactProperty.mobile:
        mobile = value;
        break;
      case ContactProperty.website:
        website = value;
        break;
      case ContactProperty.address:
        address = value;
        break;
      case ContactProperty.designation:
        designation = value;
        break;
      case ContactProperty.company:
        company = value;
        break;
      case ContactProperty.email:
        email = value;
        break;

    }
  }


  // Create a Contact Model and push it to form page
  void _createContactFromScanValues() {
    final contact = ContactModel(
      name: name,
      mobile: mobile,
      website: website,
      address: address,
      designation: designation,
      company: company,
      email: email,
      image: image,
    );
    Navigator.pushNamed(context, FormPage.routeName, arguments: contact);
  }
}




// LineItem
// This wedget use for Dragable item

class LineItem extends StatelessWidget {
  final String line;
  const LineItem({super.key, required this.line});

  @override
  Widget build(BuildContext context) {
    GlobalKey _key = GlobalKey();
    return LongPressDraggable(
      data: line,
      dragAnchorStrategy: childDragAnchorStrategy,
      feedback: Container(
        key: _key,
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.black45,
        ),
        child: Text(line, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),),
      ),
      child: Chip(label: Text(line),),
    );
  }
}

// This is Drop Traget Widget of Form Widget

class DropTargetItem extends StatefulWidget {
  final String property;
  final Function(String, String) onDrop;
  const DropTargetItem({super.key, required this.property, required this.onDrop});

  @override
  State<DropTargetItem> createState() => _DropTargetItemState();
}

class _DropTargetItemState extends State<DropTargetItem> {
  String dragItem = "";
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1,child: Text(widget.property)),
        Expanded(
          flex: 2,
          child: DragTarget<String>(builder: (context, candidateData, rejectedData) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
            decoration: BoxDecoration(
              border: candidateData.isNotEmpty ? Border.all(color: Colors.red.shade400,width: 2): null
            ),
            child: Row(
              children: [
                Expanded(child: Text(dragItem.isEmpty? "Drop Here": dragItem)),
                if(dragItem.isNotEmpty)
                InkWell(
                  onTap: (){
                    setState(() {
                      dragItem = "";
                    });
                  },
                  child: const Icon(Icons.clear, size: 15,),
                )
              ],
            ),
          ),
            onAcceptWithDetails: (details) {
              setState(() {
                if(details.data.isEmpty){
                  dragItem = details.data;
                }else{
                  dragItem += " ${details.data}";
                }
              });
              widget.onDrop(widget.property, dragItem);
            },
          ),
        )
      ],
    );
  }
}

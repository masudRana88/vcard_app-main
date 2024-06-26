import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vcard_app/models/contact_model.dart';
import 'package:vcard_app/pages/home_page.dart';
import 'package:vcard_app/providers/contact_provider.dart';
import 'package:vcard_app/utils/helper.dart';

class FormPage extends StatefulWidget {
  static const String routeName = "/form";
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late ContactModel contact;

  @override
  void didChangeDependencies() {
    contact = ModalRoute.of(context)!.settings.arguments as ContactModel;
    _nameController.text = contact.name;
    _mobileController.text = contact.mobile;
    _emailController.text = contact.email;
    _designationController.text = contact.designation;
    _companyController.text = contact.company;
    _addressController.text = contact.address;
    _websiteController.text = contact.website;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Contact"),
        actions: [
          IconButton(
            onPressed: _saveData,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Center(
        child: Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              children: [
                // Contact Name
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: "Contact",
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Contact Name is requird";
                      }
                      if (value.length > 30) {
                        return "Contact fild must be under 30 carectar";
                      }
                      return null;
                    },
                  ),
                ),
                // Mobile Number
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: _mobileController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.call),
                      labelText: "Phone Number",
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Phone number is requird";
                      }
                      if (value.length > 30) {
                        return "Contact fild must be under 30 carecter";
                      }
                      return null;
                    },
                  ),
                ),
                // Email Address
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: "Email Address",
                      filled: true,
                    ),
                  ),
                ),
                // Company Name
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextFormField(
                    controller: _companyController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.blinds_rounded),
                      labelText: "Company name",
                      filled: true,
                    ),
                  ),
                ),
                // Designation
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextFormField(
                    controller: _designationController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.label),
                      labelText: "Designation",
                      filled: true,
                    ),
                  ),
                ),
                // Address
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.business_sharp),
                      labelText: "Address",
                      filled: true,
                    ),
                  ),
                ),
                // Website
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextFormField(
                    controller: _websiteController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.web),
                      labelText: "Website",
                      filled: true,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void _saveData() async {
    if (formKey.currentState!.validate()) {
      contact.name = _nameController.text;
      contact.mobile = _mobileController.text;
      contact.website = _websiteController.text;
      contact.address = _addressController.text;
      contact.designation = _designationController.text;
      contact.company = _companyController.text;
      contact.email = _emailController.text;

      Provider.of<ContactProvider>(context, listen: false)
          .addContact(contact)
          .then((rowId) {
        if (rowId > 0) {
          Navigator.popUntil(context, ModalRoute.withName(HomePage.routeName));
          showMsg(context, "Contact is Added");
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _designationController.dispose();
    _companyController.dispose();
    _addressController.dispose();
    _websiteController.dispose();
    super.dispose();
  }
}

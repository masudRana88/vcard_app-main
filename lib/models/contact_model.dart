const String tbContact = "tb_contact";
const String tbContactColId = "id";
const String tbContactColName = "name";
const String tbContactColMobile = "mobile";
const String tbContactColEmail = "email";
const String tbContactColCompany = "company";
const String tbContactColDesignation = "Designation";
const String tbContactCollSteedAddress = "address";
const String tbContactCollWebsite = "website";
const String tbContactCollFavrite = "favrite";
const String tbContactCollImage = "image";

class ContactModel {
  int id;
  String name;
  String mobile;
  String email;
  String company;
  String designation;
  String address;
  String website;
  bool favrite;
  String image;

  ContactModel({
    this.id = -1,
    required this.name,
    required this.mobile,
    this.email = "",
    this.company = "",
    this.designation = "",
    this.address = "",
    this.website = "",
    this.favrite = false,
    this.image = 'images/person.png',
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      tbContactColName: name,
      tbContactColMobile: mobile,
      tbContactColEmail: email,
      tbContactColCompany: company,
      tbContactColDesignation: designation,
      tbContactCollSteedAddress: address,
      tbContactCollWebsite: website,
      tbContactCollFavrite: favrite ? 1 : 0,
      tbContactCollImage: image,
    };
    if (id > 0) {
      map[tbContactColId] = id;
    }
    return map;
  }

  ContactModel copyWith({
  int? id,
  String? name,
  String? mobile,
  String? email,
  String? company,
  String? designation,
  String? address,
  String? website,
  bool? favrite,
  String? image,})
  {
    ContactModel newContact = ContactModel(
      name: name?? this.name,
      mobile: mobile?? this.name,
      id: id?? this.id,
      email: email?? this.email,
      address: address?? this.address,
      designation: designation?? this.designation,
      company: company?? this.company,
      website: website?? this.website,
      favrite: favrite?? this.favrite,
      image: image?? this.image,

    );
    return newContact;
  }

  factory ContactModel.formMap(Map<String, dynamic> map) => ContactModel(
        name: map[tbContactColName],
        mobile: map[tbContactColMobile],
        id: map[tbContactColId],
        email: map[tbContactColEmail],
        company: map[tbContactColCompany],
        designation: map[tbContactColDesignation],
        address: map[tbContactCollSteedAddress],
        website: map[tbContactCollWebsite],
        image: map[tbContactCollImage],
        favrite: map[tbContactCollFavrite] == 1 ? true : false,
      );

  @override
  String toString() {
    return 'ContactModel{id: $id, name: $name, mobile: $mobile, email: $email, company: $company, designation: $designation, address: $address, website: $website, favrite: $favrite, image: $image}';
  }
}

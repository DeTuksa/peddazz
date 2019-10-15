
class UserDetails {

  String firstName;
  String middleName;
  String lastName;
  String emailId;
  String photoUrl;
  String uid;

  UserDetails({this.firstName, this.middleName, this.lastName, this.emailId, this.photoUrl, this.uid});

  Map toMap(UserDetails userDetails) {
    var data = Map<String, String>();
    data['firstName'] = userDetails.firstName;
    data['middleName'] = userDetails.middleName;
    data['surname'] = userDetails.lastName;
    data['emailId'] = userDetails.emailId;
    data['photoUrl'] = userDetails.photoUrl;
    data['uid'] = userDetails.uid;
    return data;
  }

  UserDetails.fromMap(Map<String, String> mapData) {
    this.firstName = mapData['firstName'];
    this.middleName = mapData['middleName'];
    this.lastName = mapData['surname'];
    this.emailId = mapData['emailId'];
    this.photoUrl = mapData['photoUrl'];
    this.uid = mapData['uid'];
  }

  String get fName => firstName;
  String get mName => middleName;
  String get lName => lastName;
  String get _emailId => emailId;
  String get _photoUrl => photoUrl;
  String get _uid => uid;

  set _photoUrl(String photoUrl) {
    this.photoUrl = photoUrl;
  }

  set fName(String first) {
    this.firstName = first;
  }

  set mName(String middle) {
    this.middleName = middle;
  }

  set lName(String last) {
    this.lastName = last;
  }

  set _emailId(String emailId) {
    this.emailId = emailId;
  }

  set _uid(String uid) {
    this.uid = uid;
  }

}
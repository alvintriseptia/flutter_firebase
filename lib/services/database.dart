import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crew_brew/models/brew.dart';
import 'package:crew_brew/models/user.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid = ''});

  //collection reference
  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brews');

  Future updateUserData(String sugars, String name, double strength) async {
    return await brewCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  //brew list from snapshot
  List<BrewModel> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return BrewModel(
        name: (doc.data() as dynamic)['name'] ?? '',
        sugars: (doc.data() as dynamic)['sugars'] ?? '0',
        strength: (doc.data() as dynamic)['strength'].toDouble() ?? 0.0,
      );
    }).toList();
  }

  //get brew by uid
  Stream<List<BrewModel>>? get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  //userData from snapShot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: (snapshot.data() as dynamic)['name'] ?? '',
      sugars: (snapshot.data() as dynamic)['sugars'] ?? '0',
      strength: (snapshot.data() as dynamic)['strength'].toDouble() ?? 0.0,
    );
  }

  //get user doc stream
  Stream<UserData>? get userData {
    return brewCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}

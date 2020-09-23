import 'package:appannotation/model/annotationModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestore{
  final firestoreInstance = Firestore.instance;

  Future<Map<String, dynamic>> getData(String collection, String  document) async {
    try{
      DocumentSnapshot doc = await firestoreInstance.collection(collection)
          .document(document).get();
      return doc.data;
    }
    catch(e){
      return Map();
    }
  }

  Future<bool> addData(String collection, String  document, data) async {
    try{
      await firestoreInstance.collection(collection)
        .document(document)
        .setData(data);
      return true;
    }
    catch(e){
      print(e); //debug
      return false;
    }
  }

  Future<bool> updateData(String collection, String  document, data) async {
    try{
      await firestoreInstance.collection(collection)
          .document(document)
          .updateData(data);
      return true;
    }
    catch(e){
      print(e); //debug
      return false;
    }
  }

  Future<bool> updateArrayData(String collection, String  document, String array, data) async{
    try{
      await firestoreInstance.collection(collection)
          .document(document)
          .updateData({
            array:FieldValue.arrayUnion([data])
          });
      return true;
    }
    catch(e){
      print(e); //debug
      return false;
    }
  }

  Future<List<dynamic>> getDocumentsId(String collection) async {
    List ids = [];
    QuerySnapshot result =
      await firestoreInstance.collection(collection).getDocuments();
    result.documents.forEach((element) {
      ids.add(element.documentID);
    });
    return ids;
  }

  Future<AnnotationModel> getAnnotation(String collection, String userId) async {

    try {
      QuerySnapshot results = await firestoreInstance.collection(collection)
          .getDocuments();
      AnnotationModel annotationModel = AnnotationModel();
      DocumentSnapshot result = results.documents.firstWhere((result) {
        annotationModel.parse(result.data);
        if (annotationModel.running == true &&
            annotationModel.userId == userId) {
          return true;
        }
        return false;
      });
      return result.data == null ? null : annotationModel.parse(result.data);
    }
    catch(e){
      print(e);
      return null;
    }
  }


}
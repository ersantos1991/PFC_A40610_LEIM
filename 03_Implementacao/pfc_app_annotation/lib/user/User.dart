import 'package:appannotation/db/cloudFirestore.dart';
import 'package:appannotation/utils/attributes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User{
    final firestoreInstance = Firestore.instance;
    FirebaseUser user;
    Map<String, dynamic> data;

    User(FirebaseUser user, Map<String, dynamic> data ){
        this.user = user;
        this.data = data;
    }

    Future getDocument(user) async {
        return await firestoreInstance.collection(Attributes.users)
            .document(user.uid).get();
    }

    String getEmail(){
        return user.email;
    }

    String getUsername(){
        return user.displayName;
    }

    String getPhotoUrl(){
        return user.photoUrl;
    }

    String getFirstName(){
        return data[Attributes.firstName.toLowerCase()];
    }

    String getLastName(){
        return data[Attributes.lastName.toLowerCase()];
    }

    String getGender(){
        return data[Attributes.gender.toLowerCase()];
    }

    DateTime getBirthDate(){
        return DateTime.parse(data[Attributes.birthDate]);
    }



    /*Future<bool> addUser(
        String firstName,
        String lastName,
        String gender,
        String birthDate,
        ) async{
        try{
            await firestoreInstance.collection(Attributes.users).
            document(uid).setData({
                Attributes.uid:uid,
                Attributes.firstName.toLowerCase():firstName,
                Attributes.lastName.toLowerCase():lastName,
                Attributes.gender.toLowerCase():gender,
                Attributes.birthDate:birthDate,
                Attributes.created:birthDate
            });
            return true;
        }
        catch(e){
            print(e);
            return false;
        }
    }*/

    Future<bool> updateFirstName(String firstName) async{
        return await CloudFirestore().updateData(
            Attributes.users,
            user.uid,
            {Attributes.firstName.toLowerCase():firstName});
    }

    Future<bool> updateLastName(String lastName) async{
        return await CloudFirestore().updateData(
            Attributes.users,
            user.uid,
            {Attributes.lastName.toLowerCase():lastName});
    }

    Future<bool> updateGender(String gender) async{
        if(gender == getGender()){
            return true;
        }
        return await CloudFirestore().updateData(
            Attributes.users,
            user.uid,
            {Attributes.gender.toLowerCase():gender});
    }

    Future<bool> updateBirthDate(DateTime birthDate) async{
        if(birthDate == getBirthDate()){
            return true;
        }
        return await CloudFirestore().updateData(
            Attributes.users,
            user.uid,
            {Attributes.birthDate:birthDate.toString()});
    }

    Future<bool> updatePassword(String password) async{
        try{
            if(password.isEmpty){
                return true;
            }
            await user.updatePassword(password);
            return true;
        }
        catch(e){
            print(e);
            return false;
        }
    }

    Future<bool> updateEmail(String email) async{

        try{
            if(email.isEmpty){
                return false;
            }
            if(email != user.email){
                await user.updateEmail(email);
            }
            return true;
        }
        catch(e){
            print(e);
            return false;
        }
    }

    Future<bool> updateUsername(String username) async{
        try{
            if(user.displayName!= username){
                UserUpdateInfo profile = new UserUpdateInfo();
                profile.displayName = username;
                profile.photoUrl = user.photoUrl;
                await user.updateProfile(profile);
            }
            return true;
        }
        catch(e){
            print(e);
            return false;
        }
    }

    Future<bool> updatePhotoUrl(String photoUrl) async{
        try{
            if(user.photoUrl!=photoUrl){
                UserUpdateInfo profile = new UserUpdateInfo();
                profile.displayName = user.displayName;
                profile.photoUrl = photoUrl;
                await user.updateProfile(profile);
            }
            return true;
        }
        catch(e){
            print(e);
            return false;
        }
    }


}
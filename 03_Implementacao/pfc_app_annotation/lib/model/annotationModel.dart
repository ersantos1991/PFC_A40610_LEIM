import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class AnnotationModel{
  String uuid = Uuid().v4();
  String userId = "";
  String context = "";
  bool running = true;
  String start = DateTime.now().toUtc().toString();
  String end = "";
  List tags = [];
  List emotions = [];

  parse(Map<String, dynamic> annotation){
    uuid = annotation["uuid"];
    userId = annotation["userId"];
    context = annotation["context"];
    running = annotation["running"];
    start = annotation["start"];
    end = annotation["end"];
    tags = annotation["tags"];
    emotions = annotation["emotions"];
    return this;
  }

  Map<String, dynamic> toJson() =>
      {
        "uuid": uuid,
        "userId": userId,
        "context": context,
        "running": running,
        "start": start,
        "end": end,
        "tags": tags,
        "emotions": emotions,
      };
}
class Call {
  String callerId;
  String callerName;
  String receiverId;
  String receiverName;
  String channelId;
  bool hasDialled;
  String isCall;

  Call({
    this.callerId,
    this.callerName,
    this.receiverId,
    this.receiverName,
    this.channelId,
    this.hasDialled,
    this.isCall
  });

  // to map
  Map<String, dynamic> toMap(Call call) {
    Map<String, dynamic> callMap = Map();
    callMap["caller_id"] = call.callerId;
    callMap["caller_name"] = call.callerName;
    callMap["receiver_id"] = call.receiverId;
    callMap["receiver_name"] = call.receiverName;
    callMap["channel_id"] = call.channelId;
    callMap["has_dialled"] = call.hasDialled;
    callMap["is_Call"] = call.isCall;
    return callMap;
  }

  Call.fromMap(Map callMap) {
    this.callerId = callMap["caller_id"];
    this.callerName = callMap["caller_name"];
    this.receiverId = callMap["receiver_id"];
    this.receiverName = callMap["receiver_name"];
    this.channelId = callMap["channel_id"];
    this.hasDialled = callMap["has_dialled"];
    this.isCall = callMap["is_Call"];
  }
}
class RemoteMessageData {
  final num? id;
  final String? status;
  final String? type;

  RemoteMessageData({
    this.id,
    this.status,
    this.type,
  });

  factory RemoteMessageData.fromJson(Map data) {
    return RemoteMessageData(
        id: int.tryParse(data["id"]),
        status: data["status"],
        type: data["type"]);
  }
}

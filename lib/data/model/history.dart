class History {
    String? id;
    String? userId;
    String? type;
    String? date;
    String? total;
    String? details;
    String? createdAt;
    String? updatedAt;

    History({
        required this.id,
        required this.userId,
        required this.type,
        required this.date,
        required this.total,
        required this.details,
        required this.createdAt,
        required this.updatedAt,
    });

    factory History.fromJson(Map<String, dynamic> json) => History(
        id: json["id"],
        userId: json["user_id"],
        type: json["type"],
        date: json["date"],
        total: json["total"],
        details: json["details"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "type": type,
        "date": date,
        "total": total,
        "details": details,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}

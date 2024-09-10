import "package:flutter/material.dart";

class LeaderBoardTile extends StatelessWidget {
  final int points;
  final String name;
  final bool isMatch;
  final String? image;

  const LeaderBoardTile({
    Key? key,
    required this.name,
    required this.image,
    required this.points,
    required this.isMatch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4.0),
      padding: const EdgeInsets.only(
        right: 12.5,
        top: 7.5,
        bottom: 7.5,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: image != null ? NetworkImage(image!) : null,
            backgroundColor: Colors.grey.shade400,
            child: image == null
                ? const Icon(
                    Icons.account_circle_rounded,
                    color: Colors.black,
                    size: 40.0,
                  )
                : null,
          ),
          const SizedBox(width: 15.0),
          Expanded(
            child: Text(
              isMatch ? "You" : name,
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            "$points",
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 5.0),
          const Padding(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Icon(
              Icons.hotel_class_rounded,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }
}

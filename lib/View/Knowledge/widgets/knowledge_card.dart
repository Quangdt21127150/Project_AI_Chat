import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_ai_chat/View/Knowledge/model/knowledge.dart';

class KnowledgeCard extends StatelessWidget {
  final Knowledge knowledge;

  const KnowledgeCard({super.key, required this.knowledge});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(knowledge.imageUrl),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    knowledge.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    knowledge.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // const Row(
                  //   children: [
                  //     Icon(
                  //       Icons.person_2_outlined,
                  //       size: 16,
                  //     ),
                  //     SizedBox(width: 6),
                  //     Text(
                  //       "By ${bot.team}",
                  //       style: const TextStyle(color: Colors.grey),
                  //     ),
                  //     SizedBox(width: 8),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

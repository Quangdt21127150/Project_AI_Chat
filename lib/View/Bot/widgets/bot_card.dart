import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_ai_chat/View/Bot/model/bot.dart';

class BotCard extends StatelessWidget {
  final Bot bot;

  const BotCard({super.key, required this.bot});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(bot.imageUrl),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bot.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    bot.prompt,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.person_2_outlined,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "By ${bot.team}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const Spacer(),
                      bot.isPublish
                          ? const Icon(
                              Icons.public,
                              size: 16,
                            )
                          : const Icon(
                              Icons.lock_open,
                              size: 16,
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

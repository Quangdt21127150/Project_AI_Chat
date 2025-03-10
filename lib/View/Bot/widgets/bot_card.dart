import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_ai_chat/View/Bot/model/bot.dart';

class BotCard extends StatelessWidget {
  final Bot bot;

  const BotCard({super.key, required this.bot});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.blue.shade300, Colors.purple.shade300],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(2),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                backgroundImage: bot.imageUrl.startsWith('assets/')
                    ? AssetImage(bot.imageUrl)
                    : FileImage(File(bot.imageUrl)) as ImageProvider<Object>,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bot.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.grey.shade900,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bot.prompt,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.person_2_outlined,
                        size: 16,
                        color: Colors.blue.shade400,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        bot.team,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: bot.isPublish
                              ? Colors.green.shade50
                              : Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              bot.isPublish ? Icons.public : Icons.lock_open,
                              size: 14,
                              color: bot.isPublish
                                  ? Colors.green.shade600
                                  : Colors.orange.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              bot.isPublish ? 'Public' : 'Private',
                              style: TextStyle(
                                fontSize: 12,
                                color: bot.isPublish
                                    ? Colors.green.shade600
                                    : Colors.orange.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
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
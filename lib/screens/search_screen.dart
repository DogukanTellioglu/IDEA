import 'package:flutter/material.dart';

import '../widgets/bottom_menu.dart';
import 'tweet_screen.dart'; // Burada tweetList'i import ediyoruz

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredTweets = tweetList.where((tweet) {
      final contentMatch =
          tweet.content.toLowerCase().contains(searchQuery.toLowerCase());
      final tagMatch = tweet.tags
          .any((tag) => tag.toLowerCase().contains(searchQuery.toLowerCase()));
      return contentMatch || tagMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Geçmiş Paylaşımlarınız"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Tweet ara...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: filteredTweets.isEmpty
                ? const Center(
                    child: Text(
                      "Henüz paylaşım yapılmamış.",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredTweets.length,
                    itemBuilder: (context, index) {
                      final tweet = filteredTweets[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundImage:
                                        NetworkImage(tweet.avatarUrl),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tweet.author,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "${tweet.timestamp.day.toString().padLeft(2, '0')}/${tweet.timestamp.month.toString().padLeft(2, '0')}/${tweet.timestamp.year}",
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                tweet.content,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 6,
                                children: tweet.tags
                                    .map((tag) => Chip(
                                          label: Text('#$tag'),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          labelStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary,
                                          ),
                                        ))
                                    .toList(),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.thumb_up,
                                          size: 18, color: Colors.blue),
                                      const SizedBox(width: 4),
                                      Text('${tweet.likes}'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.thumb_down,
                                          size: 18, color: Colors.red),
                                      const SizedBox(width: 4),
                                      Text('${tweet.dislikes}'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.comment, size: 18),
                                      const SizedBox(width: 4),
                                      Text('${tweet.comments.length}'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.repeat,
                                          size: 18, color: Colors.green),
                                      const SizedBox(width: 4),
                                      Text('${tweet.retweets}'),
                                    ],
                                  ),
                                ],
                              ),
                              if (tweet.comments.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Column(
                                    children: tweet.comments.map((comment) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 16,
                                              backgroundImage: NetworkImage(
                                                  comment.avatarUrl),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    comment.author,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14),
                                                  ),
                                                  Text(
                                                    comment.text,
                                                    style: const TextStyle(
                                                        fontSize: 13),
                                                  ),
                                                  Text(
                                                    "${comment.timestamp.day.toString().padLeft(2, '0')}/${comment.timestamp.month.toString().padLeft(2, '0')}/${comment.timestamp.year} ${comment.timestamp.hour.toString().padLeft(2, '0')}:${comment.timestamp.minute.toString().padLeft(2, '0')}",
                                                    style: const TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomMenu(),
    );
  }
}

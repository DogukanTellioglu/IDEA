import 'package:flutter/material.dart';
import '../core/session.dart';
import '../widgets/bottom_menu.dart';

// Gelişmiş Tweet modeli yaptım
class Tweet {
  final String content;
  final DateTime timestamp;
  final String author;
  final String avatarUrl;
  final List<String> tags;
  int likes;
  int dislikes;
  int retweets;
  List<Comment> comments;
  bool liked = false;
  bool disliked = false;
  bool retweeted = false;
  bool isReported = false;

  Tweet({
    required this.content,
    required this.timestamp,
    required this.author,
    required this.avatarUrl,
    this.tags = const [],
    this.likes = 0,
    this.dislikes = 0,
    this.retweets = 0,
    List<Comment>? comments,
  }) : comments = comments ?? [];
}

class Comment {
  final String text;
  final String author;
  final String avatarUrl;
  final DateTime timestamp;

  Comment({
    required this.text,
    required this.author,
    required this.avatarUrl,
    required this.timestamp,
  });
}

// Tweet listesini public hale getirdim
List<Tweet> tweetList = [];

class TweetPage extends StatefulWidget {
  const TweetPage({super.key});

  @override
  State<TweetPage> createState() => _TweetPageState();
}

class _TweetPageState extends State<TweetPage> {
  final TextEditingController tweetController = TextEditingController();
  final TextEditingController tagController = TextEditingController();

  void _paylas() {
    final text = tweetController.text.trim();
    if (text.isEmpty || Session.currentUser == null) return;

    final tags = tagController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    setState(() {
      tweetList.insert(
        0,
        Tweet(
          content: text,
          timestamp: DateTime.now(),
          author: Session.currentUser!.name,
          avatarUrl: Session.currentUser!.avatarUrl,
          tags: tags,
        ),
      );
      tweetController.clear();
      tagController.clear();
    });
  }

  void _showCommentDialog(Tweet tweet) {
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Yorum yap"),
        content: TextField(
          controller: commentController,
          decoration: const InputDecoration(hintText: "Yorumunuzu yazın"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final text = commentController.text.trim();
              if (text.isNotEmpty && Session.currentUser != null) {
                setState(() {
                  tweet.comments.add(Comment(
                    text: text,
                    author: Session.currentUser!.name,
                    avatarUrl: Session.currentUser!.avatarUrl,
                    timestamp: DateTime.now(),
                  ));
                });
              }
              Navigator.of(context).pop();
            },
            child: const Text("Gönder"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    tweetController.dispose();
    tagController.dispose();
    super.dispose();
  }

  Widget _tweetCard(Tweet tweet) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading:
                  CircleAvatar(backgroundImage: NetworkImage(tweet.avatarUrl)),
              title: Text(tweet.author,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(_formatDateTime(tweet.timestamp)),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => setState(() => tweetList.remove(tweet)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(tweet.content),
            ),
            if (tweet.tags.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Wrap(
                  spacing: 6,
                  children: tweet.tags
                      .map((tag) => Chip(
                            label: Text('#$tag'),
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ))
                      .toList(),
                ),
              ),
            if (tweet.comments.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                child: Column(
                  children: tweet.comments
                      .map((comment) => ListTile(
                            leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(comment.avatarUrl)),
                            title: Text(comment.author,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(comment.text),
                                Text(
                                  _formatDateTime(comment.timestamp),
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.close, size: 18),
                              onPressed: () => setState(
                                  () => tweet.comments.remove(comment)),
                            ),
                          ))
                      .toList(),
                ),
              ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.thumb_up,
                      color: tweet.liked ? Colors.blue : null),
                  onPressed: () => setState(() {
                    if (tweet.liked) {
                      tweet.likes--;
                      tweet.liked = false;
                    } else if (!tweet.disliked) {
                      tweet.likes++;
                      tweet.liked = true;
                    }
                  }),
                ),
                Text('${tweet.likes}'),
                IconButton(
                  icon: Icon(Icons.thumb_down,
                      color: tweet.disliked ? Colors.red : null),
                  onPressed: () => setState(() {
                    if (tweet.disliked) {
                      tweet.dislikes--;
                      tweet.disliked = false;
                    } else if (!tweet.liked) {
                      tweet.dislikes++;
                      tweet.disliked = true;
                    }
                  }),
                ),
                Text('${tweet.dislikes}'),
                IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: () => _showCommentDialog(tweet),
                ),
                Text('${tweet.comments.length}'),
                IconButton(
                  icon: Icon(Icons.repeat,
                      color: tweet.retweeted ? Colors.green : null),
                  onPressed: () => setState(() {
                    if (!tweet.retweeted && Session.currentUser != null) {
                      tweet.retweets++;
                      tweet.retweeted = true;
                      tweetList.insert(
                          0,
                          Tweet(
                            content: tweet.content,
                            timestamp: DateTime.now(),
                            author: Session.currentUser!.name,
                            avatarUrl: Session.currentUser!.avatarUrl,
                          ));
                    }
                  }),
                ),
                Text('${tweet.retweets}'),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Paylaşım başarıyla kopyalandı.")),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.report, color: Colors.orange),
                  onPressed: () {
                    setState(() {
                      tweet.isReported = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Gönderi bildirildi.")),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return "${dt.day.toString().padLeft(2, '0')} "
        "${_monthName(dt.month)} "
        "${dt.year} - "
        "${dt.hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')}";
  }

  String _monthName(int month) {
    const months = [
      'Oca',
      'Şub',
      'Mar',
      'Nis',
      'May',
      'Haz',
      'Tem',
      'Ağu',
      'Eyl',
      'Eki',
      'Kas',
      'Ara'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fikrini Paylaş'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: tweetController,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Ne düşünüyorsun?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _paylas,
                ),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _paylas(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: tagController,
              decoration: InputDecoration(
                hintText: 'Etiketler (virgülle ayırın)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: tweetList.isEmpty
                ? const Center(child: Text('Henüz gönderi yok'))
                : ListView.builder(
                    itemCount: tweetList.length,
                    itemBuilder: (context, index) {
                      final tweet = tweetList[index];
                      return _tweetCard(tweet);
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomMenu(),
    );
  }
}

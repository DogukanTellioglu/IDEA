import 'package:flutter/material.dart';

class TweetSharePage extends StatefulWidget {
  const TweetSharePage({super.key});

  @override
  State<TweetSharePage> createState() => _TweetSharePageState();
}

class _TweetSharePageState extends State<TweetSharePage> {
  final TextEditingController tweetController = TextEditingController();

  void _shareTweet() {
    final text = tweetController.text.trim();
    if (text.isEmpty) return;

    // Burada tweeti paylaşma işlemi yapılabilir.
    // Şimdilik sadece ekrana mesaj gösterelim:
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tweet paylaşıldı!')),
    );

    tweetController.clear();
  }

  @override
  void dispose() {
    tweetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweet Paylaş'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: tweetController,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Ne düşünüyorsun?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _shareTweet,
              child: const Text('Paylaş'),
            ),
          ],
        ),
      ),
    );
  }
}

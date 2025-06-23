import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:perplexity_clone/theme/colors.dart';
import 'package:perplexity_clone/widgets/side_bar.dart';
import 'package:perplexity_clone/models/chat_model.dart';
import 'package:perplexity_clone/services/database_service.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:perplexity_clone/pages/recent_chat.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String searchQuery = '';
  bool isSearching = false;

  List<ChatModel> _filterChats(List<ChatModel> chats) {
    return chats
        .where((item) =>
            item.question.toLowerCase().contains(searchQuery.toLowerCase()) ||
            (item.preview ?? '')
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 768;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Row(
          children: [
            if (kIsWeb && isLargeScreen) SideBar(),
            Expanded(
              child: Center(
                child: Container(
                  width: isLargeScreen ? 800 : null,
                  padding: EdgeInsets.all(isLargeScreen ? 24 : 16),
                  child: Column(
                    children: [
                      // Header
                      Row(
                        children: [
                          const Text(
                            "Chat History",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => setState(() {
                              isSearching = !isSearching;
                              if (!isSearching) searchQuery = '';
                            }),
                            icon: Icon(
                              isSearching ? Icons.close : Icons.search,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),

                      // Search
                      if (isSearching) ...[
                        const SizedBox(height: 16),
                        TextField(
                          onChanged: (value) =>
                              setState(() => searchQuery = value),
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon:
                                const Icon(Icons.search, color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),

                      // List
                      Expanded(
                        child: StreamBuilder<List<ChatModel>>(
                          stream: DatabaseService.streamMyChats(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text(
                                  "No chat history",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              );
                            }
                            final filteredHistory =
                                _filterChats(snapshot.data!);
                            if (filteredHistory.isEmpty) {
                              return const Center(
                                child: Text(
                                  "No chat history",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              );
                            }
                            return ListView.separated(
                              itemCount: filteredHistory.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final item = filteredHistory[index];
                                return Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.1),
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            RecentChatPage(chat: item),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.question,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                item.preview ?? '',
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                timeago.format(item.createdAt),
                                                style: const TextStyle(
                                                  color: Colors.white54,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Optionally add a delete button here if you implement deletion
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_ai_chat/viewmodels/prompt_list_view_model.dart';
import 'package:provider/provider.dart';
import '../PromptDetailsBottomSheet/prompt_details_bottom_sheet.dart';

class PromptListWidget extends StatefulWidget {
  const PromptListWidget({Key? key}) : super(key: key);

  @override
  _PromptListWidgetState createState() => _PromptListWidgetState();
}

class _PromptListWidgetState extends State<PromptListWidget> {
  final Map<String, bool> _favoriteStates = {}; // Theo dõi trạng thái yêu thích
  bool isDeleting = false;
  final viewModel = PromptListViewModel();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<PromptListViewModel>();
    viewModel.fetchPrompts();

    // Lắng nghe sự kiện cuộn
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !viewModel.isLoadingMore) {
        viewModel.loadMorePrompts();
      }
    });
  }

  Future<bool> _toggleFavorite(String promptId, bool isFavorite) {
    return viewModel.toggleFavorite(promptId, isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PromptListViewModel>();
    final prompts = viewModel.promptList;

    if (prompts.total == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              'No prompts found.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 5),
            Text(
              'Try adjusting your filters or search terms.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    for (var prompt in prompts.items) {
      _favoriteStates[prompt.id] ??= prompt.isFavorite ?? false;
    }

    return Stack(children: [
      ListView.builder(
        controller: _scrollController,
        itemCount: prompts.items.length + 1,
        itemBuilder: (context, index) {
          if (index < prompts.items.length) {
            final prompt = prompts.items[index];
            final isFavorite = _favoriteStates[prompt.id] ?? false;

            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                PromptDetailsBottomSheet.show(context, prompt);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              PromptDetailsBottomSheet.show(context, prompt);
                            },
                            child: Text(
                              prompt.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final success =
                                await _toggleFavorite(prompt.id, isFavorite);

                                if (success) {
                                  setState(() {
                                    _favoriteStates[prompt.id] = !isFavorite;
                                    prompt.isFavorite = !prompt.isFavorite;
                                  });
                                }
                              },
                              child: Icon(
                                isFavorite ? Icons.star : Icons.star_border,
                                color: isFavorite ? Colors.yellow : Colors.grey,
                              ),
                            ),
                            SizedBox(width: 10),
                            if (!viewModel
                                .isPublic) // Hiển thị thùng rác nếu isPublic = false
                              Row(children: [
                                GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      isDeleting =
                                      true; // Bắt đầu quá trình xóa
                                    });
                                    final success =
                                    await viewModel.deletePrompt(prompt.id);
                                    if (success) {
                                      viewModel.fetchPrompts();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                            Text('Failed to delete prompt.')),
                                      );
                                    }
                                    setState(() {
                                      isDeleting =
                                      false; // Bắt đầu quá trình xóa
                                    });
                                  },
                                  child: Icon(Icons.delete_outline,
                                      color: Colors.grey),
                                ),
                                SizedBox(width: 10),
                              ]),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                //_showPromptDetailsBottomSheet(context, prompt);
                                PromptDetailsBottomSheet.show(context, prompt);
                              },
                              child: Icon(
                                  Icons.arrow_right, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(prompt.description),
                    Divider(thickness: 1.2),
                  ],
                ),
              ),
            );
          }else if (viewModel.isLoadingMore) {
            // Hiển thị loading khi đang tải thêm
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          } else {
            return SizedBox.shrink(); // Không hiển thị gì
          }
        },
      ),
      if (isDeleting)
        Positioned.fill(
          child: Container(
            //color: Colors.black.withOpacity(0.5), // Lớp màu mờ
            child: Center(
              child: CircularProgressIndicator(color: Colors.blueGrey),
            ),
          ),
        ),
      if (viewModel.isLoading && prompts.items.isEmpty)
        Center(child: CircularProgressIndicator()),
    ]);
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

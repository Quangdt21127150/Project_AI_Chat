import 'package:flutter/material.dart';
import 'package:project_ai_chat/models/prompt_model.dart';
import 'package:project_ai_chat/models/prompt_list.dart';
import '../services/prompt_service.dart';

class PromptListViewModel extends ChangeNotifier {
  final PromptService _service = PromptService();
  PromptList allprompts = PromptList.empty();
  PromptList _promptList = PromptList.empty();



  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? error;

  // Thông tin phân trang
  int _limit = 10;
  int _offset = 0;
  bool _hasNext = true;

  bool _isPublic = false;
  String _selectedCategory = 'all';
  String _query = '';
  bool _isFavorite = false;
  bool _isCreated = false;


  PromptList get promptList => _promptList;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasError => error != null;
  bool get hasNext => _hasNext;
  bool get isPublic => _isPublic;
  String get selectedCategory => _selectedCategory;
  String get query => _query;
  bool get isFavorite => _isFavorite;
  bool get isCreated => _isCreated;

  set isPublic(bool value) {
    if (_isPublic != value) {
      _isPublic = value;
      fetchPrompts();
      notifyListeners();
    }
  }

  set selectedCategory(String value) {
    if (_selectedCategory != value) {
      _selectedCategory = value;
      fetchPrompts();
      notifyListeners();
    }
  }

  set query(String value) {
    if (_query != value) {
      _query = value;
      fetchPrompts();
      notifyListeners();
    }
  }

  set isFavorite(bool value) {
    if (_isFavorite != value) {
      _isFavorite = value;
      fetchPrompts();
      notifyListeners();
    }
  }

  PromptRequest pr = PromptRequest(
      query: "",
      offset: 0,
      limit: 10,
      category: "all",
      isFavorite: false,
      isPublic: false
  );

  PromptListViewModel() {
    init();
  }

  Future<void> init() async {
    await fetchPrompts(); // Gọi phương thức fetch dữ liệu khi khởi tạo
    notifyListeners();
  }

  Future<PromptList> fetchAllPrompts() async {
    _isLoading = true;
    notifyListeners();
    allprompts = await _service.fetchAllPrompts();
    _isLoading = false;
    notifyListeners();
    return allprompts;
  }



  // Future<void> fetchPrompts() async {
  //   _isLoading = true;
  //   notifyListeners();
  //   pr = pr.copyWith(
  //       category: _selectedCategory,
  //       query: _query,
  //       isFavorite: _isFavorite,
  //       isPublic: _isPublic);
  //   print("-------------------->>>>>>> ${pr.category}");
  //   final result = await _service.fetchPrompts(pr);
  //   _promptList = result;
  //   _isLoading = false;
  //   notifyListeners();
  // }

  Future<bool> fetchPrompts() async {
    if (_isLoading) return false;

    _isLoading = true;

    _offset = 0; // Reset lại offset
    _promptList = PromptList.empty(); // Xóa dữ liệu cũ
    _hasNext = true;

    notifyListeners();

    try {
      final request = pr = pr.copyWith(
        category: _selectedCategory,
        query: _query,
        isFavorite: _isFavorite,
        isPublic: _isPublic,
        limit: _limit,
        offset: _offset);
      final result = await _service.fetchPrompts(request);

      // Cập nhật danh sách và trạng thái phân trang
      _promptList = result;
      _hasNext = result.hasNext;
      _offset += _limit;
    } catch (e) {
      error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return true;
  }

  Future<void> loadMorePrompts() async {
    if (_isLoadingMore || !_hasNext) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final request = pr = pr.copyWith(
          category: _selectedCategory,
          query: _query,
          isFavorite: _isFavorite,
          isPublic: _isPublic,
          limit: _limit,
          offset: _offset);
      final result = await _service.fetchPrompts(request);

      // Cập nhật danh sách và trạng thái phân trang
      _promptList.items.addAll(result.items);
      _hasNext = result.hasNext;
      _offset += _limit;
    } catch (e) {
      error = e.toString();
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }


  Future<bool> toggleFavorite(String promptId, bool isFavorite) {
    return _service.toggleFavorite(promptId, isFavorite);
  }

  Future<bool> createPrompt(PromptRequest newPrompt) {
    return _service.createPrompt(newPrompt);
  }

  Future<bool> deletePrompt(String id) {
    return _service.deletePrompt(id);
  }

  Future<bool> updatePrompt(PromptRequest newPrompt, String promptId) {
    return _service.updatePrompt(newPrompt, promptId);
  }
}

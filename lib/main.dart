import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0F172A),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const EdVanceApp());
}

// ==========================================
// THEME COLORS (MATCHING V96/V114 HTML)
// ==========================================
class AppColors {
  static const Color bg = Color(0xFF0F172A);
  static const Color card = Color(0xFF1E293B);
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFFA5B4FC);
  static const Color indigoSoft = Color(0xFF818CF8);
  static const Color emerald = Color(0xFF10B981);
  static const Color emeraldLight = Color(0xFF6EE7B7);
  static const Color amber = Color(0xFFF59E0B);
  static const Color amberLight = Color(0xFFFCD34D);
  static const Color rose = Color(0xFFF43F5E);
  static const Color textMain = Color(0xFFF8FAFC);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color border = Color(0x14FFFFFF);
}

// ==========================================
// SYLLABUS & PAPER SPLIT SYSTEM
// ==========================================
const Map<String, Map<String, List<String>>> kSyllabus = {
  "Admission": {
    "পদার্থবিজ্ঞান": [
      "ভৌত জগৎ ও পরিমাপ",
      "ভেক্টর",
      "গতিবিদ্যা",
      "নিউটনিয়ান বলবিদ্যা",
      "কাজ, শক্তি ও ক্ষমতা",
      "মহাকর্ষ ও অভিকর্ষ",
      "পদার্থের গাঠনিক ধর্ম",
      "পর্যাবৃত্ত গতি",
      "তরঙ্গ",
      "আদর্শ গ্যাস ও গ্যাসের গতিতত্ত্ব",
      "তাপ গতিবিদ্যা",
      "স্থির তড়িৎ",
      "চল তড়িৎ",
      "তড়িৎ প্রবাহের চৌম্বক ক্রিয়া ও চুম্বকত্ব",
      "তড়িতচৌম্বকীয় আবেশ",
      "জ্যামিতিক আলোকবিজ্ঞান",
      "ভৌত আলোকবিজ্ঞান",
      "আধুনিক পদার্থবিজ্ঞান",
      "পরমাণু ও নিউক্লিয়ার",
      "সেমিকন্ডাক্টর",
      "জ্যোতির্বিজ্ঞান"
    ],
    "রসায়ন": [
      "ল্যাবরেটরির নিরাপদ ব্যবহার",
      "গুণগত রসায়ন",
      "মৌলের পর্যায়বৃত্ত ধর্ম",
      "রাসায়নিক পরিবর্তন",
      "কর্মমুখী রসায়ন",
      "পরিবেশ রসায়ন",
      "জৈব রসায়ন",
      "পরিমাণগত রসায়ন",
      "তড়িৎ রসায়ন",
      "অর্থনৈতিক রসায়ন"
    ],
    "উচ্চতর গণিত": [
      "ম্যাট্রিক্স ও নির্ণায়ক",
      "ভেক্টর",
      "সরলরেখা",
      "বৃত্ত",
      "বিন্যাস ও সমাবেশ",
      "ত্রিকোণমিতিক অনুপাত",
      "সংযুক্ত কোণের ত্রিকোণমিতিক অনুপাত",
      "ফাংশন",
      "অন্তরীকরণ",
      "যোগজীকরণ",
      "বাস্তব সংখ্যা",
      "যোগাশ্রয়ী প্রোগ্রাম",
      "জটিল সংখ্যা",
      "বহুপদী",
      "দ্বিপদী বিস্তৃতি",
      "কণিক",
      "বিপরীত ত্রিকোণমিতিক",
      "স্থিতিবিদ্যা",
      "সমতলে বস্তুকণার গতি",
      "বিস্তার পরিমাপ ও সম্ভাবনা"
    ],
    "জীববিজ্ঞান": [
      "কোষ ও এর গঠন",
      "কোষ বিভাজন",
      "কোষ রসায়ন",
      "অণুজীব",
      "শৈবাল ও ছত্রাক",
      "ব্রায়োফাইটা ও টেরিডোফাইটা",
      "নগ্নবীজী ও আবৃতবীজী",
      "টিস্যু ও টিস্যুতন্ত্র",
      "উদ্ভিদ শরীরতত্ত্ব",
      "উদ্ভিদ প্রজনন",
      "জীবপ্রযুক্তি",
      "জীবের পরিবেশ",
      "প্রাণীর বিভিন্নতা",
      "প্রাণীর পরিচিতি",
      "পরিপাক ও শোষণ",
      "রক্ত ও সংবহন",
      "শ্বসন",
      "বর্জ্য ও নিষ্কাশন",
      "চলন ও অঙ্গচালনা",
      "সমন্বয় ও নিয়ন্ত্রণ",
      "জীবনের ধারাবাহিকতা",
      "প্রতিরক্ষা",
      "জিন তত্ত্ব ও বিবর্তন",
      "প্রাণীর আচরণ"
    ]
  },
  "HSC": {
    "পদার্থবিজ্ঞান": [
      "ভৌত জগৎ ও পরিমাপ",
      "ভেক্টর",
      "গতিবিদ্যা",
      "নিউটনিয়ান বলবিদ্যা",
      "কাজ, শক্তি ও ক্ষমতা",
      "মহাকর্ষ ও অভিকর্ষ",
      "পদার্থের গাঠনিক ধর্ম",
      "পর্যাবৃত্ত গতি",
      "তরঙ্গ",
      "আদর্শ গ্যাস",
      "তাপ গতিবিদ্যা",
      "স্থির তড়িৎ",
      "চল তড়িৎ",
      "চৌম্বক ক্রিয়া",
      "আবেশ",
      "জ্যামিতিক আলোকবিজ্ঞান",
      "ভৌত আলোকবিজ্ঞান",
      "আধুনিক পদার্থবিজ্ঞান",
      "পরমাণু ও নিউক্লিয়ার",
      "সেমিকন্ডাক্টর",
      "জ্যোতির্বিজ্ঞান"
    ],
    "রসায়ন": [
      "ল্যাবরেটরির নিরাপদ ব্যবহার",
      "গুণগত রসায়ন",
      "পর্যায়বৃত্ত ধর্ম",
      "রাসায়নিক পরিবর্তন",
      "কর্মমুখী রসায়ন",
      "পরিবেশ রসায়ন",
      "জৈব রসায়ন",
      "পরিমাণগত রসায়ন",
      "তড়িৎ রসায়ন",
      "অর্থনৈতিক রসায়ন"
    ],
    "উচ্চতর গণিত": [
      "ম্যাট্রিক্স ও নির্ণায়ক",
      "ভেক্টর",
      "সরলরেখা",
      "বৃত্ত",
      "বিন্যাস ও সমাবেশ",
      "ত্রিকোণমিতিক অনুপাত",
      "সংযুক্ত কোণ",
      "ফাংশন",
      "অন্তরীকরণ",
      "যোগজীকরণ",
      "বাস্তব সংখ্যা",
      "যোগাশ্রয়ী",
      "জটিল সংখ্যা",
      "বহুপদী",
      "দ্বিপদী",
      "কণিক",
      "বিপরীত ত্রিকোণমিতিক",
      "স্থিতিবিদ্যা",
      "বস্তুকণার গতি",
      "বিস্তার ও সম্ভাবনা"
    ],
    "জীববিজ্ঞান": [
      "কোষ ও এর গঠন",
      "কোষ বিভাজন",
      "কোষ রসায়ন",
      "অণুজীব",
      "শৈবাল ও ছত্রাক",
      "ব্রায়োফাইটা",
      "নগ্নবীজী",
      "টিস্যু",
      "উদ্ভিদ শরীরতত্ত্ব",
      "উদ্ভিদ প্রজনন",
      "জীবপ্রযুক্তি",
      "পরিবেশ",
      "প্রাণীর বিভিন্নতা",
      "প্রাণীর পরিচিতি",
      "পরিপাক",
      "রক্ত",
      "শ্বসন",
      "বর্জ্য",
      "চলন",
      "সমন্বয়",
      "ধারাবাহিকতা",
      "প্রতিরক্ষা",
      "জিন তত্ত্ব",
      "আচরণ"
    ]
  }
};

List<String> getChaptersForPaper(String subject, String paper, String level) {
  final subs = kSyllabus[level] ?? kSyllabus["Admission"]!;
  final all = subs[subject] ?? [];
  if (paper.isEmpty || paper == "Combined") return all;
  const splitMap = {
    "পদার্থবিজ্ঞান": 10,
    "রসায়ন": 5,
    "উচ্চতর গণিত": 10,
    "জীববিজ্ঞান": 12,
  };
  final split = splitMap[subject] ?? (all.length / 2).ceil();
  if (paper == "1st") return all.sublist(0, split.clamp(0, all.length));
  if (paper == "2nd") return all.sublist(split.clamp(0, all.length));
  return all;
}

String paperLabel(String p) {
  if (p == "1st") return "১ম পত্র";
  if (p == "2nd") return "২য় পত্র";
  return "Combined";
}

String normalizeSubjectBase(String? s) {
  if (s == null || s.isEmpty) return "পদার্থবিজ্ঞান";
  final lower = s.toLowerCase();
  if (s.contains("পদার্থ") || lower.contains("physics")) return "পদার্থবিজ্ঞান";
  if (s.contains("রসা") || lower.contains("chem")) return "রসায়ন";
  if (s.contains("গণিত") || lower.contains("math")) return "উচ্চতর গণিত";
  if (s.contains("জীব") || lower.contains("bio")) return "জীববিজ্ঞান";
  return s;
}

// ==========================================
// QUESTION MODEL & V1/V2 NORMALIZER
// ==========================================
class Question {
  String id;
  final String level;
  final String subject;
  final String chapter;
  final String paper;
  final String tag;
  final String q;
  final List<String> options;
  final int ans;
  final String exp;
  final String difficulty;

  Question({
    required this.id,
    required this.level,
    required this.subject,
    required this.chapter,
    required this.paper,
    required this.tag,
    required this.q,
    required this.options,
    required this.ans,
    required this.exp,
    this.difficulty = "medium",
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "level": level,
        "subject": subject,
        "chapter": chapter,
        "paper": paper,
        "tag": tag,
        "q": q,
        "options": options,
        "ans": ans,
        "exp": exp,
        "difficulty": difficulty,
      };

  static String normText(String? s) {
    if (s == null) return "";
    return s.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  // Deterministic DJB2 Hash matching JS `hashStr`
  static String hashStr(String s) {
    int h = 5381;
    for (int i = 0; i < s.length; i++) {
      h = (((h << 5) + h) + s.codeUnitAt(i)) & 0xFFFFFFFF;
    }
    return h.toUnsigned(32).toRadixString(36);
  }

  static String makeQuestionId({
    required String subject,
    required String chapter,
    required String q,
    required List<String> options,
  }) {
    final sortedOpts = options.map((o) => normText(o)).toList()..sort();
    final base = "$subject|$chapter|${normText(q)}|${sortedOpts.join('|')}";
    return "edv-${hashStr(base)}";
  }

  static Question? normalizeQ(dynamic raw) {
    if (raw is! Map) return null;
    final p = Map<String, dynamic>.from(raw);

    final rawQ = (p['q'] ?? p['question'] ?? p['text'] ?? '').toString().trim();
    if (rawQ.length < 3) return null;

    List<String> opts = [];
    final rawOpts = p['options'] ?? p['opts'] ?? p['choices'];
    if (rawOpts is List) {
      opts = rawOpts.map((e) => e.toString().trim()).toList();
    } else if (rawOpts is Map) {
      opts = rawOpts.values.map((e) => e.toString().trim()).toList();
    } else if (p['a'] != null &&
        p['b'] != null &&
        p['c'] != null &&
        p['d'] != null) {
      opts = [
        p['a'].toString().trim(),
        p['b'].toString().trim(),
        p['c'].toString().trim(),
        p['d'].toString().trim(),
      ];
    } else {
      return null;
    }

    while (opts.length < 4) {
      opts.add("অপশন ${opts.length + 1}");
    }
    opts = opts.take(4).toList();

    dynamic rawAns = p['ans'] ?? p['answer'] ?? p['correct'] ?? 0;
    int ans = 0;
    if (rawAns is int) {
      ans = rawAns;
    } else if (rawAns is String) {
      final a = rawAns.toLowerCase().trim();
      if (a == 'a' || a == 'ক' || a == '0') {
        ans = 0;
      } else if (a == 'b' || a == 'খ' || a == '1') {
        ans = 1;
      } else if (a == 'c' || a == 'গ' || a == '2') {
        ans = 2;
      } else if (a == 'd' || a == 'ঘ' || a == '3') {
        ans = 3;
      } else {
        ans = int.tryParse(a) ?? 0;
      }
    }
    if (ans < 0 || ans > 3) ans = 0;

    String level = (p['level'] ?? 'Admission').toString();
    if (level != 'Admission' && level != 'HSC') level = 'Admission';

    final subject =
        normalizeSubjectBase((p['subject'] ?? 'পদার্থবিজ্ঞান').toString());
    final chapter = (p['chapter'] ?? 'সাধারণ').toString().trim();
    final tag = (p['tag'] ?? 'Custom').toString().trim();
    final exp = (p['exp'] ?? p['explanation'] ?? '').toString().trim();

    String paper = (p['paper'] ?? 'Combined').toString();
    if (paper != 'Combined' && paper != '1st' && paper != '2nd') {
      if (paper == '১ম পত্র' || paper == '1st Paper') {
        paper = '1st';
      } else if (paper == '২য় পত্র' || paper == '2nd Paper') {
        paper = '2nd';
      } else {
        paper = 'Combined';
      }
    }

    final difficulty = (p['difficulty'] ?? 'medium').toString();
    String id = (p['id'] ?? '').toString();
    if (!id.startsWith('edv-')) {
      id = makeQuestionId(
        subject: subject,
        chapter: chapter,
        q: rawQ,
        options: opts,
      );
    }

    return Question(
      id: id,
      level: level,
      subject: subject,
      chapter: chapter,
      paper: paper,
      tag: tag,
      q: rawQ,
      options: opts,
      ans: ans,
      exp: exp,
      difficulty: difficulty,
    );
  }
}

// ==========================================
// MAIN APP WIDGET
// ==========================================
class EdVanceApp extends StatelessWidget {
  const EdVanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EdVance Mega QB',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.emerald,
          surface: AppColors.card,
        ),
        splashFactory: InkRipple.splashFactory,
        useMaterial3: true,
      ),
      home: const MainShell(),
    );
  }
}

// ==========================================
// MAIN SHELL & STATE MANAGEMENT
// ==========================================
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  // Core DB & App State
  List<Question> db = [];
  String currentLevel = "Admission";
  int activeTab = 0; // 0: home, 1: qb, 2: exam, 3: hub

  // Persistent Stats, Bookmarks & Mistakes
  int stAttempted = 0;
  int stCorrect = 0;
  Set<String> bookmarkedIds = {};
  Set<String> mistakeIds = {};

  // Search State
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  // Scroll Controller for Top Header Fade
  final ScrollController _homeScrollController = ScrollController();
  double topHeaderOpacity = 1.0;

  // Custom Model Test State
  String mtLevelVal = "Admission";
  String mtPaperVal = "Combined";
  String mtSubjectVal = "ALL";
  String mtChapterVal = "ALL";
  int mtCountVal = 20;

  // Manual Add State
  String addSubjectVal = "পদার্থবিজ্ঞান";
  String addPaperVal = "Combined";
  String addChapterVal = "ভৌত জগৎ ও পরিমাপ";
  int addAnsVal = 0;
  final TextEditingController _addTagCtrl = TextEditingController();
  final TextEditingController _addQCtrl = TextEditingController();
  final TextEditingController _addOpt0Ctrl = TextEditingController();
  final TextEditingController _addOpt1Ctrl = TextEditingController();
  final TextEditingController _addOpt2Ctrl = TextEditingController();
  final TextEditingController _addOpt3Ctrl = TextEditingController();
  final TextEditingController _addExpCtrl = TextEditingController();
  String? addStatusMsg;
  Color addStatusColor = AppColors.emerald;

  // Import Feedback State
  String? importMsg;
  List<String> fileImportLogs = [];

  // Double Back to Exit State
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    _loadAllData();
    _homeScrollController.addListener(_onHomeScroll);
  }

  @override
  void dispose() {
    _homeScrollController.dispose();
    _searchController.dispose();
    _addTagCtrl.dispose();
    _addQCtrl.dispose();
    _addOpt0Ctrl.dispose();
    _addOpt1Ctrl.dispose();
    _addOpt2Ctrl.dispose();
    _addOpt3Ctrl.dispose();
    _addExpCtrl.dispose();
    super.dispose();
  }

  void _onHomeScroll() {
    if (activeTab != 0) return;
    final y = _homeScrollController.offset;
    final newOpacity = (1.0 - (y / 180.0)).clamp(0.0, 1.0);
    if ((newOpacity - topHeaderOpacity).abs() > 0.02) {
      setState(() {
        topHeaderOpacity = newOpacity;
      });
    }
  }

  // ==========================================
  // PERSISTENCE (SHARED PREFERENCES)
  // ==========================================
  Future<void> _loadAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedDb = prefs.getString('edv_custom_db');
      if (savedDb != null && savedDb.isNotEmpty) {
        final decoded = jsonDecode(savedDb);
        final parsedList = _extractQuestionsList(decoded);
        final loaded = <Question>[];
        for (final item in parsedList) {
          final nq = Question.normalizeQ(item);
          if (nq != null) loaded.add(nq);
        }
        db = loaded;
      }

      stAttempted = prefs.getInt('edv_st_attempted') ?? 0;
      stCorrect = prefs.getInt('edv_st_correct') ?? 0;
      bookmarkedIds = (prefs.getStringList('edv_bookmarks') ?? []).toSet();
      mistakeIds = (prefs.getStringList('edv_mistakes') ?? []).toSet();

      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Load error: $e");
    }
  }

  Future<void> _saveDB() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(db.map((q) => q.toJson()).toList());
      await prefs.setString('edv_custom_db', encoded);
    } catch (e) {
      debugPrint("Save DB error: $e");
    }
  }

  Future<void> _saveUserStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('edv_st_attempted', stAttempted);
      await prefs.setInt('edv_st_correct', stCorrect);
      await prefs.setStringList('edv_bookmarks', bookmarkedIds.toList());
      await prefs.setStringList('edv_mistakes', mistakeIds.toList());
    } catch (e) {
      debugPrint("Save stats error: $e");
    }
  }

  // ==========================================
  // HELPERS: DUPLICATE CHECK & PARSER
  // ==========================================
  List<dynamic> _extractQuestionsList(dynamic parsed) {
    if (parsed == null) return [];
    if (parsed is List) return parsed;
    if (parsed is Map) {
      if (parsed['questions'] is List) return parsed['questions'] as List;
      if (parsed['data'] is List) return parsed['data'] as List;
      if (parsed['q'] != null || parsed['question'] != null) return [parsed];
    }
    return [];
  }

  int _detectVersion(dynamic parsed) {
    if (parsed is Map && parsed['version'] is int) {
      return parsed['version'] as int;
    }
    return 1;
  }

  Question? _findDuplicate(Question newQ) {
    for (final existing in db) {
      if (existing.id == newQ.id) return existing;
      if (Question.normText(existing.q) == Question.normText(newQ.q)) {
        final nOpts = newQ.options.map(Question.normText).toList()..sort();
        final oOpts = existing.options.map(Question.normText).toList()..sort();
        if (nOpts.join('|') == oOpts.join('|')) return existing;
      }
    }
    return null;
  }

  bool _matchesSubject(Question q, String targetSub) {
    return q.subject == targetSub ||
        q.subject.contains(targetSub) ||
        normalizeSubjectBase(q.subject) == targetSub;
  }

  bool _matchesChapter(Question q, String targetChap) {
    if (q.chapter == targetChap) return true;
    if (q.chapter.isNotEmpty &&
        (q.chapter.contains(targetChap) || targetChap.contains(q.chapter))) {
      return true;
    }
    return false;
  }

  // ==========================================
  // ACTIONS & NAVIGATION
  // ==========================================
  void _haptic() {
    HapticFeedback.lightImpact();
  }

  void _setLevel(String lvl) {
    _haptic();
    setState(() {
      currentLevel = lvl;
      final chs = getChaptersForPaper(addSubjectVal, addPaperVal, currentLevel);
      if (chs.isNotEmpty && !chs.contains(addChapterVal)) {
        addChapterVal = chs.first;
      }
    });
  }

  void _switchTab(int index) {
    _haptic();
    setState(() {
      activeTab = index;
      if (index == 0) {
        topHeaderOpacity = 1.0;
      }
    });
  }

  void _toggleBookmark(String qId) {
    _haptic();
    setState(() {
      if (bookmarkedIds.contains(qId)) {
        bookmarkedIds.remove(qId);
      } else {
        bookmarkedIds.add(qId);
      }
    });
    _saveUserStats();
  }

  void _recordAnswerResult(String qId, bool isCorrect, {bool countStat = true}) {
    setState(() {
      if (countStat) {
        stAttempted++;
        if (isCorrect) stCorrect++;
      }
      if (!isCorrect) {
        mistakeIds.add(qId);
      } else {
        mistakeIds.remove(qId);
      }
    });
    _saveUserStats();
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
        backgroundColor: AppColors.card,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        margin: const EdgeInsets.only(bottom: 75, left: 40, right: 40),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ==========================================
  // OPEN ARENA (PRACTICE OR EXAM)
  // ==========================================
  void _openArena(List<Question> questions, String mode, String title) {
    _haptic();
    if (questions.isEmpty) {
      _showToast("এই ফিল্টারে কোনো প্রশ্ন নেই। আগে JSON Add করো।");
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ArenaScreen(
          questions: questions,
          mode: mode,
          title: title,
          bookmarkedIds: bookmarkedIds,
          onToggleBookmark: _toggleBookmark,
          onRecordAnswer: _recordAnswerResult,
          onBatchExamSubmit: (int total, int correct, List<String> wrongIds,
              List<String> rightIds) {
            setState(() {
              stAttempted += total;
              stCorrect += correct;
              mistakeIds.addAll(wrongIds);
              for (final rId in rightIds) {
                mistakeIds.remove(rId);
              }
            });
            _saveUserStats();
          },
        ),
      ),
    );
  }

  // ==========================================
  // DRAWERS (BOTTOM SHEETS FOR SUBJECT & BOARD)
  // ==========================================
  void _openSubjectDrawer(String subject) {
    _haptic();
    String drawerPaperVal = "Combined";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final chapters =
                getChaptersForPaper(subject, drawerPaperVal, currentLevel);
            final subQs = db
                .where((q) =>
                    q.level == currentLevel && _matchesSubject(q, subject))
                .toList();

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.82,
              maxChildSize: 0.92,
              minChildSize: 0.5,
              builder: (_, scrollController) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Handle
                      Container(
                        width: 40,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      // Title & Close
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "$subject - ${paperLabel(drawerPaperVal)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.pop(ctx),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 36,
                              height: 36,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.1),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.15)),
                              ),
                              child: const Text("✕",
                                  style: TextStyle(fontSize: 15)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Paper Switcher Tabs (Combined / 1st / 2nd)
                      Row(
                        children: ["Combined", "1st", "2nd"].map((pv) {
                          final isSel = drawerPaperVal == pv;
                          final label = pv == "Combined"
                              ? "📚 Combined"
                              : (pv == "1st" ? "📘 ১ম পত্র" : "📗 ২য় পত্র");
                          return Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: InkWell(
                                onTap: () {
                                  _haptic();
                                  setModalState(() => drawerPaperVal = pv);
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  height: 44,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color:
                                        isSel ? AppColors.primary : AppColors.bg,
                                    borderRadius: BorderRadius.circular(12),
                                    border: isSel
                                        ? null
                                        : Border.all(color: AppColors.border),
                                  ),
                                  child: Text(
                                    label,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      // Scrollable List
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          children: [
                            // Full Subject Card
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "🔥 সম্পূর্ণ $subject",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    "মোট ${subQs.length} টি প্রশ্ন • ${paperLabel(drawerPaperVal)}",
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildActionBtn(
                                          label: "📖 প্র্যাকটিস",
                                          bg: AppColors.primary
                                              .withOpacity(0.15),
                                          fg: AppColors.primaryLight,
                                          border: AppColors.primary
                                              .withOpacity(0.25),
                                          onTap: () {
                                            Navigator.pop(ctx);
                                            _openArena(
                                                subQs, "practice", subject);
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: _buildActionBtn(
                                          label: "⏱️ এক্সাম",
                                          bg: AppColors.amber.withOpacity(0.12),
                                          fg: AppColors.amberLight,
                                          border:
                                              AppColors.amber.withOpacity(0.25),
                                          onTap: () {
                                            Navigator.pop(ctx);
                                            _openArena(subQs, "exam", subject);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Individual Chapters
                            ...chapters.map((ch) {
                              final chapQs = subQs
                                  .where((q) => _matchesChapter(q, ch))
                                  .toList();
                              final cnt = chapQs.length;
                              final hasQ = cnt > 0;
                              return Opacity(
                                opacity: hasQ ? 1.0 : 0.55,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: hasQ
                                        ? AppColors.emerald.withOpacity(0.06)
                                        : AppColors.card,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: hasQ
                                          ? AppColors.emerald.withOpacity(0.4)
                                          : AppColors.border,
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
                                              ch,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15,
                                                height: 1.35,
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              hasQ
                                                  ? "✅ $cnt টি প্রশ্ন"
                                                  : "○ 0 টি প্রশ্ন - এখনো নেই",
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: hasQ
                                                    ? AppColors.emeraldLight
                                                    : AppColors.textMuted,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      _buildIconBtn(
                                        icon: "📖",
                                        bg: AppColors.primary.withOpacity(0.15),
                                        border:
                                            AppColors.primary.withOpacity(0.2),
                                        onTap: () {
                                          Navigator.pop(ctx);
                                          _openArena(chapQs, "practice",
                                              "$subject - $ch");
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                      _buildIconBtn(
                                        icon: "⏱️",
                                        bg: AppColors.amber.withOpacity(0.12),
                                        border:
                                            AppColors.amber.withOpacity(0.2),
                                        onTap: () {
                                          Navigator.pop(ctx);
                                          _openArena(
                                              chapQs, "exam", "$subject - $ch");
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _openBoardDrawer(String tag) {
    _haptic();
    final tagQs =
        db.where((q) => q.tag == tag && q.level == currentLevel).toList();
    final subjects = tagQs.map((q) => q.subject).toSet().toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "🏛️ $tag (${tagQs.length} টি প্রশ্ন)",
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: const Text("✕"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Full Board Paper Practice/Exam
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "🔥 সম্পূর্ণ প্রশ্নপত্র",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    _buildActionBtn(
                      label: "📖 প্র্যাকটিস",
                      bg: AppColors.primary.withOpacity(0.15),
                      fg: AppColors.primaryLight,
                      border: AppColors.primary.withOpacity(0.25),
                      onTap: () {
                        Navigator.pop(ctx);
                        _openArena(tagQs, "practice", tag);
                      },
                    ),
                    const SizedBox(width: 8),
                    _buildActionBtn(
                      label: "⏱️ এক্সাম",
                      bg: AppColors.amber.withOpacity(0.12),
                      fg: AppColors.amberLight,
                      border: AppColors.amber.withOpacity(0.25),
                      onTap: () {
                        Navigator.pop(ctx);
                        _openArena(tagQs, "exam", tag);
                      },
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: subjects.length,
                  itemBuilder: (_, i) {
                    final sub = subjects[i];
                    final subPool =
                        tagQs.where((q) => q.subject == sub).toList();
                    return Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sub,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  "${subPool.length} টি প্রশ্ন",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildActionBtn(
                            label: "📖 প্র্যাকটিস",
                            bg: AppColors.primary.withOpacity(0.15),
                            fg: AppColors.primaryLight,
                            border: AppColors.primary.withOpacity(0.2),
                            onTap: () {
                              Navigator.pop(ctx);
                              _openArena(subPool, "practice", "$tag - $sub");
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================
  // JSON IMPORT / EXPORT / MANUAL ADD
  // ==========================================
  Future<void> _pickAndImportJsonFiles() async {
    _haptic();
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: true,
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;

      setState(() {
        importMsg = "⏳ ${result.files.length} টি ফাইল প্রসেস হচ্ছে...";
        fileImportLogs = ["📂 ${result.files.length} টি ফাইল পাওয়া গেছে..."];
      });

      int totalAdded = 0;
      int totalSkipped = 0;

      for (final file in result.files) {
        try {
          String content = "";
          if (file.bytes != null) {
            content = utf8.decode(file.bytes!);
          } else if (file.path != null && !kIsWeb) {
            content = await File(file.path!).readAsString();
          }
          final rawParsed = jsonDecode(content);
          final ver = _detectVersion(rawParsed);
          final list = _extractQuestionsList(rawParsed);
          int addedInFile = 0;

          for (final item in list) {
            final nq = Question.normalizeQ(item);
            if (nq == null) continue;
            if (_findDuplicate(nq) != null) {
              totalSkipped++;
              continue;
            }
            db.add(nq);
            addedInFile++;
            totalAdded++;
          }
          fileImportLogs
              .add("✅ ${file.name} (V$ver): $addedInFile টি যোগ হয়েছে");
        } catch (err) {
          fileImportLogs.add("❌ ${file.name}: ফরম্যাট এরর");
          totalSkipped++;
        }
      }

      if (totalAdded > 0) {
        await _saveDB();
        importMsg =
            "✅ $totalAdded টি প্রশ্ন যোগ হয়েছে! মোট: ${db.length} টি (Save হয়ে গেছে)";
      } else if (totalSkipped > 0) {
        importMsg = "ℹ️ $totalSkipped টি আগে থেকেই আছে, নতুন নেই।";
      } else {
        importMsg = "❌ কোনো প্রশ্ন যোগ হয়নি। ফাইল চেক করো।";
      }
      setState(() {});
    } catch (e) {
      setState(() {
        importMsg = "❌ ফাইল ইমপোর্ট করা যায়নি: $e";
      });
    }
  }

  void _openPasteJsonDialog() {
    _haptic();
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text("📋 JSON কোড পেস্ট করো",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        content: TextField(
          controller: ctrl,
          maxLines: 8,
          style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
          decoration: InputDecoration(
            hintText: '[{"q": "...", "options": ["a","b","c","d"], "ans": 0}]',
            filled: true,
            fillColor: AppColors.bg,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("বাতিল"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              try {
                final rawParsed = jsonDecode(ctrl.text.trim());
                final list = _extractQuestionsList(rawParsed);
                int added = 0;
                int skipped = 0;
                for (final item in list) {
                  final nq = Question.normalizeQ(item);
                  if (nq == null) continue;
                  if (_findDuplicate(nq) != null) {
                    skipped++;
                    continue;
                  }
                  db.add(nq);
                  added++;
                }
                if (added > 0) await _saveDB();
                if (mounted) {
                  Navigator.pop(ctx);
                  setState(() {
                    importMsg =
                        "✅ পেস্ট থেকে $added টি যোগ হয়েছে ($skipped টি ডুপ্লিকেট স্কিপড)";
                  });
                }
              } catch (e) {
                _showToast("❌ সঠিক JSON ফরম্যাট নয়!");
              }
            },
            child:
                const Text("ইমপোর্ট করো", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _loadDemoStarterPack() async {
    _haptic();
    final demoRaw = [
      {
        "level": "Admission",
        "subject": "পদার্থবিজ্ঞান",
        "chapter": "ভেক্টর",
        "paper": "1st",
        "tag": "DU 2023-24",
        "q": "দুটি সমমানের ভেক্টরের মধ্যবর্তী কোণ কত হলে তাদের লব্ধির মান যেকোনো একটি ভেক্টরের মানের সমান হবে?",
        "options": ["60°", "90°", "120°", "180°"],
        "ans": 2,
        "exp": "R = P হলে 2P cos(α/2) = P ⇒ cos(α/2) = 1/2 ⇒ α = 120°।"
      },
      {
        "level": "Admission",
        "subject": "রসায়ন",
        "chapter": "গুণগত রসায়ন",
        "paper": "1st",
        "tag": "BUET 2022-23",
        "q": "নিচের কোন অরবিটালটি অসম্ভব?",
        "options": ["3d", "2p", "2d", "4f"],
        "ans": 2,
        "exp": "n = 2 হলে l এর মান 0 এবং 1 হতে পারে, তাই 2d অরবিটাল অসম্ভব।"
      },
      {
        "level": "Admission",
        "subject": "উচ্চতর গণিত",
        "chapter": "অন্তরীকরণ",
        "paper": "1st",
        "tag": "RU 2023-24",
        "q": "lim(x→0) (sin x / x) এর মান কত?",
        "options": ["0", "1", "∞", "-1"],
        "ans": 1,
        "exp": "ক্যালকুলাসের মৌলিক সীমা সূত্র অনুযায়ী lim(x→0) (sin x / x) = 1।"
      },
      {
        "level": "Admission",
        "subject": "জীববিজ্ঞান",
        "chapter": "কোষ ও এর গঠন",
        "paper": "1st",
        "tag": "MAT 2023-24",
        "q": "কোষের পাওয়ার হাউস (Powerhouse of Cell) বলা হয় কোনটিকে?",
        "options": ["রাইবোসোম", "নিউক্লিয়াস", "মাইটোকন্ড্রিয়া", "প্লাস্টিড"],
        "ans": 2,
        "exp": "মাইটোকন্ড্রিয়ায় ক্রেবস চক্র ও ইটিএস এর মাধ্যমে ATP উৎপন্ন হয়।"
      },
      {
        "level": "HSC",
        "subject": "পদার্থবিজ্ঞান",
        "chapter": "গতিবিদ্যা",
        "paper": "1st",
        "tag": "Dhaka Board 2023",
        "q": "প্রাসের গতিপথের সর্বোচ্চ বিন্দুতে বেগ ও ত্বরণের মধ্যবর্তী কোণ কত?",
        "options": ["0°", "45°", "90°", "180°"],
        "ans": 2,
        "exp": "সর্বোচ্চ বিন্দুতে বেগ অনুভূমিক (vx) এবং অভিকর্ষজ ত্বরণ g খাড়া নিচের দিকে ক্রিয়া করে, তাই কোণ 90°।"
      }
    ];

    int added = 0;
    for (final item in demoRaw) {
      final nq = Question.normalizeQ(item);
      if (nq != null && _findDuplicate(nq) == null) {
        db.add(nq);
        added++;
      }
    }
    await _saveDB();
    setState(() {
      importMsg =
          added > 0 ? "✅ $added টি ডেমো প্রশ্ন যোগ হয়েছে!" : "ℹ️ ডেমো প্রশ্নগুলো আগে থেকেই আছে।";
    });
  }

  void _exportAllJson() async {
    _haptic();
    if (db.isEmpty) {
      _showToast("কোনো প্রশ্ন নেই!");
      return;
    }
    final v2Payload = {
      "app": "EdVance",
      "version": 2,
      "exportedAt": DateTime.now().toIso8601String(),
      "count": db.length,
      "questions": db.map((q) => q.toJson()).toList(),
    };
    final jsonString = const JsonEncoder.withIndent('  ').convert(v2Payload);
    await Clipboard.setData(ClipboardData(text: jsonString));
    _showToast("✅ V2 JSON (${db.length} টি প্রশ্ন) ক্লিপবোর্ডে কপি হয়েছে!");
  }

  void _clearAllQuestions() {
    _haptic();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text("সব প্রশ্ন Clear করতে চাও?"),
        content: const Text(
          "এটি ডাটাবেসের সব প্রশ্ন মুছে ফেলবে।",
          style: TextStyle(color: AppColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("না"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.rose),
            onPressed: () async {
              Navigator.pop(ctx);
              setState(() {
                db.clear();
                importMsg = null;
                fileImportLogs.clear();
              });
              await _saveDB();
              _showToast("✅ সব Clear হয়ে গেছে!");
            },
            child: const Text("হ্যাঁ, মুছে ফেলো",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _handleAddQuestion() async {
    _haptic();
    final qText = _addQCtrl.text.trim();
    final o0 = _addOpt0Ctrl.text.trim();
    final o1 = _addOpt1Ctrl.text.trim();
    final o2 = _addOpt2Ctrl.text.trim();
    final o3 = _addOpt3Ctrl.text.trim();
    final tag =
        _addTagCtrl.text.trim().isEmpty ? "Custom" : _addTagCtrl.text.trim();

    if (qText.isEmpty ||
        o0.isEmpty ||
        o1.isEmpty ||
        o2.isEmpty ||
        o3.isEmpty) {
      setState(() {
        addStatusColor = AppColors.rose;
        addStatusMsg = "❌ সব ঘর পূরণ করো!";
      });
      return;
    }

    final nq = Question.normalizeQ({
      "level": currentLevel,
      "subject": addSubjectVal,
      "chapter": addChapterVal,
      "paper": addPaperVal,
      "tag": tag,
      "q": qText,
      "options": [o0, o1, o2, o3],
      "ans": addAnsVal,
      "exp": _addExpCtrl.text.trim(),
      "difficulty": "medium",
    });

    if (nq == null) return;
    final dup = _findDuplicate(nq);
    if (dup != null) {
      setState(() {
        addStatusColor = AppColors.amber;
        addStatusMsg =
            "⚠️ এই প্রশ্ন + অপশন আগে থেকেই আছে! (${dup.subject} • ${dup.chapter})";
      });
      return;
    }

    setState(() {
      db.add(nq);
      addStatusColor = AppColors.emerald;
      addStatusMsg =
          "✅ যোগ হয়েছে! $addSubjectVal • $addChapterVal • মোট ${db.length} টি";
      _addQCtrl.clear();
      _addOpt0Ctrl.clear();
      _addOpt1Ctrl.clear();
      _addOpt2Ctrl.clear();
      _addOpt3Ctrl.clear();
      _addExpCtrl.clear();
    });
    await _saveDB();
  }

  // ==========================================
  // CUSTOM EXAM POOL FILTER
  // ==========================================
  List<Question> _getCustomExamPool() {
    final pool = <Question>[];
    for (final qq in db) {
      if (qq.level != mtLevelVal) continue;
      if (mtSubjectVal != "ALL" && !_matchesSubject(qq, mtSubjectVal)) continue;
      if (mtPaperVal != "Combined") {
        final validChaps = getChaptersForPaper(
            qq.subject, mtPaperVal, mtLevelVal);
        final matchesPaper = qq.paper == mtPaperVal ||
            validChaps.any((c) => _matchesChapter(qq, c));
        if (!matchesPaper) continue;
      }
      if (mtChapterVal != "ALL") {
        final chapOnly = mtChapterVal.split(" | ").last;
        if (!_matchesChapter(qq, chapOnly)) continue;
      }
      pool.add(qq);
    }
    return pool;
  }

  void _startCustomExam() {
    _haptic();
    final pool = _getCustomExamPool();
    if (pool.isEmpty) {
      _showToast(
          "এই ফিল্টারে কোনো প্রশ্ন নেই। আগে JSON Add করো।\n$mtLevelVal • $mtSubjectVal");
      return;
    }
    final shuffled = List<Question>.from(pool)..shuffle(Random());
    final finalPool = shuffled.take(mtCountVal).toList();
    final subTitle = mtSubjectVal == "ALL" ? "সব বিষয়" : mtSubjectVal;
    _openArena(finalPool, "exam", "কাস্টম টেস্ট - $mtLevelVal • $subTitle");
  }

  // ==========================================
  // BUILD UI
  // ==========================================
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        // If not on Home tab -> go back to Home tab
        if (activeTab != 0) {
          _switchTab(0);
          return;
        }
        // Double back to exit on Home tab
        final now = DateTime.now();
        if (_lastBackPressTime == null ||
            now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
          _lastBackPressTime = now;
          _showToast("আবার Back চাপলে অ্যাপ বন্ধ হবে");
          return;
        }
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Sticky Top Header (Visible on Home tab with scroll fade)
              if (activeTab == 0 && topHeaderOpacity > 0.01)
                Opacity(
                  opacity: topHeaderOpacity,
                  child: Container(
                    color: AppColors.card,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "EdVance Mega QB",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              db.isEmpty
                                  ? "মোট 0 টি প্রশ্ন - JSON থেকে Add করো"
                                  : "মোট ${db.length} টি প্রশ্ন",
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.emeraldLight,
                              ),
                            ),
                          ],
                        ),
                        _buildActionBtn(
                          label: "📁 JSON",
                          bg: AppColors.primary.withOpacity(0.15),
                          fg: AppColors.primaryLight,
                          border: AppColors.primary.withOpacity(0.25),
                          onTap: () => _switchTab(3),
                        ),
                      ],
                    ),
                  ),
                ),

              // Main Content Area
              Expanded(
                child: IndexedStack(
                  index: activeTab,
                  children: [
                    _buildHomeScreen(),
                    _buildQuestionBankScreen(),
                    _buildCustomExamScreen(),
                    _buildJsonHubScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  // ==========================================
  // SCREEN 0: HOME DASHBOARD
  // ==========================================
  Widget _buildHomeScreen() {
    final levelQuestionCount =
        db.where((q) => q.level == currentLevel).length;
    final subs = kSyllabus[currentLevel] ?? kSyllabus["Admission"]!;
    final subjectKeys = subs.keys.toList();

    final tags = db
        .where((q) => q.level == currentLevel)
        .map((q) => q.tag)
        .toSet()
        .toList();

    final searchMatches = searchQuery.length < 2
        ? <Question>[]
        : db
            .where((q) =>
                q.q.toLowerCase().contains(searchQuery) ||
                q.chapter.toLowerCase().contains(searchQuery) ||
                q.tag.toLowerCase().contains(searchQuery))
            .toList();

    final accPercent =
        stAttempted > 0 ? ((stCorrect / stAttempted) * 100).round() : 0;

    return ListView(
      controller: _homeScrollController,
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        // Level Switcher (Admission / HSC)
        Container(
          margin: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildLevelSwitchBtn(
                    "Admission", "🎯 Admission", currentLevel == "Admission"),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildLevelSwitchBtn(
                    "HSC", "📚 HSC বোর্ড", currentLevel == "HSC"),
              ),
            ],
          ),
        ),

        // Hero Stats Card
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentLevel == "HSC"
                              ? "টার্গেট: এইচএসসি সকল বোর্ড প্রশ্নব্যাংক"
                              : "টার্গেট: ভার্সিটি ও ইঞ্জিনিয়ারিং অ্যাডমিশন",
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Admission + HSC - 4 টি মূল বিষয়",
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.emerald.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "$levelQuestionCount টি প্রশ্ন",
                      style: const TextStyle(
                        color: AppColors.emeraldLight,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildHeroStatBox("$stAttempted", "সমাধান", null),
                  const SizedBox(width: 8),
                  _buildHeroStatBox("$accPercent%", "সঠিকতা", null),
                  const SizedBox(width: 8),
                  _buildHeroStatBox(
                    "${mistakeIds.length}",
                    "ভুল ব্যাংক ▸",
                    () {
                      final wrongQs = db
                          .where((q) => mistakeIds.contains(q.id))
                          .toList();
                      if (wrongQs.isEmpty) {
                        _showToast("ভুল ব্যাংকে এখনো কোনো প্রশ্ন নেই!");
                        return;
                      }
                      _openArena(wrongQs, "practice", "❌ ভুল ব্যাংক রিভিউ");
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildHeroStatBox(
                    "${bookmarkedIds.length}",
                    "বুকমার্ক ▸",
                    () {
                      final savedQs = db
                          .where((q) => bookmarkedIds.contains(q.id))
                          .toList();
                      if (savedQs.isEmpty) {
                        _showToast("বুকমার্কে এখনো কোনো প্রশ্ন নেই!");
                        return;
                      }
                      _openArena(savedQs, "practice", "🔖 বুকমার্ক প্রশ্ন");
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        // Search Input
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: TextField(
            controller: _searchController,
            onChanged: (val) {
              setState(() {
                searchQuery = val.trim().toLowerCase();
              });
            },
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: "🔍 যেকোনো প্রশ্ন, অধ্যায় লিখে সার্চ করো...",
              hintStyle:
                  const TextStyle(color: AppColors.textMuted, fontSize: 13),
              filled: true,
              fillColor: AppColors.bg,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => searchQuery = "");
                      },
                    )
                  : null,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ),

        // Search Results Banner
        if (searchQuery.length >= 2)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: InkWell(
              onTap: () => _openArena(
                  searchMatches, "practice", "সার্চ: ${_searchController.text}"),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "🔍 '${_searchController.text}' - ${searchMatches.length} টি পাওয়া গেছে",
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                    ),
                    const Text(
                      "প্র্যাকটিস করো →",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Section Header: Subjects
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "📖 বিষয় ও অধ্যায়ভিত্তিক প্রশ্নব্যাংক",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              GestureDetector(
                onTap: () => _switchTab(2),
                child: const Text(
                  "কাস্টম এক্সাম →",
                  style: TextStyle(fontSize: 11, color: AppColors.indigoSoft),
                ),
              ),
            ],
          ),
        ),

        // Subject Cards
        ...subjectKeys.map((sub) {
          final chapters = subs[sub] ?? [];
          final count = db
              .where((q) => q.level == currentLevel && _matchesSubject(q, sub))
              .length;
          final hasQ = count > 0;
          String icon = "🧬";
          if (sub.contains("পদার্থ")) {
            icon = "⚛️";
          } else if (sub.contains("রসা")) {
            icon = "🧪";
          } else if (sub.contains("গণিত")) {
            icon = "📐";
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Opacity(
              opacity: hasQ ? 1.0 : 0.6,
              child: InkWell(
                onTap: () => _openSubjectDrawer(sub),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: hasQ
                        ? LinearGradient(
                            colors: [
                              AppColors.emerald.withOpacity(0.14),
                              AppColors.card,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: hasQ ? null : AppColors.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: hasQ
                          ? AppColors.emerald.withOpacity(0.55)
                          : Colors.white.withOpacity(0.14),
                    ),
                    boxShadow: hasQ
                        ? [
                            BoxShadow(
                              color: AppColors.emerald.withOpacity(0.18),
                              blurRadius: 14,
                            )
                          ]
                        : null,
                  ),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: hasQ
                                  ? AppColors.emerald.withOpacity(0.22)
                                  : AppColors.primary.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(icon,
                                style: const TextStyle(fontSize: 22)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sub,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "${chapters.length} টি অধ্যায় • ${hasQ ? '✅ $count টি প্রশ্ন আছে' : '○ এখনো প্রশ্ন নেই'}",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: hasQ
                                ? AppColors.emerald.withOpacity(0.18)
                                : AppColors.textMuted.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: hasQ
                                ? Border.all(
                                    color: AppColors.emerald.withOpacity(0.3))
                                : null,
                          ),
                          child: Text(
                            hasQ ? "✅ $count টি" : "○ 0 টি",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: hasQ
                                  ? AppColors.emeraldLight
                                  : AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),

        // Section Header: Past Papers
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "🏛️ বিগত সালের আসল প্রশ্নব্যাংক",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              GestureDetector(
                onTap: () => _switchTab(1),
                child: const Text(
                  "সব সাল দেখো →",
                  style: TextStyle(fontSize: 11, color: AppColors.indigoSoft),
                ),
              ),
            ],
          ),
        ),

        if (tags.isEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: const Text(
              "এখনো কোনো বোর্ড প্রশ্ন নেই। JSON ট্যাবে গিয়ে Add করো অথবা ডেমো প্রশ্ন লোড করো।",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
          )
        else
          ...tags.take(6).map((tag) {
            final c = db
                .where((q) => q.tag == tag && q.level == currentLevel)
                .length;
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: InkWell(
                onTap: () => _openBoardDrawer(tag),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "🏛️ $tag",
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "$c টি প্রশ্ন",
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      _buildActionBtn(
                        label: "📚 খোলো",
                        bg: AppColors.primary.withOpacity(0.15),
                        fg: AppColors.primaryLight,
                        border: AppColors.primary.withOpacity(0.2),
                        onTap: () => _openBoardDrawer(tag),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }

  // ==========================================
  // SCREEN 1: QUESTION BANK (QB)
  // ==========================================
  Widget _buildQuestionBankScreen() {
    final tags = db
        .where((q) => q.level == currentLevel)
        .map((q) => q.tag)
        .toSet()
        .toList();

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Text(
            "🏛️ ভার্সিটি ও বোর্ড প্রশ্নব্যাংক",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
        ),
        if (tags.isEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: const Text(
              "কোনো প্রশ্ন নেই। JSON ট্যাব থেকে Add করো।",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted),
            ),
          )
        else
          ...tags.map((tag) {
            final qs = db
                .where((q) => q.tag == tag && q.level == currentLevel)
                .toList();
            final subs = qs.map((q) => q.subject).toSet().join(", ");
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: InkWell(
                onTap: () => _openBoardDrawer(tag),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "📜 $tag",
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              "${qs.length} টি প্রশ্ন • $subs",
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildActionBtn(
                        label: "📚 খোলো",
                        bg: AppColors.primary.withOpacity(0.15),
                        fg: AppColors.primaryLight,
                        border: AppColors.primary.withOpacity(0.2),
                        onTap: () => _openBoardDrawer(tag),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }

  // ==========================================
  // SCREEN 2: CUSTOM EXAM BUILDER
  // ==========================================
  Widget _buildCustomExamScreen() {
    final subs = kSyllabus[mtLevelVal] ?? kSyllabus["Admission"]!;
    
    // ============================================
    // FIX 1: TYPE ADDED HERE -> List>
    // ============================================
    final List> chapterItems = [
      {"key": "ALL", "display": "📑 সব অধ্যায়"}
    ];
    
    if (mtSubjectVal == "ALL") {
      for (final sName in subs.keys) {
        final chs = getChaptersForPaper(sName, mtPaperVal, mtLevelVal);
        for (final c in chs) {
          chapterItems.add({
            "key": "$sName | $c",
            "display": "$sName (${paperLabel(mtPaperVal)}) | $c"
          });
        }
      }
    } else {
      final chs = getChaptersForPaper(mtSubjectVal, mtPaperVal, mtLevelVal);
      for (final c in chs) {
        chapterItems.add({"key": c, "display": c});
      }
    }

    final availablePool = _getCustomExamPool();
    final subLabel = mtSubjectVal == "ALL" ? "সব বিষয়" : mtSubjectVal;
    final chapLabel = mtChapterVal == "ALL" ? "সব অধ্যায়" : mtChapterVal;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "⚡ কাস্টম মডেল টেস্ট বানাও",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              const SizedBox(height: 4),
              const Text(
                "Level → Subject → Chapter → Count বেছে টেস্ট দাও",
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
              const SizedBox(height: 14),

              // Level Selector
              const Text(
                "🎯 কোন লেভেলের টেস্ট?",
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _haptic();
                        setState(() {
                          mtLevelVal = "Admission";
                          mtChapterVal = "ALL";
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: mtLevelVal == "Admission"
                              ? AppColors.primary
                              : AppColors.bg,
                          borderRadius: BorderRadius.circular(12),
                          border: mtLevelVal == "Admission"
                              ? null
                              : Border.all(color: AppColors.border),
                        ),
                        child: const Text("🎯 Admission",
                            style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _haptic();
                        setState(() {
                          mtLevelVal = "HSC";
                          mtChapterVal = "ALL";
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: mtLevelVal == "HSC"
                              ? AppColors.primary
                              : AppColors.bg,
                          borderRadius: BorderRadius.circular(12),
                          border: mtLevelVal == "HSC"
                              ? null
                              : Border.all(color: AppColors.border),
                        ),
                        child: const Text("📚 HSC বোর্ড",
                            style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Paper Selector
              const Text(
                "📄 পত্র - ১ম / ২য় / Combined",
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
              const SizedBox(height: 6),
              _buildModalDropdownButton(
                label: mtPaperVal == "Combined"
                    ? "📚 Combined (সব)"
                    : paperLabel(mtPaperVal),
                onTap: () => _showPickerModal(
                  title: "পত্র বাছো",
                  items: const [
                    {"key": "Combined", "display": "📚 Combined (সব)"},
                    {"key": "1st", "display": "📘 ১ম পত্র"},
                    {"key": "2nd", "display": "📗 ২য় পত্র"},
                  ],
                  selectedKey: mtPaperVal,
                  onSelect: (val) {
                    setState(() {
                      mtPaperVal = val;
                      mtChapterVal = "ALL";
                    });
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Subject Selector
              const Text(
                "📖 বিষয়",
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
              const SizedBox(height: 6),
              _buildModalDropdownButton(
                label: mtSubjectVal == "ALL" ? "📚 সব বিষয়" : mtSubjectVal,
                onTap: () => _showPickerModal(
                  title: "বিষয় বাছো",
                  items: const [
                    {"key": "ALL", "display": "📚 সব বিষয়"},
                    {"key": "পদার্থবিজ্ঞান", "display": "⚛️ পদার্থবিজ্ঞান"},
                    {"key": "রসায়ন", "display": "🧪 রসায়ন"},
                    {"key": "উচ্চতর গণিত", "display": "📐 উচ্চতর গণিত"},
                    {"key": "জীববিজ্ঞান", "display": "🧬 জীববিজ্ঞান"},
                  ],
                  selectedKey: mtSubjectVal,
                  onSelect: (val) {
                    setState(() {
                      mtSubjectVal = val;
                      mtChapterVal = "ALL";
                    });
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Chapter Selector
              Text(
                "📑 অধ্যায় (${chapterItems.length - 1} টি)",
                style:
                    const TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
              const SizedBox(height: 6),
              _buildModalDropdownButton(
                label: mtChapterVal == "ALL" ? "📑 সব অধ্যায়" : mtChapterVal,
                onTap: () => _showPickerModal(
                  title: "অধ্যায় বাছো",
                  items: chapterItems,
                  selectedKey: mtChapterVal,
                  onSelect: (val) {
                    setState(() => mtChapterVal = val);
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Question Count Pills
              const Text(
                "🔢 কয়টা প্রশ্ন?",
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [10, 20, 25, 30, 50, 100].map((cnt) {
                  final active = mtCountVal == cnt;
                  return InkWell(
                    onTap: () {
                      _haptic();
                      setState(() => mtCountVal = cnt);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: active ? AppColors.primary : AppColors.bg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              active ? AppColors.primary : AppColors.border,
                        ),
                      ),
                      child: Text(
                        "$cnt টি",
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              // Live Preview Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "📊 $mtLevelVal • ${paperLabel(mtPaperVal)} • $subLabel • $chapLabel • $mtCountVal টি প্রশ্ন • Available: ${availablePool.length} টি",
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primaryLight,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Start Custom Exam Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _startCustomExam,
                  child: const Text(
                    "🚀 টেস্ট শুরু করো",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // SCREEN 3: JSON HUB & MANUAL ADD
  // ==========================================
  Widget _buildJsonHubScreen() {
    final addChapters =
        getChaptersForPaper(addSubjectVal, addPaperVal, currentLevel);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        // Card 1: JSON File Import / Export
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "📂 JSON ফাইল Add করো",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "1. নিচের বাটনে ক্লিক করে JSON সিলেক্ট করো\n2. একসাথে অনেক ফাইল দিতে পারো\n3. নাম ম্যাটার করে না (V1 ও V2 উভয় সাপোর্টেড)",
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryLight,
                      height: 1.4),
                ),
              ),
              const SizedBox(height: 12),

              // Select Multiple JSON Files
              InkWell(
                onTap: _pickAndImportJsonFiles,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.bg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        "📂 সব JSON ফাইল সিলেক্ট করো",
                        style: TextStyle(
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "একসাথে অনেকগুলো .json ফাইল ইমপোর্ট করো",
                        style:
                            TextStyle(fontSize: 10, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Paste JSON or Load Demo Pack Row
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _openPasteJsonDialog,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.bg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.emerald),
                        ),
                        child: const Column(
                          children: [
                            Text(
                              "📋 JSON পেস্ট",
                              style: TextStyle(
                                color: AppColors.emerald,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              "সরাসরি টেক্সট পেস্ট",
                              style: TextStyle(
                                  fontSize: 10, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      onTap: _loadDemoStarterPack,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.bg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.amber),
                        ),
                        child: const Column(
                          children: [
                            Text(
                              "⚡ ডেমো প্রশ্ন লোড",
                              style: TextStyle(
                                color: AppColors.amberLight,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              "১-ক্লিকে স্যাম্পল টেস্ট",
                              style: TextStyle(
                                  fontSize: 10, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              if (importMsg != null) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.emerald.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(importMsg!, style: const TextStyle(fontSize: 12)),
                ),
              ],

              if (fileImportLogs.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  fileImportLogs.join("\n"),
                  style:
                      const TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ],

              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildActionBtn(
                      label: "⬇️ Export (Copy V2)",
                      bg: AppColors.primary.withOpacity(0.15),
                      fg: AppColors.primaryLight,
                      border: AppColors.primary.withOpacity(0.25),
                      onTap: _exportAllJson,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildActionBtn(
                      label: "🗑️ Clear",
                      bg: AppColors.rose.withOpacity(0.12),
                      fg: AppColors.rose,
                      border: AppColors.rose.withOpacity(0.25),
                      onTap: _clearAllQuestions,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Card 2: Manual Question Add
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "➕ ম্যানুয়াল প্রশ্ন Add",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              const SizedBox(height: 10),

              const Text(
                "📖 বিষয় - লিস্ট থেকে বাছো, লিখতে হবে না",
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
              const SizedBox(height: 6),
              _buildModalDropdownButton(
                label: addSubjectVal,
                onTap: () => _showPickerModal(
                  title: "বিষয় বাছো",
                  items: const [
                    {"key": "পদার্থবিজ্ঞান", "display": "⚛️ পদার্থবিজ্ঞান"},
                    {"key": "রসায়ন", "display": "🧪 রসায়ন"},
                    {"key": "উচ্চতর গণিত", "display": "📐 উচ্চতর গণিত"},
                    {"key": "জীববিজ্ঞান", "display": "🧬 জীববিজ্ঞান"},
                  ],
                  selectedKey: addSubjectVal,
                  onSelect: (val) {
                    setState(() {
                      addSubjectVal = val;
                      final chs = getChaptersForPaper(
                          addSubjectVal, addPaperVal, currentLevel);
                      if (chs.isNotEmpty) addChapterVal = chs.first;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                "📄 পত্র",
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
              const SizedBox(height: 6),
              _buildModalDropdownButton(
                label: addPaperVal == "Combined"
                    ? "Combined (সব)"
                    : paperLabel(addPaperVal),
                onTap: () => _showPickerModal(
                  title: "পত্র বাছো",
                  items: const [
                    {"key": "Combined", "display": "📚 Combined (সব)"},
                    {"key": "1st", "display": "📘 ১ম পত্র"},
                    {"key": "2nd", "display": "📗 ২য় পত্র"},
                  ],
                  selectedKey: addPaperVal,
                  onSelect: (val) {
                    setState(() {
                      addPaperVal = val;
                      final chs = getChaptersForPaper(
                          addSubjectVal, addPaperVal, currentLevel);
                      if (chs.isNotEmpty) addChapterVal = chs.first;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),

              Text(
                "📑 অধ্যায় (${addChapters.length} টি)",
                style:
                    const TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
              const SizedBox(height: 6),
              _buildModalDropdownButton(
                label: addChapterVal,
                onTap: () => _showPickerModal(
                  title: "অধ্যায় বাছো",
                  items: addChapters
                      .map((c) => {"key": c, "display": c})
                      .toList(),
                  selectedKey: addChapterVal,
                  onSelect: (val) {
                    setState(() => addChapterVal = val);
                  },
                ),
              ),
              const SizedBox(height: 10),

              _buildInputField(_addTagCtrl, "Tag: DU 2023-24"),
              _buildInputField(_addQCtrl, "প্রশ্ন লিখো..."),
              _buildInputField(_addOpt0Ctrl, "অপশন ক"),
              _buildInputField(_addOpt1Ctrl, "অপশন খ"),
              _buildInputField(_addOpt2Ctrl, "অপশন গ"),
              _buildInputField(_addOpt3Ctrl, "অপশন ঘ"),

              // Correct Option Selector (ক, খ, গ, ঘ)
              Row(
                children: List.generate(4, (idx) {
                  final labels = ["ক", "খ", "গ", "ঘ"];
                  final isSel = addAnsVal == idx;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: idx < 3 ? 8 : 0),
                      child: InkWell(
                        onTap: () {
                          _haptic();
                          setState(() => addAnsVal = idx);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSel ? AppColors.primary : AppColors.bg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  isSel ? AppColors.primary : AppColors.border,
                            ),
                          ),
                          child: Text(
                            labels[idx],
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 10),

              _buildInputField(_addExpCtrl, "ব্যাখ্যা..."),

              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _handleAddQuestion,
                  child: const Text(
                    "➕ প্রশ্ন যোগ করো",
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),

              if (addStatusMsg != null) ...[
                const SizedBox(height: 8),
                Text(
                  addStatusMsg!,
                  style: TextStyle(fontSize: 12, color: addStatusColor),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // REUSABLE UI WIDGETS
  // ==========================================
  Widget _buildLevelSwitchBtn(String lvl, String text, bool isActive) {
    return InkWell(
      onTap: () => _setLevel(lvl),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: isActive ? Colors.white : AppColors.textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildHeroStatBox(String val, String label, VoidCallback? onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                val,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: onTap != null
                      ? AppColors.primaryLight
                      : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionBtn({
    required String label,
    required Color bg,
    required Color fg,
    required Color border,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        constraints: const BoxConstraints(minHeight: 44),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: fg,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildIconBtn({
    required String icon,
    required Color bg,
    required Color border,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: Text(icon, style: const TextStyle(fontSize: 17)),
      ),
    );
  }

  Widget _buildModalDropdownButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        _haptic();
        onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13),
              ),
            ),
            const Text("▼", style: TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }

  // ============================================
  // FIX 2: TYPE ADDED HERE -> List>
  // ============================================
  void _showPickerModal({
    required String title,
    required List> items,
    required String selectedKey,
    required ValueChanged<String> onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 15),
                ),
              ),
              const Divider(height: 1, color: AppColors.border),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final it = items[i];
                    final isSel = it['key'] == selectedKey;
                    return ListTile(
                      dense: true,
                      selected: isSel,
                      selectedTileColor: AppColors.primary.withOpacity(0.18),
                      title: Text(
                        it['display']!,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              isSel ? FontWeight.w700 : FontWeight.normal,
                          color: isSel ? AppColors.primaryLight : Colors.white,
                        ),
                      ),
                      onTap: () {
                        _haptic();
                        Navigator.pop(ctx);
                        onSelect(it['key']!);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputField(TextEditingController ctrl, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: ctrl,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              const TextStyle(color: AppColors.textMuted, fontSize: 13),
          filled: true,
          fillColor: AppColors.bg,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {"icon": "🏠", "label": "ড্যাশ"},
      {"icon": "🏛️", "label": "ব্যাংক"},
      {"icon": "⚡", "label": "টেস্ট"},
      {"icon": "📂", "label": "JSON"},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg,
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: List.generate(items.length, (i) {
          final active = activeTab == i;
          return Expanded(
            child: InkWell(
              onTap: () => _switchTab(i),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(items[i]["icon"]!,
                        style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 2),
                    Text(
                      items[i]["label"]!,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight:
                            active ? FontWeight.w700 : FontWeight.normal,
                        color: active
                            ? AppColors.primaryLight
                            : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ==========================================
// ARENA SCREEN (PRACTICE, EXAM & RESULT REVIEW)
// ==========================================
class ArenaScreen extends StatefulWidget {
  final List<Question> questions;
  final String mode; // "practice" or "exam"
  final String title;
  final Set<String> bookmarkedIds;
  final ValueChanged<String> onToggleBookmark;
  final void Function(String qId, bool isCorrect, {bool countStat})
      onRecordAnswer;
  final void Function(int total, int correct, List<String> wrongIds,
      List<String> rightIds) onBatchExamSubmit;

  const ArenaScreen({
    super.key,
    required this.questions,
    required this.mode,
    required this.title,
    required this.bookmarkedIds,
    required this.onToggleBookmark,
    required this.onRecordAnswer,
    required this.onBatchExamSubmit,
  });

  @override
  State<ArenaScreen> createState() => _ArenaScreenState();
}

class _ArenaScreenState extends State<ArenaScreen> {
  late List<Question> sessionQuestions;
  Map<int, int> answers = {};
  bool isSubmitted = false;
  String reviewFilter = "ALL"; // ALL, WRONG, CORRECT, SKIPPED

  // Live Exam Timer
  Timer? _examTimer;
  int remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    sessionQuestions = List<Question>.from(widget.questions);
    if (widget.mode == "exam") {
      remainingSeconds = sessionQuestions.length * 60; // 1 min per question
      _startTimer();
    }
  }

  @override
  void dispose() {
    _examTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _examTimer?.cancel();
    _examTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || isSubmitted) {
        timer.cancel();
        return;
      }
      if (remainingSeconds <= 1) {
        timer.cancel();
        _submitExam();
      } else {
        setState(() => remainingSeconds--);
      }
    });
  }

  String _formatTimer(int secs) {
    final m = (secs ~/ 60).toString().padLeft(2, '0');
    final s = (secs % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  Future<bool> _confirmExitIfNeeded() async {
    if (isSubmitted || answers.isEmpty) return true;
    final modeTxt = widget.mode == "exam" ? "এক্সাম" : "প্র্যাকটিস";
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text("$modeTxt শেষ না করে বের হবে?"),
        content: const Text(
          "তোমার চলমান উত্তরগুলো সেভ হবে না।",
          style: TextStyle(color: AppColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("থাকবো"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.rose),
            onPressed: () => Navigator.pop(ctx, true),
            child:
                const Text("বের হবো", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _selectOpt(int qi, int oi) {
    if (isSubmitted) return;
    HapticFeedback.lightImpact();
    final alreadyAnsweredInPractice =
        widget.mode == "practice" && answers.containsKey(qi);

    setState(() {
      answers[qi] = oi;
    });

    if (widget.mode == "practice" && !alreadyAnsweredInPractice) {
      final q = sessionQuestions[qi];
      widget.onRecordAnswer(q.id, oi == q.ans, countStat: true);
    }
  }

  void _submitExam() {
    HapticFeedback.mediumImpact();
    _examTimer?.cancel();
    int correct = 0;
    final wrongIds = <String>[];
    final rightIds = <String>[];

    for (int i = 0; i < sessionQuestions.length; i++) {
      final q = sessionQuestions[i];
      final userAns = answers[i];
      if (userAns != null) {
        if (userAns == q.ans) {
          correct++;
          rightIds.add(q.id);
        } else {
          wrongIds.add(q.id);
        }
      }
    }

    widget.onBatchExamSubmit(
        sessionQuestions.length, correct, wrongIds, rightIds);

    setState(() {
      isSubmitted = true;
      reviewFilter = "ALL";
    });
  }

  void _retrySameTest() {
    HapticFeedback.lightImpact();
    setState(() {
      sessionQuestions.shuffle(Random());
      answers.clear();
      isSubmitted = false;
      if (widget.mode == "exam") {
        remainingSeconds = sessionQuestions.length * 60;
        _startTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmExitIfNeeded() && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        if (await _confirmExitIfNeeded() && context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Text(
                          "← Back",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isSubmitted
                            ? "📊 ফলাফল"
                            : "${widget.title} (${sessionQuestions.length} টি)",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (widget.mode == "exam" && !isSubmitted)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: remainingSeconds < 60
                              ? AppColors.rose.withOpacity(0.2)
                              : AppColors.amber.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "⏱️ ${_formatTimer(remainingSeconds)}",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: remainingSeconds < 60
                                ? AppColors.rose
                                : AppColors.amberLight,
                          ),
                        ),
                      )
                    else
                      Text(
                        widget.mode == "practice" ? "প্র্যাকটিস" : "এক্সাম",
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                  ],
                ),
              ),

              // Body Content
              Expanded(
                child: isSubmitted
                    ? _buildExamResultView()
                    : _buildQuestionsListView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // ACTIVE QUESTIONS LIST (PRACTICE OR EXAM)
  // ==========================================
  Widget _buildQuestionsListView() {
    const optLabels = ["ক", "খ", "গ", "ঘ"];

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: sessionQuestions.length + (widget.mode == "exam" ? 1 : 0),
      itemBuilder: (_, i) {
        if (i == sessionQuestions.length) {
          // Submit Button at the end of Exam
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emerald,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _submitExam,
                child: const Text(
                  "✅ জমা দাও - ফলাফল দেখো",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          );
        }

        final q = sessionQuestions[i];
        final selectedOi = answers[i];
        final isSaved = widget.bookmarkedIds.contains(q.id);

        return Container(
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${q.subject} • ${q.chapter} • ${q.tag}",
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.indigoSoft,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      widget.onToggleBookmark(q.id);
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        size: 20,
                        color: isSaved
                            ? AppColors.amberLight
                            : AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                "${i + 1}. ${q.q}",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              ...List.generate(4, (oi) {
                Color bg = Colors.transparent;
                Color border = Colors.white.withOpacity(0.1);

                if (selectedOi != null) {
                  if (widget.mode == "practice") {
                    if (oi == q.ans) {
                      bg = AppColors.emerald.withOpacity(0.2);
                      border = AppColors.emerald;
                    } else if (oi == selectedOi && selectedOi != q.ans) {
                      bg = AppColors.rose.withOpacity(0.2);
                      border = AppColors.rose;
                    }
                  } else {
                    if (oi == selectedOi) {
                      bg = AppColors.primary.withOpacity(0.2);
                      border = AppColors.primary;
                    }
                  }
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: InkWell(
                    onTap: () => _selectOpt(i, oi),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: border),
                      ),
                      child: Text(
                        "${optLabels[oi]}. ${q.options[oi]}",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                );
              }),

              // Practice Mode Instant Explanation
              if (widget.mode == "practice" && selectedOi != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "💡 ব্যাখ্যা: ${q.exp.isNotEmpty ? q.exp : 'ব্যাখ্যা নেই'} ${selectedOi == q.ans ? '✅ সঠিক!' : '❌ ভুল, সঠিক: ${optLabels[q.ans]}'}",
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.primaryLight),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================
  // EXAM RESULT & FILTERABLE REVIEW VIEW
  // ==========================================
  Widget _buildExamResultView() {
    int correct = 0;
    int wrong = 0;
    int unanswered = 0;

    for (int i = 0; i < sessionQuestions.length; i++) {
      final ans = answers[i];
      if (ans == null) {
        unanswered++;
      } else if (ans == sessionQuestions[i].ans) {
        correct++;
      } else {
        wrong++;
      }
    }

    final total = sessionQuestions.length;
    final perc = total > 0 ? ((correct / total) * 100).round() : 0;

    String grade = "F";
    String msg = "ভয় পেয়ো না, সবাই এখান থেকে শুরু করে";
    Color gradeColor = AppColors.rose;
    String emoji = "💪";

    if (perc >= 90) {
      grade = "A+";
      msg = "অসাধারণ! তুমি টপার লেভেলে আছো 🔥";
      gradeColor = AppColors.emerald;
      emoji = "🏆";
    } else if (perc >= 80) {
      grade = "A";
      msg = "খুব ভালো! আর একটু হলেই টপার";
      gradeColor = AppColors.emerald;
      emoji = "🎉";
    } else if (perc >= 70) {
      grade = "A-";
      msg = "ভালো হচ্ছে! ভুলগুলো রিভিউ করো";
      gradeColor = AppColors.primary;
      emoji = "👍";
    } else if (perc >= 60) {
      grade = "B";
      msg = "মোটামুটি ভালো, আরো প্র্যাকটিস দরকার";
      gradeColor = AppColors.amber;
      emoji = "💪";
    } else if (perc >= 50) {
      grade = "C";
      msg = "চেষ্টা করছো, ভুলগুলো দেখে নাও";
      gradeColor = AppColors.amber;
      emoji = "📚";
    } else if (perc >= 40) {
      grade = "D";
      msg = "হাল ছেড়ো না, অধ্যায়টা আবার পড়ো";
      gradeColor = AppColors.rose;
      emoji = "📖";
    }

    const optLabels = ["ক", "খ", "গ", "ঘ"];

    final filteredIndices = <int>[];
    for (int i = 0; i < sessionQuestions.length; i++) {
      final userAns = answers[i];
      final isCorr = userAns == sessionQuestions[i].ans;
      final isSkip = userAns == null;
      if (reviewFilter == "WRONG" && (isCorr || isSkip)) continue;
      if (reviewFilter == "CORRECT" && !isCorr) continue;
      if (reviewFilter == "SKIPPED" && !isSkip) continue;
      filteredIndices.add(i);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        // Top Result Card
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E1B4B), AppColors.card],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 48)),
              Text(
                "$grade  •  $perc%",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: gradeColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                msg,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.primaryLight),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildResultStatItem("মোট প্রশ্ন", "$total", Colors.white),
                  const SizedBox(width: 8),
                  _buildResultStatItem(
                      "✅ সঠিক", "$correct", AppColors.emerald),
                  const SizedBox(width: 8),
                  _buildResultStatItem("❌ ভুল", "$wrong", AppColors.rose),
                  const SizedBox(width: 8),
                  _buildResultStatItem(
                      "⏭️ স্কিপ", "$unanswered", AppColors.textMuted),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: perc / 100.0,
                  minHeight: 10,
                  backgroundColor: Colors.white.withOpacity(0.08),
                  valueColor: AlwaysStoppedAnimation<Color>(gradeColor),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "তুমি $total টার মধ্যে $correct টা ঠিক করেছো",
                style:
                    const TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
        ),

        // Retry & Home Buttons
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 46,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _retrySameTest,
                  child: const Text("🔄 আবার টেস্ট দাও",
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 46,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.card,
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("🏠 ড্যাশবোর্ডে যাও",
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Review Title + Filter Pills
        const Text(
          "📝 উত্তর রিভিউ - সব প্রশ্নের সঠিক উত্তর",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip("ALL", "সব ($total)"),
              const SizedBox(width: 6),
              _buildFilterChip("WRONG", "❌ ভুল ($wrong)"),
              const SizedBox(width: 6),
              _buildFilterChip("CORRECT", "✅ সঠিক ($correct)"),
              const SizedBox(width: 6),
              _buildFilterChip("SKIPPED", "⏭️ স্কিপ ($unanswered)"),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Review Questions List
        ...filteredIndices.map((i) {
          final q = sessionQuestions[i];
          final userAns = answers[i];
          final isCorrect = userAns == q.ans;
          final isUnanswered = userAns == null;
          final isSaved = widget.bookmarkedIds.contains(q.id);

          return Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isCorrect
                    ? AppColors.emerald.withOpacity(0.4)
                    : AppColors.rose.withOpacity(0.4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${q.subject} • ${q.chapter} • ${q.tag}",
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.indigoSoft),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        widget.onToggleBookmark(q.id);
                        setState(() {});
                      },
                      child: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        size: 20,
                        color: isSaved
                            ? AppColors.amberLight
                            : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "${i + 1}. ${q.q}",
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 15),
                ),
                const SizedBox(height: 8),
                ...List.generate(4, (oi) {
                  String label = "${optLabels[oi]}. ${q.options[oi]}";
                  Color bg = Colors.transparent;
                  Color border = Colors.white.withOpacity(0.1);

                  if (oi == q.ans) {
                    bg = AppColors.emerald.withOpacity(0.2);
                    border = AppColors.emerald;
                    label += "  ✅ সঠিক উত্তর";
                  }
                  if (oi == userAns && !isCorrect && !isUnanswered) {
                    bg = AppColors.rose.withOpacity(0.2);
                    border = AppColors.rose;
                    label += "  ❌ তোমার উত্তর";
                  }
                  if (oi == userAns && isCorrect) {
                    label += "  ✅ তুমি ঠিক দিয়েছো";
                  }

                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: border),
                    ),
                    child: Text(label, style: const TextStyle(fontSize: 13)),
                  );
                }),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: isUnanswered
                        ? AppColors.textMuted.withOpacity(0.12)
                        : (isCorrect
                            ? AppColors.emerald.withOpacity(0.1)
                            : AppColors.rose.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    isUnanswered
                        ? "⏭️ তুমি উত্তর দাওনি - সঠিক: ${optLabels[q.ans]}"
                        : (isCorrect
                            ? "✅ সঠিক!"
                            : "❌ ভুল - তুমি দিয়েছো: ${optLabels[userAns]} | সঠিক: ${optLabels[q.ans]}"),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                if (q.exp.isNotEmpty)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "💡 ব্যাখ্যা: ${q.exp}",
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.primaryLight),
                    ),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildResultStatItem(String label, String val, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              val,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final active = reviewFilter == key;
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => reviewFilter = key);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
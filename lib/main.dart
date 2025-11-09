import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'تطبيق أمل',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFE0F7F5), // تركوازي فاتح
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00897B), // تركوازي داكن
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.teal),
          ),
        ),
      ),
      home: const MyHomePage(title: 'تطبيق أمل'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  // المتغيرات لحفظ بيانات المستخدم
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // مفاتيح وإدارة الحالة
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoggingIn = false;

  late AnimationController _animController;
  late Animation<double> _logoScale;
  late Animation<double> _cardFade;
  late Animation<Offset> _cardSlide;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoScale = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );

    _cardFade = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    );

    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.25, 1.0, curve: Curves.easeOutCubic),
    ));

    // استمع للتغييرات لتحديث زر الدخول والتحقق الفوري
    _usernameController.addListener(_onFieldChanged);
    _passwordController.addListener(_onFieldChanged);

    // تشغيل الأنيميشن عند الدخول
    _animController.forward();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    setState(() {}); // لتحديث حالة الزر ومؤشر القوة
  }

  // دالة تقدير قوة كلمة المرور
  double _passwordStrength(String password) {
    if (password.isEmpty) return 0;
    int score = 0;
    if (password.length >= 6) score++;
    if (password.length >= 10) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-]').hasMatch(password)) score++;
    // normalize to 0..1
    return (score / 6).clamp(0, 1).toDouble();
  }

  String _passwordStrengthLabel(double s) {
    if (s == 0) return 'فارغة';
    if (s < 0.34) return 'ضعيفة';
    if (s < 0.67) return 'متوسطة';
    return 'قوية';
  }

  Color _passwordStrengthColor(double s) {
    if (s == 0) return Colors.grey.shade400;
    if (s < 0.34) return Colors.red.shade400;
    if (s < 0.67) return Colors.orange.shade500;
    return Colors.green.shade500;
  }

  bool get _isFormValid {
    final u = _usernameController.text.trim();
    final p = _passwordController.text;
    return u.isNotEmpty && p.length >= 6;
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoggingIn = true);

    await Future.delayed(const Duration(seconds: 1)); // محاكاة طلب شبكة

    setState(() => _isLoggingIn = false);

    final username = _usernameController.text.trim();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("مرحبًا $username! تم تسجيل الدخول بنجاح ✅")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final password = _passwordController.text;
    final strength = _passwordStrength(password);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _logoScale,
                  child: CircleAvatar(
                    radius: 44,
                    backgroundColor: const Color(0xFF00897B),
                    child: const Icon(Icons.lock_outline,
                        size: 48, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                FadeTransition(
                  opacity: _cardFade,
                  child: Text(
                    "تسجيل الدخول",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SlideTransition(
                  position: _cardSlide,
                  child: FadeTransition(
                    opacity: _cardFade,
                    child: Card(
                      elevation: 6,
                      shadowColor: Colors.teal.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _usernameController,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  labelText: 'اسم المستخدم',
                                  prefixIcon: Icon(Icons.person),
                                ),
                                validator: (v) {
                                  final value = v?.trim() ?? '';
                                  if (value.isEmpty) {
                                    return 'الرجاء إدخال اسم المستخدم';
                                  }
                                  if (value.length < 3) {
                                    return 'يجب أن لا يقل عن 3 أحرف';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: 'كلمة المرور',
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    tooltip: _obscurePassword
                                        ? 'إظهار'
                                        : 'إخفاء',
                                    icon: Icon(_obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                                validator: (v) {
                                  final value = v ?? '';
                                  if (value.isEmpty) {
                                    return 'الرجاء إدخال كلمة المرور';
                                  }
                                  if (value.length < 6) {
                                    return 'الحد الأدنى 6 أحرف';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 8),
                              // مؤشر قوة كلمة المرور
                              if (password.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: LinearProgressIndicator(
                                        minHeight: 8,
                                        value: strength,
                                        color: _passwordStrengthColor(strength),
                                        backgroundColor:
                                        Colors.grey.shade200,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'قوة كلمة المرور: ${_passwordStrengthLabel(strength)}',
                                          style: TextStyle(
                                            fontSize: 12.5,
                                            color: _passwordStrengthColor(
                                                strength),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '${(strength * 100).round()}%',
                                          style: TextStyle(
                                            fontSize: 12.5,
                                            color: _passwordStrengthColor(
                                                strength),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    onChanged: (v) {
                                      setState(() => _rememberMe = v ?? false);
                                    },
                                    activeColor: const Color(0xFF00897B),
                                  ),
                                  const Text('تذكرني'),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text('رابط استعادة كلمة المرور (تجريبي)'),
                                      ));
                                    },
                                    child: const Text('نسيت كلمة المرور؟'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _isFormValid && !_isLoggingIn
                                      ? _login
                                      : null,
                                  icon: _isLoggingIn
                                      ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                      : const Icon(Icons.login),
                                  label: Text(
                                    _isLoggingIn ? 'جارٍ الدخول...' : 'دخول',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF00897B),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // سطر اجتماعي/معلوماتي بسيط
                FadeTransition(
                  opacity: _cardFade,
                  child: TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تسجيل باستخدام مزود خارجي (تجريبي)'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shield_outlined, color: Colors.teal),
                    label: const Text(
                      'الحفاظ على أمان حسابك هو أولويتنا',
                      style: TextStyle(color: Colors.teal),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
 }
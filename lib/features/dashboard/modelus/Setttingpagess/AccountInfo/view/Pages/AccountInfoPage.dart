import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // هذا الاستيراد قد لا يكون مستخدماً لو Cubit مش مستخدم مباشرة هنا
import 'package:greanspherproj/core/widget/validation.dart'; // تأكد من صحة هذا المسار
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
// import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/AccountInfo/controller/cubit/account_info_cubit.dart'; // هذا الاستيراد قد لا يكون مستخدماً

import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/DeleteAccount/DeleteAccount.dart'; // DeleteAccountScreen
//import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_api_service.dart'; // ApiService, UserProfile

class AccountInfoScreen extends StatefulWidget {
  final UserProfile? userProfile; // <--- لاستقبال بيانات البروفايل
  final VoidCallback
      onProfileUpdated; // <--- Callback لتحديث البروفايل في ProfileScreen

  const AccountInfoScreen(
      {Key? key, this.userProfile, required this.onProfileUpdated})
      : super(key: key);

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _emailController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _dateOfBirthController;
  String? _selectedGender;

  bool _isEditing = false;
  bool _isLoading = true; // مؤشر تحميل لـ AccountInfoScreen نفسها
  String _errorMessage = ''; // رسالة خطأ لـ AccountInfoScreen

  @override
  void initState() {
    super.initState();
    // إذا لم يتم تمرير userProfile، تقوم الشاشة بجلب بياناتها بنفسها
    if (widget.userProfile == null) {
      _fetchUserProfileInternal();
    } else {
      _initializeControllers(
          widget.userProfile!); // تهيئة Controllers بالبيانات الممررة
      _isLoading = false;
    }
  }

  // دالة داخلية لجلب البروفايل لو لم يتم تمريره
  Future<void> _fetchUserProfileInternal() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final profile = await _apiService.fetchUserProfile();
      _initializeControllers(profile); // تهيئة Controllers بالبيانات المجلوبة
    } catch (e) {
      print("Error fetching user profile internally: $e");
      setState(() {
        _errorMessage = 'Failed to load profile details: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // دالة لتهيئة الـ Controllers
  void _initializeControllers(UserProfile profile) {
    _emailController = TextEditingController(text: profile.email);
    _firstNameController = TextEditingController(text: profile.firstName);
    _lastNameController = TextEditingController(text: profile.lastName);
    _dateOfBirthController = TextEditingController(
        text: profile.dateOfBirth != null
            ? '${profile.dateOfBirth!.year}-${profile.dateOfBirth!.month.toString().padLeft(2, '0')}-${profile.dateOfBirth!.day.toString().padLeft(2, '0')}'
            : '');
    _selectedGender = profile.gender;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  void _toggleEditMode() async {
    setState(() {
      _isEditing = !_isEditing;
    });

    if (!_isEditing && _formKey.currentState!.validate()) {
      // لو تم الضغط على Save
      try {
        await _apiService.editUserProfile(
          // <--- استدعاء API التعديل
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          gender: _selectedGender,
          dateOfBirth: _dateOfBirthController.text.isNotEmpty
              ? DateTime.tryParse(_dateOfBirthController.text)
              : null,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        // لو onProfileUpdated تم تمريرها، استدعيها
        widget.onProfileUpdated.call(); // <--- استدعاء الـ Callback
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${e.toString()}')),
        );
        print("Error updating profile: $e");
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateOfBirthController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  // تم حذف دالة _confirmDeleteAccount() من هنا تماماً

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Account info",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          backgroundColor: Colors.white,
          leading: BackButton(color: Colors.black),
        ),
        body: Center(child: CircularProgressIndicator(color: Colors.green)),
      );
    }
    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Account info",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          backgroundColor: Colors.white,
          leading: const BackButton(color: Colors.black),
        ),
        body: Center(child: Text(_errorMessage)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Account info",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon:
              Image.asset("assets/images/arrowback.png", width: 25, height: 25),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _toggleEditMode,
            child: Text(
              _isEditing ? "Save" : "Edit",
              style: const TextStyle(color: Colors.black, fontSize: 24),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _emailController,
                validator: MyValidation.validateEmail,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email, color: Colors.black),
                  labelText: "Email",
                ),
                enabled: _isEditing,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _firstNameController,
                validator: MyValidation.validateName,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.account_circle, color: Colors.black),
                  labelText: "First Name",
                ),
                enabled: _isEditing,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _lastNameController,
                validator: MyValidation.validateName,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.account_circle, color: Colors.black),
                  labelText: "Last Name",
                ),
                enabled: _isEditing,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _dateOfBirthController,
                readOnly: true,
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.grey),
                    onPressed: _isEditing ? () => _selectDate(context) : null,
                  ),
                  labelText: "Date of birth (optional)",
                ),
                onTap: _isEditing ? () => _selectDate(context) : null,
              ),
              const SizedBox(height: 20),
              const Text("Gender (optional)",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text("Male",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      value: "Male",
                      groupValue: _selectedGender,
                      onChanged: _isEditing
                          ? (value) => setState(() => _selectedGender = value)
                          : null,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text("Female",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      value: "Female",
                      groupValue: _selectedGender,
                      onChanged: _isEditing
                          ? (value) => setState(() => _selectedGender = value)
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: OutlinedButton(
                  // عند الضغط، ننتقل مباشرة إلى DeleteAccountScreen
                  onPressed: _isEditing
                      ? null
                      : () {
                          // <--- تعديل هنا
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const DeleteAccountScreen()), // <--- انتقال مباشر
                          );
                        },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.green),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 105),
                  ),
                  child: Text(
                    "Delete account",
                    style: TextStyle(
                        color: _isEditing ? Colors.grey : Colors.green,
                        fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

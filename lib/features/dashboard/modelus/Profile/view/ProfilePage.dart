import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/ABOUT/view/AboutApp.dart';
import 'package:greanspherproj/features/dashboard/modelus/AddNewCardScreen/AddNewCardScreen.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/view/ComponentPage.dart';
import 'package:greanspherproj/features/dashboard/modelus/Favourite/view/Favourite.dart';
//import 'package:greanspherproj/features/dashboard/modelus/Favourite/view/FavouriteScreen.dart';
import 'package:greanspherproj/features/dashboard/modelus/Order/view/OrderPage.dart';
//import 'package:greanspherproj/features/dashboard/modelus/PAY/view/PayPage.dart';
import 'package:greanspherproj/features/dashboard/modelus/Reward/view/Reward.dart';
//import 'package:greanspherproj/features/dashboard/modelus/Reward/view/RewardsScreen.dart';
import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/Setting/view/SettingPage.dart'; // <--- استيراد SettingsScreen
//import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_api_service.dart'; // <--- تأكد من صحة هذا الاستيراد
import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/AccountInfo/view/Pages/AccountInfoPage.dart'; // استيراد AccountInfoScreen
import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/ChangeEmailPage/view/ChangeEmailPage.dart';
import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/ChangePasswordPgd/view/ChangePaswwordPage.dart';
import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/SavedAddress/view/SavedAddressPage.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;

  const ProfileScreen({
    Key? key,
    required this.userName,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  UserProfile? _userProfile;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUserProfile(); // جلب بيانات البروفايل عند بدء تشغيل الشاشة
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final profile = await _apiService
          .fetchUserProfile(); // <--- استدعاء API جلب البروفايل
      setState(() {
        _userProfile = profile;
      });
    } catch (e) {
      print("Error fetching user profile: $e");
      setState(() {
        _errorMessage = 'Failed to load profile: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // تحديد الاسم للعرض (من الـ API أو الـ dummy userName)
    String displayUserName = _userProfile != null
        ? '${_userProfile!.firstName} ${_userProfile!.lastName}'
        : widget.userName;

    // تحديد أول حرف للصورة
    String firstChar = '';
    if (_userProfile != null && _userProfile!.firstName.isNotEmpty) {
      firstChar = _userProfile!.firstName[0].toUpperCase();
    } else if (widget.userName.isNotEmpty) {
      firstChar = widget.userName[0].toUpperCase();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        left: 16,
                        top: 65,
                        right: 16,
                      ),
                      color: Colors.white,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.green,
                            child: Text(
                              firstChar,
                              style: const TextStyle(
                                  fontSize: 30, color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayUserName,
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/egypt.png",
                                    width: 30,
                                    height: 30,
                                  ),
                                  const SizedBox(width: 6),
                                  const Text("Egypt",
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          GestureDetector(
                            child: Image.asset(
                              "assets/images/tdesign_setting-1.png",
                              width: 30,
                              height: 30,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingsScreen(
                                    userProfile:
                                        _userProfile, // <--- تمرير userProfile هنا
                                    onProfileUpdated:
                                        _fetchUserProfile, // <--- تمرير دالة الـ refresh هنا
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const Divider(
                      color: Colors.grey,
                      height: 16,
                    ),

                    // Menu Items
                    buildMenuItem(context, "assets/images/Vector.png",
                        "Rewards", const RewardsScreen()),
                    buildMenuItem(context, "assets/images/List.png",
                        "Your Order", const OrdersScreen()),
                    buildMenuItem(context, "assets/images/pay.png", "Pay",
                        const AddNewCardScreen()),
                    buildMenuItem(
                      context,
                      "assets/images/favourite.png",
                      "Favourite",
                      FavouriteScreen(
                        favoriteProducts: ComponentPageState.favoriteProducts,
                        onRemoveFavorite: ComponentPageState
                            .handleFavoriteRemovedFromScreenStatic,
                        onClearAllFavorites: ComponentPageState
                            .handleClearAllFavoritesFromScreenStatic,
                      ),
                    ),
                    buildMenuItem(context, "assets/images/Information.png",
                        "About App", const AboutAppScreen()),
                  ],
                ),
    );
  }

  Widget buildMenuItem(
      BuildContext context, String imagePath, String text, Widget page) {
    return ListTile(
      leading: Image.asset(imagePath, width: 25, height: 25),
      title: Text(text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }
}

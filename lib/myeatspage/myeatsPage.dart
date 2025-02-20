import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; //fgggggg
import 'package:coupangeats/homepage/home_page.dart';
import 'package:coupangeats/theme.dart';
import 'package:coupangeats/ownerpage/storeownerPage.dart';

class myeatsPage extends StatefulWidget {
  const myeatsPage({super.key});

  @override
  State<myeatsPage> createState() => _myeatsPageState();
}

class _myeatsPageState extends State<myeatsPage> {

  String _userName = ''; //변수들임
  String _userPhone = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserData();
  }

  Future<void>_loadUserData()async{
    try{
      final user = FirebaseAuth.instance.currentUser;
      if(user != null){
        final userData=  await FirebaseFirestore.instance.collection('signup').doc(user.uid).get();

        if(userData.exists){
          setState(() {
            _userName = userData.data()?['name']??'';
            _userPhone = userData.data()?['num']??'';
          });
        }
      }
    } catch (e){
      print('Error loading user data: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                children: [
                  Text(_userName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(_formatPhoneNumber(_userPhone), style: TextStyle(color: Colors.grey[600])),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('1', '내가 남긴 리뷰'),
                      _buildStatItem('0', '도움이 됐어요'),
                      _buildStatItem('0', '즐겨찾기'),
                    ],
                  ),
                  SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: () {},
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('자세히 보기', style: TextStyle(color: Colors.blue)),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            _buildListTile('주소 관리', Icons.list_alt),
            _buildListTile('즐겨찾기', Icons.favorite_border),
            _buildListTile('할인쿠폰', Icons.local_offer_outlined),
            _buildListTileWithTag('진행중인 이벤트', Icons.event, 'NEW'),
            _buildListTileWithButton('친구 초대', Icons.person_add, '5,000원 쿠폰받기'),
            _buildListTileWithButton('이츠 몰펫', Icons.card_giftcard, '가입하고 쿠폰받기'),
          ],
        ),
      ),
    );
  }
  
  String _formatPhoneNumber(String phone){
    if (phone.length>= 10){
      return phone.replaceRange(3, 7, '****');
    } return phone;
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildListTile(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, size: 24),
      title: Text(title),
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
    );
  }

  Widget _buildListTileWithTag(String title, IconData icon, String tag) {
    return ListTile(
      leading: Icon(icon, size: 24),
      title: Row(
        children: [
          Text(title),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              tag,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
    );
  }

  Widget _buildListTileWithButton(String title, IconData icon, String buttonText) {
    return ListTile(
      leading: Icon(icon, size: 24),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              buttonText,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
    );
  }
}

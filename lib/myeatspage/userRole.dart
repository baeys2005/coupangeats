class UserRole {
  static const String OWNER = '사장님';
  static const String CUSTOMER = '일반';

  static bool isOwner(String? role){
    return role == OWNER;
  }
}
const example = 'example';

mixin class ApiUrl {
  static const _urlBase = "https://api.hitmoments.com/v1";
  static const login = "$_urlBase/auth/login";
  static const register = "$_urlBase/auth/register";
  static const getFriends = "$_urlBase/friends/list-friends";
  static const getFriendsRequest = "$_urlBase/friends/list-received-request";
  static const deleteFriend = "$_urlBase/friends/delete-friend";
}

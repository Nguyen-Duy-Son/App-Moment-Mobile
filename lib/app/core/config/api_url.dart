const example = 'example';

mixin class ApiUrl {
  static const _urlBase = "https://api.hitmoments.com/v1";

  static const login = "$_urlBase/auth/login";
  static const register = "$_urlBase/auth/register";
  static const getMe = "$_urlBase/auth/me";
  static const getListMoment = "$_urlBase/moments/";
  static const getFriends = "$_urlBase/friends/list-friends";
  static const getFriendsRequest = "$_urlBase/friends/list-received-request";
  static const deleteFriend = "$_urlBase/friends/delete-friend";
  static const confirmFriendRequest = "$_urlBase/friends/confirm-request";
  static const searchFriendOfUser = "$_urlBase/friends/search-user";
  static const declineFriendRequest = "$_urlBase/friends/delince-request";
  static const sentFriendRequestOfUser = "$_urlBase/friends/invite";
  static const getCurrentWeather = "http://api.weatherapi.com/v1/current.json";
}

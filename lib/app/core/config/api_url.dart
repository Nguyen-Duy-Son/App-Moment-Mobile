const example = 'example';

mixin class ApiUrl{
  static const _urlBase = "https://api.hitmoments.com/v1";

  static const login = "$_urlBase/auth/login";
  static const register = "$_urlBase/auth/register";
  static const getMe = "$_urlBase/auth/me";

  static const getListMoment = "$_urlBase/moments/";

}
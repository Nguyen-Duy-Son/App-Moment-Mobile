
//sử dụng để gán trạng thái cho các module như call api, bla bla
enum ModuleStatus{
  initial,
  loading,
  success,
  fail
}

enum TypeMoment{
  image,
  video,
}
getStringTypeMoment(TypeMoment type){
  switch(type){
    case TypeMoment.image:
      return 'image';
    case TypeMoment.video:
      return 'video';
    default:
      return 'image';
  }
}
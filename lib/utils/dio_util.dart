import 'package:dio/dio.dart';


class DioResult{
  bool result;
  String msg;
  DioResult({
    required this.result,
    required this.msg,
});
}

class BaseDio{
  static final BaseDio _baseDio=BaseDio();
  static BaseDio get instance=>_baseDio;

  Dio? _dio;
  BaseDio(){
    _dio??=Dio(BaseOptions(
      responseType: ResponseType.json,
      receiveDataWhenStatusError: false,
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
    ));
  }

  Future<DioResult> requestPost({
    required String path,
    required Map<String,dynamic> data,
})async{

    try{
      var response = await _dio?.request<String>(
        path,
        data: data,
        options: Options(method: "post")
      );
      return DioResult(result: response?.statusCode==200, msg: response?.data??"");
    }catch(e){
      return DioResult(result: false, msg: "");
    }
  }
}
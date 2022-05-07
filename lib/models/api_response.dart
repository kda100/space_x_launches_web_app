// ignore: file_names
///Api Response Type.

enum ApiResponseType {
  loading,
  success,
  error,
}

///Api response object to communicate with view objects after app makes an api request.

class ApiResponse {
  final ApiResponseType responseType;
  String _message = "";

  ApiResponse.success() : responseType = ApiResponseType.success;

  ApiResponse.error()
      : responseType = ApiResponseType.error,
        _message = "Something went wrong";

  ApiResponse.loading() : responseType = ApiResponseType.loading;

  String get message => _message;
}

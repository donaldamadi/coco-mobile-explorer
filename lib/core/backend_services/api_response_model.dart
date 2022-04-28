class ResponseModel<T> {
  late int? statusCode;
  late ErrorModel? error;
  late bool? valid = false;
  late dynamic message = '';
  late T? data;

  ResponseModel({valid, message, statusCode, data, error}) {
    this.valid = valid ?? false;
    this.message = message ?? 'an error occurred please try again';
    this.statusCode = statusCode ?? 000;
    this.data = data;
    this.error = error ?? ErrorModel();
  }
}

class ErrorModel {
  String? errorCode;
  String? message;

  ErrorModel({this.errorCode, this.message});

  @override
  String toString() {
    return '{errorCode: $errorCode, message: $message}';
  }

  factory ErrorModel.fromJson(dynamic data) {
    return ErrorModel(
      errorCode: data['errorCode'] ?? '',
      message: data['message'] ?? '',
    );
  }
}

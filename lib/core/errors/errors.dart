abstract class Failures {
  final String errormessage;
  Failures({required this.errormessage});
}

class ServerFailure extends Failures {
  @override
  ServerFailure({required super.errormessage});
}

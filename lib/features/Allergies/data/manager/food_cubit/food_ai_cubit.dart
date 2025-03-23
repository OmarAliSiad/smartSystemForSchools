// import 'dart:developer';
// import 'dart:io';
// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import '../../food_ai_service.dart';

// part 'food_ai_state.dart';

// class FoodAICubit extends Cubit<FoodAIState> {
//   final FoodAIService _foodAIService;
//   Map<String, dynamic>? foodAnalysisResult;

//   FoodAICubit(this._foodAIService) : super(FoodAIInitial()) {
//     _initModel();
//   }

//   Future<void> _initModel() async {
//     try {
//       await _foodAIService.loadModel();
//     } catch (e) {
//       emit(FoodAIError('Failed to load AI model: $e'));
//     }
//   }

//   Future<void> analyzeFood(File imageFile) async {
//     if (!_foodAIService.isModelLoaded) {
//       emit(FoodAIError('Model not loaded yet'));
//       return;
//     }

//     emit(FoodAILoading());

//     try {
//       final result = await _foodAIService.analyzeFoodImage(imageFile);
//       foodAnalysisResult = result;

//       if (result.containsKey('error')) {
//         emit(FoodAIError(result['error']));
//       } else {
//         emit(FoodAISuccess(
//           foodType: result['foodType'],
//           allergens: List<String>.from(result['allergens']),
//           nutritionalInfo: result['nutritionalInfo'],
//           confidenceScore: result['confidenceScore'],
//         ));
//       }
//     } catch (e) {
//       log('Error analyzing food: $e');
//       emit(FoodAIError('Error analyzing food: $e'));
//     }
//   }
// }

// lib/features/adoption/presentation/cubit/adoption_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:petadoptapp/features/adoptpet/domain/entity/adoptpet.dart';
import 'package:petadoptapp/features/adoptpet/domain/repository/adoptstatus_repo.dart';

part 'adoption_state.dart';

class AdoptionCubit extends Cubit<AdoptionState> {
  final AdoptionRepository adoptionRepository;

  AdoptionCubit({required this.adoptionRepository}) : super(AdoptionInitial());

  Future<void> submitAdoption({
    required String petId,
    required String userId,
    required String message,
  }) async {
    emit(AdoptionLoading());
    try {
      final application = AdoptionApplication.createNew(
        petId: petId,
        userId: userId,
        message: message,
      );

      await adoptionRepository.submitAdoptionApplication(application);
      emit(AdoptionSuccess(message: 'nigga'));
    } catch (e) {
      emit(AdoptionError(message: e.toString()));
    }
  }

  Future<void> loadMyApplications(String userId) async {
    emit(AdoptionLoading());
    try {
      final applications = await adoptionRepository.getMyApplications(userId);
      emit(ApplicationsLoaded(applications: applications));
    } catch (e) {
      emit(AdoptionError(message: e.toString()));
    }
  }

  Future<void> cancelAdoption(String applicationId) async {
    emit(AdoptionLoading());
    try {
      await adoptionRepository.cancelApplication(applicationId);
      emit(AdoptionCanceled());
    } catch (e) {
      emit(AdoptionError(message: e.toString()));
    }
  }

  Future<bool> hasAppliedForPet(String userId, String petId) async {
    return await adoptionRepository.hasAppliedForPet(userId, petId);
  }
}

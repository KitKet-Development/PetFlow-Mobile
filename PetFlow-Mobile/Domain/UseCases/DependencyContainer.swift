//
//  DependencyContainer.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 18.05.2026.
//

final class DependencyContainer {

    static let shared = DependencyContainer()

    private init() {}
    
    lazy var bookingRepository: BookingRepositoryProtocol = {
        BookingRepository(apiClient: apiClient)
    }()

    // MARK: - API Client

    lazy var apiClient: APIClientProtocol = {
        APIClient.shared
    }()

    // MARK: - Repositories

    lazy var authRepository: AuthRepositoryProtocol = {
        AuthRepository()
    }()

    lazy var petRepository: PetRepositoryProtocol = {
        PetRepository()
    }()

    lazy var clinicRepository: ClinicRepositoryProtocol = {
        ClinicRepository()
    }()
    
    lazy var getClinicsUseCase: GetClinicsUseCase = {
        GetClinicsUseCase(repository: clinicRepository)
    }()

    lazy var profileRepository: ProfileRepositoryProtocol = {
        ProfileRepository(apiClient: apiClient)
    }()

    lazy var petMetaRepository: PetMetaRepositoryProtocol = {
        PetMetaRepository(apiClient: APIClient.shared)
    }()

    // MARK: - UseCases

    lazy var signUpUseCase: SignUpUseCase = {
        SignUpUseCase(repository: authRepository)
    }()

    lazy var loginUseCase: LoginUseCase = {
        LoginUseCase(repository: authRepository)
    }()

    lazy var createPetUseCase: CreatePetUseCase = {
        CreatePetUseCase(repository: petRepository)
    }()

    lazy var createBookingUseCase: CreateBookingUseCase = {
        CreateBookingUseCase(repository: bookingRepository)
    }()

    lazy var getUserAppointmentsUseCase: GetUserAppointmentsUseCase = {
        GetUserAppointmentsUseCase(repository: bookingRepository)
    }()

    lazy var getPetsUseCase: GetPetsUseCase = {
        GetPetsUseCase(repository: petRepository)
    }()

    lazy var getProfileUseCase: GetProfileUseCase = {
        GetProfileUseCase(repository: profileRepository)
    }()

    lazy var updateProfileUseCase: UpdateProfileUseCase = {
        UpdateProfileUseCase(repository: profileRepository)
    }()
    
    lazy var tokenStorage: TokenStorageProtocol = {
        TokenStorage.shared
    }()

    lazy var getSpeciesUseCase: GetSpeciesUseCase = {
        GetSpeciesUseCase(repository: petMetaRepository)
    }()

    lazy var getBreedsUseCase: GetBreedsUseCase = {
        GetBreedsUseCase(repository: petMetaRepository)
    }()
    
    lazy var getSlotsUseCase: GetSlotsUseCase = {
        GetSlotsUseCase(repository: clinicRepository)
    }()
}

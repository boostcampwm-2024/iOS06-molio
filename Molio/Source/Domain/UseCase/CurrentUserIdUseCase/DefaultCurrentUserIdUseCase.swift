struct DefaultCurrentUserIdUseCase: CurrentUserIdUseCase {
    private let authService: AuthService
    private let usecase: ManageAuthenticationUseCase
    
    init(
        authService: AuthService,
        usecase: ManageAuthenticationUseCase
    ) {
        self.authService = authService
        self.usecase = usecase
    }
    
    func execute() throws -> String? {
        if usecase.isLogin() {
            return try authService.getCurrentID()
        } else {
            return nil
        }
    }
}

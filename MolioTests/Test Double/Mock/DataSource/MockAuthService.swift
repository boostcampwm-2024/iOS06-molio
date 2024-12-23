import FirebaseAuth

@testable import Molio

final class MockAuthService: AuthService {
    var currentUserID: String = "myUserID"

    func getCurrentUser() async throws -> FirebaseAuth.User {
        throw FirestoreError.documentFetchError
    }
    
    func getCurrentID() -> String {
        return currentUserID

    }
    
    func signInApple(info: AppleAuthInfo) async throws -> (uid: String, isNewUser: Bool) {
        return ("", false)
    }
    
    func logout() throws {
        
    }
    func reauthenticateApple(idToken: String, nonce: String) async throws {
        
    }
    
    func deleteAccount(authorizationCode: String) async throws {
        
    }
}

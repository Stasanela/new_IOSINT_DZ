class Checker {
    
    private let login = "admin"
    private let password = "admin"
    
    static let shared = Checker()
    
    private init() {}
    
    func check(login: String, password: String) -> Bool {

        return self.login == login && self.password == password
    }
}

protocol LoginViewControllerDelegate {
    func check(login: String, password: String) -> Bool
}

struct LoginInspector: LoginViewControllerDelegate {
    func check(login: String, password: String) -> Bool {
        return Checker.shared.check(login: login, password: password)
    }
}

protocol LoginFactory {
    func makeLoginInspector() -> LoginInspector
}

struct MyLoginFactory: LoginFactory {
    func makeLoginInspector() -> LoginInspector {
        return LoginInspector()
    }
}

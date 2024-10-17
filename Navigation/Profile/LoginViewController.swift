import Foundation
import UIKit

final class LoginViewController: UIViewController {
    
#if DEBUG
       var userService = TestUserService()
#else
    var userService = CurrentUserService(user: User(login: "User123", fullName: "Teo West", avatar: UIImage(named: "teo")!, status: "Online"))
#endif
    

    weak var loginDelegate: LoginViewControllerDelegate?
    

    // MARK: Visual content
    
    var loginScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var vkLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "vkLogo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var loginStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.layer.borderColor = UIColor.lightGray.cgColor
        stack.layer.borderWidth = 0.5
        stack.layer.cornerRadius = LayoutConstants.cornerRadius
        stack.distribution = .fillProportionally
        stack.backgroundColor = .systemGray6
        stack.clipsToBounds = true
        return stack
    }()
    
    var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if let pixel = UIImage(named: "blue_pixel") {
            button.setBackgroundImage(pixel, for: .normal)
        }
        button.layer.cornerRadius = LayoutConstants.cornerRadius
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        return button
    }()
    
    var loginField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = LayoutConstants.cornerRadius
        textField.backgroundColor = .white
        textField.placeholder = "Login"
        return textField
    }()
    
    var passwordField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = LayoutConstants.cornerRadius
        textField.backgroundColor = .white
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.addTarget(self, action: #selector(touchLoginButton), for: .touchUpInside)
    }
    
    // MARK: - Event handlers

    @objc private func touchLoginButton() {

        guard let login = loginField.text, !login.isEmpty else {
            showError("Please, enter a login")
            return
        }

        guard let password = passwordField.text, !password.isEmpty else {
            showError("Please, enter a password")
            return
        }
        

        if loginDelegate?.check(login: login, password: password) == true {
            if let user = userService.getUser(login: login) {
                let profileVC = ProfileViewController()
                profileVC.user = user  // Pass user to ProfileViewController
                navigationController?.setViewControllers([profileVC], animated: true)
            }
        } else {
            showError("Invalid login or password. Please, try again")
        }
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Keyboard handling
    
    @objc private func keyboardShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            loginScrollView.contentOffset.y = keyboardSize.height - (loginScrollView.frame.height - loginButton.frame.minY)
            loginScrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc private func keyboardHide(notification: NSNotification) {
        loginScrollView.contentOffset = CGPoint(x: 0, y: 0)
    }
}

// MARK: - Extension

extension LoginViewController: UITextFieldDelegate {
    
    // tap 'done' on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


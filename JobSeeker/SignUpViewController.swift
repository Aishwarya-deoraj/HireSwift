import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!

    var role: String = "recruiter"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup UI
        usernameTextField.placeholder = "Enter username"
        passwordTextField.placeholder = "Enter password"
        passwordTextField.isSecureTextEntry = true

        // Set the title based on role
        titleLabel.text = "\(role.capitalized) Sign Up"
    }

    @IBAction func signUpTapped(_ sender: UIButton) {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        guard !username.isEmpty, !password.isEmpty else {
            showAlert("Missing Info", "Please fill in both fields.")
            return
        }

        let key = "\(role)_\(username)"
        UserDefaults.standard.set(password, forKey: key)

        showAlert("Success", "Account created for \(role.capitalized). You can now log in.")
    }

    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}


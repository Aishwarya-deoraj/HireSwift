import UIKit

class LoginViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var roleSegmentedControl: UISegmentedControl! // Recruiter / Seeker

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        assert(navigationController != nil, "Embed LoginVC in a UINavigationController in Main.storyboard")

        usernameTextField.placeholder = "Name"
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true

        // Optional: default selection
        roleSegmentedControl.selectedSegmentIndex = 0
    }

    // MARK: - Actions
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        view.endEditing(true)

        let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextField.text ?? ""

        let selectedIndex = roleSegmentedControl.selectedSegmentIndex
        guard selectedIndex == 0 || selectedIndex == 1 else {
            showAlert(title: "Error", message: "Please select a role.")
            return
        }

        let role = selectedIndex == 0 ? "recruiter" : "seeker"
        let key = "\(role)_\(username)"
        let storedPassword = UserDefaults.standard.string(forKey: key)

        if storedPassword == password {
            usernameTextField.text = ""
            passwordTextField.text = ""
            selectedIndex == 0 ? showRecruiterVC() : showSeekerVC()
        } else {
            showAlert(title: "Login Failed", message: "Invalid credentials.")
        }
    }

    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else {
            fatalError("Storyboard ID for SignUpViewController not set")
        }

        // Pass the selected role (default to recruiter if not set)
        let selectedIndex = roleSegmentedControl.selectedSegmentIndex
        signUpVC.role = selectedIndex == 0 ? "recruiter" : "seeker"

        navigationController?.pushViewController(signUpVC, animated: true)
    }

    // MARK: - Navigation
    private func showRecruiterVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let recVC = storyboard.instantiateViewController(withIdentifier: "RecruiterViewController") as? RecruiterViewController else {
            fatalError("Storyboard ID for RecruiterViewController not set")
        }
        navigationController?.pushViewController(recVC, animated: true)
    }

    private func showSeekerVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tabBarVC = storyboard.instantiateViewController(withIdentifier: "JobTabBarController") as? UITabBarController else {
            fatalError("Storyboard ID for JobTabBarController not set or not a UITabBarController")
        }
        navigationController?.pushViewController(tabBarVC, animated: true)
    }

    // MARK: - Alert Helper
    private func showAlert(title: String = "Error", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}


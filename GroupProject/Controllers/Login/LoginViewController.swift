
import UIKit
import Parse
import FirebaseAuth

extension UITextField {
    func setRightView(icon: UIImage, btnView: UIButton) {
    btnView.setImage(icon, for: .normal)
    btnView.tintColor = .lightGray
    btnView.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
    self.rightViewMode = .always
    self.rightView = btnView
  }
}

class LoginViewController: UIViewController {
 
    let eyeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    {
        didSet{
            passwordField.setRightView(icon: UIImage.init(named: "eye_slash")!, btnView: eyeButton)
            passwordField.tintColor = .lightGray
            passwordField.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let placeholderU = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        usernameField.attributedPlaceholder = placeholderU;
        self.view.addSubview(usernameField)
        let placeholderP = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        passwordField.attributedPlaceholder = placeholderP;
        self.view.addSubview(passwordField)
        
        loginButton.layer.cornerRadius = 0.02 * loginButton.bounds.size.width
        loginButton.clipsToBounds = true
        

        //eyeButton.setTitle("Click Me", for: .normal)
        eyeButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(eyeButton)


        // Do any additional setup after loading t he view.
    }
    
    @objc func buttonAction(sender: UIButton!) {
        let btnsendtag: UIButton = sender
        if passwordField.isSecureTextEntry {
            //print("Success, on eye button")
            passwordField.isSecureTextEntry = false
            passwordField.setRightView(icon: UIImage.init(named: "eye_open")!, btnView: eyeButton)
        }else{
            passwordField.isSecureTextEntry = true
            passwordField.setRightView(icon: UIImage.init(named: "eye_slash")!, btnView: eyeButton)
        }
    }
    
    
    @IBAction func onSignIn(_ sender: Any) {
        let username = usernameField.text!
        let email = usernameField.text!
        let password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password){ (user, error) in
        PFUser.logInWithUsername(inBackground: email, password: password){ (user, error) in
            if user != nil{
                FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { success, Error in
                    guard let result = success, Error == nil else{
                        print("Failed to login Firebase")
                        return
                    }
                    let FBUser = success?.user
                    print("Logged in as \(FBUser)")
                    
                })
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }else{
                print("Error: \(error?.localizedDescription)")
            }
        }
        
        
        
    }
    
    

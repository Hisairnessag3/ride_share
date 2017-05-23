
import UIKit
import FirebaseAuth

class SigninVC: UIViewController {
    
    private let RIDER_SEGUE = "RiderVC"
    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    
    
    @IBAction func Login(_ sender: Any) {
        
    
    if emailTextField.text != "" && PasswordTextField.text != "" {
            
            AuthProvider.Instance.login(withEmail: emailTextField.text!, password: PasswordTextField.text!, loginHandler: {(message) in
                if message != nil {
                    self.alterTheUser(title: "Problem With Authentication", message:  message!);
                }else {
                    RideHandler.Instance.rider = self.emailTextField.text!;
                    
                    self.emailTextField.text = "";
                    self.PasswordTextField.text = "";
                    
                     self.performSegue(withIdentifier: self.RIDER_SEGUE, sender: nil);
                }
        
           });
        } else {
            alterTheUser(title: "Email and Password are required", message: "Please enter and email and password");
        }
        
    }
    
   
    
        
        
        
  
    
  
        
    @IBAction func SignUp(_ sender: Any) {
    
        
    
         
            if emailTextField.text != "" && PasswordTextField.text != "" {
            
            AuthProvider.Instance.signUp(withEmail: emailTextField.text!, password: PasswordTextField.text!, loginHandler: { (message) in
                
                if message != nil {
                    self.alterTheUser(title: "Problem with creating user", message: message!);
                    
                }else{
                    
                    RideHandler.Instance.rider = self.emailTextField.text!;
                    
                    self.emailTextField.text = "";
                    self.PasswordTextField.text = "";
                    
                    self.performSegue(withIdentifier: self.RIDER_SEGUE, sender: nil);
                }
                
            });
            
        }else {
            
            alterTheUser(title: "Email and Password are required", message: "Please enter and email and password");
            
        }
        
    }
    private func alterTheUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle:  .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    
}//class


















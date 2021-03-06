//
//  LoginViewController.m
//  InstaClone
//
//  Created by Abby Li on 7/6/21.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.usernameField.placeholder = @"Username";
    self.passwordField.placeholder = @"Password";
    self.passwordField.secureTextEntry = true;
}

- (IBAction)signUpTap:(id)sender {
    //set up alert
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Sign Up"
                                                                               message:@"Username or Password field is blank"
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle response here.
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    if ([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]) {
        [self presentViewController:alert animated:YES completion:^{
        }];
    }
    else {
        // initialize a user object
        PFUser *newUser = [PFUser user];
           
        // set user properties
        newUser.username = self.usernameField.text;
        newUser.password = self.passwordField.text;
           
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
            }
            else {
                NSLog(@"User registered successfully");
                   
                // manually segue to logged in view
                [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            }
        }];
    }
}

- (IBAction)loginTap:(id)sender {
    NSString *username = self.usernameField.text;
        NSString *password = self.passwordField.text;
        
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
            if (error != nil) {
                NSLog(@"User log in failed: %@", error.localizedDescription);
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Login"
                                                                                           message:@"Invalid username or incorrect password"
                                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                         // handle response here.
                                                                 }];
                // add the OK action to the alert controller
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:^{
                }];
            }
            else {
                NSLog(@"User logged in successfully");
                
                // display view controller that needs to shown after successful login
                [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            }
        }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

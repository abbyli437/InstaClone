//
//  UploadViewController.m
//  InstaClone
//
//  Created by Abby Li on 7/6/21.
//

#import "UploadViewController.h"
#import "UIKit/UIKit.h"
#import "SceneDelegate.h"
#import "HomeViewController.h"
#import "Post.h"
#import "ImageUtil.h"

@interface UploadViewController ()
@property (weak, nonatomic) IBOutlet UITextField *captionText;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (strong, nonatomic) UIImagePickerController *imagePickerVC;

@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.captionText.placeholder = @"Add a caption...";
    
    self.imagePickerVC = [ImageUtil makeImagePicker];
    self.imagePickerVC.delegate = self;
}

- (IBAction)didTapImage:(id)sender {
    [self presentViewController:self.imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    self.postImage.image = editedImage;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelTap:(id)sender {
    [self goHome];
}

- (IBAction)shareTap:(id)sender {
    //UIImage *img = self.postImage.image;
    UIImage *img = [ImageUtil resizeImage:self.postImage.image withSize:CGSizeMake(300, 300)];
    [Post postUserImage:img withCaption:self.captionText.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Successfully shared image!");
            [self goHome];
        }
        else {
            //display error
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                       message:error.localizedDescription
                                                                                preferredStyle:(UIAlertControllerStyleAlert)];
            // create an OK action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                     // handle response here.
                                                             }];
            // add the OK action to the alert controller
            [alert addAction:okAction];
        }
    }];
}

- (void)goHome {
    self.postImage.image = nil;
    self.captionText.text = @"";
    
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController *homeViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabNavController"];
    sceneDelegate.window.rootViewController = homeViewController;
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

//
//  ProfileViewController.m
//  InstaClone
//
//  Created by Abby Li on 7/8/21.
//

#import "ProfileViewController.h"
#import "Post.h"
#import "ProfilePostCell.h"
#import "Parse/Parse.h"
#import "ImageUtil.h"
@import Parse;

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet PFImageView *pfpImage;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) UIImagePickerController *imagePickerVC;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.authorLabel.text = [PFUser currentUser].username;
    
    // UICollectionViewDelegateFlowLayout
    // time -->
    
    //sets poster size layout
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1))/ postersPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    self.collectionView.collectionViewLayout = layout;
    
    [self getPosts];
    [self getPfp];
    
    //sets up image picker
    self.imagePickerVC = [ImageUtil makeImagePicker];
    self.imagePickerVC.delegate = self;
}

- (void)getPfp {
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    PFUser *user = [PFUser currentUser];

    // Retrieve the object by id
   [query getObjectInBackgroundWithId:user.objectId
                               block:^(PFObject *user, NSError *error) {
       self.pfpImage.file = user[@"pfp"];
       [self.pfpImage loadInBackground];
       
       NSLog(@"successfully retrieved pfp");
   }];
}

- (void)getPosts {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    
    PFUser *user = [PFUser currentUser];
    [query whereKey:@"author" equalTo:user];

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)changePfp:(id)sender {
    [self presentViewController:self.imagePickerVC animated:YES completion:nil];
}

- (void)updatePfp {
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    PFUser *user = [PFUser currentUser];
    
    //resize object and convert object to PFFile
    UIImage *img = [ImageUtil resizeImage:self.pfpImage.image withSize:CGSizeMake(300, 300)];
    NSData *imageData = UIImagePNGRepresentation(img);
    // get image data and check if that is not nil
    if (!imageData) {
        return;
    }
    
    PFFileObject *pfpObject = [PFFileObject fileObjectWithName:@"image.png" data:imageData];

     // Retrieve the object by id
    [query getObjectInBackgroundWithId:user.objectId
                                block:^(PFObject *user, NSError *error) {
         [user setObject:pfpObject forKey:@"pfp"];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        NSLog(@"successfully updated pfp");
        }];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
   
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    self.pfpImage.image = editedImage;
    [self updatePfp];
    
   
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ProfilePostCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ProfilePostCell" forIndexPath:indexPath];
    Post *post = self.posts[indexPath.item];
    
    //set up image
    cell.postImage.file = post.image;
    [cell.postImage loadInBackground];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

@end

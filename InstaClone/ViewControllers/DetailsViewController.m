//
//  DetailsViewController.m
//  InstaClone
//
//  Created by Abby Li on 7/7/21.
//

#import "DetailsViewController.h"
#import "Post.h"
#import "DateTools/DateTools.h"
@import Parse;

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet PFImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PFUser *user = self.post.author;
    if (user != nil) {
        self.authorLabel.text = user.username;
    }
    else {
        self.authorLabel.text = @"🤖";
    }
    
    NSString *likes = [NSString stringWithFormat:@"%@", self.post.likeCount];
    self.likeLabel.text = [likes stringByAppendingString:@" likes"];
    
    self.captionLabel.text = self.post.caption;
    
    //sets up post image
    self.postImage.file = self.post.image;
    [self.postImage loadInBackground];
  
    // TODO: Format and set createdAtString
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    // Convert String to Date
    NSDate *date = self.post.createdAt;
    
    // Convert Date to String
    self.timestampLabel.text = [[date shortTimeAgoSinceNow] stringByAppendingString:@" ago"];
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

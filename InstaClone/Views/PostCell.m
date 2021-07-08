//
//  PostCell.m
//  InstaClone
//
//  Created by Abby Li on 7/6/21.
//

#import "PostCell.h"
#import "Post.h"
#import "DateTools/DateTools.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPost:(Post *)post {
    _post = post;
    
    PFUser *user = post.author;
    if (user != nil) {
        self.authorLabel.text = user.username;
    }
    else {
        self.authorLabel.text = @"🤖";
    }
    
    NSString *likes = [NSString stringWithFormat:@"%@", post.likeCount];
    self.likeLabel.text = [likes stringByAppendingString:@" likes"];
    
    self.captionLabel.text = post.caption;
    
    //sets up post image
    self.postImage.file = post.image;
    [self.postImage loadInBackground];
    
    //sets up timestamp
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    // Convert String to Date
    NSDate *date = self.post.createdAt;
    // Convert Date to String
    self.timestampLabel.text = [[date shortTimeAgoSinceNow] stringByAppendingString:@" ago"];
}

@end

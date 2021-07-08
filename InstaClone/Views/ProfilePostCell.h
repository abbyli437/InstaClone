//
//  ProfilePostCell.h
//  InstaClone
//
//  Created by Abby Li on 7/8/21.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface ProfilePostCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet PFImageView *postImage;

@end

NS_ASSUME_NONNULL_END

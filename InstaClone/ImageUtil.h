//
//  ImageUtil.h
//  InstaClone
//
//  Created by Abby Li on 7/9/21.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface ImageUtil : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

+ (UIImagePickerController *)makeImagePicker;

+ (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END

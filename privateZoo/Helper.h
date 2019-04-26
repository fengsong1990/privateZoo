//
//  Helper.h
//  HttpServer
//
//  Created by itsnow on 17/5/9.
//  Copyright © 2017年 fengsong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Helper : NSObject

@property(nonatomic,copy)NSString *ftpCurrentFolderName;
+(instancetype) shareInstance;
+ (NSString *)deviceIPAdress;
//+ (NSString *)ftpCurrentFolderName:(NSString *)floderName;
- (UIImage *)fixOrientation:(UIImage *)aImage;
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image;

+(CGSize)getImageSizeWithURL:(id)imageURL;
@end

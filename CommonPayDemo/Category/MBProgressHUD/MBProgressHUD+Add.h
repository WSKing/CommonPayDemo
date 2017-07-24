//
//  MBProgressHUD+Add.h
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

typedef void (^ATProgressHUDBlock)(MBProgressHUD *hud);

#define defaultFailure (^(NSString *errorMsg) { [MBProgressHUD showMessage:errorMsg]; })
#define failureWihtHud(hud) (^(NSString *errorMsg) { [hud hideWithMessage:errorMsg completionBlock:nil]; })

#define DEFAULT_HIDE_DELAY 1
#define DEFAULT_DELAY 2
#define DEFAULT_MAX_DELAY 60
@interface MBProgressHUD (Add)
+ (MBProgressHUD *)defaultView;
+ (MBProgressHUD *)showError:(NSString *)error;
+ (MBProgressHUD *)showSuccess:(NSString *)success;
+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;
+ (MBProgressHUD *)showImage:(UIImage *)image message:(NSString *)message;
+ (MBProgressHUD *)showImage:(UIImage *)image message:(NSString *)message toView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;

+ (MBProgressHUD *)showSimpleMessage:(NSString *)message whileExecutingBlock:(ATProgressHUDBlock)block;
+ (MBProgressHUD *)showProgressMessage:(NSString *)message whileExecutingBlock:(ATProgressHUDBlock)block;
+ (MBProgressHUD *)showProgressMessage:(NSString *)message mode:(MBProgressHUDMode)mode whileExecutingBlock:(ATProgressHUDBlock)block completionBlock:(ATProgressHUDBlock)completion;

+ (MBProgressHUD *)showMessage:(NSString *)message mode:(MBProgressHUDMode)mode withBlock:(ATProgressHUDBlock)block;
+ (MBProgressHUD *)showMessage:(NSString *)message inView:(UIView *)view mode:(MBProgressHUDMode)mode withBlock:(ATProgressHUDBlock)block;
+ (MBProgressHUD *)showMessage:(NSString *)message mode:(MBProgressHUDMode)mode hideAfterDelay:(NSTimeInterval)delay withBlock:(ATProgressHUDBlock)block;

+ (MBProgressHUD *)showSimpleInView:(UIView *)view
                            message:(NSString *)message
                             detail:(NSString *)detail
                             square:(BOOL)square
                           animated:(BOOL)animated
                               mode:(MBProgressHUDMode)mode
                         customView:(UIView *)customView
                              color:(UIColor *)color
                     hideAfterDelay:(NSTimeInterval)delay
                whileExecutingBlock:(ATProgressHUDBlock)block
                    completionBlock:(ATProgressHUDBlock)completion;


- (void)hideWithSuccess:(NSString *)message completionBlock:(MBProgressHUDCompletionBlock)completion;
- (void)hideWithFailure:(NSString *)message completionBlock:(MBProgressHUDCompletionBlock)completion;
- (void)hideWithMessage:(NSString *)message completionBlock:(MBProgressHUDCompletionBlock)completion;
- (void)hideWithMessage:(NSString *)message withImage:(UIImage *)image completionBlock:(MBProgressHUDCompletionBlock)completion;
- (void)hide:(BOOL)animated withMessage:(NSString *)message withImage:(UIImage *)image afterDelay:(NSTimeInterval)delay completionBlock:(MBProgressHUDCompletionBlock)completion;
+ (void)showMessage:(NSString *)message hideAfterDelay:(NSTimeInterval)delay completionBlock:(MBProgressHUDCompletionBlock)completion;
+ (void)showMessage:(NSString *)message hideAfterDelay:(NSTimeInterval)delay withBlock:(ATProgressHUDBlock)block completionBlock:(MBProgressHUDCompletionBlock)completion;
@end

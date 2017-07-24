//
//  MBProgressHUD+Add.m
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+Add.h"

@implementation MBProgressHUD (Add)

+ (UIView *)defaultView {
    UIView *view;
    for (UIWindow * window in [UIApplication sharedApplication].windows) {
        if (!window.hidden && ![window isKindOfClass:NSClassFromString(@"MMPopupWindow")]) {
            view = window;
        }
    }
    return view;
}
#pragma mark 显示一些信息
+ (MBProgressHUD *)showError:(NSString *)error {
    return [MBProgressHUD showImage:[UIImage imageNamed:@"MBProgressHud.bundle/error"] message:error];
}
+ (MBProgressHUD *)showSuccess:(NSString *)success {
    return [MBProgressHUD showImage:[UIImage imageNamed:@"MBProgressHud.bundle/37x-Checkmark"] message:success];
}
+ (MBProgressHUD *)showMessage:(NSString *)message {
    return [MBProgressHUD showMessage:message toView:nil hideAfterDelay:DEFAULT_DELAY];
}
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    
    return [MBProgressHUD showSimpleInView:view
                                   message:message
                                    detail:nil
                                    square:NO
                                  animated:YES
                                      mode:MBProgressHUDModeText
                                customView:nil
                                     color:nil
                            hideAfterDelay:delay
                       whileExecutingBlock:nil
                           completionBlock:nil];
}
+ (MBProgressHUD *)showImage:(UIImage *)image message:(NSString *)message {
    return [MBProgressHUD showImage:image message:message toView:nil hideAfterDelay:DEFAULT_DELAY];
}
+ (MBProgressHUD *)showImage:(UIImage *)image message:(NSString *)message toView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    
    return [MBProgressHUD showSimpleInView:view
                                   message:message
                                    detail:nil
                                    square:NO
                                  animated:YES
                                      mode:MBProgressHUDModeCustomView
                                customView:[[UIImageView alloc] initWithImage:image]
                                     color:nil
                            hideAfterDelay:delay
                       whileExecutingBlock:nil
                           completionBlock:nil];
}
+ (MBProgressHUD *)showSimpleMessage:(NSString *)message whileExecutingBlock:(ATProgressHUDBlock)block{
    return [MBProgressHUD showProgressMessage:message mode:MBProgressHUDModeIndeterminate whileExecutingBlock:block completionBlock:nil];
}
+ (MBProgressHUD *)showProgressMessage:(NSString *)message whileExecutingBlock:(ATProgressHUDBlock)block {
    return [MBProgressHUD showProgressMessage:message mode:MBProgressHUDModeDeterminate whileExecutingBlock:block completionBlock:nil];
}
+ (MBProgressHUD *)showProgressMessage:(NSString *)message mode:(MBProgressHUDMode)mode whileExecutingBlock:(ATProgressHUDBlock)block completionBlock:(ATProgressHUDBlock)completion {
    
    return [MBProgressHUD showSimpleInView:nil
                                   message:message
                                    detail:nil
                                    square:NO
                                  animated:YES
                                      mode:mode
                                customView:nil
                                     color:nil
                            hideAfterDelay:0
                       whileExecutingBlock:block
                           completionBlock:completion];
}

+ (MBProgressHUD *)showMessage:(NSString *)message mode:(MBProgressHUDMode)mode withBlock:(ATProgressHUDBlock)block {
    return [MBProgressHUD showMessage:message mode:mode hideAfterDelay:DEFAULT_MAX_DELAY withBlock:block];
}
+ (MBProgressHUD *)showMessage:(NSString *)message inView:(UIView *)view mode:(MBProgressHUDMode)mode withBlock:(ATProgressHUDBlock)block {
    return [MBProgressHUD showSimpleInView:view
                                   message:message
                                    detail:nil
                                    square:NO
                                  animated:YES
                                      mode:mode
                                customView:nil
                                     color:nil
                            hideAfterDelay:DEFAULT_MAX_DELAY
                       whileExecutingBlock:block
                           completionBlock:nil];;
}
+ (MBProgressHUD *)showMessage:(NSString *)message mode:(MBProgressHUDMode)mode hideAfterDelay:(NSTimeInterval)delay withBlock:(ATProgressHUDBlock)block {
    return [MBProgressHUD showSimpleInView:nil
                                   message:message
                                    detail:nil
                                    square:NO
                                  animated:YES
                                      mode:mode
                                customView:nil
                                     color:nil
                            hideAfterDelay:delay
                       whileExecutingBlock:block
                           completionBlock:nil];
}

#pragma mark - Actions
+ (MBProgressHUD *)showSimpleInView:(UIView *)view
                            message:(NSString *)message
                             detail:(NSString *)detail
                             square:(BOOL)square
                           animated:(BOOL)animated
                               mode:(MBProgressHUDMode)mode
                         customView:(UIView *)customView
                              color:(UIColor *)color
                     hideAfterDelay:(NSTimeInterval)delay
                whileExecutingBlock:(void (^)(MBProgressHUD *hud))block
                    completionBlock:(void (^)(MBProgressHUD *hud))completion
{
    MBProgressHUD *hud;
    
    if (view == nil) {
        view = [MBProgressHUD defaultView];
    }
    
    hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.contentColor = [UIColor whiteColor];
    hud.label.text = message;
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font = [UIFont systemFontOfSize:16.0f];
    hud.detailsLabel.text = detail;
    hud.detailsLabel.textColor = [UIColor lightGrayColor];
    hud.detailsLabel.font = [UIFont systemFontOfSize:12];
    hud.square = square;
    hud.mode = mode;
    hud.customView = customView;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = color ? color : [UIColor colorWithWhite:0 alpha:0.7];
    hud.bezelView.layer.cornerRadius = 5.0f;
    hud.removeFromSuperViewOnHide = YES;
    hud.animationType = MBProgressHUDAnimationFade;
    if (delay <= 0 && block) {
        [hud showAnimated:animated];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(hud);
            }
            __weak typeof(hud) weakHud = hud;
            [hud setCompletionBlock:^{
                if (completion) {
                    __strong typeof(weakHud) strongHud = weakHud;
                    completion(strongHud);
                }
            }];
            [hud hideAnimated:YES];
        });
    }
    else {
        [hud showAnimated:animated];
        if (delay) {
            hud.userInteractionEnabled = NO;
            [hud hideAnimated:animated afterDelay:delay];
        }
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {//dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                block(hud);
            });
        }
    }
    
    return hud;
}
- (void)hideWithSuccess:(NSString *)message completionBlock:(MBProgressHUDCompletionBlock)completion {
    [self hide:YES withMessage:message withImage:[UIImage imageNamed:@"MBProgressHud.bundle/37x-Checkmark"] afterDelay:DEFAULT_HIDE_DELAY completionBlock:completion];
}
- (void)hideWithFailure:(NSString *)message completionBlock:(MBProgressHUDCompletionBlock)completion {
    [self hide:YES withMessage:message withImage:[UIImage imageNamed:@"MBProgressHud.bundle/error"] afterDelay:DEFAULT_HIDE_DELAY completionBlock:completion];
}
- (void)hideWithMessage:(NSString *)message completionBlock:(MBProgressHUDCompletionBlock)completion {
    [self hide:YES withMessage:message withImage:nil afterDelay:DEFAULT_HIDE_DELAY completionBlock:completion];
}
- (void)hideWithMessage:(NSString *)message withImage:(UIImage *)image completionBlock:(MBProgressHUDCompletionBlock)completion {
    [self hide:YES withMessage:message withImage:image afterDelay:DEFAULT_HIDE_DELAY completionBlock:completion];
}
- (void)hide:(BOOL)animated withMessage:(NSString *)message withImage:(UIImage *)image afterDelay:(NSTimeInterval)delay completionBlock:(MBProgressHUDCompletionBlock)completion {
    self.userInteractionEnabled = NO;
    if (message.length == 0 && image == nil) {
        [self hideAnimated:YES];
        return;
    }
    if (message) {
        self.label.text = message;
    }
    if (image) {
        self.customView = [[UIImageView alloc] initWithImage:image];
    }
    self.mode = MBProgressHUDModeCustomView;
    [self setCompletionBlock:completion];
    [self hideAnimated:YES afterDelay:delay];
}

+ (void)showMessage:(NSString *)message hideAfterDelay:(NSTimeInterval)delay completionBlock:(MBProgressHUDCompletionBlock)completion
{
    [MBProgressHUD showMessage:message hideAfterDelay:delay withBlock:nil completionBlock:completion];
}
+ (void)showMessage:(NSString *)message hideAfterDelay:(NSTimeInterval)delay withBlock:(ATProgressHUDBlock)block completionBlock:(MBProgressHUDCompletionBlock)completion
{
    [[MBProgressHUD showSimpleInView:nil
                             message:message
                              detail:nil
                              square:NO
                            animated:YES
                                mode:MBProgressHUDModeIndeterminate
                          customView:nil
                               color:nil
                      hideAfterDelay:delay
                 whileExecutingBlock:block
                     completionBlock:nil] setCompletionBlock:completion];
}
@end

//
//  Created by ShareSDK.cn on 13-1-14.
//  官网地址:http://www.ShareSDK.cn
//  技术支持邮箱:support@sharesdk.cn
//  官方微信:ShareSDK   （如果发布新版本的话，我们将会第一时间通过微信将版本更新内容推送给您。如果使用过程中有任何问题，也可以通过微信与我们取得联系，我们将会在24小时内给予回复）
//  商务QQ:4006852216
//  Copyright (c) 2013年 ShareSDK.cn. All rights reserved.
//
#import "UIView+Common.h"

@implementation UIView (Common)

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setWidth:(CGFloat)width
{
    CGRect newFrame = self.frame;
    newFrame.size.width = width;
    self.frame = newFrame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect newFrame = self.frame;
    newFrame.size.height = height;
    self.frame = newFrame;
}

- (void)setLeft:(CGFloat)x
{
    CGRect oldFrame = self.frame;
    CGRect newFrame = CGRectMake(x, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
    self.frame = newFrame;
}

- (void)setTop:(CGFloat)y
{
    CGRect oldFrame = self.frame;
    CGRect newFrame = CGRectMake(oldFrame.origin.x, y, oldFrame.size.width, oldFrame.size.height);
    self.frame = newFrame;
}

- (void)removeAllSubviews
{
	while (self.subviews.count) 
    {
		UIView *child = self.subviews.lastObject;
		[child removeFromSuperview];
	}
}

- (UIViewController *)getViewController {
    UIView *view = self.superview;
    while(view) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
        view = view.superview;
    }
    return nil;
}

- (UIScrollView *)getSuperScrollView{
    UIViewController *vc = [self getViewController];
    if (vc) {
        UIView * view = self.superview;
        while (view) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                for (UIScrollView *tempSv in vc.view.subviews) {
                    if (tempSv == view) {
                        return tempSv;
                    }
                }
            }
            view = view.superview;
        }
    }
    return nil;
}

- (UINavigationController *)getNavigationController {
    UIView *view = self.superview;
    while(view) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)nextResponder;
        }
        view = view.superview;
    }
    return nil;
}

+ (instancetype)cornerBadge:(CGSize)size {
    if (size.height <= 0 || size.width <= 0) {
        size = CGSizeMake(8, 8);
    }
    UIView *badge = [[self alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    badge.layer.cornerRadius = size.width/2;
    badge.backgroundColor = [UIColor redColor];
    return badge;
}

- (void)showBadge:(BOOL)badgeShow {
    [self showBadge:badgeShow withOffset:CGPointZero];
}
- (void)showBadge:(BOOL)badgeShow withOffset:(CGPoint)offset
{
    const int tag = 23977199;
    if (badgeShow) {
        UIView *badge = [self viewWithTag:tag];
        if (!badge) {
            badge = [UIView cornerBadge:CGSizeMake(8, 8)];
            badge.tag = tag;
            [self addSubview:badge];
            [badge mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(badge.superview.mas_right).offset(offset.x);
                make.centerY.equalTo(badge.superview.mas_top).offset(offset.y);
                make.width.height.equalTo(@(8));
            }];
        }
    }
    else{
        for (UIView *view in self.subviews) {
            if (view.tag == tag) {
                [view removeFromSuperview];
                break;
            }
        }
    }
}
- (UIImage *)capture {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)enumerateChildScrollViewUsingBlock:(void (^)(UIScrollView *, NSUInteger, BOOL *))block {
    __block BOOL gStop = NO;
    NSUInteger gIdx = 0;
    if (!block) {
        return;
    }
    for (UIScrollView *view in self.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            block(view, gIdx, &gStop);
            gIdx++;
            if (gStop) {
                return;
            }
        }
    }
    for (UIScrollView *view in self.subviews) {
        [view enumerateChildScrollViewUsingBlock:^(__kindof UIScrollView * _Nonnull scrollView, NSUInteger idx, BOOL * _Nonnull stop) {
            block(scrollView, gIdx + idx, &gStop);
            *stop = gStop;
        }];
    }
}
@end

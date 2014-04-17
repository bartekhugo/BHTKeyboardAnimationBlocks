//
//  UIViewController+BHTKeyboardNotifications.h
//
//  Created by Bartek Hugo Trzcinski on 16/04/14.
//  Copyright (c) 2014 Untitled Kingdom. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BHTKeyboardFrameAnimationBlock)(CGRect keyboardFrame);

@interface UIViewController (BHTKeyboardNotifications)

- (void)setKeyboardWillShowAnimationBlock:(BHTKeyboardFrameAnimationBlock)willShowBlock;
- (void)setKeyboardWillHideAnimationBlock:(BHTKeyboardFrameAnimationBlock)willHideBlock;

- (void)setKeyboardDidShowActionBlock:(BHTKeyboardFrameAnimationBlock)didShowBlock;
- (void)setKeyboardDidHideActionBlock:(BHTKeyboardFrameAnimationBlock)didHideBlock;

@end

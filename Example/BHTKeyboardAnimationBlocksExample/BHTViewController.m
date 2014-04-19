//
//  BHTViewController.m
//  BHTKeyboardAnimationBlocksExample
//
//  Created by Bartek Hugo Trzcinski on 19/04/14.
//  Copyright (c) 2014 Bartek Hugo Trzcinski. All rights reserved.
//

#import "BHTViewController.h"
#import "UIViewController+BHTKeyboardNotifications.h"

@interface BHTViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldYAlignContratint;

@end

@implementation BHTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupKeyboardAnimations];
}

- (void)setupKeyboardAnimations
{
    __weak typeof(self) wself = self;
    
    [self setKeyboardWillShowAnimationBlock:^(CGRect keyboardFrame) {
        // block to be performed during keybord appearing
        wself.textFieldYAlignContratint.constant = keyboardFrame.size.height / 2.0;
        [wself.view layoutIfNeeded];
    }];
    
    [self setKeyboardWillHideAnimationBlock:^(CGRect keyboardFrame) {
        // block to be performed during keybord disappearing
        wself.textFieldYAlignContratint.constant = 0.0;
        [wself.view layoutIfNeeded];
    }];
    
    [self setKeyboardDidShowActionBlock:^(CGRect keyboardFrame){
        // block to be performed when keyboard did appear
        wself.view.backgroundColor = [UIColor lightGrayColor
                                    ];
    }];
    
    [self setKeyboardDidHideActionBlock:^(CGRect keyboardFrame){
        // block to be performed when keyboard did hide
        wself.view.backgroundColor = [UIColor whiteColor];
        
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end

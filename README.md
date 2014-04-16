BHTKeyboardAnimationBlocks
==========================

UIViewController category making life easier when working with animation on keybard appearing/disappearing. 
Provides a simple block based API to set animations to be performed on each of UIKeyboardNotifications.

Category registers only for those notifications for which there are any blocks set.
Registering for notifications happens on `viewWillAppear:` method call and unregistering on `viewDidDisappear:` method call.

Example
==========================

> With current implementation it's important to set those blocks before `viewWillAppear:` method gets called

```objc
- (void)setupKeybaordAnimations
{
    __weak typeof(self) wself = self;
    
    [self setKeyboardWillShowAnimationBlock:^(CGRect keyboardFrame) {
        // block to be performed during keybord appearing
    }];
    
    [self setKeyboardWillHideAnimationBlock:^(CGRect keyboardFrame) {
        // block to be performed during keybord disappearing
    }];
    
    [self setKeyboardDidShowActionBlock:^(CGRect keyboardFrame){
        // block to be performed when keyboard did appear
    }];
    
    [self setKeyboardDidHideActionBlock:^(CGRect keyboardFrame){
        // block to be performed when keyboard did hide
    }];
}
```

//
//  Home.m
//  RED BOOK
//
//  Created by Naresh Kharecha on 2/2/15.
//  Copyright (c) 2015 Founders Found. All rights reserved.
//

#import "Home.h"

@interface Home () <UIViewControllerTransitioningDelegate>


@end

@implementation Home

#pragma mark - ViewLifeCycle
#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSLog(@"font fmily %@", [UIFont fontNamesForFamilyName:@"Milano-regular"]);
    [imgViewLogo setTintColor:APP_TINT_COLOR];
    [imgViewLogo setImage:IMAGE_WITH_NAME_AND_RENDER_MODE(@"app-icon", kImageRenderModeTemplate)];
    
    [Global applyPropertiesToButtons:@[btnSignUp] likeFont:@"UnDotum" fontSize:20 fontNormalColor:WHITE_COLOR fontHighlightedColor:WHITE_COLOR borderColor:APP_TINT_COLOR borderWidth:0 cornerRadius:5 normalBackgroundColor:APP_TINT_COLOR andHighlightedBackgroundColor:APP_TINT_COLOR];
    
    [Global applyPropertiesToButtons:@[btnLogin] likeFont:@"UnDotum" fontSize:20 fontNormalColor:APP_TINT_COLOR fontHighlightedColor:WHITE_COLOR borderColor:APP_TINT_COLOR borderWidth:1 cornerRadius:5 normalBackgroundColor:CLEAR_COLOR andHighlightedBackgroundColor:APP_TINT_COLOR];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [imgViewLogo setFrame:CGRectMake((self.view.frame.size.width/2) - (imgViewLogo.frame.size.width/2), (self.view.frame.size.height/2) - (imgViewLogo.frame.size.height/2), imgViewLogo.frame.size.width, imgViewLogo.frame.size.height)];
    
    [lblTitle setAlpha:0.0];
    [btnSignUp setAlpha:0.0];
    [btnLogin setAlpha:0.0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    SetStatusBarHidden(NO);
    
    SetStatusBarLightContent(NO);
    [self setNeedsStatusBarAppearanceUpdate];
    
    [UIView animateWithDuration:0.5 animations:^{
        [imgViewLogo setFrame:CGRectMake(imgViewLogo.frame.origin.x, imgViewLogo.frame.origin.y - (IsBiggerThaniPhone ? 48 : 60), imgViewLogo.frame.size.width, imgViewLogo.frame.size.height)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            [lblTitle setAlpha:1.0];
            [btnSignUp setAlpha:1.0];
            [btnLogin setAlpha:1.0];
        }];
    }];
}

#pragma mark - Action Methods
#pragma mark -
- (IBAction)btnSignUpTaped:(id)sender
{
    
}

- (IBAction)btnLogInTaped:(id)sender
{
    
}

#pragma mark - Memory Management
#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
#pragma mark -
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
//    UINavigationController *navController = segue.destinationViewController;
//    Register *detailViewController = navController.viewControllers[0];
//    
//    if ([segue.identifier isEqualToString:@"SignUp"]) {
//        [detailViewController setViewType:SIGN_UP_VIEW];
//    }
//    else if ([segue.identifier isEqualToString:@"LogIn"]) {
//        [detailViewController setViewType:LOGIN_VIEW];
//    }
//    detailViewController.transitioningDelegate = self;
//    detailViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    detailViewController.view.backgroundColor = [UIColor clearColor];
//    
//    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
//    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
//    
//    UIImage *copied = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    detailViewController.imageFromPreviousScreen = copied;
}


@end

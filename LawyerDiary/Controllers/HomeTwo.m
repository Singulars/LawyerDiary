//
//  HomeTwo.m
//  LawyerDiary
//
//  Created by Verma Mukesh on 03/08/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import "HomeTwo.h"

@interface HomeTwo () <UIViewControllerTransitioningDelegate, UITextFieldDelegate>
{
    BOOL keyboardShown;
    
    BOOL isAccessoryToolBarVisible;
}

@end

@implementation HomeTwo

@synthesize confirmationCode;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:APP_TINT_COLOR];
    
    [imgViewLogo setTintColor:APP_TINT_COLOR];
    [imgViewLogo setImage:IMAGE_WITH_NAME_AND_RENDER_MODE(@"app-icon", kImageRenderModeTemplate)];
    [tfCode setAttributedPlaceholder:[Global getAttributedString:@"Enter Code" withFont:@"HelveticaNeue-Bold" fontSize:36 fontColor:UICOLOR(42, 50, 65, 0.5) strokeColor:CLEARCOLOUR]];
    
    [tfCode setTintColor:APP_TINT_COLOR];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mobileFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [tfCode setInputAccessoryView:accessoryView];
    [self registerToReciveKeyboardNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    SetStatusBarLightContent(NO);
    
    //    if (!viewAppeared) {
    //        [imgViewLogo setFrame:CGRectMake((self.view.frame.size.width/2) - (imgViewLogo.frame.size.width/2), (self.view.frame.size.height/2) - (imgViewLogo.frame.size.height/2), imgViewLogo.frame.size.width, imgViewLogo.frame.size.height)];
    //
    //        [lblTitle setAlpha:0.0];
    //        [btnSignUp setAlpha:0.0];
    //        [btnLogin setAlpha:0.0];
    //        [tfMobile setAlpha:0.0];
    //        [imgViewLine setAlpha:0.0];
    //    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [toolbar setFrame:CGRectMake(-self.view.bounds.size.width, 0, toolbar.frame.size.width, toolbar.frame.size.height)];
    
    [scrollView setContentSize:VIEWSIZE(self.view)];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}

#pragma mark - KeyboardNotification
#pragma mark -
- (void)registerToReciveKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardNotificationObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    if (keyboardShown) {
        return;
    }
    
    NSDictionary *userInfo = [aNotification userInfo];
    
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    NSValue *animationDurationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height), 0.0);
    //    [scrollView setContentOffset:CGPointMake(ViewX(scrollView), -keyboardSize.height) animated:NO];
    
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    [UIView commitAnimations];
    
    keyboardShown = YES;
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    
    NSValue *animationDurationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [scrollView setContentInset:UIEdgeInsetsZero];
    [UIView commitAnimations];
    
    keyboardShown = NO;
}

- (IBAction)barBtnDoneTaped:(id)sender
{
    @try {
        if ([tfCode.text isEqualToString:@""]) {
            [Global showNotificationWithTitle:@"Please enter verification code" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
        }
        else if (tfCode.text.length > 0) {
            if ([confirmationCode isEqualToNumber:@(tfCode.text.integerValue)]) {
                
                [self setEditing:YES];
                
                Register *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Register"];
                [detailViewController setViewType:SIGN_UP_VIEW];
                [detailViewController setVerificationCode:confirmationCode];
                [detailViewController setUserMobile:_userMobile];
                
                detailViewController.transitioningDelegate = self;
                detailViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                detailViewController.view.backgroundColor = [UIColor clearColor];
                
                //            UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
                //            [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
                //
                //            UIImage *copied = UIGraphicsGetImageFromCurrentImageContext();
                //            UIGraphicsEndImageContext();
                
                //            detailViewController.imageFromPreviousScreen = copied;
                
                [self presentViewController:detailViewController animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }];
            }
            else {
                [Global showNotificationWithTitle:@"Please enter valid verification code" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception => %@ %@", [self class], exception);
    }
    @finally {
        
    }
}

- (void)mobileFieldValueChanged:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.25 animations:^{
        if (tfCode.text.length > 0) {
            
            if (!isAccessoryToolBarVisible) {
                isAccessoryToolBarVisible = YES;
                [toolbar setFrame:CGRectMake(0, 0, toolbar.frame.size.width, toolbar.frame.size.height)];
            }
        }
        else {
            isAccessoryToolBarVisible = NO;
            [toolbar setFrame:CGRectMake(-toolbar.frame.size.width, 0, toolbar.frame.size.width, toolbar.frame.size.height)];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

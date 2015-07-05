//
//  Home.h
//  RED BOOK
//
//  Created by Naresh Kharecha on 2/2/15.
//  Copyright (c) 2015 Founders Found. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Home : UIViewController <UIScrollViewDelegate>
{
    IBOutlet UIImageView *imgViewLogo;
    IBOutlet UILabel *lblTitle;
    IBOutlet UIButton *btnSignUp;
    IBOutlet UIButton *btnLogin;
    IBOutlet UIScrollView *scrollView;
    IBOutlet FFTextField *tfMobile;
    IBOutlet UIImageView *imgViewLine;
    
    IBOutlet UIToolbar *toolbar;
    IBOutlet UIBarButtonItem *barBtnDone;
    
    IBOutlet UIActivityIndicatorView *indicator;
}
@end

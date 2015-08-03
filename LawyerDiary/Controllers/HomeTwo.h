//
//  HomeTwo.h
//  LawyerDiary
//
//  Created by Verma Mukesh on 03/08/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTwo : UIViewController <UIScrollViewDelegate>
{
    IBOutlet UIImageView *imgViewLogo;
    IBOutlet UIScrollView *scrollView;
    IBOutlet FFTextField *tfCode;
    
    IBOutlet UIView *accessoryView;
    
    IBOutlet UIToolbar *toolbar;
    IBOutlet UIBarButtonItem *barBtnDone;
    
    IBOutlet UIActivityIndicatorView *indicator;
}

@property (nonatomic, strong) NSNumber *confirmationCode;
@property (nonatomic, strong) NSString *userMobile;

@end

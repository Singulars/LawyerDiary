//
//  Cases.m
//  LawyerDiary
//
//  Created by Naresh Kharecha on 4/26/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import "Cases.h"

@interface Cases ()
@end

@implementation Cases

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SetStatusBarLightContent(YES);
    SetStatusBarHidden(NO);
    
    [self.navigationController.navigationBar setTintColor:WHITE_COLOR];
}

#pragma mark - Actions

- (IBAction)actionToggleLeftDrawer:(id)sender {
    
    SetStatusBarLightContent(NO);
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
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
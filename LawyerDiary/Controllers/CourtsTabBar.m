//
//  CourtsTabBar.m
//  LawyerDiary
//
//  Created by Verma Mukesh on 03/08/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import "CourtsTabBar.h"

@interface CourtsTabBar ()

@end

@implementation CourtsTabBar

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBar setTranslucent:NO];
    //    [self.tabBar setBarTintColor:APP_TINT_COLOR];
    [self.tabBar setTintColor:APP_TINT_COLOR];
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

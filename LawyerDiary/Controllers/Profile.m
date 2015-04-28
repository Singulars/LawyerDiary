//
//  Profile.m
//  LawyerDiary
//
//  Created by Verma Mukesh on 28/04/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import "Profile.h"

#define degreesToRadians(degrees) (M_PI * degrees / 180.0)

@interface Profile ()
{
    BOOL isPasswordSectionExpanded;
}
@end

@implementation Profile

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:WHITE_COLOR];
    [self.navigationController.navigationBar setBarTintColor:APP_TINT_COLOR];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[Global setNavigationBarTitleTextAttributesLikeFont:APP_FONT fontColor:WHITE_COLOR andFontSize:22 andStrokeColor:CLEARCOLOUR]];
    
    [self setTitle:NSStringf(@"%@ %@", USER_OBJECT.firstName, USER_OBJECT.lastName)];
    
    [Global applyCornerRadiusToViews:@[imgeViewProfile] withRadius:imgeViewProfile.frame.size.width/2 borderColor:APP_TINT_COLOR andBorderWidth:1];
    
    [imgeViewProfile setImageWithURL:GetProPicURLForUser(USER_ID) withName:USER_OBJECT.proPic andSize:VIEWSIZE(imgeViewProfile) withPlaceholderImageName:IMG_user_placeholder_80];
    
    [tfFirstName setText:USER_OBJECT.firstName];
    [tfLastName setText:USER_OBJECT.lastName];
    [tfEmail setText:USER_OBJECT.email];
    [tfMobile setText:USER_OBJECT.mobile];
    [tfBirthdate setText:USER_OBJECT.birthdate];
    [tfRegNo setText:USER_OBJECT.registrationNo];
    [tvAddress setText:USER_OBJECT.address];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_TINT_COLOR] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:APP_TINT_COLOR]];
    
    [imgViewRowDisclosure setTintColor:APP_TINT_COLOR];
    [imgViewRowDisclosure setImage:IMAGE_WITH_NAME_AND_RENDER_MODE(IMG_row_disclosure, kImageRenderModeTemplate)];
}

#pragma mark - Actions

- (IBAction)actionToggleLeftDrawer:(id)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(self.tableView), 44)];
    [headerView setBackgroundColor:APP_TINT_COLOR];
    
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(10, headerView.frame.size.height-25, SCREEN_WIDTH(headerView)-10, 20)];
    [lblHeader setFont:FONT_WITH_NAME_SIZE(APP_FONT, 12)];
    [lblHeader setTextColor:WHITE_COLOR];
    [headerView addSubview:lblHeader];
    
    NSString *headerTitle = @"";
    switch (section) {
        case 0:
            headerTitle = @"PROFILE";
            break;
        case 1:
            headerTitle = @"UPDATE PASSWORD";
            break;
        case 2:
            headerTitle = @"FIRM INFO";
            break;
        default:
            break;
    }
    
    [lblHeader setText:headerTitle];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0;
    
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row == 0) {
                rowHeight = 88;
            }
            else {
                rowHeight = 44;
            }
        }
            break;
        case 1: {
            rowHeight = 44;
        }
            break;
        case 2: {
            if (indexPath.row == 0) {
                rowHeight = 44;
            }
            else {
                rowHeight = 88;
            }
        }
            break;
        default:
            break;
    }
    
    return rowHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = 0;
    
    switch (section) {
        case 0: {
            rowCount = 4;
        }
            break;
        case 1: {
            if (isPasswordSectionExpanded) {
                rowCount = 3;
            }
            else {
                rowCount = 1;
            }
        }
            break;
        case 2: {
            rowCount = 2;
        }
            break;
        default:
            break;
    }
    
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0:
                    return cellFirst;
                    break;
                case 1:
                    return cellEmail;
                    break;
                case 2:
                    return cellMobile;
                    break;
                case 3:
                    return cellBirthdate;
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: {
            if (isPasswordSectionExpanded) {
                switch (indexPath.row) {
                    case 0:
                        return cellChangePass;
                        break;
                    case 1:
                        return cellCurrentPass;
                        break;
                    case 2:
                        return cellNewPass;
                        break;
                    default:
                        break;
                }
            }
            else {
                switch (indexPath.row) {
                    case 0:
                        return cellChangePass;
                        break;
                    default:
                        break;
                }
            }
        }
            break;
        case 2: {
            switch (indexPath.row) {
                case 0:
                    return cellRegNo;
                    break;
                case 1:
                    return cellAdress;
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        if (isPasswordSectionExpanded) {
            NSArray *indexPathToBeDeleted = @[
                                              [NSIndexPath indexPathForRow:1 inSection:indexPath.section],
                                              [NSIndexPath indexPathForRow:2 inSection:indexPath.section],
                                              ];
            isPasswordSectionExpanded = NO;
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:indexPathToBeDeleted withRowAnimation:UITableViewRowAnimationBottom];
            [self.tableView endUpdates];
            
            [UIView animateWithDuration:0.2 animations:^{
                imgViewRowDisclosure.transform = CGAffineTransformIdentity;
            }];
        }
        else {
            NSArray *indexPathToBeAdded = @[
                                            [NSIndexPath indexPathForRow:2 inSection:indexPath.section],
                                            [NSIndexPath indexPathForRow:1 inSection:indexPath.section],
                                            ];
            isPasswordSectionExpanded = YES;
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:indexPathToBeAdded withRowAnimation:UITableViewRowAnimationTop];
            [self.tableView endUpdates];
            
            [UIView animateWithDuration:0.2 animations:^{
                imgViewRowDisclosure.transform = CGAffineTransformMakeRotation(degreesToRadians(90));
            }];
        }
    }
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

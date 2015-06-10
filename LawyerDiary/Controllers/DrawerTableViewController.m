//
//  DrawerTableViewController.m
//  LawyerDiary
//
//  Created by Naresh Kharecha on 4/26/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import "DrawerTableViewController.h"
#import "DrawerCell.h"
#import "JVFloatingDrawerViewController.h"

typedef NS_ENUM(NSUInteger, TableCellIndex) {
    kCellProfileIndex   = 0,
    kCellCaseIndex      = 1,
    kCellClientIndex    = 2,
    kCellCourtIndex         = 3
};

static const CGFloat kJVTableViewTopInset = 0.0;
static NSString * const kDrawerCellReuseIdentifier = @"DrawerCellReuseIdentifier";
static NSString * const kProfileCellReuseIdentifier = @"ProfileCellReuseIdentifier";

@interface DrawerTableViewController ()

@end

@implementation DrawerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(kJVTableViewTopInset, 0.0, 0.0, 0.0);
    self.clearsSelectionOnViewWillAppear = NO;
    
    [imgViewHeader setTintColor:APP_TINT_COLOR];
    [imgViewHeader setImage:IMAGE_WITH_NAME_AND_RENDER_MODE(@"app-icon", kImageRenderModeTemplate)];
    
    [Global applyCornerRadiusToViews:@[imgViewProPic] withRadius:imgViewProPic.frame.size.width/2 borderColor:APP_TINT_COLOR andBorderWidth:1];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:kCellCaseIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    [self updateUserDetail];
}

- (void)updateUserDetail
{
    [lblUsername setText:NSStringf(@"%@ %@", USER_OBJECT.firstName, USER_OBJECT.lastName)];
    
    [imgViewProPic setImageWithURL:[NSURL URLWithString:GetProPicURLForUser(USER_OBJECT.userId)] placeholderImage:image_placeholder_80];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0;
    if (indexPath.row == 0) {
        rowHeight = 80;
    }
    else {
        rowHeight = 60;
    }
    return rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DrawerCell *menuCell;
    if (indexPath.row != 0) {
         menuCell = [tableView dequeueReusableCellWithIdentifier:kDrawerCellReuseIdentifier forIndexPath:indexPath];
    }
    
    switch (indexPath.row) {
        case kCellProfileIndex: {
            return cellProfile;
        }
            break;
        case kCellCaseIndex: {
            menuCell.titleText = @"Cases";
            menuCell.iconImage = [UIImage imageNamed:@"icon-cases"];
        }
            break;
        case kCellClientIndex: {
            menuCell.titleText = @"Clients";
            menuCell.iconImage = [UIImage imageNamed:@"icon-clients"];
        }
            break;
        case kCellCourtIndex: {
            menuCell.titleText = @"Courts";
            menuCell.iconImage = [UIImage imageNamed:@"icon-court-small"];
        }
            break;
        default:
            break;
    }
        
    return menuCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *destinationViewController = nil;
    
    switch (indexPath.row) {
        case kCellProfileIndex: {
            destinationViewController = [APP_DELEGATE profileViewController];
        }
            break;
        case kCellCaseIndex: {
            destinationViewController = [APP_DELEGATE casesViewController];
        }
            break;
        case kCellClientIndex: {
            destinationViewController = [APP_DELEGATE clientsViewController];
        }
            break;
        case kCellCourtIndex: {
            destinationViewController = [APP_DELEGATE courtsViewController];
        }
            break;
        default:
            break;
    }
    
    [[APP_DELEGATE drawerViewController] setCenterViewController:destinationViewController];
    [APP_DELEGATE toggleLeftDrawer:self animated:YES];
    
    SetStatusBarLightContent(YES);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

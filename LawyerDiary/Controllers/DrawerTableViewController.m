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
    kCellCaseCellIndex      = 0,
    kCellClientCellIndex    = 1,
    kCellCourtIndex         = 2
};

//static const CGFloat kJVTableViewTopInset = 80.0;
static NSString * const kDrawerCellReuseIdentifier = @"DrawerCellReuseIdentifier";

@interface DrawerTableViewController ()

@end

@implementation DrawerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tableView.backgroundColor = [UIColor clearColor];
//    self.tableView.contentInset = UIEdgeInsetsMake(kJVTableViewTopInset, 0.0, 0.0, 0.0);
    self.clearsSelectionOnViewWillAppear = NO;
    
    [imgViewHeader setTintColor:APP_TINT_COLOR];
    [imgViewHeader setImage:IMAGE_WITH_NAME_AND_RENDER_MODE(@"app-icon", kImageRenderModeTemplate)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:kCellCaseCellIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - Table View Data Source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 110.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return tableHeaderView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DrawerCell *cell = [tableView dequeueReusableCellWithIdentifier:kDrawerCellReuseIdentifier forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case kCellCaseCellIndex: {
            cell.titleText = @"Cases";
            cell.iconImage = [UIImage imageNamed:@"icon-cases"];
        }
            break;
        case kCellClientCellIndex: {
            cell.titleText = @"Clients";
            cell.iconImage = [UIImage imageNamed:@"icon-clients"];
        }
            break;
        case kCellCourtIndex: {
            cell.titleText = @"Courts";
            cell.iconImage = [UIImage imageNamed:@"icon-courts"];
        }
            break;
        default:
            break;
    }
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *destinationViewController = nil;
    
    switch (indexPath.row) {
        case kCellCaseCellIndex: {
            destinationViewController = [APP_DELEGATE casesViewController];
        }
            break;
        case kCellClientCellIndex: {
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

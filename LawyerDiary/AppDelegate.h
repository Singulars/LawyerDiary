//
//  AppDelegate.h
//  LawyerDiary
//
//  Created by Singulars on 19/04/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Reachability.h"

#import "Profile.h"
#import "Subordinates.h"

#import "CasesTabBar.h"
#import "ClientsTabBarController.h"
#import "CourtsTabBar.h"

@class JVFloatingDrawerViewController;
@class JVFloatingDrawerSpringAnimator;

extern Reachability *hostReach;

typedef void(^getDeviceTokenCompletionHandler)(BOOL success);

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    getDeviceTokenCompletionHandler getDeviceTokenHandler;
}
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) UIStoryboard *mainStoryboard;
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UINavigationController *registerNavController;
@property (nonatomic, strong) UINavigationController *homeNavController;

@property (nonatomic, strong) JVFloatingDrawerViewController *drawerViewController;
@property (nonatomic, strong) JVFloatingDrawerSpringAnimator *drawerAnimator;

@property (nonatomic, strong) UIViewController *leftDrawerViewController;

@property (nonatomic, strong) CasesTabBar *casesTabBar;
@property (nonatomic, strong) ClientsTabBarController *clientsTabBar;
@property (nonatomic, strong) CourtsTabBar *courtsTabBar;

@property (nonatomic, strong) Profile *profileViewController;
@property (nonatomic, strong) Subordinates *subordinatesViewController;

- (void)registerForUserNotifications:(getDeviceTokenCompletionHandler)completionHandler;

- (void)toggleLeftDrawer:(id)sender animated:(BOOL)animated;

+ (AppDelegate *)globalDelegate;

- (void)showLogIn;
- (void)showHome;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end

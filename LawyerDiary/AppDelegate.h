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

extern Reachability *hostReach;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) UIStoryboard *storyboard;
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UINavigationController *registerNavController;
@property (nonatomic, strong) UINavigationController *homeNavController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end

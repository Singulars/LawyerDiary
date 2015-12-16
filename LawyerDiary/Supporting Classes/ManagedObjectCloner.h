//
//  ManagedObjectCloner.h
//  AnyWordz
//
//  Created by Singulars on 19/04/15.
//  Copyright (c) 2015 Singulars. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ManagedObjectCloner : NSObject

+ (NSManagedObject *)clone:(NSManagedObject *)source inContext:(NSManagedObjectContext *)context;

@end

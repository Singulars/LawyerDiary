//
//  ManagedObjectCloner.m
//  AnyWordz
//
//  Created by Singulars on 19/04/15.
//  Copyright (c) 2015 Singulars. All rights reserved.
//

#import "ManagedObjectCloner.h"

@implementation ManagedObjectCloner

+ (NSManagedObject *)clone:(NSManagedObject *)source inContext:(NSManagedObjectContext *)context{
    NSString *entityName = [[source entity] name];
    
    //create new object in data store
//    NSManagedObject *cloned = [NSEntityDescription
//                               insertNewObjectForEntityForName:entityName
//                               inManagedObjectContext:context];
    
    NSManagedObject *cloned = [[NSManagedObject alloc] initWithEntity:[source entity] insertIntoManagedObjectContext:nil];
    
    //loop through all attributes and assign then to the clone
    NSDictionary *attributes = [[NSEntityDescription
                                 entityForName:entityName
                                 inManagedObjectContext:context] attributesByName];
    
    for (NSString *attr in attributes) {
        [cloned setValue:[source valueForKey:attr] forKey:attr];
    }
    
    //Loop through all relationships, and clone them.
    NSDictionary *relationships = [[NSEntityDescription
                                    entityForName:entityName
                                    inManagedObjectContext:context] relationshipsByName];
    for (NSRelationshipDescription *rel in relationships){
        NSString *keyName = [NSString stringWithFormat:@"%@",rel];
        //get a set of all objects in the relationship
        NSMutableSet *sourceSet = [source mutableSetValueForKey:keyName];
        NSMutableSet *clonedSet = [cloned mutableSetValueForKey:keyName];
        NSEnumerator *e = [sourceSet objectEnumerator];
        NSManagedObject *relatedObject;
        while ( relatedObject = [e nextObject]){
            //Clone it, and add clone to set
            NSManagedObject *clonedRelatedObject = [ManagedObjectCloner clone:relatedObject
                                                                    inContext:context];
            [clonedSet addObject:clonedRelatedObject];
        }
        
    }
    
    return cloned;
}

@end

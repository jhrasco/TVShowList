//
//  NSManagedObject+Convenince.h
//  TVShowList
//
//  Created by John Harold Rasco on 22/03/2016.
//  Copyright © 2016 JRasco™. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Convenince)

/**
 *  Returns the name of the entity  or class.
 */
+ (NSString *)entityName;

/**
 *  Returns the entity descriptor of the class in managed object context.
 */
+ (NSEntityDescription *)entityDescriptionWithContext:(NSManagedObjectContext *)context;

/**
 *  Returns the object in a given managed object context, creating if necessary.
 *  Note: The object will not be saved unless the save method in the DataManager is called.
 */
+ (instancetype)insertNewObjectWithContext:(NSManagedObjectContext *)context;

/**
 *  Create an object without inserting to managed object context.
 */
+ (instancetype)newObjectWithContext:(NSManagedObjectContext *)context;

@end

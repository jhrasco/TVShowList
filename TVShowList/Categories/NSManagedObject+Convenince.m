//
//  NSManagedObject+Convenince.m
//  TVShowList
//
//  Created by John Harold Rasco on 22/03/2016.
//  Copyright © 2016 JRasco™. All rights reserved.
//

#import "NSManagedObject+Convenince.h"

@implementation NSManagedObject (Convenince)

+ (NSString *)entityName {
    return NSStringFromClass([self class]);
}

+ (NSEntityDescription *)entityDescriptionWithContext:(NSManagedObjectContext *)context {
    NSEntityDescription *entityDescription = nil;
    entityDescription = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    
    return entityDescription;
}

+ (instancetype)insertNewObjectWithContext:(NSManagedObjectContext *)context {
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
}

+ (instancetype)newObjectWithContext:(NSManagedObjectContext *)context {
    return [[self alloc] initWithEntity:[self entityDescriptionWithContext:context] insertIntoManagedObjectContext:nil];
}

@end

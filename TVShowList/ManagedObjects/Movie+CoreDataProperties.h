//
//  Movie+CoreDataProperties.h
//  TVShowList
//
//  Created by John Harold Rasco on 22/03/2016.
//  Copyright © 2016 JRasco™. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface Movie (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *channel;
@property (nullable, nonatomic, retain) NSString *endTime;
@property (nullable, nonatomic, retain) NSString *startTime;
@property (nullable, nonatomic, retain) NSString *rating;
@property (nullable, nonatomic, retain) NSNumber *page;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *movieID;

@end

NS_ASSUME_NONNULL_END

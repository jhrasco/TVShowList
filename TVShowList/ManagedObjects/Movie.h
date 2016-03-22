//
//  Movie.h
//  TVShowList
//
//  Created by John Harold Rasco on 22/03/2016.
//  Copyright © 2016 JRasco™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSManagedObject

+ (Movie *)insertMovieWithID:(NSString *)movieID
                     details:(NSDictionary *)details
                  pageNumber:(NSUInteger)pageNumber
                     context:(NSManagedObjectContext *)context;

+ (NSArray <Movie *> *)insertMoviesWithArrayOfData:(NSArray <NSDictionary *> *)array
                                        pageNumber:(NSUInteger)pageNumber
                                           context:(NSManagedObjectContext *)context;

+ (NSArray <Movie *> *)allMoviesWithContext:(NSManagedObjectContext *)context;

+ (NSUInteger)lastFetchedPageWithContext:(NSManagedObjectContext *)context;

+ (void)deleteAllMoviesWithContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "Movie+CoreDataProperties.h"

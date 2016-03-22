//
//  Movie.m
//  TVShowList
//
//  Created by John Harold Rasco on 22/03/2016.
//  Copyright © 2016 JRasco™. All rights reserved.
//

#import "Movie.h"

#import "NSManagedObject+Convenince.h"

@implementation Movie

+ (Movie *)insertMovieWithID:(NSString *)movieID
                     details:(NSDictionary *)details
                  pageNumber:(NSUInteger)pageNumber
                     context:(NSManagedObjectContext *)context {
    
    NSString *name      = details[@"name"];
    NSString *channel   = details[@"channel"];
    NSString *startTime = details[@"start_time"];
    NSString *endTime   = details[@"end_time"];
    NSString *rating    = details[@"rating"];
    NSNumber *page      = @(pageNumber);

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [[self class] entityDescriptionWithContext:context];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"movieID == %@", movieID];
    fetchRequest.fetchLimit = 1;

    NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
    Movie *movie = results.firstObject;
    
    // If no movie found, insert the object
    if (!movie) {
        movie = [[self class] insertNewObjectWithContext:context];
        movie.movieID   = movieID;
        movie.name      = name;
        movie.channel   = channel;
        movie.startTime = startTime;
        movie.endTime   = endTime;
        movie.rating    = rating;
    }
    movie.page = page;
    
    return movie;
}

+ (NSArray <Movie *> *)insertMoviesWithArrayOfData:(NSArray<NSDictionary *> *)array
                                        pageNumber:(NSUInteger)pageNumber
                                          context:(NSManagedObjectContext *)context {
    NSMutableArray *movies = [[NSMutableArray alloc] init];
    NSUInteger i = pageNumber;
    for (NSDictionary *details in array) {
        Movie *movie = [Movie insertMovieWithID:[NSString stringWithFormat:@"%lu", (unsigned long)i++]
                                        details:details
                                     pageNumber:pageNumber
                                        context:context];
        [movies addObject:movie];
    }
    return movies;
}

+ (NSUInteger)lastFetchedPageWithContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [[self class] entityDescriptionWithContext:context];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"page" ascending:NO]];
    fetchRequest.fetchLimit = 1;
    
    NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
    Movie *movie = results.firstObject;
    
    return [movie.page integerValue];
}

+ (NSArray <Movie *> *)allMoviesWithContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [[self class] entityDescriptionWithContext:context];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"movieID" ascending:YES]];
    return [context executeFetchRequest:fetchRequest error:nil];
}

+ (void)deleteAllMoviesWithContext:(NSManagedObjectContext *)context {
    NSArray *allMovies = [Movie allMoviesWithContext:context];
    for (Movie *movie in allMovies) {
        [context deleteObject:movie];
    }
}

@end

//
//  APIRequestManager.h
//  TVShowList
//
//  Created by John Harold Rasco on 22/03/2016.
//  Copyright © 2016 JRasco™. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef void(^APIRequestManagerSuccessBlock)(NSDictionary *responseObject);
typedef void(^APIRequestManagerFailureBlock)(NSError *error);

@interface APIRequestManager : AFHTTPSessionManager

+ (APIRequestManager *)sharedManager;

- (void)fetchMovieListStartingFrom:(NSUInteger)start
                           success:(APIRequestManagerSuccessBlock)success
                           failure:(APIRequestManagerFailureBlock)failure;

@end

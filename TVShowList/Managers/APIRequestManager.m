//
//  APIRequestManager.m
//  TVShowList
//
//  Created by John Harold Rasco on 22/03/2016.
//  Copyright © 2016 JRasco™. All rights reserved.
//

#import "APIRequestManager.h"

#import "AFNetworkActivityIndicatorManager.h"

typedef void (^AFRequestOperationSuccesBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void (^AFRequestOperationFailureBlock)(NSURLSessionDataTask *task, NSError *error);

static NSString * const APIBaseURL = @"https://www.whatsbeef.net";
static NSString * const APIMovieListEndpoint = @"wabz/guide.php";

@implementation APIRequestManager

+ (APIRequestManager *)sharedManager {
    static APIRequestManager * _instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:APIBaseURL]];
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    });
    return _instance;
}

#pragma mark - Private Methods

- (AFRequestOperationSuccesBlock)successCallback:(APIRequestManagerSuccessBlock)success {
    return ^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    };
}

- (AFRequestOperationFailureBlock)failureCallback:(APIRequestManagerFailureBlock)failure {
    return ^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    };
}

#pragma mark - Public Methods

- (void)fetchMovieListStartingFrom:(NSUInteger)start
                           success:(APIRequestManagerSuccessBlock)success
                           failure:(APIRequestManagerFailureBlock)failure {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:1];
    parameters[@"start"] = [NSString stringWithFormat:@"%lu", (unsigned long)start];
    
    [self GET:APIMovieListEndpoint
   parameters:parameters
     progress:nil
      success:[self successCallback:success]
      failure:[self failureCallback:failure]];
}


@end

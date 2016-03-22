//
//  DataManager.m
//  TVShowList
//
//  Created by John Harold Rasco on 22/03/2016.
//  Copyright © 2016 JRasco™. All rights reserved.
//

#import "DataManager.h"

#import "Movie.h"

static NSString * const DataModelName = @"DataModel";

@interface DataManager ()

@property (readwrite, nonatomic, strong) NSManagedObjectModel         *managedObjectModel;
@property (readwrite, nonatomic, strong) NSManagedObjectContext       *managedObjectContext;
@property (readwrite, nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSURL *applicationDocumentsDirectory;

@end

@implementation DataManager

+ (DataManager *)sharedManager {
    static DataManager * _instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

#pragma mark - Private Methods

- (NSURL *)applicationDocumentsDirectory {
    if (!_applicationDocumentsDirectory) {
        _applicationDocumentsDirectory = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
    }
    return _applicationDocumentsDirectory;
}

- (void)createCoreDataDebugFile {
    // CoreDataPro usage source: https://github.com/yepher/CoreDataUtility
    NSString *pathComponent = [NSString stringWithFormat:@"%@.sqlite", DataModelName];
    NSURL *storeURL = [self.applicationDocumentsDirectory URLByAppendingPathComponent:pathComponent];
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:DataModelName withExtension:@"momd"];
    
    NSDictionary* project = @{@"storeFilePath": storeURL.absoluteString,
                              @"storeFormat" : NSSQLiteStoreType,
                              @"modelFilePath": modelURL.absoluteString,
                              @"v" : @(1)};
    
    NSString* projectFile = @"/Users/haroldrasco/Desktop/TVShowList.cdp";
    [project writeToFile:projectFile atomically:YES];
}

#pragma mark - Core Data Stack

- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:DataModelName withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        if (self.persistentStoreCoordinator) {
            _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        }
    }
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        NSString *pathComponent = [NSString stringWithFormat:@"%@.sqlite", DataModelName];
        NSURL *storeURL = [self.applicationDocumentsDirectory URLByAppendingPathComponent:pathComponent];
        
        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        
        NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES};
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
            [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        }
#if DEBUG
        [self createCoreDataDebugFile];
#endif
    }
    return _persistentStoreCoordinator;
}

#pragma mark - Public Methods

- (BOOL)save {
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Failed to Save Data : %@", error);
    }
    return (error == nil);
}

- (void)deleteObject:(NSManagedObject *)object {
    [self.managedObjectContext deleteObject:object];
}

- (void)deleteObjects:(NSArray *)objects {
    for (NSManagedObject *object in objects) {
        [self deleteObject:object];
    }
}

- (void)deleteAllData {
    [Movie deleteAllMoviesWithContext:self.managedObjectContext];
    [self save];
}

@end

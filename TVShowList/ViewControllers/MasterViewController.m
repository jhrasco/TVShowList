//
//  MasterViewController.m
//  TVShowList
//
//  Created by John Harold Rasco on 22/03/2016.
//  Copyright © 2016 JRasco™. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#import "MovieListTableViewCell.h"
#import "MovieListHeaderTableViewCell.h"

#import "Movie.h"

#import "APIRequestManager.h"
#import "DataManager.h"

#import "NSManagedObject+Convenince.h"
#import "UIAlertController+Convenience.h"

@interface MasterViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (assign, nonatomic) BOOL isFetchingMovies;
@property (assign, nonatomic) BOOL didReachEndOfResults;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadData];
    
    if (self.fetchedResultsController.fetchedObjects.count == 0) {
        [self fetchMovieList];
    }
}

- (void)dealloc {
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    _fetchedResultsController.delegate = nil;
}

#pragma mark - Private Methods

- (void)reloadData {
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
}

- (void)showBottomActivityIndicator {
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 50.0);
    self.tableView.tableFooterView = activityIndicatorView;
    [activityIndicatorView startAnimating];
}

- (void)hideBottomActivityIndicator {
    // Remove extra line separators
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Lazy Init

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        NSManagedObjectContext *context = [DataManager sharedManager].managedObjectContext;
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[Movie entityName]];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"movieID" ascending:YES]];
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:context
                                                                          sectionNameKeyPath:@"page"
                                                                                   cacheName:nil];
        _fetchedResultsController.delegate = self;
    }
    
    return _fetchedResultsController;
}

#pragma mark - UITableViewDataSource / UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    NSInteger numericSection = [[sectionInfo name] integerValue] / 10;
    NSString *sectionTitle;
    
    if (numericSection == 0) {
        sectionTitle = @"Tonight";
    } else if (numericSection == 1) {
        sectionTitle = @"A Day From Now";
    } else {
        sectionTitle = [NSString stringWithFormat:@"%lu Days From Now", numericSection];
    }
    
    NSString *cellIdentifier = [MovieListHeaderTableViewCell cellIdentifier];
    MovieListHeaderTableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    headerView.title = sectionTitle;
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return [sectionInfo numberOfObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [MovieListTableViewCell cellIdentifier];
    MovieListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.movie = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Start fetching the next data.
    if (!self.didReachEndOfResults) {
        if (indexPath.section == self.fetchedResultsController.sections.count-1) {
            id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[indexPath.section];
            if (indexPath.row == [sectionInfo numberOfObjects]-1) {
                [self fetchMovieList];
            }
        }
    }
}

#pragma mark - Request Operations

- (void)fetchMovieList {
    if (self.isFetchingMovies) {
        return;
    }
    
    NSManagedObjectContext *context = [DataManager sharedManager].managedObjectContext;
    NSUInteger start = self.fetchedResultsController.fetchedObjects.count;
    
    [self showBottomActivityIndicator];

    self.isFetchingMovies = YES;
    
    [[APIRequestManager sharedManager] fetchMovieListStartingFrom:start
    success:^(NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);

        NSArray *results = [Movie insertMoviesWithArrayOfData:responseObject[@"results"] pageNumber:start context:context];
        [[DataManager sharedManager] save];
        
        if (results.count == 0) {
            self.didReachEndOfResults = YES;
        }
        
        self.isFetchingMovies = NO;
        [self hideBottomActivityIndicator];
        [self reloadData];
    } failure:^(NSError *error) {
        self.isFetchingMovies = NO;
        [self hideBottomActivityIndicator];
        [UIAlertController showAlertWithViewController:self
                                                 title:@"Failed to Load Movies"
                                               message:error.localizedDescription];
    }];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController *detailViewController = (DetailViewController *)[[segue destinationViewController] topViewController];
        detailViewController.movie = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
}

@end

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

#import "Movie.h"

#import "APIRequestManager.h"
#import "DataManager.h"

#import "UIAlertController+Convenience.h"

@interface MasterViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray <Movie *> *movies;

@property (assign, nonatomic) BOOL isFetchingMovies;
@property (assign, nonatomic) BOOL didReachEndOfResults;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[DataManager sharedManager] deleteAllData];
    [self reloadData];
    
    if (self.movies.count == 0) {
        [self fetchMovieList];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)reloadData {
    self.movies = [Movie allMoviesWithContext:[DataManager sharedManager].managedObjectContext];
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

#pragma mark - UITableViewDataSource / UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
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
    cell.movie = self.movies[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.movies.count-1) {
        if (!self.didReachEndOfResults) {
            [self fetchMovieList];
        }
    }
}

#pragma mark - Request Operations

- (void)fetchMovieList {
    if (self.isFetchingMovies) {
        return;
    }
    
    NSManagedObjectContext *context = [DataManager sharedManager].managedObjectContext;
    NSUInteger start = self.movies.count;
    
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
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        NSDate *object = self.objects[indexPath.row];
//        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
//        [controller setDetailItem:object];
//        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
//        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

@end

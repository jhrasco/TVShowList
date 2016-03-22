//
//  DetailViewController.m
//  TVShowList
//
//  Created by John Harold Rasco on 22/03/2016.
//  Copyright © 2016 JRasco™. All rights reserved.
//

#import "DetailViewController.h"

#import "Movie.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)configureView {
    self.navigationItem.title = self.movie.name;
    self.movieTitleLabel.text = self.movie.name;
    self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@", self.movie.startTime, self.movie.endTime];
}

@end

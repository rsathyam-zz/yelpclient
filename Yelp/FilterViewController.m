//
//  FilterViewController.m
//  Yelp
//
//  Created by Ravi Sathyam on 10/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()

@end

typedef NS_ENUM(NSInteger, FilterSectionType) {
    CATEGORIES, SORT, RADIUS, DEALS
};

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.filterTableView.delegate = self;
    self.filterTableView.dataSource = self;
}

#pragma mark - UITableViewControllerDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //Categories, Sort, Radius, Deals
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section; {
    switch(section) {
        case CATEGORIES:
            return @"Categories";
        case SORT:
            return @"Sort";
        case RADIUS:
            return @"Radius";
        case DEALS:
            return @"Deals";
        default:
            return @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  MainViewController.h
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterViewController.h"

@interface MainViewController : UIViewController<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, FilterViewControllerDelegate>
@property (strong, nonatomic) NSArray* searchData;
//@property (weak, nonatomic) IBOutlet UISearchBar *yelpSearchBar;
//@property (weak, nonatomic) UISearchBar* yelpSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

@end

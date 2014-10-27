//
//  FilterViewController.h
//  Yelp
//
//  Created by Ravi Sathyam on 10/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchCell.h"

@class FilterViewController;

@protocol FilterViewControllerDelegate <NSObject>
- (void) filtersViewController:(FilterViewController *) filtersViewController didChangeFilters:(NSDictionary *)filters;
@end

@interface FilterViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *filterTableView;
@property (nonatomic, weak) id<FilterViewControllerDelegate> delegate;
@end
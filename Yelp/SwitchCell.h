//
//  SwitchCell.h
//  Yelp
//
//  Created by Ravi Sathyam on 10/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchCell;

@protocol SwitchCellDelegate <NSObject>
- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value;
@end

@interface SwitchCell : UITableViewCell
@property (nonatomic, assign) BOOL on;
@property (weak, nonatomic) IBOutlet UILabel *switchTitleLabel;
- (IBAction)switchValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;
@property (nonatomic, weak) id<SwitchCellDelegate> delegate;
@end

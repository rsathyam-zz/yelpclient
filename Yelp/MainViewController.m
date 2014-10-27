//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "SearchTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "YelpClient.h"

NSString * const kYelpConsumerKey = @"RBzq7fFFWsh8t26AjjOEkg";
NSString * const kYelpConsumerSecret = @"35XmT0pVRYexaQ3OVDLnTh56GEo";
NSString * const kYelpToken = @"JbYKA9eZRwwj0J1SZOqNH6qbxqjrLNjL";
NSString * const kYelpTokenSecret = @"LbElGoEaw3B_lB03QNryn5X5szE";

#define kSearchTableViewCellIdentifier @"SearchTableViewCell"

@interface MainViewController ()

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray* businesses;
@property (nonatomic, strong) NSArray* data;
@property UIRefreshControl *refreshControl;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        // we use a weak reference to self so that we avoid a retain cycle
        __weak typeof(self) weakSelf = self;
        [self fetchResultsWithQuery:@"thai" withHandler:^(NSArray *results, NSError *error) {
            weakSelf.businesses = results;
            [weakSelf.searchTableView reloadData];
        }];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.yelpSearchBar.delegate = self;
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    
    [self.searchTableView registerNib:[UINib nibWithNibName:kSearchTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:kSearchTableViewCellIdentifier];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.searchTableView insertSubview:self.refreshControl atIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIRefreshControl
- (void)onRefresh
{
    // use weak reference to self to avoid retain cycles
    __weak typeof(self) weakSelf = self;
    if (!self.yelpSearchBar.text)
        return;
    
    [self fetchResultsWithQuery:self.yelpSearchBar.text withHandler:^(NSArray *results, NSError *error) {
        weakSelf.businesses = results;
        [weakSelf.searchTableView reloadData];
    }];
}

- (void)fetchResultsWithQuery:(NSString *)query withHandler:(void (^)(NSArray *results, NSError *error))handler
{
    [self.client searchWithTerm:query success:^(AFHTTPRequestOperation *operation, id response) {
        handler(response[@"businesses"], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
        handler(nil, error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.businesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchTableViewCell* stvc = [tableView dequeueReusableCellWithIdentifier:@"SearchTableViewCell" forIndexPath:indexPath];
    NSDictionary* business = self.businesses[indexPath.row];
    stvc.placeNameLabel.text = business[@"name"];
    NSURL* placeURL = [NSURL URLWithString:business[@"image_url"]];
    NSURLRequest* placeRequest = [[NSURLRequest alloc] initWithURL:placeURL];
    CGSize targetSize = stvc.placeImageView.bounds.size;
    [stvc.placeImageView setImageWithURLRequest:placeRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
        [image drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
        UIImage* resized = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [stvc.placeImageView setImage:resized];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    NSURL* ratingsURL = [NSURL URLWithString:business[@"rating_img_url"]];
    NSURLRequest* ratingsRequest = [[NSURLRequest alloc] initWithURL:ratingsURL];
    targetSize = stvc.ratingsImageView.bounds.size;
    
    [stvc.ratingsImageView setImageWithURLRequest:ratingsRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
        [image drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
        UIImage* resized = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [stvc.ratingsImageView setImage:resized];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"%@", error);
    }];

    NSString* categories = [[NSString alloc] init];
    NSArray* categories_array = business[@"categories"];
    for (int i = 0; i < categories_array.count;  i++) {
        NSArray* category = categories_array[i];
        categories = [categories stringByAppendingString:category[0]];
        if (i != categories_array.count - 1) {
            categories = [categories stringByAppendingString: @", "];
        }
    }
    NSDictionary* location = business[@"location"];
    NSArray* address = location[@"address"];
    if (address.count > 0)
        stvc.addressLabel.text = address[0];
    stvc.categoryLabel.text = categories;
    float distance = [business[@"distance"] floatValue];
    stvc.distanceLabel.text = [NSString stringWithFormat:@"%0.2f m", distance];
    return stvc;
}


#pragma mark - Search bar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString*)searchText
{
    if(searchText.length > 0)
    {
        [self.client searchWithTerm:searchText success:^(AFHTTPRequestOperation *operation, id response) {
            if (self) {
                self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
                [self.client searchWithTerm:searchText success:^(AFHTTPRequestOperation *operation, id response) {
                    self.businesses = response[@"businesses"];
                    [self.searchTableView reloadData];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"error: %@", [error description]);
                }];
            }

            [self.searchTableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", [error description]);
        }];
    }

}


@end

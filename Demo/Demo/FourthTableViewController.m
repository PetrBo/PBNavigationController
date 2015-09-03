//
//  FourthTableViewController.m
//  Demo
//
//  Created by Petr Bobak on 02.09.15.
//  Copyright (c) 2015 Petr Bobak. All rights reserved.
//

#import "FourthTableViewController.h"
#import "PBNavigationController.h"
#import "PBGradientView.h"

@interface FourthTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) PBGradientView *gradientView;

@end

@implementation FourthTableViewController {
    CGFloat kOriginalHeaderImageViewHeight;
    CGFloat kOriginalGradientViewHeight;
}

#pragma mark - Lazy Instantiation methods

- (PBGradientView *)gradientView {
    if (!_gradientView) {
        _gradientView = [[PBGradientView alloc] initWithFrame:[(PBNavigationController *)self.navigationController frameForGradientView]];
    }
    return _gradientView;
}

#pragma mark – Lifetime cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.headerImageView.clipsToBounds = YES;
    //self.headerImageView.image = nil;
    kOriginalHeaderImageViewHeight = self.headerImageView.frame.size.height;
    
    // create offsets
    UIEdgeInsets scrollInset = self.tableView.scrollIndicatorInsets;
    scrollInset.top = [[UIApplication sharedApplication] statusBarFrame].size.height;
    self.tableView.scrollIndicatorInsets = scrollInset;
    
    // top gradient
    kOriginalGradientViewHeight = self.gradientView.frame.size.height;
    [self.view addSubview:self.gradientView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell4" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"%zd", indexPath.row + 1];
    
    return cell;
}

// It is important to set "Adjust Scroll View Inset" to NO (uncheck) in storyboard.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY >= kOriginalHeaderImageViewHeight - 64.f) {
        // not transparent navigation bar
        [(PBNavigationController *)self.navigationController setDefaultBackground];
    } else {
        // transparent navigation bar
        [(PBNavigationController *)self.navigationController setTransparentBackground];
        
        // header view stretching
        CGRect frame = self.headerImageView.frame;
        frame.origin.y = offsetY;
        frame.size.height = -offsetY + kOriginalHeaderImageViewHeight;
        self.headerImageView.frame = frame;
        
        // gradient
        frame = self.gradientView.frame;
        frame.origin.y = offsetY;
        
        // prevents table cells and gradientView overlap
        if (self.headerImageView.frame.size.height <= kOriginalGradientViewHeight) {
            frame.size.height = self.headerImageView.frame.size.height;
        } else {
            frame.size.height = kOriginalGradientViewHeight;
        }
        self.gradientView.frame = frame;
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

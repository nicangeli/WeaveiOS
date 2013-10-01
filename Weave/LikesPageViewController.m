//
//  LikesPageViewController.m
//  Weave
//
//  Created by Nicholas Angeli on 01/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "LikesPageViewController.h"
#import "AppDelegate.h"

@interface LikesPageViewController ()

@end

@implementation LikesPageViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"i am loaded");
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Likes *l = [delegate likes];
    NSLog(@"%d", [l count]);
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Likes *l = [delegate likes];
    // Return the number of rows in the section.
    NSLog(@"%d",[l count]);
    return [l count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Likes *l = [delegate likes];
    static NSString *CellIdentifier = @"ProductCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    //cell.textLabel.text = [[l objectAtIndex:indexPath.row] getTitle];
    //cell.detailTextLabel.text = [[l objectAtIndex:indexPath.row] getPrice];
    Product *p = [l objectAtIndex:indexPath.row];
    UIImageView *thumbnailView = (UIImageView *)[cell viewWithTag:100];
    thumbnailView.image = [UIImage imageNamed:[p getImageUrl]];
    thumbnailView.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:101];
    titleLabel.text = [p getTitle];
    
    UILabel *typeLabel = (UILabel *)[cell viewWithTag:102];
    typeLabel.text = [p getType];
    
    UILabel *brandLabel = (UILabel *)[cell viewWithTag:103];
    brandLabel.text = [p getBrand];
    
    UILabel *priceLavel = (UILabel *)[cell viewWithTag:104];
    priceLavel.text = [p getPrice];
    
    UIButton *moreDetailsButton = (UIButton *)[cell viewWithTag:105];
    moreDetailsButton.accessibilityHint = [p getUrl];
    
    [moreDetailsButton addTarget:self action:@selector(moreDetailsPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)moreDetailsPressed:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[sender accessibilityHint]]];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Likes *l = [delegate likes];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [l removeProductAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    }

}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end

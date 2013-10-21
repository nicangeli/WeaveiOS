//
//  LikesPageViewController.m
//  Weave
//
//  Created by Nicholas Angeli on 01/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "LikesPageViewController.h"
#import "AppDelegate.h"
#import "ImageDownloader.h"
#import "ProductDetailViewController.h"

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
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weave-nav.png"]];
    [[Mixpanel sharedInstance] track:@"Likes page loaded"];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Flurry endTimedEvent:@"Products_Viewed" withParameters:nil]; // You can pass in additiona

    
    Likes *likes = [Likes instance];
    NSString *count = [NSString stringWithFormat:@"%d", [likes count]];
    NSDictionary *articleParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @"Num_Likes", count, // Capture author info
     nil];
    
    [Flurry logEvent:@"Likes_Viewed" withParameters:articleParams];
}

-(IBAction)thumbnailTapped:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    Likes *l = [Likes instance];
    NSMutableArray *likes = [l getLikes];
    Product *p = [l objectAtIndex:indexPath.row];
    //ProductDetailViewController *pdvc = [[ProductDetailViewController alloc] init];
    NSLog(@"Product is: %@", [p getTitle]);
    //pdvc.product = p;
    //[self.navigationController pushViewController:pdvc animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ProductDetailViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"detailView"];
    viewController.product = p;
    [self.navigationController pushViewController:viewController animated:YES];
    //[self presentViewController:pdvc animated:YES completion:nil];
   // [self performSegueWithIdentifier:@"MoreDetailsSegue" sender:p];
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
    NSLog(@"num of rows called now");
    Likes *likes = [Likes instance];
    // Return the number of rows in the section.
    //NSLog(@"items num %d", [likes count]);
    
    return [likes count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Likes *likes = [Likes instance];
    static NSString *CellIdentifier = @"ProductCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    int index  = [likes count] - indexPath.row -1;
    Product *p = [likes objectAtIndex:index];
    UIButton *thumbnailView = (UIButton *)[cell viewWithTag:100];
    
    [[thumbnailView imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [thumbnailView setBackgroundImage:[UIImage imageWithContentsOfFile:[p getImageUrl]] forState:UIControlStateNormal];

    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:101];
    titleLabel.text = [p getTitle];
        
    UILabel *brandLabel = (UILabel *)[cell viewWithTag:103];
    brandLabel.text = [p getBrand];
    
    UILabel *priceLavel = (UILabel *)[cell viewWithTag:104];
    priceLavel.text = [p getPrice];
    
    return cell;
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
    Likes *likes = [Likes instance];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Product *p = [likes objectAtIndex:indexPath.row];
        [likes removeProductAtIndex:indexPath.row];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [ImageDownloader deleteFileAtPath:[p getImageUrl]];
        [self saveLikes];
    }

}

-(void)saveLikes
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    /* get likes from appdelegate */
    Likes *likes = [Likes instance];
    [archiver encodeObject:likes forKey:@"Likes"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

- (NSString *)dataFilePath
{
    return [[self documentsDirectory] stringByAppendingPathComponent:@"Weave.plist"];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"MoreDetailsSegue"])
    {
        ProductDetailViewController *pvc = segue.destinationViewController;
        // get product here  = nil;
        pvc.product = sender;
        
    }
    
}

@end

//
//  ProductViewController.m
//  Weave
//
//  Created by Nicholas Angeli on 27/09/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "ProductViewController.h"

@interface ProductViewController ()

@end

@implementation ProductViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    shoeCollection = [[Collection alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)likeItem:(id)sender
{
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:1001];
    //[imageView setImage:[UIImage imageNamed:@"shoe2.jpg"]];
    NSString *image = [shoeCollection getRandomShoe];
    [self updateImageView:imageView withImageNamed:image];
    
}

-(IBAction)dislikeItem:(id)sender
{
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:1001];
    NSString *image = [shoeCollection getRandomShoe];
    [self updateImageView:imageView withImageNamed:image];


}

-(void)updateImageView:(UIImageView *)imageView withImageNamed:(NSString *)name
{
    [imageView setImage:[UIImage imageNamed:name]];
}

@end

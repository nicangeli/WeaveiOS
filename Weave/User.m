//
//  User.m
//  Weave
//
//  Created by Nicholas Angeli on 11/11/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "User.h"
#import "AppDelegate.h"

@implementation User

@synthesize categoryFilter;

+(User *)instance
{
    static User *user = nil;
    @synchronized(self)
    {
        if(!user) {
            user = [[User alloc] init];
        }
        
        return user;
    }
}

- (id)init {
    if (self = [super init]) {
        NSArray *objects = [NSArray arrayWithObjects:[NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], nil];
        
        NSArray *keys = [NSArray arrayWithObjects:@"Dresses", @"Coats", @"Shoes", @"Skirts", @"Trousers", @"Jumpers", @"Lingerie", @"Swimwear", @"Accessories", @"Tops",  nil];
        
        categoryFilter = [[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys];
    }
    return self;
}

-(void)getUserDetails
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if([appDelegate.session isOpen]) {
        [FBSession setActiveSession:appDelegate.session];
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
            if(!error) {
                NSLog(@"%@", user);
                NSString *gender = [user objectForKey:@"gender"];
                if([gender isEqualToString:@"male"]) {
                    UIAlertView *genderAlert = [[UIAlertView alloc] initWithTitle:@"Male?" message:@"Whoa - For the time being, Weave only has female clothes. Have a play anyway." delegate:nil cancelButtonTitle:@"Got it" otherButtonTitles:nil, nil];
                    [genderAlert show];
                    //[Flurry setUserID:user.email]
                }
                
                self.gender = gender;
                self.email = [user objectForKey:@"email"];
                self.name = [user objectForKey:@"name"];
                self.facebookUrl = [user objectForKey:@"link"];
                self.birthday = [user objectForKey:@"birthday"];
                [self saveUser];
                
                [Flurry setGender:gender];
                [Flurry setUserID:[user objectForKey:@"email"]];
                
            }
            else {
                NSLog(@"%@", [error localizedDescription]);
            }
        }];
    }
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self forKey:@"User"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self = [aDecoder decodeObjectForKey:@"User"];

    }
    return self;
}

-(void)setUser:(User *)user{
    self.gender = user.gender;
    self.birthday = user.birthday;
    self.name = user.name;
    self.email = user.email;
    self.facebookUrl = user.facebookUrl;
}


-(void)saveUser
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    /* get likes from appdelegate */
    User *user = [User instance];
    [archiver encodeObject:user forKey:@"User"];
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
@end

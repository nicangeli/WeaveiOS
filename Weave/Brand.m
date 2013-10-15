//
//  Brand.m
//  Weave
//
//  Created by Nicholas Angeli on 15/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "Brand.h"

@implementation Brand

-(id)initWithName:(NSString *)name andImageName:(NSString *)imageName andClickedName:(NSString *)clickedName andImageClickedName:(NSString *)imageClickedName andChecked:(BOOL)checked
{
    self = [super init];
    if(self != nil) {
        // initialization code here
        self.name = name;
        self.clickedName = clickedName;
        self.imageName = imageName;
        self.imageClickedName = imageClickedName;
        self.checked = checked;
    }
    return self;
}

-(BOOL)isChecked
{
    return self.checked;
}

-(NSString *)getName
{
    return self.name;
}

@end

//
//  Brand.h
//  Weave
//
//  Created by Nicholas Angeli on 15/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Brand : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *imageClickedName;
@property (nonatomic, strong) NSString *clickedName;
@property BOOL checked;

-(id)initWithName:(NSString *)name andImageName:(NSString *)imageName andClickedName:(NSString *)clickedName andImageClickedName:(NSString *)imageClickedName andChecked:(BOOL)checked;

-(BOOL)isChecked;
-(NSString *)getName;

@end

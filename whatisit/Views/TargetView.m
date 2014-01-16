//
//  TargetView.m
//  Anagrams
//
//  Created by Abhishek Mishra on 4/14/13.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "TargetView.h"

@implementation TargetView

- (id)initWithFrame:(CGRect)frame
{
    NSAssert(NO, @"Use initWithLetter:andSideLength instead");
    return nil;
}

//create a new target, store what letter should it match to
-(instancetype)initWithLetter:(NSString*)letter andSideLength:(float)sideLength
{
    UIImage* img = [UIImage imageNamed:@"slot"];
    self = [super initWithImage: img];
    
    if (self != nil) {
        //initialization
        self.isOccupied = NO;
        
        float scale = sideLength/img.size.width;
        self.frame = CGRectMake(0,0,img.size.width*scale, img.size.height*scale);
        
        _letter = letter;
    }
    return self;
}

//create a new target, store what letter should it match to
-(instancetype)initWithLetter:(NSString*)letter andSideLength:(float)sideLength andSideWidth:(float)sideWidth
{
    UIImage* img = [UIImage imageNamed:@"slot"];
    self = [super initWithImage: img];
    
    if (self != nil) {
        //initialization
        self.isOccupied = NO;
        
        float lengthScale = sideLength/img.size.width;
        float widthScale = sideWidth/img.size.width;
        self.frame = CGRectMake(0,0,img.size.width*widthScale, img.size.height*lengthScale);
        
        _letter = letter;
    }
    return self;
}

@end

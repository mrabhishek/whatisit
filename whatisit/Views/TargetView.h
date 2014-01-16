//
//  TargetView.h
//  Anagrams
//
//  Created by Abhishek Mishra on 4/14/13.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TargetView : UIImageView

@property(nonatomic) CGPoint           firstCenter;
@property (strong, nonatomic) NSString* letter;
@property (assign, nonatomic) BOOL isOccupied;

-(instancetype)initWithLetter:(NSString*)letter andSideLength:(float)sideLength;
-(instancetype)initWithLetter:(NSString*)letter andSideLength:(float)sideLength andSideWidth:(float)sideWidth;

@end

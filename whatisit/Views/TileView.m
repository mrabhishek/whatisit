//
//  TileView.m
//  Anagrams
//
//  Created by Abhishek Mishra on 4/13/13.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TileView.h"
#import "config.h"

@implementation TileView

int _xOffset, _yOffset;
CGAffineTransform _tempTransform;

//1
- (id)initWithFrame:(CGRect)frame
{
    NSAssert(NO, @"Use initWithLetter:andSideLength instead");
    return nil;
}

//2 create new tile for a given letter
-(instancetype)initWithLetter:(NSString*)letter andSideLength:(float)sideLength:(int)andLetterSizeMultiplier
{
    //the tile background
    UIImage* img = [UIImage imageNamed:@"tile.png"];
    
    //create a new object
    self = [super initWithImage:img];
    
    if (self != nil) {
        
        //3 resize the tile
        float scale = sideLength/img.size.width;
        self.frame = CGRectMake(0,0,img.size.width*scale, img.size.height*scale);
        
        //more initialization here
        
        //add a letter on top
        UILabel* lblChar = [[UILabel alloc] initWithFrame:self.bounds];
        lblChar.textAlignment = NSTextAlignmentCenter;
        lblChar.textColor = [UIColor yellowColor];
        lblChar.backgroundColor = [UIColor clearColor];
        lblChar.text = [letter uppercaseString];
        lblChar.font = [UIFont fontWithName:@"Verdana-Bold" size:andLetterSizeMultiplier*scale]; //78 for 1 letter
        [self addSubview: lblChar];
        
        //begin in unmatched state
        self.isMatched = NO;
        
        //save the letter
        _letter = letter;
        // enable user interaction
        self.userInteractionEnabled = YES;
        
        //create the tile shadow
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0;
        self.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
        self.layer.shadowRadius = 15.0f;
        self.layer.masksToBounds = NO;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
        self.layer.shadowPath = path.CGPath;
    }
    
    return self;
}

//2 create new tile for a given letter
-(instancetype)initWithLetter:(NSString*)letter andSideLength:(float)sideLength andSideWidth:(float)sideWidth :(int)andLetterSizeMultiplier
{
    //the tile background
    UIImage* img = [UIImage imageNamed:@"tile.png"];
    
    //create a new object
    self = [super initWithImage:img];
    
    if (self != nil) {
        
        //3 resize the tile
        float lengthScale = sideLength/img.size.width;
        float widthScale = sideWidth/img.size.width;
        self.frame = CGRectMake(0,0,img.size.width*lengthScale, img.size.height*widthScale);
        
        //more initialization here
        
        //add a letter on top
        UILabel* lblChar = [[UILabel alloc] initWithFrame:self.bounds];
        lblChar.textAlignment = NSTextAlignmentCenter;
        lblChar.textColor = [UIColor yellowColor];
        lblChar.backgroundColor = [UIColor clearColor];
        lblChar.text = [letter uppercaseString];
        lblChar.font = [UIFont fontWithName:@"Verdana-Bold" size:andLetterSizeMultiplier*widthScale]; //78 for 1 letter
        [self addSubview: lblChar];
        
        //begin in unmatched state
        self.isMatched = NO;
        
        //save the letter
        _letter = letter;
        // enable user interaction
        self.userInteractionEnabled = YES;
        
        //create the tile shadow
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0;
        self.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
        self.layer.shadowRadius = 15.0f;
        self.layer.masksToBounds = NO;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
        self.layer.shadowPath = path.CGPath;
    }
    
    return self;
}

-(void)setLetter:(NSString*)letter
{
    UILabel* lblChar = self.subviews[0];
    lblChar.text = [letter uppercaseString];
    
    //begin in unmatched state
    self.isMatched = NO;
    
    //save the letter
    _letter = letter;
    // enable user interaction
    self.userInteractionEnabled = YES;
    
    //create the tile shadow
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0;
    self.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
    self.layer.shadowRadius = 15.0f;
    self.layer.masksToBounds = NO;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowPath = path.CGPath;
    
}

-(void)randomize
{
    //1
    //set random rotation of the tile
    //anywhere between -0.2 and 0.3 radians
    float rotation = randomf(0,50) / (float)100 - 0.2;
    self.transform = CGAffineTransformMakeRotation( rotation );
    
    //2
    //move randomly upwards
    int yOffset = (arc4random() % 10) - 10;
    self.center = CGPointMake(self.center.x, self.center.y + yOffset);
}

#pragma mark - dragging the tile
//1
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt = [[touches anyObject] locationInView:self.superview];
    _xOffset = pt.x - self.center.x;
    _yOffset = pt.y - self.center.y;
    
    //show the drop shadow
    self.layer.shadowOpacity = 0.8;
    
    //save the current transform
    _tempTransform = self.transform;
    //enlarge the tile
    self.transform = CGAffineTransformScale(self.transform, 2, 2);
    [self.superview bringSubviewToFront:self];
}

//2
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt = [[touches anyObject] locationInView:self.superview];
    self.center = CGPointMake(pt.x - _xOffset, pt.y - _yOffset);
}

//3
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
    //restore the original transform
    self.transform = _tempTransform;
    
    bool shouldTileComeBackToOriginalPosition = YES;
    if(self.firstCenter.y > self.center.y - 20)
    {
        shouldTileComeBackToOriginalPosition = NO;
    }
    
    if (self.dragDelegate) {
        [self.dragDelegate tileView:self didDragToPoint:self.center:shouldTileComeBackToOriginalPosition];
    }
    self.layer.shadowOpacity = 0.0;
}

//reset the view transoform in case drag is cancelled
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.transform = _tempTransform;
    self.layer.shadowOpacity = 0.0;
}


@end
//
//  TileView.h
//  Anagrams
//
//  Created by Abhishek Mishra on 4/13/13.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TileView;

@protocol TileDragDelegateProtocol <NSObject>
-(void)tileView:(TileView*)tileView didDragToPoint:(CGPoint)pt :(bool)shouldTileComeBackToOriginalPosition;
@end

@interface TileView : UIImageView

@property(nonatomic) CGPoint           firstCenter;
@property (strong, nonatomic) NSString* letter;
@property (assign, nonatomic) BOOL isMatched;

//store the delegate
@property (retain, nonatomic) id<TileDragDelegateProtocol> dragDelegate;

-(instancetype)initWithLetter:(NSString*)letter andSideLength:(float)sideLength :(int)andLetterSizeMultiplier ;
-(instancetype)initWithLetter:(NSString*)letter andSideLength:(float)sideLength andSideWidth:(float)sideWidth :(int)andLetterSizeMultiplier;
-(void)setLetter:(NSString*)letter;
-(void)randomize;

@end

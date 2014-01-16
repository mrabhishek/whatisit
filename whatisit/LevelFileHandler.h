//
//  LevelFileHandler.h
//  whatisit
//
//  Created by Abhishek Mishra on 1/5/14.
//
//

#import <Foundation/Foundation.h>

#import "ApplicationConstants.h"

@class TargetCircle, TargetPlusShape;

@interface LevelFileHandler : NSObject

@property NSMutableArray* targetCircles;
@property NSMutableArray* targetPlusShapes;

- (id)initWithFileName:(NSString*) fileName;

@end

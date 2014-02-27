//
//  LevelCompletionDelegate.h
//  whatisit
//
//  Created by Abhishek Mishra on 1/20/14.
//
//

#import "cocos2d.h"
#import "ApplicationConstants.h"

@protocol LevelCompletionDelegate <NSObject>

-(void)levelComplete :(id)sender;
-(void)levelFailed :(id)sender;

@end

@interface LevelCompletion : CCLayer


@property (nonatomic,assign) id<LevelCompletionDelegate> delegate;

@end

//
//  Level.h
//  Anagrams
//
//  Created by Abhishek Mishra on 4/13/13.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/* 
 This is an entity for specifying episode/level information
 for menu/scene controller etc. This doesn't know anything 
 about level files etc.
 */

@interface Level : NSObject

@property (assign, nonatomic) int levelNum;
@property (assign, nonatomic) int episode;

-(id)initWithEpisode:(int)ep :(int)l ;

@end

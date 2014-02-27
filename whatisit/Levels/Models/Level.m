//
//  Level.m
//  Anagrams
//
//  Created by Abhishek Mishra on 4/13/13.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "Level.h"

@implementation Level

-(id)initWithEpisode:(int)ep :(int)l{
    self = [super init];
    if (self) {
        _episode = ep;
        _levelNum = l;
    }
    return self;
}

+(Level*)getNext:(Level*)level
{
    if(level == nil)
    {
        return [[Level alloc]initWithEpisode:1 :1];
    }
    else
    {
        if(level.levelNum >= kLevelsPerEpisode)
        {
            if(kTotalNumberOfEpisodes < ++level.episode)
            {
                return nil;
            }
            level.levelNum =1;
        }
        else
        {
            level.levelNum++;
        }
    }
    
    return level;
}

@end

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

@end

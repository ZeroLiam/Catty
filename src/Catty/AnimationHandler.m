/**
 *  Copyright (C) 2010-2013 The Catrobat Team
 *  (http://developer.catrobat.org/credits)
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  An additional term exception under section 7 of the GNU Affero
 *  General Public License, version 3, is available at
 *  (http://developer.catrobat.org/license_additional_term)
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see http://www.gnu.org/licenses/.
 */

#import "AnimationHandler.h"
#import "SpriteObject.h"

@interface AnimationHandler()

@property (nonatomic, strong) NSLock* jugglerLock;

@end


@implementation AnimationHandler

static AnimationHandler* sharedAnimationHandler = nil;

+ (AnimationHandler *) sharedAnimationHandler {
    
    @synchronized(self) {
        if (sharedAnimationHandler == nil) {
            sharedAnimationHandler = [[AnimationHandler alloc] init];
        }
    }
    
    return sharedAnimationHandler;
}


- (id)init
{
    self = [super init];
    if (self) {
        self.jugglerLock = [NSLock new];
    }
    
    return self;
}


- (void)glideToPosition:(CGPoint)position withDurationInSeconds:(float)durationInSeconds withObject:(SpriteObject*)object {
    
    SPTween *tween = [SPTween tweenWithTarget:object time:durationInSeconds];
    [tween moveToX:position.x y:position.y];
    tween.repeatCount = 1;
    [self.jugglerLock lock];
    [Sparrow.juggler addObject:tween];
    [self.jugglerLock unlock];
}


-(void)changeXBy:(float)x withObject:(SpriteObject*)object
{
    
    SPTween *tween = [SPTween tweenWithTarget:object time:0.0f];
    [tween animateProperty:@"x" targetValue:object.x+x];
    tween.repeatCount = 1;
    [self.jugglerLock lock];
    [Sparrow.juggler addObject:tween];
    [self.jugglerLock unlock];
    
}

-(void)changeYBy:(float)y withObject:(SpriteObject*)object
{
    SPTween *tween = [SPTween tweenWithTarget:object time:0.0f];
    [tween animateProperty:@"y" targetValue:object.y-y];
    tween.repeatCount = 1;
    [self.jugglerLock lock];
    [Sparrow.juggler addObject:tween];
    [self.jugglerLock unlock];
}


@end

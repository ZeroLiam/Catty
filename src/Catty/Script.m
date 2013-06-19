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


#import "Script.h"
#import "Brick.h"
#import "SpriteObject.h"
#import "LoopBeginBrick.h"
#import "LoopEndBrick.h"
#import "IfLogicBeginBrick.h"
#import "IfLogicElseBrick.h"
#import "IfLogicEndBrick.h"
#import "NoteBrick.h"
#import "NSString+CatrobatNSStringExtensions.h"
#import <objc/runtime.h>


@interface Script()

@property (nonatomic, assign) NSUInteger currentBrickIndex;
@property (nonatomic, strong) NSString* actionKey;
@property (nonatomic, strong) SKAction* startAction;

@end


@implementation Script



- (id)init
{
    if (self = [super init])
    {
        self.currentBrickIndex = 0;
        self.actionKey = [NSString uuid];
    }
    return self;
}

#pragma mark - Custom getter and setter
-(NSMutableArray*)brickList
{
    if (_brickList == nil)
        _brickList = [[NSMutableArray alloc] init];
    
    return _brickList;
}


-(SKAction*)buildActions
{   
    
    SKAction *action = nil;
    
    for (int i=[self.brickList count]-1; i>=0; i--) {
        Brick *brick = [self.brickList objectAtIndex:i];
        
        action = [brick actionWithNextAction:action actionKey:self.actionKey];
    }
    
    return action;
}

-(void)reset
{
    [self.object removeActionForKey:self.actionKey];
    for(Brick* brick in self.brickList) {
        if([brick isKindOfClass:[LoopBeginBrick class]]) {
            [((LoopBeginBrick*)brick) reset];
        }
    }

}


-(void)start
{
    if (self.startAction == nil) {
        self.startAction = [self buildActions];
    }
    
    NSDebug(@"Starting: %@", self.description);
    [self reset];
    [self.object runAction:self.startAction withKey:self.actionKey];
}


- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval
{
    //[self runNextAction];
}

                             

-(void)runWithAction:(SKAction*)action
{
    
    
//    [self.object runAction:action completion:^{
//
//        if(self.currentBrickIndex < [self.brickList count]) {
//            Brick* brick = [self.brickList objectAtIndex:self.currentBrickIndex++];
//
//            // TODO: IF/REPEAT/FOREVER
//            SKAction* action = [brick action];
//            [self runWithAction:action];
//        }
//    }];
    
}







//-(SKAction*) actionSequence
//{
//    
//    if(!_actionSequence) {
//        NSMutableArray* actionsArray = [[NSMutableArray alloc] initWithCapacity:[self.brickList count]];
//        for(int i=0; i<[self.brickList count]; i++) {
//            
//            Brick* brick = [self.brickList objectAtIndex:i];
//            
//            SKAction* action = nil;
//            if([brick isMemberOfClass:[ForeverBrick class]] ||
//               [brick isMemberOfClass:[RepeatBrick class]]){
//                action = [brick actionWithActions:[self buildActionSequenceForForLoopAndIndex:&i]];
//                
//            } else if([brick isMemberOfClass:[IfLogicBeginBrick class]]) {
//                action = [self buildActionSequenceForIf:&i];
//            }
//            
//            else {
//                action = [brick action];
//            }
//            
//            [actionsArray addObject:action];
//        
//        }
//        _actionSequence = [SKAction sequence:actionsArray];
//    }
//    
//    return _actionSequence;
//}
//
//
//-(SKAction*)buildActionSequenceForForLoopAndIndex:(int*)index;
//{
//    NSMutableArray *sequence = [[NSMutableArray alloc]init];
//
//    Brick* brick = nil;
//
//    while(![brick isMemberOfClass:[LoopEndBrick class]] && (*index) < [self.brickList count]) {
//        
//        brick = [self.brickList objectAtIndex:(*index)++];
//        SKAction* action = nil;
//        
//        if([brick isMemberOfClass:[ForeverBrick class]] ||
//           [brick isMemberOfClass:[RepeatBrick class]]){
//            action = [brick actionWithActions:[self buildActionSequenceForForLoopAndIndex:index]];
//        }
//        if([brick isMemberOfClass:[IfLogicBeginBrick class]]){
//            action = [self buildActionSequenceForIf:index];
//        }
//        
//        else {
//            action = [brick action];
//        }
//        
//        [sequence addObject:action];
//    }
//
//    return [SKAction sequence:sequence];
//    
//}
//
//-(SKAction*)buildActionSequenceForIf:(int*)index
//{
//    IfLogicBeginBrick* ifBrick = [self.brickList objectAtIndex:(*index)];
//    (*index)++;
//    SKAction* thenSequence = [self buildActionSequenceForIf:index];
//    SKAction* elseSequence = [self buildActionSequenceForThen:index];
//    
//    return [ifBrick actionWithThenAction:thenSequence andElseAction:elseSequence];
//}
//
//-(SKAction*)buildActionSequenceForThen:(int*)index
//{
//    
//    (*index)++;
//    NSMutableArray* sequence = [[NSMutableArray alloc] init];
//    
//    Brick* brick = nil;
//    
//    while(![brick isMemberOfClass:[IfLogicElseBrick class]] && (*index) < [self.brickList count]) {
//        
//        brick = [self.brickList objectAtIndex:(*index)++];
//        SKAction* action = nil;
//        
//        if([brick isMemberOfClass:[IfLogicBeginBrick class]]){
//            action = [self buildActionSequenceForIf:index];
//        }
//        
//        else if([brick isMemberOfClass:[ForeverBrick class]] ||
//           [brick isMemberOfClass:[RepeatBrick class]]){
//            action = [brick actionWithActions:[self buildActionSequenceForForLoopAndIndex:index]];
//        }
//        
//        else {
//            action = [brick action];
//        }
//        
//        [sequence addObject:action];
//        
//    }
//    
//    return [SKAction sequence:sequence];
//    
//}
//
//-(SKAction*)buildActionSequenceForElse:(int*)index
//{
//    NSMutableArray* sequence = [[NSMutableArray alloc] init];
//    
//    Brick* brick = nil;
//    
//    while(![brick isMemberOfClass:[IfLogicEndBrick class]] && (*index) < [self.brickList count]) {
//        
//        brick = [self.brickList objectAtIndex:(*index)++];
//        SKAction* action = nil;
//        
//        if([brick isMemberOfClass:[IfLogicBeginBrick class]]){
//            action = [self buildActionSequenceForIf:index];
//        }
//        
//        else if([brick isMemberOfClass:[ForeverBrick class]] ||
//                [brick isMemberOfClass:[RepeatBrick class]]){
//            action = [brick actionWithActions:[self buildActionSequenceForForLoopAndIndex:index]];
//        }
//        
//        else {
//            action = [brick action];
//        }
//        
//        [sequence addObject:action];
//        
//    }
//    
//    return [SKAction sequence:sequence];
//    
//}



//#warning remove!
//-(void)runScript
//{
//    //TODO: check loop-condition BEFORE first iteration
//    if (self.currentBrickIndex < 0)
//        self.currentBrickIndex = 0;
//    while (!self.stop && self.currentBrickIndex < [self.brickList count]) {
//        if (self.currentBrickIndex < 0)
//            self.currentBrickIndex = 0;
//        Brick *brick = [self.brickList objectAtIndex:self.currentBrickIndex];
//        
////        if([sprite.name isEqualToString:@"Spawning"])
////        {          
////            NSLog(@"Brick: %@", [brick description]);
////        }
//        
//        if ([brick isKindOfClass:[ForeverBrick class]]) {
//            
//            if (![(ForeverBrick*)brick checkConditionAndDecrementLoopCounter]) {
//                // go to end of loop
//                int numOfLoops = 1;
//                int tmpCounter = self.currentBrickIndex+1;
//                while (numOfLoops > 0 && tmpCounter < [self.brickList count]) {
//                    brick = [self.brickList objectAtIndex:tmpCounter];
//                    if ([brick isKindOfClass:[ForeverBrick class]])
//                        numOfLoops += 1;
//                    else if ([brick isMemberOfClass:[LoopEndBrick class]])
//                        numOfLoops -= 1;
//                    tmpCounter += 1;
//                }
//                self.currentBrickIndex = tmpCounter-1;
//            } else {
//                [self.startLoopIndexStack addObject:[NSNumber numberWithInt:self.currentBrickIndex]];
//                [self.startLoopTimestampStack addObject:[NSNumber numberWithDouble:[[NSDate date]timeIntervalSince1970]]];
//            }
//            
//        } else if ([brick isMemberOfClass:[LoopEndBrick class]]) {
//            
//            self.currentBrickIndex = ((NSNumber*)[self.startLoopIndexStack lastObject]).intValue-1;
//            [self.startLoopIndexStack removeLastObject];
//            
//            double startTimeOfLoop = ((NSNumber*)[self.startLoopTimestampStack lastObject]).doubleValue;
//            [self.startLoopTimestampStack removeLastObject];
//            double timeToWait = 0.02f - ([[NSDate date]timeIntervalSince1970] - startTimeOfLoop); // 20 milliseconds
////            NSLog(@"timeToWait (loop): %f", timeToWait);
//            if (timeToWait > 0)
//                [NSThread sleepForTimeInterval:timeToWait];
//            
//        } else if([brick isMemberOfClass:[IfLogicBeginBrick class]]) {
//            BOOL condition = [(IfLogicBeginBrick*)brick checkCondition];
//            if(!condition) {
//                
////                int index = [self.brickList indexOfObject:((IfLogicBeginBrick*)brick).ifElseBrick];
////                if(index <= 0 ||index > [self.brickList count]-1) {
////                    abort();
////                }
////                self.currentBrickIndex = index;
//                
//                
//#warning workaround until XML fixed    
//                
//                BOOL found = NO;
//                Brick* elseBrick = nil;
//                int ifcount = 0;
//
//                while (self.currentBrickIndex < [self.brickList count] && !found) {
//                    self.currentBrickIndex++;
//                    elseBrick = [self.brickList objectAtIndex:self.currentBrickIndex];
//                    if([elseBrick isMemberOfClass:[IfLogicBeginBrick class]]) {
//                        ifcount++;
//                    }
//                    else if([elseBrick isMemberOfClass:[IfLogicEndBrick class]]) {
//                        ifcount--;
//                    }
//                    else if([elseBrick isMemberOfClass:[IfLogicElseBrick class]] && ifcount == 0) {
//                        found = YES;
//                    }
//                }
//            }
//        } else if([brick isMemberOfClass:[IfLogicElseBrick class]]) {
//
//            
////            int index = [self.brickList indexOfObject:((IfLogicElseBrick*)brick).ifEndBrick];
////            if(index <= 0 ||index > [self.brickList count]-1) {
////                abort();
////            }
////            self.currentBrickIndex = index;
// 
//#warning workaround until XML fixed
//            int endcount = 1;
//            Brick* endBrick = nil;
//            
//            while (self.currentBrickIndex < [self.brickList count] && ![endBrick isMemberOfClass:[IfLogicEndBrick class]] && endcount != 0) {
//                self.currentBrickIndex++;
//                endBrick = [self.brickList objectAtIndex:self.currentBrickIndex];
//                if([endBrick isMemberOfClass:[IfLogicBeginBrick class]]) {
//                    endcount++;
//                }
//                else if([endBrick isMemberOfClass:[IfLogicEndBrick class]]) {
//                    endcount--;
//                }
//            }
//        } else if([brick isMemberOfClass:[IfLogicElseBrick class]]) {
//            // No action needed
//        }
//        else if(![brick isMemberOfClass:[NoteBrick class] ]) {
//            [brick performFromScript:self];
//        }
//        
//        self.currentBrickIndex += 1;
//        
//
////        NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!! currentBrickIndex=%d", self.currentBrickIndex);
//    }
//}


#pragma mark - Description
-(NSString*)description
{
    NSMutableString *ret = [[NSMutableString alloc] initWithString:@"Script"];
    
    if ([self.brickList count] > 0)
    {
        [ret appendString:@"Bricks: \r"];
        for (Brick *brick in self.brickList)
        {
            [ret appendFormat:@"%@\r", brick];
        }
    }
    else 
    {
        [ret appendString:@"Bricks array empty!\r"];
    }
    
    return ret;
}




@end

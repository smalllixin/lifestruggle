//
//  LifeStruggleView.m
//  coderetreat
//
//  Created by lixin on 11/15/14.
//  Copyright (c) 2014 whisper. All rights reserved.
//

#import "LifeStruggleView.h"
@interface LifeStruggleView()
@property (nonatomic, assign) NSInteger worldWidth;
@property (nonatomic, assign) NSInteger worldHeight;
@property (nonatomic, strong) NSMutableArray *world;
@property (nonatomic, strong) NSMutableArray *nextWorld;
@property (nonatomic, assign) NSInteger worldTotalSize;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation LifeStruggleView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _worldWidth = frame.size.width;
        _worldHeight = frame.size.height;
        self.worldTotalSize = _worldWidth*_worldHeight;
        
        self.world = [[NSMutableArray alloc] initWithCapacity:self.worldTotalSize];
        self.nextWorld = [[NSMutableArray alloc] initWithCapacity:self.worldTotalSize];
        [self buildWorld];
    }
    return self;
}

- (void)buildWorld
{
    for (int i = 0; i < _worldTotalSize; i ++) {
        self.world[i] = @(0);
    }
    for (int i = 1000; i <1000+ 200; i ++){
        self.world[i] = @(1);
    }
}

- (void)startWorld
{
    if (self.timer) {
        [self.timer invalidate];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeTick:) userInfo:nil repeats:YES];
    [self buildWorld];
}

- (void)stopWorld
{
    [self.timer invalidate];
}

- (NSInteger)howManyLivesAroundWithX:(NSInteger)x y:(NSInteger)y
{
    return [self cellAtX:x-1 y:y-1] +
            [self cellAtX:x y:y-1] +
            [self cellAtX:x+1 y:y] +
            [self cellAtX:x-1 y:y] +
            [self cellAtX:x+1 y:y] +
            [self cellAtX:x-1 y:y+1] +
            [self cellAtX:x y:y+1] +
            [self cellAtX:x+1 y:y+1];
}

// 1 for alive | 0 for dead
- (NSInteger)adjustDestiny:(NSInteger)idx
{
    NSInteger x = idx%_worldWidth;
    NSInteger y = idx/_worldWidth;
    BOOL isAlive = [self cellAtX:x y:y];
    NSInteger aliveCount = [self howManyLivesAroundWithX:x y:y];
    if (isAlive) {
        if (aliveCount == 2|aliveCount == 3) {
            return 1;
        } else {
            return 0;
        }
    } else {
        if (aliveCount == 3) {
            return 1;
        } else {
            return 0;
        }
    }
}

- (NSInteger)cellAtX:(NSInteger)x y:(NSInteger)y
{
    NSInteger idx = y * _worldWidth + x;
    if (idx < 0 || idx >= _worldTotalSize) {
        return 0;
    }
    return [_world[idx] integerValue];
}

- (void)timeTick:(NSTimer*)t
{
    for (int i = 0; i < _worldTotalSize; i ++) {
        NSInteger aliveForNext = [self adjustDestiny:[_world[i] integerValue]];
        _nextWorld[i] = @(aliveForNext);
    }
    for (int i = 0; i < _worldTotalSize; i ++) {
        _world[i] = _nextWorld[i];
    }
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    for (int i = 0; i < _worldTotalSize; i ++) {
        NSInteger isDrawPoint = [_world[i] integerValue];
        if (isDrawPoint) {
            NSInteger x = i%_worldWidth;
            NSInteger y = i/_worldWidth;
            CGContextFillRect(context, CGRectMake(x,y,1,1));
//            NSLog(@"%ld,%ld",x,y);
        }
    }
    
    
}

@end

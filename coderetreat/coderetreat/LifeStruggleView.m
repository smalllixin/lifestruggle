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
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) BOOL isWorldStop;
@end

const NSInteger PointInPixels = 10;

@implementation LifeStruggleView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _worldWidth = frame.size.width/PointInPixels;
        _worldHeight = frame.size.height/PointInPixels;
        self.worldTotalSize = _worldWidth*_worldHeight;
        
        self.world = [[NSMutableArray alloc] initWithCapacity:self.worldTotalSize];
        self.nextWorld = [[NSMutableArray alloc] initWithCapacity:self.worldTotalSize];
        [self buildWorld];
    }
    return self;
}

- (void)fillPointWithTouch:(UITouch*)touch {
    CGPoint touchLocation = [touch locationInView:self];
    NSInteger idx = round(touchLocation.x/PointInPixels) + round(touchLocation.y/PointInPixels)*_worldWidth;
    if (idx < _worldTotalSize)
        _world[idx] = @(1);

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isWorldStop = YES;
    [self fillPointWithTouch:[[event allTouches] anyObject]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self fillPointWithTouch:[[event allTouches] anyObject]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isWorldStop = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isWorldStop = NO;
}

- (void)buildWorld
{
    for (int i = 0; i < _worldTotalSize; i ++) {
        self.world[i] = @(0);
    }
}

- (void)startWorld
{
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(timeTick:)];
    displayLink.frameInterval = 5;
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    _displayLink = displayLink;
}

- (void)stopWorld
{
    _displayLink.paused = YES;
}

- (NSInteger)howManyLivesAroundWithX:(NSInteger)x y:(NSInteger)y
{
    return [self cellAtX:x-1 y:y-1] +
            [self cellAtX:x y:y-1] +
            [self cellAtX:x+1 y:y-1] +
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
    NSInteger isAlive = [self cellAtX:x y:y];
    NSInteger aliveCount = [self howManyLivesAroundWithX:x y:y];
    if (isAlive) {
        if (aliveCount == 2 || aliveCount == 3) {
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
    
    if (x < 0 || y < 0 || x >= _worldWidth || y >= _worldHeight) {
        return 0;
    }
    NSInteger idx = y * _worldWidth + x;
    return [_world[idx] integerValue];
}

- (void)dumpWorld
{
    NSMutableString *ms = [[NSMutableString alloc] initWithCapacity:255];
    for (int i = 0; i < _worldTotalSize; i ++) {
        if (i % _worldWidth == 0) {
            [ms appendString:@"\n"];
        }
        [ms appendFormat:@"%@", _world[i]];
    }
    NSLog(@"%@", ms);
}

- (void)timeTick:(id)t
{
    if (!_isWorldStop) {
        for (int i = 0; i < _worldTotalSizef; i ++) {
            NSInteger aliveForNext = [self adjustDestiny:i];
            _nextWorld[i] = @(aliveForNext);
        }
    
    
        NSMutableArray *temp = _nextWorld;
        _nextWorld = _world;
        _world = temp;
    }

    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, rect);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    for (int i = 0; i < _worldTotalSize; i ++) {
        NSInteger isDrawPoint = [_world[i] integerValue];
        if (isDrawPoint) {
            NSInteger x = i%_worldWidth;
            NSInteger y = i/_worldWidth;
            CGContextFillRect(context, CGRectMake(x*PointInPixels+1,y*PointInPixels+1,PointInPixels-1,PointInPixels-1));
        }
    }
    
    
}

@end

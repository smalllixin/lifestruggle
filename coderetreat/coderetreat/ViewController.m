//
//  ViewController.m
//  coderetreat
//
//  Created by lixin on 11/15/14.
//  Copyright (c) 2014 whisper. All rights reserved.
//

#import "ViewController.h"
#import "LifeStruggleView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic, strong) LifeStruggleView *worldView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    LifeStruggleView *worldView = [[LifeStruggleView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:worldView];
    [_button addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
    _worldView = worldView;
    [_worldView startWorld];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnPress:(id)sender
{
    
}

@end

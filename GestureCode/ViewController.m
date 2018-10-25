//
//  ViewController.m
//  GestureCode
//
//  Created by Sean on 2018/10/25.
//  Copyright © 2018 private. All rights reserved.
//

#import "ViewController.h"
#import "SLGestureCodeView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = false;
    
    //Do any additional setup after loading the view, typically from a nib.
    SLGestureCodeView *gestureCodeView = [[SLGestureCodeView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:gestureCodeView];
}


@end

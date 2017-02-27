//
//  ViewController.m
//  Practice超级猜图
//
//  Created by 王为 on 17/2/27.
//  Copyright © 2017年 王为. All rights reserved.
//

#import "ViewController.h"
#import "Question.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *questions;
@property (nonatomic,assign) int index;
@property (weak, nonatomic) IBOutlet UILabel *lblIndex;
@property (weak, nonatomic) IBOutlet UIButton *btnScore;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnIcon;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *cover;
@property (nonatomic, assign)CGRect iconFrame;

- (IBAction)btnNextClick;
- (IBAction)zoomImg:(UIButton *)sender;
- (IBAction)btnIcon:(UIButton *)sender;

@end

@implementation ViewController

-(NSArray *)questions{
    if(_questions == nil){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"questions.plist" ofType:nil];
        NSArray *arryDict = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *arrayModel = [NSMutableArray array];
        
        for(NSDictionary *dict in arryDict){
            Question *model = [Question questionWithDict:dict];
            [arrayModel addObject:model];
        }
        
        _questions = arrayModel;
    }
    return _questions;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.index = -1;
    [self nextQuesion];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnNextClick {
    [self nextQuesion];
}

- (IBAction)zoomImg:(UIButton *)sender {
    
    [self zoomUp];
    
}

- (IBAction)btnIcon:(UIButton *)sender {
    if(self.cover == nil){
        [self zoomUp];
    }else{
        [self zoomDown];
    }
}


-(void) zoomUp{
    self.iconFrame = self.btnIcon.frame;
    
    UIButton *cover = [[UIButton alloc]init];
    self.cover = cover;
    cover.frame = self.view.bounds;
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.0;
    [self.view addSubview:cover];
    
    [cover addTarget:self action:@selector(zoomDown) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view bringSubviewToFront:self.btnIcon];
    
    CGFloat iconW = self.view.frame.size.width;
    CGFloat iconH = iconW;
    CGFloat iconX = 0;
    CGFloat iconY = (self.view.frame.size.height - iconH) * 0.5;
    
    [UIView animateWithDuration:0.7 animations:^{
        self.btnIcon.frame = CGRectMake(iconX, iconY, iconW, iconH);
        cover.alpha = 0.6;
    }];

}


-(void) zoomDown{
    [UIView animateWithDuration:0.7 animations:^{
        self.btnIcon.frame = self.iconFrame;
        self.cover.alpha = 0.0;
    }completion:^(BOOL finished) {
        if(finished){
            [self.cover removeFromSuperview];
            self.cover = nil;
        }
    }];
}

-(void) nextQuesion{
    self.index++;
    
    Question *model = self.questions[self.index];
    [self.lblIndex setText:[NSString stringWithFormat:@"%d/%ld",self.index+1,self.questions.count]];
    self.lblTitle.text = model.title;
    [self.btnIcon setImage:[UIImage imageNamed:model.icon ] forState:UIControlStateNormal];
    
    self.btnNext.enabled = (self.index != self.questions.count - 1);
}
@end

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

@property (weak, nonatomic) IBOutlet UIView *answerView;
@property (weak, nonatomic) IBOutlet UIView *optionsView;

@property (weak, nonatomic) IBOutlet UIButton *cover;
@property (nonatomic, assign)CGRect iconFrame;

@property (nonatomic, assign)int answerIndex;

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
    self.answerIndex = 0;
    self.index++;
    Question *model = self.questions[self.index];
    
    [self updateUpPart:model];
    [self updateAnswer:model];
    [self updateOptions:model];
    
    
}

-(void) updateUpPart:(Question *)model{
    [self.lblIndex setText:[NSString stringWithFormat:@"%d/%ld",self.index+1,self.questions.count]];
    self.lblTitle.text = model.title;
    [self.btnIcon setImage:[UIImage imageNamed:model.icon ] forState:UIControlStateNormal];
    
    self.btnNext.enabled = (self.index != self.questions.count - 1);
}

-(void) updateAnswer:(Question *)model{
    NSInteger len = model.answer.length;
    CGFloat margin = 10;
    CGFloat answerW = 35;
    CGFloat answerH = 35;
    CGFloat answerY = 0;
    CGFloat marginLeft = (self.answerView.frame.size.width - (len * answerW) - (len - 1) * margin) / 2;
    
    [self.answerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for(int i = 0; i < len; i++){
        UIButton *btnAnswer = [[UIButton alloc]init];
        
        [btnAnswer setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        
        [btnAnswer setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateHighlighted];
        
        CGFloat answerX = marginLeft + i * (answerW + margin);
        
        btnAnswer.frame = CGRectMake(answerX, answerY, answerW, answerH);
        [btnAnswer setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnAnswer addTarget:self action:@selector(answerClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.answerView addSubview:btnAnswer];
    }
}

-(void) updateOptions:(Question *)model{
    CGFloat optionW = 35;
    CGFloat optionH = 35;
    CGFloat margin = 10;
    int columnNum = 7;
    CGFloat optionMarginLeft = (self.optionsView.frame.size.width - (columnNum * optionW) - (columnNum-1) * margin)/2;
    
    NSInteger optionNum = model.options.count;
    
    [self.optionsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for(int i = 0; i < optionNum; i++){
        int coluId = i % columnNum;
        int rowId = i / columnNum;
        
        CGFloat optionX = optionMarginLeft + coluId * (margin + optionW);
        CGFloat optionY = rowId * (margin + optionH) + margin;
        
        UIButton *optBtn = [[UIButton alloc]init];
        optBtn.frame = CGRectMake(optionX, optionY, optionW, optionH);
        [optBtn setTitle:model.options[i] forState:UIControlStateNormal];
        [optBtn setBackgroundImage:[UIImage imageNamed:@"btn_option"] forState:UIControlStateNormal];
        [optBtn setBackgroundImage:[UIImage imageNamed:@"btn_option_highlighted"] forState:UIControlStateHighlighted];
        [optBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [optBtn addTarget:self action:@selector(optionClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.optionsView addSubview:optBtn];
    }

}

-(void) optionClicked:(UIButton *)opt{
    self.answerIndex++;
    opt.hidden = YES;
    
    BOOL isFull = YES;
    
    NSString *optText = opt.currentTitle;
    for(UIButton *btn in self.answerView.subviews){
        if(btn.currentTitle == nil){
            [btn setTitle:optText forState:UIControlStateNormal];
            break;
        }
    }
    
    for(UIButton *btn in self.answerView.subviews){
        if(btn.currentTitle == nil){
            isFull = NO;
            break;
        }
    }
    
    if(isFull){
        self.optionsView.userInteractionEnabled = NO;
    }
}

-(void) answerClicked:(UIButton *)ans{
    
    [self showAlter];
    
    if(ans.currentTitle != nil){
        NSString *text = ans.currentTitle;
        [ans setTitle:nil forState:UIControlStateNormal];
        for(UIButton *btn in self.optionsView.subviews){
            if(btn.currentTitle == text){
                btn.hidden = NO;
                self.optionsView.userInteractionEnabled = YES;
            }
        }
    }
}

-(void) showAlter{
    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"Tips" message:@"Congratulation" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Other", nil];
    [alter show];
    
}
@end

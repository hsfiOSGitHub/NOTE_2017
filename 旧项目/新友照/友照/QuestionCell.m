//
//  QuestionCell.m
//  友照
//
//  Created by monkey2016 on 16/12/7.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "QuestionCell.h"

#import "QuestionCell_question.h"
#import "QuestionCell_answer.h"
#import "QUestionCell_explain.h"
#import "QuestionCell_commit.h"


@interface QuestionCell ()

@end

static NSString *identifierQuestion = @"identifierQuestion";
static NSString *identifierAnswer = @"identifierAnswer";
static NSString *identifierExplain = @"identifierExplain";
static NSString *identifierCommit = @"identifierCommit";
@implementation QuestionCell

#pragma mark -懒加载
-(NSMutableArray *)seleteStateArr{
    if (!_seleteStateArr) {
        _seleteStateArr = [NSMutableArray arrayWithObjects:@"0", @"0", @"0", @"0", nil];//0代表还没选择；1代表选对了；2代表选错了 3代表已选择但还没有判断对错（用于多选） 4代表多选时 选择了但是没选完全正确
    }
    return _seleteStateArr;
}
-(NSMutableArray *)seleteCellArr{
    if (!_seleteCellArr) {
        _seleteCellArr = [NSMutableArray arrayWithObjects:@"0", @"0", @"0", @"0", nil];//0代表还没选择；1代表选了；
    }
    return _seleteCellArr;
}
-(NSArray *)seleteStateArr_copy{
    if (!_seleteStateArr_copy) {
        _seleteStateArr_copy = [NSArray array];
    }
    return _seleteStateArr_copy;
}
-(NSMutableArray *)currentAnswer{
    if (!_currentAnswer) {
        _currentAnswer = [NSMutableArray array];
    }
    return _currentAnswer;
}


#pragma mark -awakeFromNib
- (void)awakeFromNib {
    [super awakeFromNib];
    //配置tableView
    [self setUpTableView];
    
    
}
//配置tableView
-(void)setUpTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //高度
    self.tableView.estimatedRowHeight = 44; 
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([QuestionCell_question class]) bundle:nil] forCellReuseIdentifier:identifierQuestion];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([QuestionCell_answer class]) bundle:nil] forCellReuseIdentifier:identifierAnswer];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([QUestionCell_explain class]) bundle:nil] forCellReuseIdentifier:identifierExplain];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([QuestionCell_commit class]) bundle:nil] forCellReuseIdentifier:identifierCommit];
}

#pragma mark -UITableViewDelegate,UITableViewDataSource
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isShowExplain) {
        if ([self.Q_Model.Type isEqualToString:@"1"] || [self.Q_Model.Type isEqualToString:@"2"]) {//判断题  单选题
            return 3;
        }else if ([self.Q_Model.Type isEqualToString:@"3"]) {//多选题
            return 4;
        }
    }else{
        if ([self.Q_Model.Type isEqualToString:@"1"] || [self.Q_Model.Type isEqualToString:@"2"]) {//判断题  单选题
            return 2;
        }else if ([self.Q_Model.Type isEqualToString:@"3"]) {//多选题
            return 3;
        }
    }
    return 0;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        if ([self.Q_Model.Type isEqualToString:@"1"]) {//判断题
            return 2;
        }else if ([self.Q_Model.Type isEqualToString:@"2"]) {//单选题
            return 4;
        }else if ([self.Q_Model.Type isEqualToString:@"3"]) {//多选题
            return 4;
        }
    }else if (section == 2) {
        return 1;
    }else if (section == 3) {
        return 1;
    }
    return 0;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        QuestionCell_question *questionCell = [tableView dequeueReusableCellWithIdentifier:identifierQuestion forIndexPath:indexPath];
        questionCell.backgroundColor = [UIColor clearColor];        
        //题目类型
        NSString *type = @"";
        if ([self.Q_Model.Type isEqualToString:@"1"]) {//判断题
            type = @"（判断题）";
        }else if ([self.Q_Model.Type isEqualToString:@"2"]) {//单选题
            type = @"（单选题）";
        }else if ([self.Q_Model.Type isEqualToString:@"3"]) {//多选题
            type = @"（多选题）";
        }
        //题号
        NSString *question_id = [NSString stringWithFormat:@"%ld",(long)(self.currentIndex + 1)];
        //完整的题目
        NSString *allStr = [NSString stringWithFormat:@"%@%@、%@",type,question_id,self.Q_Model.Question];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:allStr];
        [attrStr addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:17.0f]
                        range:NSMakeRange(0, 5)];
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:KRGB(77, 153, 235, 1)
                        range:NSMakeRange(0, 5)];
        questionCell.questionStr.attributedText = attrStr;
        //加载图片或视频
        if (self.Q_Model.sinaimg) {
            questionCell.sinaimgViewHeightCons.constant = 180;
            [self setNeedsLayout];
            //先将原来的移除
//            [[NSNotificationCenter defaultCenter] removeObserver:self];
            questionCell.sinaimgView.image = nil;
            //判断是视频还是图片
            NSString *pathStr = [[NSBundle mainBundle] pathForResource:self.Q_Model.sinaimg ofType:nil];
            if ([self.Q_Model.sinaimg containsString:@".webp"]) {//图片>>>>>>>>>>>>>>>>>
                [questionCell.contentView bringSubviewToFront:questionCell.sinaimgView];
                questionCell.sinaimgView.image = [UIImage imageWithWebP:pathStr];
            }else if ([self.Q_Model.sinaimg containsString:@".mp4"]) {//视频<<<<<<<<<<<<<<<<<<<
                questionCell.sinaimgView.image = nil;
                [questionCell.contentView bringSubviewToFront:questionCell.movieView];
                //添加视频播放器
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //先将原来的view移除
                    NSArray *subViews = questionCell.movieView.subviews;
                    if (subViews.count > 0) {
                        for (UIView *view in subViews) {
                            [view removeFromSuperview];
                        }
                    }
                    //创建新的view来装播放器
                    UIView *view = [[UIView alloc]initWithFrame:questionCell.movieView.bounds];
                    [questionCell.movieView addSubview:view];
                    //创建播放器
                    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:pathStr]];
                    [item seekToTime:kCMTimeZero];
                    _avPlayer = [[AVPlayer alloc] initWithPlayerItem:item];
                    _avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
                    _avPlayerLayer.videoGravity=AVLayerVideoGravityResizeAspect;//视频填充模式
                    _avPlayerLayer.frame = questionCell.movieView.bounds;
                    [view.layer addSublayer:_avPlayerLayer];
                    [_avPlayer play];
                    //添加播放完成通知
                    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_avPlayer.currentItem];
                }); 
            }
        }else{
            questionCell.sinaimgViewHeightCons.constant = 0;
            [self setNeedsLayout];
        }
        
        return questionCell;
    }else if (indexPath.section == 1) {
        QuestionCell_answer *answerCell = [tableView dequeueReusableCellWithIdentifier:identifierAnswer forIndexPath:indexPath];
        answerCell.backgroundColor = [UIColor clearColor];
        //赋值
        if ([self.Q_Model.Type isEqualToString:@"1"]) {//判断题
            if (indexPath.row == 0) {
                answerCell.optionStr.text = @"A、正确";
            }else if (indexPath.row == 1) {
                answerCell.optionStr.text = @"B、错误";
            }
        }else if ([self.Q_Model.Type isEqualToString:@"2"] || [self.Q_Model.Type isEqualToString:@"3"]) {//选择题(单双)
            if (indexPath.row == 0) {
                answerCell.optionStr.text = [NSString stringWithFormat:@"A、%@",self.Q_Model.An1];
            }else if (indexPath.row == 1) {
                answerCell.optionStr.text = [NSString stringWithFormat:@"B、%@",self.Q_Model.An2];
            }else if (indexPath.row == 2) {
                answerCell.optionStr.text = [NSString stringWithFormat:@"C、%@",self.Q_Model.An3];
            }else if (indexPath.row == 3) {
                answerCell.optionStr.text = [NSString stringWithFormat:@"D、%@",self.Q_Model.An4];
            }
        }
        //确认是否选择
        if ([self.seleteCellArr[indexPath.row] isEqualToString:@"0"]) {//选中了cell
            answerCell.bgView.backgroundColor = [UIColor clearColor];
        }else if ([self.seleteCellArr[indexPath.row] isEqualToString:@"1"]) {//没有选中cell
            answerCell.bgView.backgroundColor = KRGB(241, 241, 241, 1);
        }
        //确认seleteBtn的图片
        NSArray *seleteState_current = self.seleteStateArr;
        if (self.isShowExplain) {
            if ([self.Q_Model.status isEqualToString:@"0"]) {
                seleteState_current = [self getRightSeleteStateArr];
            }else{//
                if ([HSFValueHelper sharedHelper].isReset) {
                    seleteState_current = [self getRightSeleteStateArr];
                }else{
                    seleteState_current = self.seleteStateArr;
                }
            }
        }else{
            seleteState_current = self.seleteStateArr;
        }
        if ([self.Q_Model.Type isEqualToString:@"1"] || [self.Q_Model.Type isEqualToString:@"2"]) {//判断题  单选题
            NSString *seleteState = seleteState_current[indexPath.row];
            if ([seleteState isEqualToString:@"0"]) {//没有选择
                [answerCell.seleteBtn setImage:[UIImage imageNamed:@"选择_单选"] forState:UIControlStateNormal];
                answerCell.optionStr.textColor = KRGB(60, 60, 60, 1);
            }else if ([seleteState isEqualToString:@"1"]) {//选对了
                [answerCell.seleteBtn setImage:[UIImage imageNamed:@"正确_单选"] forState:UIControlStateNormal];
                answerCell.optionStr.textColor = KRGB(23, 163, 14, 1);
            }else if ([seleteState isEqualToString:@"2"]) {//选错了
                [answerCell.seleteBtn setImage:[UIImage imageNamed:@"错误_单选"] forState:UIControlStateNormal];
                answerCell.optionStr.textColor = KRGB(206, 31, 111, 1);
            }
        }else if ([self.Q_Model.Type isEqualToString:@"3"]) {//多选题
            NSString *seleteState = seleteState_current[indexPath.row];
            if ([seleteState isEqualToString:@"0"]) {//没有选择
                [answerCell.seleteBtn setImage:[UIImage imageNamed:@"选择_多选"] forState:UIControlStateNormal];
                answerCell.optionStr.textColor = KRGB(60, 60, 60, 1);
            }else if ([seleteState isEqualToString:@"1"]) {//选对了
                [answerCell.seleteBtn setImage:[UIImage imageNamed:@"正确_多选"] forState:UIControlStateNormal];
                answerCell.optionStr.textColor = KRGB(23, 163, 14, 1);
            }else if ([seleteState isEqualToString:@"2"]) {//选错了
                [answerCell.seleteBtn setImage:[UIImage imageNamed:@"错误_多选"] forState:UIControlStateNormal];
                answerCell.optionStr.textColor = KRGB(206, 31, 111, 1);
            }else if ([seleteState isEqualToString:@"3"]) {//已选择
                [answerCell.seleteBtn setImage:[UIImage imageNamed:@"选择_多选0"] forState:UIControlStateNormal];
                answerCell.optionStr.textColor = [UIColor blackColor];
            }
        }
        //seleteBtn的点击事件
        [answerCell.seleteBtn setTag:100 + indexPath.row];
        [answerCell.seleteBtn addTarget:self action:@selector(seleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        //判断是否可以用户交互(显示详解时不能点击)
        if (self.isPracticeMode) {
            if ([self.Q_Model.status isEqualToString:@"0"]) {
                answerCell.userInteractionEnabled = YES;
            }else{
                answerCell.userInteractionEnabled = NO;
            }
        }else{
            answerCell.userInteractionEnabled = NO;
        }
        
        return answerCell;
    }else if (indexPath.section == 2) {
        if ([self.Q_Model.Type isEqualToString:@"1"] || [self.Q_Model.Type isEqualToString:@"2"]) {//判断题  判断题
            QUestionCell_explain *explainCell = [tableView dequeueReusableCellWithIdentifier:identifierExplain forIndexPath:indexPath];
            explainCell.backgroundColor = [UIColor clearColor];
            NSMutableString *mtStr = [NSMutableString stringWithString:self.Q_Model.explain];
            NSRange range = {0,mtStr.length};
            [mtStr replaceOccurrencesOfString:@"\\n"withString:@"\n" options:NSLiteralSearch range:range];
            explainCell.explainStr.text = mtStr;
            explainCell.yourAnswer.text = [self getYourAnswer];
            explainCell.rightAnswer.text = [self getRightAnswer];
            if (self.isShowExplain) {
                if ([self.Q_Model.status isEqualToString:@"0"]) {
                    explainCell.yourAnswer.hidden = YES;
                    explainCell.yourAnswerTitle.hidden = YES;
                    explainCell.finishImgView.image = [UIImage imageNamed:@"未完成"];
                }else{
                    if ([HSFValueHelper sharedHelper].isReset) {
                        explainCell.yourAnswer.hidden = YES;
                        explainCell.yourAnswerTitle.hidden = YES;
                        explainCell.finishImgView.image = [UIImage imageNamed:@"未完成"];
                    }else{
                        explainCell.yourAnswer.hidden = NO;
                        explainCell.yourAnswerTitle.hidden = NO;
                        explainCell.finishImgView.image = [UIImage imageNamed:@"完成"];
                    }
                }
            }else{
                explainCell.yourAnswer.hidden = NO;
                explainCell.yourAnswerTitle.hidden = NO;
                explainCell.finishImgView.image = [UIImage imageNamed:@""];
            }
            return explainCell;
        }else if ([self.Q_Model.Type isEqualToString:@"3"]) {//多选题  (提交按钮)
            QuestionCell_commit *commitCell = [tableView dequeueReusableCellWithIdentifier:identifierCommit forIndexPath:indexPath];
            commitCell.backgroundColor = [UIColor clearColor];
            //提交按钮添加点击事件
            [commitCell.commitBtn addTarget:self action:@selector(commitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            //判断是否可以用户交互(显示详解时不能点击)
            if (self.isPracticeMode) {
                if ([self.Q_Model.status isEqualToString:@"0"]) {
                    commitCell.commitBtn.userInteractionEnabled = YES;
                }else{
                    commitCell.commitBtn.userInteractionEnabled = NO;
                }
            }else{
                commitCell.commitBtn.userInteractionEnabled = NO;
            }
            return commitCell;
        }
        
    }else if (indexPath.section == 3) {
        QUestionCell_explain *explainCell = [tableView dequeueReusableCellWithIdentifier:identifierExplain forIndexPath:indexPath];
        explainCell.backgroundColor = [UIColor clearColor];
        explainCell.explainStr.text = self.Q_Model.explain;
        explainCell.yourAnswer.text = [self getYourAnswer];
        explainCell.rightAnswer.text = [self getRightAnswer];
        if (self.isShowExplain) {
            if ([self.Q_Model.status isEqualToString:@"0"]) {
                explainCell.yourAnswer.hidden = YES;
                explainCell.yourAnswerTitle.hidden = YES;
                explainCell.finishImgView.image = [UIImage imageNamed:@"未完成"];
            }else{
                if ([HSFValueHelper sharedHelper].isReset) {
                    explainCell.yourAnswer.hidden = YES;
                    explainCell.yourAnswerTitle.hidden = YES;
                    explainCell.finishImgView.image = [UIImage imageNamed:@"未完成"];
                }else{
                    explainCell.yourAnswer.hidden = NO;
                    explainCell.yourAnswerTitle.hidden = NO;
                    explainCell.finishImgView.image = [UIImage imageNamed:@"完成"];
                }
            }
        }else{
            explainCell.yourAnswer.hidden = NO;
            explainCell.yourAnswerTitle.hidden = NO;
            explainCell.finishImgView.image = [UIImage imageNamed:@""];
        }
        return explainCell;
    }
    return nil;
}

//获取你选的答案
-(NSString *)getYourAnswer{
    NSString *yourAnswer = [NSString string];
    NSArray *arr = self.currentAnswer.mutableCopy;
    NSArray *sortedArr = [arr sortedArrayUsingSelector:@selector(compare:)];//排序
    for (NSString *answerStr in sortedArr) {
        NSString *optionStr = @"";
        if ([answerStr isEqualToString:@"1"]) {
            optionStr = @"A";
        }else if ([answerStr isEqualToString:@"2"]) {
            optionStr = @"B";
        }else if ([answerStr isEqualToString:@"3"]) {
            optionStr = @"C";
        }else if ([answerStr isEqualToString:@"4"]) {
            optionStr = @"D";
        }
        yourAnswer = [NSString stringWithFormat:@"%@%@",yourAnswer,optionStr];
    }
    return yourAnswer;
}
//获取正确答案
-(NSString *)getRightAnswer{
    NSString *rightAnswer = self.Q_Model.AnswerTrue;
    NSString *rightOptionAnswer = [NSString string];
    for (int i = 0; i < rightAnswer.length; i++) {
        NSString *subStr = [rightAnswer substringWithRange:NSMakeRange(i, 1)];
        NSString *optionStr = @"";
        if ([subStr isEqualToString:@"1"]) {
            optionStr = @"A";
        }else if ([subStr isEqualToString:@"2"]) {
            optionStr = @"B";
        }else if ([subStr isEqualToString:@"3"]) {
            optionStr = @"C";
        }else if ([subStr isEqualToString:@"4"]) {
            optionStr = @"D";
        }
        rightOptionAnswer = [NSString stringWithFormat:@"%@%@",rightOptionAnswer,optionStr];
    }
    return rightOptionAnswer;
}
//获取正确的seleteStateArr
-(NSMutableArray *)getRightSeleteStateArr{
    NSString *rightAnswer = self.Q_Model.AnswerTrue;
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"0", @"0", @"0", @"0", nil];//0代表还没选择；1代表选对了；2代表选错了 3代表已选择但还没有判断对错（用于多选）
    for (int i = 0; i < rightAnswer.length; i++) {
        NSString *subStr = [rightAnswer substringWithRange:NSMakeRange(i, 1)];
        NSInteger index = [subStr integerValue] - 1;
        [arr replaceObjectAtIndex:index withObject:@"1"];
    }
    return arr;
}
//提交按钮点击事件
-(void)commitBtnAction:(UIButton *)sender{    
    NSString *rightAnswer = self.Q_Model.AnswerTrue;
    //遍历
    NSMutableArray *isAllRightArr = [NSMutableArray array];
    for (NSString *yourAnswer in self.currentAnswer) {
        NSString * isAllRight = @"1";
        if ([rightAnswer containsString:yourAnswer]) {
            isAllRight = @"1";
        }else{
            isAllRight = @"0";
        }
        [isAllRightArr addObject:isAllRight];
    }
    if ([isAllRightArr containsObject:@"0"]) {//选错了 、有一题选错了
        //答错时显示详解
        [self showRightAnswer];
        if ([self.agency respondsToSelector:@selector(changeShowExplainArrWith:)]) {
            [self.agency changeShowExplainArrWith:self.currentIndex];
            //更改题目状态（已做/未做）
            self.Q_Model.status = @"2";
            [[ZXTopicManager sharedTopicManager] updateTopicStatus:self.Q_Model];
        }
        
    }else{
        //判断是否全选对了（完全正确）
        NSInteger count = rightAnswer.length;
        if (isAllRightArr.count == count) {//（完全正确）
            //显示正确答案呢
            [self showRightAnswer];
            [self.tableView reloadData];
            //下一题
            if ([self.agency respondsToSelector:@selector(jumpToNextQuestionWith:)]) {
                [self.agency jumpToNextQuestionWith:self.currentIndex];
                //更改题目状态（已做/未做）
                self.Q_Model.status = @"1";
                [[ZXTopicManager sharedTopicManager] updateTopicStatus:self.Q_Model];
            }
        }else{//答案不对，显示详解
            [self showRightAnswer];
            if ([self.agency respondsToSelector:@selector(changeShowExplainArrWith:)]) {
                [self.agency changeShowExplainArrWith:self.currentIndex];
                //更改题目状态（已做/未做）
                self.Q_Model.status = @"2";
                [[ZXTopicManager sharedTopicManager] updateTopicStatus:self.Q_Model];
            }
        }
    }
    
}
//显示正确答案(显示详解时)
-(void)showRightAnswer{
    NSString *rightAnswer = self.Q_Model.AnswerTrue;
    if ([self.Q_Model.Type isEqualToString:@"1"] || [self.Q_Model.Type isEqualToString:@"2"]) {//判断 //单选
        NSInteger index = [rightAnswer integerValue] - 1;
        [self.seleteStateArr replaceObjectAtIndex:index withObject:@"1"];
    }else if ([self.Q_Model.Type isEqualToString:@"3"]) {//多选
        //先把你选择的选项设为选错
        [self.currentAnswer enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.seleteStateArr replaceObjectAtIndex:([obj integerValue]-1) withObject:@"2"];
        }];
        //再把正确答案的选项设为选对
        for (int i = 0; i < rightAnswer.length; i++) {
            NSString *subStr = [rightAnswer substringWithRange:NSMakeRange(i, 1)];
            NSInteger index = [subStr integerValue] - 1;
            [self.seleteStateArr replaceObjectAtIndex:index withObject:@"1"];
        }
    }
//    //刷表
//    [self.tableView reloadData];
}
//判断对错
-(void)checkAnswer:(NSInteger)yourChoose{
    //确认是否选择
    if ([self.seleteCellArr[yourChoose] isEqualToString:@"0"]) {//选中cell
        [self.seleteCellArr replaceObjectAtIndex:yourChoose withObject:@"1"];
    }else if ([self.seleteCellArr[yourChoose] isEqualToString:@"1"]) {//取消选中cell
        [self.seleteCellArr replaceObjectAtIndex:yourChoose withObject:@"0"];
    }
    
    NSString *rightAnswer = self.Q_Model.AnswerTrue;
    NSString *yourAnswer = [NSString stringWithFormat:@"%ld",(long)yourChoose + 1];
    if ([self.Q_Model.Type isEqualToString:@"1"] || [self.Q_Model.Type isEqualToString:@"2"]) {//判断 //单选
        
        //直接判断对错
        BOOL isRight = NO;
        if ([rightAnswer containsString:yourAnswer]) {
            [self.seleteStateArr replaceObjectAtIndex:yourChoose withObject:@"1"];//答对了
            isRight = YES;
        }else{
            [self.seleteStateArr replaceObjectAtIndex:yourChoose withObject:@"2"];//答错了
            isRight = NO;
        }
        if (isRight) {//答对了，下一题
            [self showRightAnswer];//答对了也显示详解
            if ([self.agency respondsToSelector:@selector(jumpToNextQuestionWith:)]) {
                [self.agency jumpToNextQuestionWith:self.currentIndex];
                //更改题目状态（已做/未做）
                self.Q_Model.status = @"1";
                [[ZXTopicManager sharedTopicManager] updateTopicStatus:self.Q_Model];
            }
        }else{//答错了，显示详解
            [self showRightAnswer];
            if ([self.agency respondsToSelector:@selector(changeShowExplainArrWith:)]) {
                [self.agency changeShowExplainArrWith:self.currentIndex];
                //更改题目状态（已做/未做）
                self.Q_Model.status = @"2";
                [[ZXTopicManager sharedTopicManager] updateTopicStatus:self.Q_Model];
            }
        }
        [self.currentAnswer addObject:yourAnswer];
    }else if ([self.Q_Model.Type isEqualToString:@"3"]) {//多选
        if ([self.seleteStateArr[yourChoose] isEqualToString:@"0"]) {
            [self.seleteStateArr replaceObjectAtIndex:yourChoose withObject:@"3"];//选择
            [self.currentAnswer addObject:yourAnswer];
        }else if ([self.seleteStateArr[yourChoose] isEqualToString:@"3"]) {
            [self.seleteStateArr replaceObjectAtIndex:yourChoose withObject:@"0"];//取消选择
            [self.currentAnswer removeObject:yourAnswer];
        }
    }
}
//点击seleteBtn
-(void)seleteBtnAction:(UIButton *)sender{
    
    //判断对错
    switch (sender.tag) {
        case 100:{
            [self checkAnswer:0];
        }
            break;
        case 101:{
            [self checkAnswer:1];
        }
            break;
        case 102:{
            [self checkAnswer:2];
        }
            break;
        case 103:{
            [self checkAnswer:3];
        }
            break;
            
        default:
            break;
    }
    //刷表
    [self.tableView reloadData];
}
//不可高亮cell
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return YES;
    }
    return NO;
}
//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 1) {
        return;
    }
    //判断对错
    switch (indexPath.row) {
        case 0:{
            [self checkAnswer:0];
        }
            break;
        case 1:{
            [self checkAnswer:1];
        }
            break;
        case 2:{
            [self checkAnswer:2];
        }
            break;
        case 3:{
            [self checkAnswer:3];
        }
            break;
            
        default:
            break;
    }
    //刷表
    [self.tableView reloadData];
}
#pragma mark -播放视频（完成）
- (void)moviePlayDidEnd:(NSNotification *)notify {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AVPlayerItem * p = [notify object];
        [p seekToTime:kCMTimeZero];
        //    [_avPlayer seekToTime:CMTimeMake(0, 1)];
        [_avPlayer play];
    });
}

@end

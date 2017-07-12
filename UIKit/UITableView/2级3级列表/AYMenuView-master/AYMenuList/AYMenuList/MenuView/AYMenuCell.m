//
//  AYMenuCell.m
//  AYMenuList
//
//  Created by Andy on 2017/4/26.
//  Copyright © 2017年 Andy. All rights reserved.
//

#import "AYMenuCell.h"
#import "AYMenuItem.h"

@interface AYMenuCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leading;

@end

@implementation AYMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setItem:(AYMenuItem *)item{
    _item = item;
    _titleLabel.text = item.title;
    _leading.constant = 30 * item.level;
    if (_item.isSubItemsOpen) {
        _menuImgView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }else{
        _menuImgView.transform = CGAffineTransformMakeRotation(0);
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
           
        NSLog(@"%d",_item.isSubItemsOpen);
        
    
    
    
}

@end

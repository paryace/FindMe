//
//  FansCell.m
//  FindMe
//
//  Created by mac on 14-7-14.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "FansCell.h"
#import "UIImageView+MJWebCache.h"
@implementation FansCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.photo sd_setImageWithURL:[HDTool getSImage:self.user.userPhoto] placeholderImage:[UIImage imageNamed:@"defaultImage"] options:SDWebImageRetryFailed];
    self.nicknameLbl.text = self.user.userNickName;
    self.schoolLbl.text = [self.user getSchoolName];
    self.departmentLbl.text = [self.user getDepartmentName];
    self.gradeLbl.text = self.user.userGrade;
}

@end

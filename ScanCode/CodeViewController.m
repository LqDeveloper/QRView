//
//  CodeViewController.m
//  相册
//
//  Created by liquan on 2017/3/8.
//  Copyright © 2017年 liquan. All rights reserved.
//

#import "CodeViewController.h"
#import "CreateCode.h"
@interface CodeViewController ()
@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,strong)UIImageView *imageView;
@end

@implementation CodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickView)];
    [self.view addGestureRecognizer:tap];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.textField = [[UITextField alloc]init];
    [self.view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view).with.offset(94);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.textColor = [UIColor redColor];
    self.textField.backgroundColor = [UIColor cyanColor];
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.textField.mas_bottom).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    [button setTitle:@"生成二维码" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(createCodeImage) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.imageView = [[UIImageView alloc]init];
    [self.view addSubview:_imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(button.mas_bottom).with.offset(40);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
}
-(void)createCodeImage{
    [self.textField resignFirstResponder];
    UIImage *image = [CreateCode createCodeImageWithString:self.textField.text];
    //UIImage *hImage = [CreateCode addIconToCodeImage:image withIcon:[UIImage imageNamed:@"kepu_select"] withScale:5];
    UIImage *cImage = [CreateCode createCodeImageWithImage:image withRed:12 green:200 blue:100];
    self.imageView.image = cImage;
}
-(void)clickView{
    [self.textField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

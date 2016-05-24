//
//  ViewController.m
//  BlueTooth
//
//  Created by meigusd on 16/5/5.
//  Copyright © 2016年 Jiang. All rights reserved.
//

#import "ViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
@interface ViewController ()<MCSessionDelegate,MCAdvertiserAssistantDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) UIView *backView;

//@property (nonatomic, strong) GKSession *session;
//@property (nonatomic, strong) GKPeerPickerController *pc;
- (IBAction)imageClick:(id)sender;

@end



@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    self.showImageView.layer.borderWidth = 1.0;
    self.showImageView.layer.borderColor = [[UIColor purpleColor] CGColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    NSLog(@"状态改变");
    switch (state) {
        case MCSessionStateConnected:
            NSLog(@"连接成功.");
            break;
        case MCSessionStateConnecting:
            NSLog(@"正在连接...");
            break;
        default:
            NSLog(@"连接失败.");
            break;
    }
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    NSLog(@"开始接收数据...");
    UIImage *image=[UIImage imageWithData:data];
    [self.showImageView setImage:image];
    //保存到相册
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    self.showImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSError *error = nil;
    [self.session sendData:UIImagePNGRepresentation(self.showImageView.image) toPeers:[self.session connectedPeers] withMode:MCSessionSendDataUnreliable error:&error];
    NSLog(@"开始发送数据...");
    if (error) {
        NSLog(@"发送数据过程中发生错误，错误信息：%@",error.localizedDescription);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)imageClick:(id)sender {
    UIImagePickerController *i = [[UIImagePickerController alloc] init];
    i.delegate = self;
    [self presentViewController:i animated:YES completion:nil];
}

- (IBAction)sendClick:(id)sender {
    [self.advertiser start];
}
- (IBAction)reLink:(id)sender {
   
//    [self.pc show];
}

- (MCSession *)session{
    if (!_session) {
         MCPeerID *pID = [[MCPeerID alloc] initWithDisplayName:@"Jiang__Advertiser"];
        _session = [[MCSession alloc] initWithPeer:pID];
        _session.delegate = self;
    }
    return _session;
}
- (MCAdvertiserAssistant *)advertiser{
    if (!_advertiser) {
        _advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"cmj-stream" discoveryInfo:nil session:self.session];
        _advertiser.delegate = self;
    }
    return _advertiser;
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
        _backView.backgroundColor = [UIColor purpleColor];
    }
    return _backView;
}

@end

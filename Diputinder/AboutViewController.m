//
//  AboutViewController.m
//  
//
//  Created by Carlos Castellanos on 19/08/15.
//
//

#import "AboutViewController.h"


@interface AboutViewController ()<UITextViewDelegate>

@end

@implementation AboutViewController

- (void)viewDidLoad {
   
    
    _scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_scroll];
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-50, 20, 100, 100)];
    img.image=[UIImage imageNamed:@"iosiconliguepolitico.png"];
    [_scroll addSubview: img];
    
    self.view.backgroundColor=[UIColor whiteColor];
    UITextView *text=[[UITextView alloc]initWithFrame:CGRectMake(20, img.frame.size.height+img.frame.origin.y+20, self.view.frame.size.width-40, 200) ];
    text.backgroundColor=[UIColor clearColor];
    text.editable=false;
    text.delegate=self;
   // [text setFont:[UIFont fontWithName:@"OpenSans-Bold" size:16]];
    
    NSString *t=@"Con Ligue Político podrás conocer quiénes son tus candidatos a puestos de elección popular, de acuerdo a tu ubicación geográfica, para exigirles que se comprometan con la transparencia y la rendición de cuentas. \n Ligue Político es una iniciativa ciudadana, abierta y colaborativa, promovida y apoyada por: Factual, Hivos, Chequeado, Yo Quiero Saber, El Tiempo, y Fáctico) \n Si un candidato te atrae, desliza a la derecha. ¡Pero cuidado! Si no ha presentado su declaración patrimonial o jurada, ¡exígela! \n \n www.liguepolitico.com";
    
    text.text=t;
     [text setFont:[UIFont fontWithName:@"GothamRounded-Book" size:14]];
    text.scrollEnabled=FALSE;
     text.dataDetectorTypes = UIDataDetectorTypeAll;
  //  text.attributedText =attrib;
    [text sizeToFit];
    
    /**/
    [_scroll addSubview:text];
    
    
    [_scroll setContentSize:CGSizeMake(self.view.frame.size.width,text.frame.size.height+text.frame.origin.y+68)];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated {
    
    

    self.navigationController.navigationBar.backItem.title=@"";
    
    

    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIFont fontWithName:@"GothamRounded-Bold" size:19],NSFontAttributeName,nil];
    self.navigationController.navigationBar.titleTextAttributes =textAttributes;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.navigationController.topViewController.navigationItem.title=@"Acerca de";
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    NSLog(@"URL: %@", URL);
    
    //  WebViewController *web=[[WebViewController alloc]init];
    NSString *schema=[NSString stringWithFormat:@"twitter://user?screen_name=%@",[[URL absoluteString] stringByReplacingOccurrencesOfString:@"http://twitter.com/" withString:@""]];
    //web.texto=schema;
    
    NSURL *url = [NSURL URLWithString:[schema stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
    //   [self.navigationController pushViewController:web animated:NO];
    
    //You can do anything with the URL here (like open in other web view).
    return NO;
}





@end

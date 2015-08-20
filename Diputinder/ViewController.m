//
//  ViewController.m
//  Diputinder
//
//  Created by Carlos Castellanos on 28/04/15.
//  Copyright (c) 2015 Carlos Castellanos. All rights reserved.
//

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#import "ViewController.h"

#import "DraggableViewBackground.h"

#import <AFHTTPRequestOperationManager.h>

#import "AppDelegate.h"
#import "DetailViewController.h"
#import <AudioToolbox/AudioServices.h>
#import  <Social/Social.h>

#import "AboutViewController.h"
@interface ViewController ()

@end

@implementation ViewController
{
    NSInteger cardsLoadedIndex; //%%% the index of the card you have loaded into the loadedCards array last
    NSMutableArray *loadedCards; //%%% the array of card loaded (change max_buffer_size to increase or decrease the number of cards this holds)
    
    UIButton* menuButton;
    UIButton* messageButton;
    UIButton* checkButton;
    UIButton* xButton;
    NSMutableArray *candidatos;
    NSMutableArray *conFoto;
    NSMutableArray *sinFoto;
    NSMutableArray * exampleCardLabels;
    UILabel *name;
    UIScrollView *vista;
    NSString *territory;
    
    UIActivityIndicatorView *loading;
    AppDelegate *delegate;
    
    int current;
    NSString *tuiter;
    BOOL goodPerson;
    UIView *cardContainer;
}
//this makes it so only two cards are loaded at a time to
//avoid performance and memory costs
static const int MAX_BUFFER_SIZE = 2; //%%% max number of cards loaded at any given time, must be greater than 1
//@synthesize exampleCardLabels; //%%% all the labels I'm using as example data at the moment
@synthesize allCards;//%%% all the cards

-(void)refreshData{

    [candidatos removeAllObjects];
    [self getAddress];
}
- (void)viewDidLoad {
    UIButton *search =  [UIButton buttonWithType:UIButtonTypeCustom];
    search.tintColor=[UIColor whiteColor];
    [search setImage:[UIImage imageNamed:@"Refresh_icon.png"] forState:UIControlStateNormal];
    [search addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventTouchUpInside];
    
    [search setFrame:CGRectMake(0, 0, 30 , 30)];
    UIBarButtonItem *buscar = [[UIBarButtonItem alloc]initWithCustomView:search];
    NSMutableArray *button=[[NSMutableArray alloc]initWithObjects:buscar, nil];
    self.navigationController.topViewController.navigationItem.rightBarButtonItems = button;
    goodPerson=true;
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* named in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", named);
        }
    }
    
    
    locationManager = [[CLLocationManager alloc]init]; // initializing locationManager
    locationManager.delegate = self; // we set the delegate of locationManager to self.
    locationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
    
    [locationManager startUpdatingLocation];
    
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
    }
#endif
    
    [[[self navigationController] navigationBar] setBarStyle:UIBarStyleBlackTranslucent];
    //  DraggableViewBackground *draggableBackground = [[DraggableViewBackground alloc]initWithFrame:self.view.frame];
    //2 [self.view addSubview:draggableBackground];
    // Do any additional setup after loading the view, typically from a nib.
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:48/255.0 green:204/255.0 blue:113/255.0 alpha:1]];
    // [super layoutSubviews];
    // UIImage *image2 = [UIImage imageNamed:@"ligue.png"];
    //[self.navigationController.navigationBar setBackgroundImage:image2 forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    UIButton* tryAgain = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [tryAgain addTarget:self
                 action:@selector(reload:)
       forControlEvents:UIControlEventTouchUpInside];
    [tryAgain setTitle:@"Volver a intentar" forState:UIControlStateNormal];
    tryAgain.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 160.0, 40.0);
    [vista addSubview:tryAgain];
    
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,25,20)] ;
    
    //set your image logo replace to the main-logo
    [image setImage:[UIImage imageNamed:@"ligue.png"]];
    
    // [self.navigationController.navigationBar.topItem setTitleView:image];
    
    
    //self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ligue.png"]];
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIFont fontWithName:@"GothamRounded-Bold" size:19],NSFontAttributeName,nil];
    self.navigationController.navigationBar.titleTextAttributes =textAttributes;
    
    
    //[[[ self.tabBarController navigationController] navigationBar] setBarStyle:UIBarStyleBlackTranslucent];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //[self setUpNavbar];
    self.navigationController.topViewController.navigationItem.title=@"Ligue Político";
    
    UIButton *button_infon =  [UIButton buttonWithType:UIButtonTypeInfoLight];
    button_infon.backgroundColor=[UIColor clearColor];
    button_infon.imageView.backgroundColor=[UIColor clearColor];
    button_infon.tintColor=[UIColor whiteColor];
    //[button setImage:[UIImage imageNamed:@"button_menu_navigationbar.png"] forState:UIControlStateNormal];
    [button_infon addTarget:self action:@selector(info:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [button_infon setFrame:CGRectMake(0, 0, 37,34)];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button_infon];
    self.navigationController.topViewController.navigationItem.leftBarButtonItem = barButton;
    
    
    [self setupView];
    //exampleCardLabels = [[NSArray alloc]initWithObjects:@"Diego",@"second",@"third",@"fourth",@"last", nil]; //%%% placeholder for card-specific information
    loadedCards = [[NSMutableArray alloc] init];
    allCards = [[NSMutableArray alloc] init];
    cardsLoadedIndex = 0;
    [self getAddress];
    //verde 48,204, 113
    //modaro 116, 94,197
    //226,226,226
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//%%% sets up the extra buttons on the screen
-(void)setupView
{
    delegate= (AppDelegate*)[[UIApplication sharedApplication]delegate];
    loading=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25, self.view.frame.size.height/2-25, 50, 50)];
    loading.backgroundColor=[UIColor blackColor];
    [loading startAnimating];
    [loading.layer setCornerRadius:loading.frame.size.width / 2];
    loading.layer.cornerRadius = loading.frame.size.width / 2;
    loading.layer.masksToBounds = YES;
    
    [self.view addSubview:loading];
    

    self.view.backgroundColor = [UIColor colorWithRed:.92 green:.93 blue:.95 alpha:1]; //the gray background colors
    menuButton = [[UIButton alloc]initWithFrame:CGRectMake(17, 34, 22, 15)];
    [menuButton setImage:[UIImage imageNamed:@"menuButton"] forState:UIControlStateNormal];
    messageButton = [[UIButton alloc]initWithFrame:CGRectMake(284, 34, 18, 18)];
    [messageButton setImage:[UIImage imageNamed:@"messageButton"] forState:UIControlStateNormal];
    
    
    xButton = [[UIButton alloc]initWithFrame:CGRectMake(60, self.view.frame.size.height-150, 80 , 80)];
    [xButton setImage:[UIImage imageNamed:@"nobutton.png"] forState:UIControlStateNormal];
    [xButton addTarget:self action:@selector(swipeLeft) forControlEvents:UIControlEventTouchUpInside];
    checkButton = [[UIButton alloc]initWithFrame:CGRectMake(200, self.view.frame.size.height-150, 80, 80)];
    [checkButton setImage:[UIImage imageNamed:@"yesbutton.png"] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(swipeRight) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.backgroundColor=[UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
    
    vista=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    vista.backgroundColor=[UIColor clearColor];
    
    
    // [self addSubview:menuButton];
    // [self addSubview:messageButton];
    [vista addSubview:xButton];
    [vista addSubview:checkButton];
    [self.view addSubview:vista];
    
}

//%%% creates a card and returns it.  This should be customized to fit your needs.
// use "index" to indicate where the information should be pulled.  If this doesn't apply to you, feel free
// to get rid of it (eg: if you are building cards from data from the internet)
-(DraggableView *)createDraggableViewWithDataAtIndex:(NSInteger)index
{
     loading.hidden=TRUE;
    current=index;
    //   DraggableView *draggableView = [[DraggableView alloc]initWithFrame:CGRectMake((self.frame.size.width - CARD_WIDTH)/2, (self.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT)];
    
    DraggableView *draggableView = [[DraggableView alloc]init];
    NSLog(@"%f", [[UIScreen mainScreen] bounds].size.height);
    if ( [[UIScreen mainScreen] bounds].size.height <=480) {
        
                draggableView.frame= CGRectMake(10, 10, self.view.frame.size.width-20 , self.view.frame.size.width-20);
    }else{
    
         draggableView.frame=CGRectMake(10, 10, self.view.frame.size.width-20 , self.view.frame.size.width+80);
    }
    draggableView.information.text = @"test";//[exampleCardLabels objectAtIndex:index]; //%%% placeholder for card-specific information
    //modificamos el frame de los botones
    xButton.frame=CGRectMake((draggableView.frame.size.width/2)-100, draggableView.frame.origin.y+ draggableView.frame.size.height+12, xButton.frame.size.width, xButton.frame.size.height);
    checkButton.frame=CGRectMake((draggableView.frame.size.width/2)+40, draggableView.frame.origin.y+ draggableView.frame.size.height+12, checkButton.frame.size.width, checkButton.frame.size.height);
    
    
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, draggableView.frame.size.width, draggableView.frame.size.height-50)];
    img.image=[UIImage imageNamed:@"noimage.jpg"];
    UIActivityIndicatorView *a=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(img.frame.size.width/2-25, img.frame.size.height/2-25, 50, 50)];
    [a startAnimating];
    [img addSubview: a];
    
    // Revisa si el usuario tiene twitter
    if ([[[candidatos objectAtIndex:index]objectForKey:@"candidate"]objectForKey:@"twitter"] !=NULL  ) {
        
        tuiter=[[[candidatos objectAtIndex:index]objectForKey:@"candidate"]objectForKey:@"twitter"];
        NSString *tw=[[[candidatos objectAtIndex:index]objectForKey:@"twitter"] stringByReplacingOccurrencesOfString: @"\n" withString: @""];
        NSString *st=[NSString stringWithFormat:@"https://twitter.com/%@/profile_image?size=original",tuiter];

        // buscamos la img en cache y si no pues la descargamos
        if(tuiter == nil || [tuiter isEqualToString:@""]){
                    img.image=[UIImage imageNamed:@"noimage.jpg"];
        }
        else{
            dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
            dispatch_async(imageQueue, ^{
                
                UIImage *imgAux=[self buscarCache:st];
                if (imgAux==nil) {
                    UIImage *tmp= [self descargarImg:st];
                    [delegate.imgCache setObject: tmp forKey: st];
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    
                    img.image=[self buscarCache:st];
                    [a stopAnimating];
                    
                });
                
                
            });
        }
        
    }
    else{
        [a stopAnimating];
        if ([[[candidatos objectAtIndex:index]objectForKey:@"gnero"] isEqualToString:@"M"]) {
            img.image=[UIImage imageNamed:@"h.jpg"];
        }
        else
            img.image=[UIImage imageNamed:@"m.jpg"];
        
        tuiter=[NSString stringWithFormat:@"#%@%@%@",[[[candidatos objectAtIndex:index]objectForKey:@"candidate"]objectForKey:@"nombres"],[[[candidatos objectAtIndex:index]objectForKey:@"candidate"]objectForKey:@"apellido_paterno"],[[[candidatos objectAtIndex:index]objectForKey:@"candidate"]objectForKey:@"apellido_materno"]];
        
    }
    name =[[UILabel alloc]initWithFrame:CGRectMake(0, draggableView.frame.size.height-50, draggableView.frame.size.width-50, 50 )];
    name.backgroundColor=[UIColor clearColor];
    name.numberOfLines=3;
    name.textColor=[UIColor whiteColor];
    name.textAlignment=NSTextAlignmentCenter;
    name.text=@"nombre del dipudato";
    name.text=[NSString stringWithFormat:@"%@ %@ %@",[[[candidatos objectAtIndex:index]objectForKey:@"candidate"]objectForKey:@"nombres"],[[[candidatos objectAtIndex:index]objectForKey:@"candidate"]objectForKey:@"apellido_paterno"],[[[candidatos objectAtIndex:index]objectForKey:@"candidate"]objectForKey:@"apellido_materno"]];
    
    
    [name setFont:[UIFont fontWithName:@"GothamRounded-Bold" size:18]];
 
    name.frame=CGRectMake(0, draggableView.frame.size.height- name.frame.size.height, draggableView.frame.size.width-50, name.frame.size.height );

    UIImageView *partido=[[UIImageView alloc]initWithFrame:CGRectMake(draggableView.frame.size.width-50,  draggableView.frame.size.height-50, 50, 50)];
    
    //obtener la imagen con la url del json y ponerla aqui y en cache
    
    
    
     // buscamos la img en cache y si no pues la descargamos
    NSLog(@"index = %i",index);
     dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
     dispatch_async(imageQueue, ^{
     
     UIImage *imgAux=[self buscarCache:[[[[candidatos objectAtIndex:index] objectForKey:@"party"]objectAtIndex:0] objectForKey:@"image"]];
     if (imgAux==nil) {
     UIImage *tmp= [self descargarImg:[[[[candidatos objectAtIndex:index] objectForKey:@"party"]objectAtIndex:0] objectForKey:@"image"]];
     [delegate.imgCache setObject: tmp forKey:[[[[candidatos objectAtIndex:index] objectForKey:@"party"]objectAtIndex:0] objectForKey:@"image"]];
     }
     
     dispatch_async(dispatch_get_main_queue(), ^{
     // Update the UI
     
     partido.image=[self buscarCache:[[[[candidatos objectAtIndex:index] objectForKey:@"party"]objectAtIndex:0] objectForKey:@"image"]];
     [a stopAnimating];
     
     });
     
     
     });
     
    
    //partido.image=[UIImage imageNamed: [NSString stringWithFormat:@"%@.png",[[candidatos objectAtIndex:index]objectForKey:@"partido"]]];
    
    [draggableView addSubview:partido];
    [draggableView addSubview:name];
    [draggableView addSubview:img];
    draggableView.delegate = self;
    draggableView.tag=index;
    
    //verde 48,204, 113
    //modaro 116, 94,197
    draggableView.backgroundColor= [UIColor colorWithRed:116/255.0 green:94/255.0 blue:197/255.0 alpha:1];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    singleFingerTap.accessibilityLabel=[NSString stringWithFormat:@"%li",(long)index];
    [draggableView addGestureRecognizer:singleFingerTap];
    
    return draggableView;
}
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    NSLog(@"%i",[recognizer.accessibilityLabel integerValue]);
    DetailViewController *detail=[[DetailViewController alloc]init];
    detail.data=[candidatos objectAtIndex:[recognizer.accessibilityLabel integerValue]];
    detail.territory=territory;
    [delegate.navBar pushViewController:detail animated:YES];
    
}
-(void)getData{
    
    exampleCardLabels=[[NSMutableArray alloc]init];
    candidatos=[[NSMutableArray alloc]init];
    conFoto=[[NSMutableArray alloc]init];
    sinFoto=[[NSMutableArray alloc]init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url ;
    if ([delegate.city isKindOfClass:[NSNull class]] || [delegate.city isEqualToString:@"(null)"]) {
        url =[NSString stringWithFormat:@"http://liguepolitico.herokuapp.com/countries/%@/states/%@.json",delegate.country,delegate.state];
    }else
        url =[NSString stringWithFormat:@"http://liguepolitico.herokuapp.com/countries/%@/states/%@/cities/%@.json",delegate.country,delegate.state,delegate.city];
    
    if ([delegate.state isKindOfClass:[NSNull class]] || [delegate.state isEqualToString:@"(null)"]) {
        url =[NSString stringWithFormat:@"http://liguepolitico.herokuapp.com/countries/%@.json",delegate.country];
    }
    url =[NSString stringWithFormat:@"http://liguepolitico-staging.herokuapp.com/countries/1/states/1/cities/1.json"];
 
    [manager GET:url parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject){
        loading.hidden=TRUE;
        NSMutableArray *positions =[[NSMutableArray alloc]init];
        territory= [responseObject objectForKey:@"name"];
        for (NSDictionary *item in [responseObject objectForKey:@"positions"]) {
            // debo obtener todas las posiciones y luego juntarlas
            [positions addObject:item];
       
            
            /*if ([[item objectForKey:@"entidadFederativa"]isEqualToString:delegate.country])
             {
             
             if ([item objectForKey:@"twitter"]!=NULL) {
             [conFoto addObject:item];
             }
             else{
             [sinFoto addObject:item];
             }
             
             }*/
            
        }
        
        for (int a=0; a<positions.count; a++) {
            NSLog(@"%@",[[positions objectAtIndex:a]objectForKey:@"title"]);
            
            NSMutableArray *candis=[[NSMutableArray alloc]initWithArray:[[positions objectAtIndex:a]objectForKey:@"candidates"]];
            //recorro todos los candidato de este cargo politico
            for (int b =0 ; b<candis.count; b++) {
                NSMutableDictionary *aux=[NSMutableDictionary dictionaryWithDictionary:[[[positions objectAtIndex:a]objectForKey:@"candidates"] objectAtIndex:b]];
                
                [aux setObject:[[positions objectAtIndex:a]objectForKey:@"title"] forKey:@"position"];
                   [aux setObject:[[positions objectAtIndex:a]objectForKey:@"territory"] forKey:@"territory"];
                [candidatos addObject:aux];
            }
        }
        
        
        [candidatos addObjectsFromArray:conFoto];
        [candidatos addObjectsFromArray:sinFoto];
        if ([candidatos count]) {
            exampleCardLabels=candidatos;
            //   NSLog(@"si hay ");
            [self loadCards];
             loading.hidden=TRUE;
        }
        else{
            // No Success
            //   NSLog(@"no hay ");
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Mensaje" message:@"No encontramos candidatos en tu zona" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
            [alert show];
             loading.hidden=TRUE;
            
        }
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error %@", error);
        
        
    }];
}
//%%% loads all the cards and puts the first x in the "loaded cards" array
-(void)loadCards
{
    if([exampleCardLabels count] > 0) {
        NSInteger numLoadedCardsCap =(([exampleCardLabels count] > MAX_BUFFER_SIZE)?MAX_BUFFER_SIZE:[exampleCardLabels count]);
        //%%% if the buffer size is greater than the data size, there will be an array error, so this makes sure that doesn't happen
        
        //%%% loops through the exampleCardsLabels array to create a card for each label.  This should be customized by removing "exampleCardLabels" with your own array of data
        for (int i = 0; i<[exampleCardLabels count]; i++) {
            DraggableView* newCard = [self createDraggableViewWithDataAtIndex:i];
            [allCards addObject:newCard];
            
            if (i<numLoadedCardsCap) {
                //%%% adds a small number of cards to be loaded
                [loadedCards addObject:newCard];
            }
        }
        
        //%%% displays the small number of loaded cards dictated by MAX_BUFFER_SIZE so that not all the cards
        // are showing at once and clogging a ton of data
        for (int i = 0; i<[loadedCards count]; i++) {
            NSLog(@"%i",i);
            if (i>0) {
                [self.view insertSubview:[loadedCards objectAtIndex:i] belowSubview:[loadedCards objectAtIndex:i-1]];
            } else {
                [self.view addSubview:[loadedCards objectAtIndex:i]];
            }
            cardsLoadedIndex++; //%%% we loaded a card into loaded cards, so we have to increment
        }
    }
}

//%%% action called when the card goes to the left.
// This should be customized with your own action
-(void)cardSwipedLeft:(UIView *)card;
{
    //do whatever you want with the card that was swiped
    //    DraggableView *c = (DraggableView *)card;
    if (cardsLoadedIndex ==[allCards count]) {
        cardsLoadedIndex=0;
        [allCards removeAllObjects];
        //[self loadCards];
    }
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self.view insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
}
//%%% action called when the card goes to the right.
// This should be customized with your own action
-(void)cardSwipedRight:(UIView *)card
{
    
    //do whatever you want with the card that was swiped
    //    DraggableView *c = (DraggableView *)card;
    if (cardsLoadedIndex <=1) {
      //  [self loadCards];
    }
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self.view insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
    
    
    if ([[candidatos objectAtIndex:card.tag]objectForKey:@"twitter"]!=NULL) {
        tuiter=[NSString stringWithFormat:@"@%@",[[candidatos objectAtIndex:card.tag]objectForKey:@"twitter"]];
    }
    else{
        tuiter=[NSString stringWithFormat:@"#%@%@%@",[[candidatos objectAtIndex:card.tag]objectForKey:@"nombres"],[[candidatos objectAtIndex:card.tag]objectForKey:@"apellidoPaterno"],[[candidatos objectAtIndex:card.tag]objectForKey:@"apellidoMaterno"]];
        
    }
    //  revisar si tiene todos los indicadores
    
    for (NSMutableDictionary *indicator in [[candidatos objectAtIndex:card.tag]objectForKey:@"indicators"]) {
        
        NSLog(@"%@",[indicator objectForKey:@"document"]);
        if ([[indicator objectForKey:@"document"] isEqualToString:@""]) {
            UIAlertView *a=[[UIAlertView alloc]initWithTitle:@"Mensaje" message:@"Esta persona no te corresponde por que no tiene su 3 de 3 ¿Quiere solicitarselo?" delegate:self cancelButtonTitle:@"Si" otherButtonTitles:@"No", nil];
           // [a show];
            goodPerson = false;
            
            break;
            
            }
        }
    if (goodPerson) {
        UIAlertView *a=[[UIAlertView alloc]initWithTitle:@"Mensaje" message:@"Esta persona si cumple con su 3 de 3 ¿Quieres mandarle un twett?" delegate:self cancelButtonTitle:@"Si" otherButtonTitles:@"No", nil];
       // [a show];

    }
    [self detailView:card.tag];
    
    /*if ([[candidatos objectAtIndex:card.tag]objectForKey:@"fiscal"]==NULL || [[candidatos objectAtIndex:card.tag]objectForKey:@"patrimonial"]==NULL || [[candidatos objectAtIndex:card.tag]objectForKey:@"fiscal"]==NULL) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        UIAlertView *a=[[UIAlertView alloc]initWithTitle:@"Mensaje" message:@"Esta persona no te corresponde por que no tiene su 3 de 3 ¿Quiere solicitarselo?" delegate:self cancelButtonTitle:@"Si" otherButtonTitles:@"No", nil];
        [a show];
    }
    else{
        UIAlertView *a=[[UIAlertView alloc]initWithTitle:@"Mensaje" message:@"Esta persona si cumple con su 3 de 3 ¿Quieres mandarle un twett?" delegate:self cancelButtonTitle:@"Si" otherButtonTitles:@"No", nil];
        [a show];
        
    }*/
    
}

-(void)detailView: (int ) index{
   cardContainer=[[UIView alloc]initWithFrame:CGRectMake(15, 15, self.view.frame.size.width-30, self.view.frame.size.height-30)];
    
    
    
 
    cardContainer.backgroundColor=[UIColor darkGrayColor];
    
    UIImageView *img= [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width/3, self.view.frame.size.width/3)];
    [img.layer setCornerRadius:img.frame.size.width / 2];
    img.layer.cornerRadius = img.frame.size.width / 2;
    img.layer.masksToBounds = YES;
    if ([[[candidatos objectAtIndex:index]objectForKey:@"candidate"]objectForKey:@"twitter"] !=NULL ) {
        
        tuiter=[[[candidatos objectAtIndex:index]objectForKey:@"candidate"]objectForKey:@"twitter"];
        
        if ([tuiter isEqualToString:@""] || [tuiter isKindOfClass:[NSNull class]]) {
              tuiter=[NSString stringWithFormat:@"#%@%@%@",[[[candidatos objectAtIndex:index]objectForKey:@"candidate"]objectForKey:@"nombres"],[[[candidatos objectAtIndex:index]objectForKey:@"candidate"]objectForKey:@"apellido_paterno"],[[[candidatos objectAtIndex:index]objectForKey:@"candidate"]objectForKey:@"apellido_materno"]];
             img.image=[UIImage imageNamed:@"noimage.jpg"];
        }
        else {
     
        NSString *st=[NSString stringWithFormat:@"https://twitter.com/%@/profile_image?size=original",tuiter];

        // buscamos la img en cache y si no pues la descargamos
        
        dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
        dispatch_async(imageQueue, ^{
            
            UIImage *imgAux=[self buscarCache:st];
            if (imgAux==nil) {
                UIImage *tmp= [self descargarImg:st];
                [delegate.imgCache setObject: tmp forKey: st];
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                
                img.image=[self buscarCache:st];
               
                
            });
            
            
        });
        }
        
        
    }
    else{
      
        if ([[[candidatos objectAtIndex:index]objectForKey:@"gnero"] isEqualToString:@"M"]) {
            img.image=[UIImage imageNamed:@"h.jpg"];
        }
        else
            img.image=[UIImage imageNamed:@"m.jpg"];
        
    }
    
    [cardContainer addSubview:img];
    
    UILabel *candidate=[[UILabel alloc]initWithFrame:CGRectMake(img.frame.size.height+img.frame.origin.x+10, 20, cardContainer.frame.size.width-img.frame.size.width-img.frame.origin.x-10, 100)];
    candidate.text=[NSString stringWithFormat:@"%@ %@ %@",[[[candidatos objectAtIndex:index]objectForKey:@"candidate"]objectForKey:@"nombres"],[[[candidatos objectAtIndex:index]objectForKey:@"candidate"]objectForKey:@"apellido_paterno"],[[[candidatos objectAtIndex:index]objectForKey:@"candidate"]objectForKey:@"apellido_materno"]];
      [candidate setFont:[UIFont fontWithName:@"GothamRounded-Bold" size:20]];
    candidate.numberOfLines=3;
    candidate.textColor=[UIColor whiteColor];
    [candidate sizeToFit];
    [cardContainer addSubview:candidate];
    [self.view addSubview: cardContainer];
    
    UILabel *text=[[UILabel alloc]initWithFrame:CGRectMake(15, img.frame.size.height+img.frame.origin.y +15, cardContainer.frame.size.width-30, 120)];
          [text setFont:[UIFont fontWithName:@"GothamRounded-Bold" size:17]];
    text.numberOfLines=5;
    text.textColor=[UIColor whiteColor];
    
    if (goodPerson) {
     text.text=@"A este candidato sí le interesas porque ya presentó sus declaraciones.";
    }
    else
        text.text=@"Lo sentimos, a este candidato no le interesas porque no ha presentado sus declaraciones.";
    
      [cardContainer addSubview:text];
    [text sizeToFit];
    
    UIView *twitterView=[[UIView alloc]initWithFrame:CGRectMake(0, cardContainer.frame.size.height-150, cardContainer.frame.size.width, 110)];
    twitterView.backgroundColor=[UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1];
    [cardContainer addSubview: twitterView];
    
    UIImageView *tuiterImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
    tuiterImg.image= [UIImage imageNamed:@"ic_twitter.png"];
     [twitterView addSubview: tuiterImg];
    
    UILabel *msj=[[UILabel alloc]initWithFrame:CGRectMake(tuiterImg.frame.size.height+tuiterImg.frame.origin.x+20, 10, twitterView.frame.size.width-tuiterImg.frame.size.height-tuiterImg.frame.origin.x-10, 100)];
          [msj setFont:[UIFont fontWithName:@"GothamRounded-Book" size:15]];
    msj.numberOfLines=5;
    if (goodPerson) {
        msj.text=@"¡Mándale un mensaje de felicitación!";
    }
    else
        msj.text=@"¡Mándale un  mensaje para que presente sus declaraciones!";
    
    [msj sizeToFit];
    [twitterView addSubview:msj];
    msj.textColor=[UIColor whiteColor];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnTwitterSharing_Clicked:)];
    tapGesture.numberOfTapsRequired=1;
    
    tapGesture.numberOfTouchesRequired=1;
    // prevents the scroll view from swallowing up the touch event of child buttons
    tapGesture.cancelsTouchesInView = NO;
    [twitterView addGestureRecognizer:tapGesture];
    
    UIButton *btn= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn addTarget:self
            action:@selector(cerrar)
  forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"Cerrar" forState:UIControlStateNormal];
    btn.frame=CGRectMake(0, cardContainer.frame.size.height-40, cardContainer.frame.size.width, 40);
    btn.backgroundColor=[UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1];
    
    btn.tintColor=[UIColor whiteColor];
    //    mas.tintColor=[UIColor blackColor];
    btn.titleLabel.font=[UIFont fontWithName:@"GothamRounded-Book" size:15];
     [twitterView addSubview:msj];
         [cardContainer addSubview:btn];

}
-(void)cerrar{


    [cardContainer removeFromSuperview];
}
//%%% when you hit the right button, this is called and substitutes the swipe
-(void)swipeRight
{
    DraggableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeRight;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView rightClickAction];
    
}

//%%% when you hit the left button, this is called and substitutes the swipe
-(void)swipeLeft
{
    DraggableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeLeft;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView leftClickAction];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
/***************************************/
/*  Codigo para cache de imagenes      */
/***************************************/
-(UIImage *)buscarCache:(NSString *)url {
    UIImage *img=[delegate.imgCache objectForKey:url];
    return img;
}



-(UIImage *)descargarImg:(NSString *)url {
    UIImage *tmp;
    NSLog(@"%@",url);
    if([[url substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"http"]){
        
        tmp =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: url]]];
        if (tmp !=nil)
            return tmp;
        while (tmp==nil) {
            //   tmp=[UIImage imageNamed:@"h.jpg"];
            [self descargarImg:url];
            NSLog(@"intenta descargar de nuevo");
        }
    }
    
    else{
        // no es una url valida
        tmp=[UIImage imageNamed:@"noimage.jpg"];
    }
    
    return tmp;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Si"])
    {
        NSLog(@"Button 1 was selected.");
        [self btnTwitterSharing_Clicked:self];
    }
    else if([title isEqualToString:@"No"])
    {
        NSLog(@"Button 2 was selected.");
    }
    else if([title isEqualToString:@"Button 3"])
    {
        NSLog(@"Button 3 was selected.");
    }
}
-(IBAction)btnTwitterSharing_Clicked:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheetOBJ = [SLComposeViewController
                                                  composeViewControllerForServiceType:SLServiceTypeTwitter];
        NSString *tw;
        if (goodPerson) {
            tw=[NSString stringWithFormat:@"Oye %@ Gracias por ser responsable @liguepolítico", tuiter];
        }
        else
        tw=[NSString stringWithFormat:@"Oye %@ , te encontré  en @LiguePolitico y no has presentado todas tus declaraciones, ¿qué esperas?", tuiter];
        
        [tweetSheetOBJ setInitialText:tw];
        [self presentViewController:tweetSheetOBJ animated:YES completion:nil];
    }
    else{
        
        UIAlertView *info=[[UIAlertView alloc]initWithTitle:@"Mensaje" message:@"Inicia sesión en Twitter desde el menú preferencias " delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        [info show];
    }
}
-(IBAction)info:(id)sender{
    AboutViewController *about=[[AboutViewController alloc]init];
    [self.navigationController pushViewController:about animated:NO];
    
}
-(IBAction)reload:(id)sender{
    [self viewDidLoad];
}

-(void)getAddress{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //NSString *url =[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?sensor=true&latlng=%f,%f",locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude];
    NSString *url =[NSString stringWithFormat:@"http://liguepolitico.herokuapp.com/geocoder.json?latitude=%f&longitude=%f",locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude];
    
    
    [manager GET:url parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"%@",[[responseObject objectForKey:@"country"]objectForKey:@"id"]);
        NSLog(@"%@",[[responseObject objectForKey:@"state"]objectForKey:@"id"]);
        
        delegate.country=  [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"country"]objectForKey:@"id"]];
        delegate.state= [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"state"]objectForKey:@"id"]];
        delegate.city= [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"city"]objectForKey:@"id"]];;
        [self getData];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error %@", error);
        
        
    }];
    
}
-(void)viewDidAppear:(BOOL)animated{

    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIFont fontWithName:@"GothamRounded-Bold" size:19],NSFontAttributeName,nil];
    self.navigationController.navigationBar.titleTextAttributes =textAttributes;
    
    
    //[[[ self.tabBarController navigationController] navigationBar] setBarStyle:UIBarStyleBlackTranslucent];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //[self setUpNavbar];
    self.navigationController.topViewController.navigationItem.title=@"Ligue Político";
    
}
@end
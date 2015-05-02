//
//  DraggableViewBackground.m
//  testing swiping
//
//  Created by Richard Kim on 8/23/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//
#import <AFHTTPRequestOperationManager.h>
#import "DraggableViewBackground.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import <AudioToolbox/AudioServices.h>

@implementation DraggableViewBackground{
    NSInteger cardsLoadedIndex; //%%% the index of the card you have loaded into the loadedCards array last
    NSMutableArray *loadedCards; //%%% the array of card loaded (change max_buffer_size to increase or decrease the number of cards this holds)
    
    UIButton* menuButton;
    UIButton* messageButton;
    UIButton* checkButton;
    UIButton* xButton;
    NSMutableArray *candidatos;
    NSMutableArray * exampleCardLabels;
    UILabel *name;
    UIScrollView *vista;
    
    UIActivityIndicatorView *loading;
    AppDelegate *delegate;
    
}
//this makes it so only two cards are loaded at a time to
//avoid performance and memory costs
static const int MAX_BUFFER_SIZE = 2; //%%% max number of cards loaded at any given time, must be greater than 1
static const float CARD_HEIGHT = 386; //%%% height of the draggable card
static const float CARD_WIDTH = 290; //%%% width of the draggable card

//@synthesize exampleCardLabels; //%%% all the labels I'm using as example data at the moment
@synthesize allCards;//%%% all the cards

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [super layoutSubviews];
        [self setupView];
        //exampleCardLabels = [[NSArray alloc]initWithObjects:@"Diego",@"second",@"third",@"fourth",@"last", nil]; //%%% placeholder for card-specific information
        loadedCards = [[NSMutableArray alloc] init];
        allCards = [[NSMutableArray alloc] init];
        cardsLoadedIndex = 0;
        [self getData];
    }
    return self;
}

//%%% sets up the extra buttons on the screen
-(void)setupView
{
    delegate= (AppDelegate*)[[UIApplication sharedApplication]delegate];
    loading=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-25, self.frame.size.height/2-25, 50, 50)];
    loading.backgroundColor=[UIColor blackColor];
    [loading startAnimating];
    [self addSubview:loading];
    
#warning customize all of this.  These are just place holders to make it look pretty
    self.backgroundColor = [UIColor colorWithRed:.92 green:.93 blue:.95 alpha:1]; //the gray background colors
    menuButton = [[UIButton alloc]initWithFrame:CGRectMake(17, 34, 22, 15)];
    [menuButton setImage:[UIImage imageNamed:@"menuButton"] forState:UIControlStateNormal];
    messageButton = [[UIButton alloc]initWithFrame:CGRectMake(284, 34, 18, 18)];
    [messageButton setImage:[UIImage imageNamed:@"messageButton"] forState:UIControlStateNormal];
    xButton = [[UIButton alloc]initWithFrame:CGRectMake(60, self.frame.size.height-100, 59, 59)];
    [xButton setImage:[UIImage imageNamed:@"xButton"] forState:UIControlStateNormal];
    [xButton addTarget:self action:@selector(swipeLeft) forControlEvents:UIControlEventTouchUpInside];
    checkButton = [[UIButton alloc]initWithFrame:CGRectMake(200, self.frame.size.height-100, 59, 59)];
    [checkButton setImage:[UIImage imageNamed:@"checkButton"] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(swipeRight) forControlEvents:UIControlEventTouchUpInside];
 
    self.backgroundColor=[UIColor yellowColor];
    
    vista=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    vista.backgroundColor=[UIColor clearColor];
    
   
    [self addSubview:menuButton];
    [self addSubview:messageButton];
    [vista addSubview:xButton];
    [vista addSubview:checkButton];
     [self addSubview:vista];
    
}

#warning include own card customization here!
//%%% creates a card and returns it.  This should be customized to fit your needs.
// use "index" to indicate where the information should be pulled.  If this doesn't apply to you, feel free
// to get rid of it (eg: if you are building cards from data from the internet)
-(DraggableView *)createDraggableViewWithDataAtIndex:(NSInteger)index
{
    if (index==70)
    {
        NSLog(@"");
    }
    DraggableView *draggableView = [[DraggableView alloc]initWithFrame:CGRectMake((self.frame.size.width - CARD_WIDTH)/2, (self.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT)];
    draggableView.information.text = @"test";//[exampleCardLabels objectAtIndex:index]; //%%% placeholder for card-specific information

    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, draggableView.frame.size.width, draggableView.frame.size.height-50)];
    if ([[candidatos objectAtIndex:index]objectForKey:@"twitter"] !=NULL ) {
        
        if([[[candidatos objectAtIndex:index]objectForKey:@"twitter"] isEqualToString:@"No se identificó"] ||[[[candidatos objectAtIndex:index]objectForKey:@"twitter"] isEqualToString:@"No tiene twitter"])
        {
        // son tan pendejos que le ponen no tiene tuiter
            if ([[[candidatos objectAtIndex:index]objectForKey:@"gnero"] isEqualToString:@"M"]) {
                img.image=[UIImage imageNamed:@"h.jpg"];
            }
            else
                img.image=[UIImage imageNamed:@"m.jpg"];
        }
        else{
            if([[[candidatos objectAtIndex:index]objectForKey:@"apellidoPaterno"]isEqualToString:@"Doring"]|| [[[candidatos objectAtIndex:index]objectForKey:@"nombres"]isEqualToString:@"Dora Elia"])
            {
                NSLog( @"encontre a este puto ");
            }
        NSString *tw=[[[candidatos objectAtIndex:index]objectForKey:@"twitter"] stringByReplacingOccurrencesOfString: @"\n" withString: @""];
        NSString *st=[NSString stringWithFormat:@"https://twitter.com/%@/profile_image?size=original",tw];
        
        // buscamos la img en cache y si no pues la descargamos
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIImage *imgAux=[self buscarCache:st];
            if (imgAux==nil) {
                UIImage *tmp= [self descargarImg:st];
                [delegate.imgCache setObject: tmp forKey: st];
                
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                
                img.image=[self buscarCache:st];
            }];
            
            
        });}
        
        
        
    }else{
      
        if ([[[candidatos objectAtIndex:index]objectForKey:@"gnero"] isEqualToString:@"M"]) {
              img.image=[UIImage imageNamed:@"h.jpg"];
        }
        else
            img.image=[UIImage imageNamed:@"m.jpg"];
        
    }
    name =[[UILabel alloc]initWithFrame:CGRectMake(0, draggableView.frame.size.height-50, draggableView.frame.size.width, 50 )];
    name.textAlignment=NSTextAlignmentCenter;
    name.text=@"nombre del dipudato";
    name.text=[NSString stringWithFormat:@"%@ %@",[[candidatos objectAtIndex:index]objectForKey:@"nombres"],[[candidatos objectAtIndex:index]objectForKey:@"apellidoPaterno"]];
    [draggableView addSubview:name];
    [draggableView addSubview:img];
    draggableView.delegate = self;
    draggableView.tag=index;
    draggableView.backgroundColor=[UIColor redColor];
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
    [delegate.navBar pushViewController:detail animated:YES];

}
-(void)getData{

    exampleCardLabels=[[NSMutableArray alloc]init];
    candidatos=[[NSMutableArray alloc]init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    NSString *url =[NSString stringWithFormat:@"https://candidatotransparente.mx/scripts/datos/Diputados.json"];
    
    [manager GET:url parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject){
        loading.hidden=TRUE;
        for (NSDictionary *item in responseObject) {
            
            if ([[item objectForKey:@"entidadFederativa"]isEqualToString:delegate.localidad])
                {
                 [candidatos addObject:item];
                    NSLog(@"se agrego a %@",delegate.localidad);
                }
           
        }
        if ([candidatos count]) {
            exampleCardLabels=candidatos;
            //   NSLog(@"si hay ");
             [self loadCards];
                   }
        else{
            // No Success
            //   NSLog(@"no hay ");
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Mensaje" message:@"No encontramos candidatos en tu zona" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
            [alert show];
            
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
                [self insertSubview:[loadedCards objectAtIndex:i] belowSubview:[loadedCards objectAtIndex:i-1]];
            } else {
                [self addSubview:[loadedCards objectAtIndex:i]];
            }
            cardsLoadedIndex++; //%%% we loaded a card into loaded cards, so we have to increment
        }
    }
}

#warning include own action here!
//%%% action called when the card goes to the left.
// This should be customized with your own action
-(void)cardSwipedLeft:(UIView *)card;
{
    //do whatever you want with the card that was swiped
    //    DraggableView *c = (DraggableView *)card;
    
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
}

#warning include own action here!
//%%% action called when the card goes to the right.
// This should be customized with your own action
-(void)cardSwipedRight:(UIView *)card
{
    //do whatever you want with the card that was swiped
    //    DraggableView *c = (DraggableView *)card;
    
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
    
    if ([[candidatos objectAtIndex:card.tag]objectForKey:@"fiscal"]==NULL || [[candidatos objectAtIndex:card.tag]objectForKey:@"patrimonial"]==NULL || [[candidatos objectAtIndex:card.tag]objectForKey:@"fiscal"]==NULL) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        UIAlertView *a=[[UIAlertView alloc]initWithTitle:@"Mensaje" message:@"Esta persona no te corresponde por que no tiene su 3de3" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        [a show];
    }
    else{
        UIAlertView *a=[[UIAlertView alloc]initWithTitle:@"Mensaje" message:@"Esta persona si te ama" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        [a show];
        
    }

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
            while (tmp==nil) {
                tmp=[UIImage imageNamed:@"h.jpg"];

            }
        }
        else{
            tmp=[UIImage imageNamed:@"h.jpg"];
        }
    
    return tmp;
}
@end

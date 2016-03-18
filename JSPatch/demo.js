

defineClass('yunzhan.AboutVC', {
            
    viewWillAppear: function(animated) {
        
       require('UIImage,UIImageView')
       self.super().viewWillAppear(animated);
            
        var temp = self.view().subviews().objectAtIndex(0);
        if (temp.isKindOfClass(UIImageView.class()))
        {
           var image = temp;
           image.setImage(UIImage.imageNamed("aboutImage"));
        }
    }
});

defineClass('yunzhan_external.AboutVC', {
            
            viewWillAppear: function(animated) {
            
            require('UIImage,UIImageView')
            self.super().viewWillAppear(animated);
            
            var temp = self.view().subviews().objectAtIndex(0);
            if (temp.isKindOfClass(UIImageView.class()))
            {
            var image = temp;
            image.setImage(UIImage.imageNamed("aboutImage"));
            }
            }
});

require('UILabel') 
defineClass('yunzhan.CollectionActView', {

           
    layoutSubviews: function() {
            self.super().layoutSubviews();
             self.introduce().setText("ddd123456789122332424234723847823974878977");
//            self.titleL().setContentCompressionResistancePriority_forAxis(1000, 0);
    },

});

require('CommonWebController,UIAlertView');
defineClass('yunzhan.ViewController', {
            
          
//            viewDidLoad: function() {
//            self.super().viewDidLoad();
//            var alert = UIAlertView.alloc().initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles("123", "789", null, "0", null, null);
//            alert.show();
//            self.test();
//            },

            
            test:function(){
            
            var alert = UIAlertView.alloc().initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles("test", "789", null, "0", null, null);
            alert.show();
            
            },
            
            collectionView_didSelectHeadView: function(link, indexPath) {
            
            
            var alert = UIAlertView.alloc().initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles("123", "789", null, "0", null, null);
            alert.show();
            
            if (link.isEqualToString("")) {
              return;
            }

            var c = CommonWebController.initWithUrl(link);
            c.setHidesBottomBarWhenPushed(true);
            self.navigationController().pushViewController_animated(c, true);
            },
});

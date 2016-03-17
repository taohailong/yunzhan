

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


defineClass('yunzhan.CollectionActView', {

    fullDataToCell: function(data){
            
        require('UILabel,SchedulerData,UILayoutPriorityRequired,UILayoutConstraintAxis')
            
        titleL.text = "\(data.date) \(data.time)";
        introduce.text = "123";
        titleL.setContentCompressionResistancePriority_forAxis(UILayoutPriorityRequired, UILayoutConstraintAxisHorizontal);
    }

});

require('CommonWebController,UIAlertView');
defineClass('yunzhan.ViewController', {
            
          
            fetchData: function() {},
            
//            viewDidLoad: function() {
//            self.super().viewDidLoad();
//            var alert = UIAlertView.alloc().initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles("123", "789", null, "0", null, null);
//            alert.show();
//            
//            },

            
            
            collectionView_didSelectHeadView: function(link, indexPath) {
            
            
            var alert = UIAlertView.alloc().initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles("123", "789", null, "0", null, null);
            alert.show();
            
            if (link.isEqualToString("")) {
            return;
            }
            
            var c = CommonWebController.alloc().init();
            c.setHidesBottomBarWhenPushed(true);
            self.navigationController().pushViewController_animated(c, true);
            },
});

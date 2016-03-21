

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
            self.titleL().setContentCompressionResistancePriority_forAxis(1000, 0);
    },

});


require('UIPageControl,NSString')
defineClass('RepeatScrollView', {
            
            tapAction: function() {
            
            var tapBlock = self.valueForKey("_tapBlock");
                if (tapBlock) {
            
                           var dataSource = self.valueForKey("_dataSource")
                           var pageControl = self.valueForKey("_pageControl")
                           var  tapData = dataSource.objectAtIndex(pageControl.currentPage());
            
                           var link = tapData.getImageUrl();
                          if (link.isKindOfClass(NSString.class()))
                          {
                           }

                           if (link.length() == 70) {
//                           console.log('ok'+ link)
                           return;
                        }
                        tapBlock(pageControl.currentPage(), tapData);
            }
            },
            });


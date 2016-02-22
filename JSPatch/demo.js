

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

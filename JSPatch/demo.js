

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

//        for (var i = 0; i < self.view().subviews().count(); i++)
//        {
//            var temp = self.view().subviews().objectAtIndex(i);
//            if (temp.isKindOfClass(UIImageView.class()))
//            {
//              var image = temp;
//              image.setImage(UIImage.imageNamed("aboutImage"));
//            }
//        }
    
    }
});
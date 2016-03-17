

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

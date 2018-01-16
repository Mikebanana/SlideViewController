# SlideViewController
iOS自定义分段控制器
#使用方法
## 1.创建一个控制器继承LYSlidePageViewController

## 2.在.m文件中
  ```
  //设置标题组
   self.titleArray = @[@"项目信息",@"相关资料",@"投资记录"];
   //创建各子控制器
     UIViewController *vc1 = [UIViewController new];
    vc1.view.backgroundColor = [UIColor redColor];
    UIViewController *vc2 = [UIViewController new];
    vc2.view.backgroundColor = [UIColor yellowColor];
    UIViewController *vc3 = [UIViewController new];
    vc3.view.backgroundColor = [UIColor blueColor];
    //设置成self的子控制器
   self.controllerArray = @[vc1,vc2,vc3];
  ```

## 3.大功告成
![效果图.gif](http://upload-images.jianshu.io/upload_images/3095453-8dcd80d63e6ab9f9.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

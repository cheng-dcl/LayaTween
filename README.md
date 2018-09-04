[cTween.as]:https://github.com/dcl-Cheng/LayaTween/src/cTween.as
[demo]:https://github.com/dcl-Cheng/LayaTween
[demogif]:https://github.com/dcl-Cheng/LayaTween/demo.mp4
# LayaTween
这段时间学习laya做3d小游戏，在想要3d缓动时，发现官方的缓动只能用于2d。且想用一个基本的yoyo和loop时，也是不支持的，需要自己实现。
看到社区里也有很多人问Tween有没有yoyo或3d之类的。所以这里把自己简单实现的分享出来。说不定对刚接触laya的同学有所帮助。

#实现功能
##1，增加loop类型： loop , pingpong
```java
public static const LoopType_None:String = "none";
public static const LoopType_Pingpong:String = "pingpong";
public static const LoopType_Loop:String = "loop";
```

##2,增加简单3d缓动: Position,Scale,Rotation,Color

#使用方式
1，cTween是原Tween上覆盖实现的,实现方式和使用方式尽量保持的跟laya的一致。
2，下载[cTween.as]文件拖到自己项目中。
3，也可以下载整个[demo]，看看效果及调用方式。效果如下：

#如何调用
1，直接cTween.to(...)调用。
```java
public static function to(target:*, props:Object, duration:int,loop:String = LoopType_None, ease:Function = null, complete:Handler = null, delay:int = 0, coverBefore:Boolean = false, autoRecover:Boolean = true) :cTween
例：
//Position  将Cube box2 使用pingpong的方式缓动到（0,2,0位置
cTween.to(this.box2,{localPosition:new Vector3(0,2,0)},2000,cTween.LoopType_Pingpong,Ease.quadIn);
//Color  将Cube box3 的材质颜色使用pingpong的方式改变为黑色
cTween.to(this.box3,{color:new Vector4(0,0,0,1)},2000,cTween.LoopType_Pingpong,null,null,0,true);
```

2，几个3d简单的静态调用函数。
```java
//3D  static function 
public static function positionTo(target:Sprite3D,position:Vector3,duration:int,loop:String = LoopType_None,complete:Handler = null):cTween
public static function scaleTo(target:Sprite3D,scale:Vector3,duration:int,loop:String = LoopType_None,complete:Handler = null):cTween
public static function rotationTo(target:Sprite3D,rotation:Vector3,duration:int,loop:String = LoopType_None,complete:Handler = null):cTween
public static function localPositionTo(target:Sprite3D,position:Vector3,duration:int,loop:String = LoopType_None,complete:Handler = null):cTween
public static function localScaleTo(target:Sprite3D,scale:Vector3,duration:int,loop:String = LoopType_None,complete:Handler = null):cTween
public static function localRotationTo(target:Sprite3D,rotation:Vector3,duration:int,loop:String = LoopType_None,complete:Handler = null):cTween
public static function colorTo(target:Sprite3D,color:Vector4,duration:int,loop:String = LoopType_None,complete:Handler = null):cTween
```

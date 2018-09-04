package {
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.models.BoxMesh;
	import laya.display.Stage;
	import laya.utils.Stat;
	import laya.d3.resource.Texture2D;
	import laya.d3.component.physics.BoxCollider;
	import view.aaaa;
	import laya.utils.Handler;
	import laya.utils.Ease;
	public class LayaAir3D {
		
		private var box0:MeshSprite3D;
		private var box1:MeshSprite3D;
		private var box2:MeshSprite3D;
		private var box3:MeshSprite3D;
		private var box4:MeshSprite3D;
		public function LayaAir3D() {

			//初始化引擎
			Laya3D.init(1280, 760,true);
			
			//适配模式
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;

			//开启统计信息
			//Stat.show();
			
			//添加3D场景
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			//添加照相机
			var camera:Camera = (scene.addChild(new Camera( 0, 0.1, 100))) as Camera;
			camera.transform.translate(new Vector3(0, 1, 8));
			//camera.transform.rotate(new Vector3( 0, 0, 0), true, false);
			camera.clearColor = new Vector4(0.8,0.8,0.8);
	
			//添加方向光
			var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
			directionLight.color = new Vector3(1, 1, 1);
			directionLight.direction = new Vector3(1, -1, -1);



			for(var i:int = 0;i < 5 ; i++){
				this["box" + i] = scene.addChild(new MeshSprite3D(new BoxMesh(1,1,1)));
				//this["box" + i].transform.rotate(new Vector3(0,45,0),false,false);
				this["box" + i].transform.position = new Vector3((i - 2 ) * 3,0,0);
				var material:StandardMaterial = new StandardMaterial();
				material.diffuseTexture = Texture2D.load("res/layabox.png");
				this["box" + i].meshRender.material = material;
			}

			
			//Postion
			cTween.to(this.box0,{localRotationEuler:new Vector3(180,90,0)},2000,cTween.LoopType_Pingpong,null,null,1000,true);
			//Scale
			cTween.to(this.box1,{localScale:new Vector3(2,2,2)},2000,cTween.LoopType_Pingpong,Ease.elasticIn);
			//Rotation
			cTween.to(this.box2,{localPosition:new Vector3(box2.transform.position.x,2,0)},2000,cTween.LoopType_Pingpong,Ease.quadIn);
			//Color
			cTween.to(this.box3,{color:new Vector4(0,0,0,1)},2000,cTween.LoopType_Pingpong,null,null,0,true);

			//Lines    Static simple Function
			var lines:Function = function():void{
				cTween.positionTo(this.box4,new Vector3(6,2,0),2000,cTween.LoopType_None,Handler.create(this,function():void{
					cTween.scaleTo(this.box4,new Vector3(2,2,2),2000,cTween.LoopType_None,Handler.create(this,function():void{
						cTween.localRotationTo(this.box4,new Vector3(360,0,0),2000,cTween.LoopType_None,Handler.create(this,function():void{
							cTween.colorTo(this.box4,new Vector4(0,0,0,1),2000,cTween.LoopType_None,Handler.create(this,function():void{
								cTween.positionTo(this.box4,new Vector3(6,0,0),2000);
								cTween.colorTo(this.box4,new Vector4(1,1,1,1),2000);
								cTween.scaleTo(this.box4,new Vector3(1,1,1),2000,cTween.LoopType_None,Handler.create(this,function():void{
									lines();
								}))
							}));
						}));
					}));
				}));
			}
			lines();
		
			new aaaa().show();
		}		
	}
}
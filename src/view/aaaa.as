/**Created by the LayaAirIDE*/
package view
{
	import ui.aaaaUI
	import laya.utils.Ease;

	public class aaaa extends aaaaUI
	{
		
		public function aaaa() 
		{
			
		}
		

		override public function onOpened():void {
			cTween.to(txt1,{x:600},2000,cTween.LoopType_Pingpong);
			cTween.to(txt,{x:600},2000,cTween.LoopType_Loop);

			prompt.text ="3d左起：box0 -- box4 \n" +
						 "box0 : RotationEuler 旋转 \n" + 
						 "box1 : Scale 缩放 \n" +
						 "box2 : Position 移动 \n" +
						 "box3 : Color  材质颜色\n" +
						 "box4 : Lines  整合方法实例  "
		}
	}

}
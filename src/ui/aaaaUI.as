/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 
	import laya.display.Text;

	public class aaaaUI extends Dialog {
		public var txt:Text;
		public var prompt:TextArea;
		public var txt1:Text;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"Dialog","props":{"y":0,"x":0,"width":1280,"height":760},"child":[{"type":"Text","props":{"y":92,"x":800,"width":323,"var":"txt","text":"2d : loop","height":100,"fontSize":50,"color":"#000000"}},{"type":"TextArea","props":{"y":77,"x":27,"width":541,"var":"prompt","height":291,"fontSize":20,"color":"#030303"}},{"type":"Text","props":{"y":194,"x":800,"width":323,"var":"txt1","text":"2d : pingpong","height":100,"fontSize":50,"color":"#000000"}}]};
		override protected function createChildren():void {
			View.regComponent("Text",Text);
			super.createChildren();
			createView(uiView);

		}

	}
}
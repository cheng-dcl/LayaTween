package {
	/*[IF-FLASH]*/
	import flash.utils.Dictionary;
	import laya.display.Node;
	import laya.utils.Handler;
	import laya.utils.Pool;
	import laya.utils.Browser;
	import laya.d3.math.Vector3;
	import laya.utils.Utils;
	import laya.d3.utils.Utils3D;
	import laya.display.Sprite;
	import laya.d3.core.Transform3D;
	import laya.d3.math.Quaternion;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.material.BlinnPhongMaterial;
	import laya.d3.math.Vector4;
	import laya.utils.Ease;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.material.PBRMaterial;
	import laya.d3.core.material.PBRStandardMaterial;
	import laya.d3.core.material.PBRSpecularMaterial;
	import laya.d3.core.particleShuriKen.ShurikenParticleMaterial;
	import laya.d3.core.material.ExtendTerrainMaterial;
	
	/**
	 * <code>Tween</code>  是一个缓动类。使用此类能够实现对目标对象属性的渐变。
	 * author: dcl-Cheng
	 */
	public class cTween {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		/**@private */
		/*[IF-FLASH]*/
		private static var tweenMap:flash.utils.Dictionary = new flash.utils.Dictionary(true);
		//[IF-JS] private static var tweenMap:Array = {};
		/**@private */
		private var _complete:Handler;
		/**@private */
		private var _target:*;
		/**@private */
		private var _ease:Function;
		/**@private */
		private var _props:Array;
		/**@private */
		private var _duration:int;
		/**@private */
		private var _delay:int;
		/**@private */
		private var _startTimer:int;
		/**@private */
		private var _usedTimer:int;
		/**@private */
		private var _usedPool:Boolean;
		/**@private */
		private var _delayParam:Array;

		/**@private 唯一标识，TimeLintLite用到*/
		public var gid:int = 0;
		/**更新回调，缓动数值发生变化时，回调变化的值*/
		public var update:Handler;
		

		public static const LoopType_None:String = "none";
		public static const LoopType_Pingpong:String = "pingpong";
		public static const LoopType_Loop:String = "loop";

		private var _propsObject:Object;
		private var _loop:String;
		private var _isTo:Boolean;
		private var _material:BaseMaterial;
		private var vector3_start:Vector3;
		private var vector3_end:Vector3;
		private var vector3_lerp:Vector3;
		private var vector4_start:Vector4
		private var vector4_end:Vector4 
		private var vector4_lerp:Vector4;
		/**
		 * 缓动对象的props属性到目标值。
		 * @param	target 目标对象(即将更改属性值的对象)。
		 * @param	props 变化的属性列表，比如{x:100,y:20,ease:Ease.backOut,complete:Handler.create(this,onComplete),update:new Handler(this,onComplete)}。
		 * @param	duration 花费的时间，单位毫秒。
		 * @param	ease 缓动类型，默认为匀速运动。
		 * @param	complete 结束回调函数。
		 * @param	delay 延迟执行时间。
		 * @param	coverBefore 是否覆盖之前的缓动。
		 * @param	autoRecover 是否自动回收，默认为true，缓动结束之后自动回收到对象池。
		 * @return	返回Tween对象。
		 */
		public static function to(target:*, props:Object, duration:int,loop:String = LoopType_None, ease:Function = null, complete:Handler = null, delay:int = 0, coverBefore:Boolean = false, autoRecover:Boolean = true):cTween {
			return Pool.getItemByClass("ctween", cTween)._create(target, props, duration,loop, ease, complete, delay, coverBefore, true, autoRecover, true);
		}
		
		/**
		 * 从props属性，缓动到当前状态。
		 * @param	target 目标对象(即将更改属性值的对象)。
		 * @param	props 变化的属性列表，比如{x:100,y:20,ease:Ease.backOut,complete:Handler.create(this,onComplete),update:new Handler(this,onComplete)}。
		 * @param	duration 花费的时间，单位毫秒。
		 * @param	ease 缓动类型，默认为匀速运动。
		 * @param	complete 结束回调函数。
		 * @param	delay 延迟执行时间。
		 * @param	coverBefore 是否覆盖之前的缓动。
		 * @param	autoRecover 是否自动回收，默认为true，缓动结束之后自动回收到对象池。
		 * @return	返回Tween对象。
		 */
		public static function from(target:*, props:Object, duration:int,loop:String = LoopType_None, ease:Function = null, complete:Handler = null, delay:int = 0, coverBefore:Boolean = false, autoRecover:Boolean = true):cTween {
			return Pool.getItemByClass("ctween", cTween)._create(target, props, duration,loop, ease, complete, delay, coverBefore, false, autoRecover, true);
		}
		
		/**
		 * 缓动对象的props属性到目标值。
		 * @param	target 目标对象(即将更改属性值的对象)。
		 * @param	props 变化的属性列表，比如{x:100,y:20,ease:Ease.backOut,complete:Handler.create(this,onComplete),update:new Handler(this,onComplete)}。
		 * @param	duration 花费的时间，单位毫秒。
		 * @param	ease 缓动类型，默认为匀速运动。
		 * @param	complete 结束回调函数。
		 * @param	delay 延迟执行时间。
		 * @param	coverBefore 是否覆盖之前的缓动。
		 * @return	返回Tween对象。
		 */
		public function to(target:*, props:Object, duration:int,loop:String = LoopType_None, ease:Function = null, complete:Handler = null, delay:int = 0, coverBefore:Boolean = false):cTween {
			return _create(target, props, duration,loop, ease, complete, delay, coverBefore, true, false, true);
		}
		
		/**
		 * 从props属性，缓动到当前状态。
		 * @param	target 目标对象(即将更改属性值的对象)。
		 * @param	props 变化的属性列表，比如{x:100,y:20,ease:Ease.backOut,complete:Handler.create(this,onComplete),update:new Handler(this,onComplete)}。
		 * @param	duration 花费的时间，单位毫秒。
		 * @param	ease 缓动类型，默认为匀速运动。
		 * @param	complete 结束回调函数。
		 * @param	delay 延迟执行时间。
		 * @param	coverBefore 是否覆盖之前的缓动。
		 * @return	返回Tween对象。
		 */
		public function from(target:*, props:Object, duration:int,loop:String = LoopType_None, ease:Function = null, complete:Handler = null, delay:int = 0, coverBefore:Boolean = false):cTween {
			return _create(target, props, duration,loop, ease, complete, delay, coverBefore, false, false, true);
		}

		//3D  static function
		public static function positionTo(target:Sprite3D,position:Vector3,duration:int,loop:String = LoopType_None,complete:Handler = null):cTween{
			return cTween.to(target,{"position":position},duration,loop,null,complete);
		}

		public static function scaleTo(target:Sprite3D,scale:Vector3,duration:int,loop:String = LoopType_None,complete:Handler = null):cTween{

			return cTween.to(target,{"scale":scale},duration,loop,null,complete);
		}

		public static function rotationTo(target:Sprite3D,rotation:Vector3,duration:int,loop:String = LoopType_None,complete:Handler = null):cTween{; 
			return cTween.to(target, {"rotationEuler":rotation},duration,loop,null,complete);
		}

		public static function localPositionTo(target:Sprite3D,position:Vector3,duration:int,loop:String = LoopType_None,complete:Handler = null):cTween{
			return cTween.to(target,{"localPosition":position},duration,loop,null,complete);
		}

		public static function localScaleTo(target:Sprite3D,scale:Vector3,duration:int,loop:String = LoopType_None,complete:Handler = null):cTween{
			return cTween.to(target,{"localScale":scale},duration,loop,null,complete);
		}

		public static function localRotationTo(target:Sprite3D,rotation:Vector3,duration:int,loop:String = LoopType_None,complete:Handler = null):cTween{
			return cTween.to(target,{"localRotationEuler":rotation},duration,loop,null,complete);
		}

		public static function colorTo(target:Sprite3D,color:Vector4,duration:int,loop:String = LoopType_None,complete:Handler = null):cTween{
			if(!target as MeshSprite3D) return null; 
			return cTween.to(target,{"color":color},duration,loop,null,complete);
		}
		
		/** @private */
		public function _create(target:*, props:Object, duration:int,loop:String, ease:Function, complete:Handler, delay:int, coverBefore:Boolean, isTo:Boolean, usePool:Boolean, runNow:Boolean):cTween {
			if (!target) throw new Error("Tween:target is null");
			this._target = target;
			this._duration = duration;
			this._ease = ease || props.ease || easeNone;
			this._loop = loop || props.loop || LoopType_None;
			this._complete = complete || props.complete;
			this._delay = delay;
			this._props = [];
			this._usedTimer = 0;
			this._startTimer = Browser.now();
			this._usedPool = usePool;
			this._delayParam = null;
			this.update = props.update;
			this._propsObject = {};
			this._propsObject = props;
			this._isTo = isTo;
			
			//判断是否覆盖			
			//[IF-JS]var gid:int = (target.$_GID || (target.$_GID = Utils.getGID()));
			/*[IF-FLASH]*/
			var gid:* = target;
			if (!tweenMap[gid]) {
				tweenMap[gid] = [this];
			} else {
				if (coverBefore) clearTween(target);
				tweenMap[gid].push(this);
			}			
			toStart(target,props,isTo,runNow);
			return this;
		}

		private function toStart(target:*, props:Object, isTo:Boolean,runNow:Boolean):void{
			if (runNow) {
				if (this._delay <= 0) firstStart(target, props, isTo);
				else
				{
					_delayParam = [target, props, isTo];
					Laya.scaleTimer.once(this._delay, this, firstStart, _delayParam);
				} 
			} else {
				_initProps(target, props, isTo);
			}
		}
		
		private function firstStart(target:*, props:Object, isTo:Boolean):void {
			_delayParam = null;
			if (target.destroyed) {
				this.clear();
				return;
			}
			_initProps(target, props, isTo);
			_beginLoop();
		}
		
		private function _initProps(target:*, props:Object, isTo:Boolean):void {
			//初始化属性
			for (var p:String in props) {
				if (target[p] is Number) {
					var start:Number = isTo ? target[p] : props[p];
					var end:Number = isTo ? props[p] : target[p];
					this._props.push([p, start, end - start,end]);
					if (!isTo) target[p] = start;
				}
				if(target.transform && target.transform[p] is Vector3){
					vector3_lerp = new Vector3();
					vector3_start = isTo ? target.transform[p] : props[p];
					vector3_end = isTo ? props[p] : target.transform[p]; 
					vector3_end = new Vector3(clerp(vector3_start.x,vector3_end.x,1),clerp(vector3_start.y,vector3_end.y,1),clerp(vector3_start.z,vector3_end.z,1));
					Vector3.subtract( vector3_end,vector3_start,vector3_lerp);
					this._props.push([p, vector3_start,vector3_lerp,vector3_end]);
					if (!isTo) target[p] = vector3_start;

					
				}
				if(p.toLowerCase() == "color" && (target as MeshSprite3D)){
					_material = (target as MeshSprite3D).meshRender.material;
					var oc:Vector4;
					//TODO 常用的材质，需要再添加
					// oc = (_material as StandardMaterial).albedoColor;
					// oc = (_material as BlinnPhongMaterial).albedoColor;
					// oc = (_material as PBRStandardMaterial).albedoColor;
					// oc = (_material as PBRSpecularMaterial).albedoColor;
					// oc = (_material as ShurikenParticleMaterial).tintColor;	
					if(_material["tintColor"]) oc = _material["tintColor"];
					if(_material["albedoColor"]) oc = _material["albedoColor"];
					vector4_lerp = new Vector4();		
					vector4_start = isTo ? oc : props[p];
					vector4_end = isTo ? props[p] : oc; 
					Vector4.subtract(vector4_end,vector4_start,vector4_lerp)
					this._props.push([p, vector4_start,vector4_lerp,vector4_end]);
					if (!isTo) target[p] = vector4_start;
				}
			}
		}
		
		private function _beginLoop():void {
			Laya.timer.frameLoop(1, this, _doEase);
		}
		
		/**执行缓动**/
		private function _doEase():void {
			_updateEase(Browser.now());
		}
		
		/**@private */
		public function _updateEase(time:Number):void {
			var target:* = this._target;
			if (!target) return;
			
			//如果对象被销毁，则立即停止缓动
			/*[IF-FLASH]*/
			if (target is Node && target.destroyed) return clearTween(target);
			//[IF-JS]if (target.destroyed) return clearTween(target);
			
			var usedTimer:Number = this._usedTimer = time - this._startTimer - this._delay;

			if (usedTimer < 0) return;
			if (usedTimer >= this._duration) return complete();
			var ratio:Number = usedTimer > 0 ? this._ease(usedTimer, 0, 1, this._duration) : 0;
			var props:Array = this._props;
			for (var i:int, n:int = props.length; i < n; i++) {
				var prop:Array = props[i];
				if(target[prop[0]] is Number){
					target[prop[0]] = prop[1] + (ratio * prop[2]);
				}
				
				//3d   Position,RotationEular,Scale  
				//target = Sprite3d ，不能使用Transform3d对象，引擎会报莫名的错误。
				if(target.transform && target.transform[prop[0]] is Vector3){
					target.transform[prop[0]] = new Vector3(
						prop[1].x + (ratio * prop[2].x),
						prop[1].y + (ratio * prop[2].y),
						prop[1].z + (ratio * prop[2].z));

					// target.transform.rotate(new Vector3(
					// 	(ratio * prop[2].x),
					// 	(ratio * prop[2].y),
					// 	(ratio * prop[2].z)),false,false);

					// target.transform.localRotation = Eular(new Vector3(
					// 	prop[1].x + (ratio * prop[2].x),
					// 	prop[1].y + (ratio * prop[2].y),
					// 	prop[1].z + (ratio * prop[2].z)));
				}

				//3d   材质更换颜色  这里只做了BlinnPhongMaterial
				//target = MeshSprite3D 
				if(prop[0].toLowerCase() == "color" && (target as MeshSprite3D)){
					var color:Vector4 = new Vector4(
						prop[1].x + (ratio * prop[2].x),
						prop[1].y + (ratio * prop[2].y),
						prop[1].z + (ratio * prop[2].z),
						1);
					if(_material["albedoColor"])
						 _material["albedoColor"] = color;
					if(_material["tintColor"])
						 _material["tintColor"] = color;
				}
			}
			if (update) update.run();
		}


		private function Eular(v:Vector3):Quaternion{
			var q:Quaternion;
			var ex:Number = v.x * 0.0174532925 / 2;
			var ey:Number = v.y * 0.0174532925 / 2;
			var ez:Number = v.z * 0.0174532925 / 2;
			var qx:Number, qy:Number, qz:Number, qw:Number;
			qx = Math.sin(ex) * Math.cos(ey) * Math.cos(ez) + Math.cos(ex) * Math.sin(ey) * Math.sin(ez);
			qy = Math.cos(ex) * Math.sin(ey) * Math.cos(ez) - Math.sin(ex) * Math.cos(ey) * Math.sin(ez);
			qz = Math.cos(ex) * Math.cos(ey) * Math.sin(ez) - Math.sin(ex) * Math.sin(ey) * Math.cos(ez);
			qw = Math.cos(ex) * Math.cos(ey) * Math.cos(ez) + Math.sin(ex) * Math.sin(ey) * Math.sin(ez);
			q = new Quaternion(qx, qy, qz, qw);
			return q;
		}

		private function clerp(start:Number, end:Number, value:Number):Number{
			var min:Number = 0.0;
			var max:Number = 360.0;

			var half:Number = Math.abs((max - min) * 0.5);
			var retval:Number = 0.0;
			var diff:Number = 0.0;
			if ((end - start) < -half){
				diff = ((max - start) + end) * value;
				retval = start + diff;
			}else if ((end - start) > half){
				diff = -((max - end) + start) * value;
				retval = start + diff;
			}else retval = start + (end - start) * value;
			return retval;
		}
		
		/**设置当前执行比例**/
		public function set progress(v:Number):void {
			var uTime:Number = v * _duration;
			this._startTimer = Browser.now() - this._delay - uTime;
		}
		
		/**
		 * 立即结束缓动并到终点。
		 */
		public function complete():void {
			if (!this._target) return;
			//立即执行初始化
			Laya.scaleTimer.runTimer(this, firstStart);
			//缓存当前属性
			var target:* = this._target;
			var handler:Handler = this._complete;
			
			completeData();
			if (update) update.run();
			if(this._loop == LoopType_Loop || this._loop == LoopType_Pingpong){
				this._usedTimer = 0;
				this._startTimer = Browser.now();
				this._props = [];
				toStart(target,this._propsObject,this._loop == LoopType_Pingpong ? true : this._isTo,true);
			}else{
				//清理
				clear();
			}
			//回调
			handler && handler.run();
		}

		/**
		 * 设置终点属性, 改变缓动类别数据
		 */
		private function completeData():void{
			//缓存当前属性
			var target:* = this._target;
			var props:* = this._props;
			for (var i:int, n:int = props.length; i < n; i++) {
				var prop:Array = props[i];
				if(target[prop[0]] is Number){
					
					if(this._loop == LoopType_Loop){
						target[prop[0]] = prop[1];
						if(!this._isTo)
							target[prop[0]] = prop[3];
					}else{
						target[prop[0]] = prop[3];
						
					}
				}
				
				if(target.transform && target.transform[prop[0]] is Vector3){
					if(this._loop == LoopType_Loop){
						target.transform[prop[0]] = prop[1];
						if(!this._isTo)
							target.transform[prop[0]] = prop[3];
					}else{
						target.transform[prop[0]] = prop[3];
					}
				}
				if(prop[0].toLowerCase() == "color" && (target as MeshSprite3D)){
					var color:Vector4;
					if(this._loop == LoopType_Loop){
						color =  prop[1];
						if(!this._isTo)
							color =  prop[3];
					}else{
						color =  prop[3];
					}
					if(_material["albedoColor"])
						 _material["albedoColor"] = color;
					if(_material["tintColor"])
						 _material["tintColor"] = color;
				}

				if(this._loop == LoopType_Pingpong){
					this._propsObject[prop[0]] = prop[1];

				}
			}
		}
		
		/**
		 * 暂停缓动，可以通过resume或restart重新开始。
		 */
		public function pause():void {
			Laya.scaleTimer.clear(this, _beginLoop);
			Laya.scaleTimer.clear(this, _doEase);
			Laya.scaleTimer.clear(this, firstStart);
			var time:Number = Browser.now();
			var dTime:Number;
			dTime = time - this._startTimer - this._delay;
			if (dTime < 0)
			{
				this._usedTimer = dTime;
			}
			
		}
		
		/**
		 * 设置开始时间。
		 * @param	startTime 开始时间。
		 */
		public function setStartTime(startTime:Number):void {
			_startTimer = startTime;
		}
		
		/**
		 * 清理指定目标对象上的所有缓动。
		 * @param	target 目标对象。
		 */
		public static function clearAll(target:Object):void {
			/*[IF-FLASH]*/
			if (!target) return;
			//[IF-JS]if (!target || !target.$_GID) return;
			/*[IF-FLASH]*/
			var tweens:Array = tweenMap[target];
			//[IF-JS]var tweens:Array = tweenMap[target.$_GID];
			if (tweens) {
				for (var i:int, n:int = tweens.length; i < n; i++) {
					tweens[i]._clear();
				}
				tweens.length = 0;
			}
		}
		
		/**
		 * 清理某个缓动。
		 * @param	tween 缓动对象。
		 */
		public static function clear(tween:cTween):void {
			tween.clear();
		}
		
		/**@private 同clearAll，废弃掉，尽量别用。*/
		public static function clearTween(target:Object):void {
			clearAll(target);
		}
		
		/**
		 * 停止并清理当前缓动。
		 */
		public function clear():void {
			if (this._target) {
				_remove();
				_clear();
			}
		}
		
		/**
		 * @private
		 */
		public function _clear():void {
			pause();
			Laya.scaleTimer.clear(this, firstStart);
			this._complete = null;
			this._target = null;
			this._ease = null;
			this._props = null;
			this._delayParam = null;
			this._propsObject = null;
			if (this._usedPool) {
				this.update = null;
				Pool.recover("ctween", this);
			}
		}
		
		/** 回收到对象池。*/
		public function recover():void {
			_usedPool = true;
			_clear();
		}
		
		private function _remove():void {
			/*[IF-FLASH]*/
			var tweens:Array = tweenMap[this._target];
			//[IF-JS]var tweens:Array = tweenMap[this._target.$_GID];
			if (tweens) {
				for (var i:int, n:int = tweens.length; i < n; i++) {
					if (tweens[i] === this) {
						tweens.splice(i, 1);
						break;
					}
				}
			}
		}
		
		/**
		 * 重新开始暂停的缓动。
		 */
		public function restart():void {
			pause();
			this._usedTimer = 0;
			this._startTimer = Browser.now();
			if (this._delayParam)
			{
				Laya.scaleTimer.once( this._delay, this, firstStart, this._delayParam);
				return;
			}
			var props:Array = this._props;
			for (var i:int, n:int = props.length; i < n; i++) {
				var prop:Array = props[i];
				this._target[prop[0]] = prop[1];
			}
			Laya.scaleTimer.once(this._delay, this, _beginLoop);
		}
		
		/**
		 * 恢复暂停的缓动。
		 */
		public function resume():void {
			if (this._usedTimer >= this._duration) return;
			this._startTimer = Browser.now() - this._usedTimer - this._delay;
			if (this._delayParam)
			{
				if (this._usedTimer < 0)
				{
					Laya.scaleTimer.once(-this._usedTimer, this, firstStart, this._delayParam);
				}else
				{
					firstStart.apply(this, this._delayParam);
				}
			}else
			{
				_beginLoop();
			}	
		}
		
		private static function easeNone(t:Number, b:Number, c:Number, d:Number):Number {
			return c * t / d + b;
		}
	}
}
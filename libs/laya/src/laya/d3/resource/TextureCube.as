package laya.d3.resource {
	import laya.events.Event;
	import laya.maths.Arith;
	import laya.resource.Bitmap;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	public class TextureCube extends BaseTexture {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**@private */
		private const _texCount:int = 6;
		
		/**@private */
		private var _loadedImgCount:int;
		
		/**HTML Image*/
		private var _images:Array;
		
		/**@private 文件路径全名。*/
		protected var _srcs:Array;
		
		/**异步加载锁*/
		protected var _recreateLock:Boolean = false;
		/**异步加载完成后是否需要释放（有可能在恢复过程中,再次被释放，用此变量做标记）*/
		protected var _needReleaseAgain:Boolean = false;
		
		/**
		 * 文件路径全名。
		 */
		public function get srcs():Array {
			return _srcs;
		}
		
		public function TextureCube(srcs:Array, size:int = 512) {//TODO:临时设置512
			super();
			
			if (srcs.length < _texCount)
				throw new Error("srcs路径数组长度小于6！");
			
			_loadedImgCount = 0;
			
			_srcs = srcs;
			_width = size;
			_height = size;
			_images = [];
			
			for (var i:int = 0; i < _texCount; i++) {
				Laya.loader.load(_srcs[i], Handler.create(this, _onSubCubeTextureLoaded, [i], true), null, "nativeimage", 1, false);
			}
		}
		
		private function _onSubCubeTextureLoaded(index:int, img:*):void {
			_images[index] = img;
			_loadedImgCount++;
			if (_loadedImgCount == _texCount) {
				_loaded = true;
				event(Event.LOADED, this);
			}
		}
		
		private function _createWebGlTexture():void {
			var i:int;
			for (i = 0; i < _texCount; i++) {
				if (!_images[i]) {
					throw "create GLTextur err:no data:" + _images[i];
				}
			}
			var gl:WebGLContext = WebGL.mainContext;
			var glTex:* = _source = gl.createTexture();
			var w:int = _width;
			var h:int = _height;
			
			var preTarget:* = WebGLContext.curBindTexTarget;
			var preTexture:* = WebGLContext.curBindTexValue;
			WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_CUBE_MAP, glTex);
			gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_POSITIVE_X, 0, WebGLContext.RGBA, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, _images[0]);
			gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_NEGATIVE_X, 0, WebGLContext.RGBA, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, _images[1]);
			gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_POSITIVE_Y, 0, WebGLContext.RGBA, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, _images[2]);
			gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_NEGATIVE_Y, 0, WebGLContext.RGBA, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, _images[3]);
			gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_POSITIVE_Z, 0, WebGLContext.RGBA, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, _images[4]);
			gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_NEGATIVE_Z, 0, WebGLContext.RGBA, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, _images[5]);
			
			var minFifter:int = this.minFifter;
			var magFifter:int = this.magFifter;
			var repeat:int = this.repeat ? WebGLContext.REPEAT : WebGLContext.CLAMP_TO_EDGE
			
			var isPOT:Boolean = Arith.isPOT(w, h);
			if (isPOT) {
				if (this.mipmap)
					(minFifter !== -1) || (minFifter = WebGLContext.LINEAR_MIPMAP_LINEAR);
				else
					(minFifter !== -1) || (minFifter = WebGLContext.LINEAR);
				
				(magFifter !== -1) || (magFifter = WebGLContext.LINEAR);
				
				gl.texParameteri(WebGLContext.TEXTURE_CUBE_MAP, WebGLContext.TEXTURE_MIN_FILTER, minFifter);
				gl.texParameteri(WebGLContext.TEXTURE_CUBE_MAP, WebGLContext.TEXTURE_MAG_FILTER, magFifter);
				gl.texParameteri(WebGLContext.TEXTURE_CUBE_MAP, WebGLContext.TEXTURE_WRAP_S, repeat);
				gl.texParameteri(WebGLContext.TEXTURE_CUBE_MAP, WebGLContext.TEXTURE_WRAP_T, repeat);
				this.mipmap && gl.generateMipmap(WebGLContext.TEXTURE_CUBE_MAP);
			} else {
				(minFifter !== -1) || (minFifter = WebGLContext.LINEAR);
				(magFifter !== -1) || (magFifter = WebGLContext.LINEAR);
				gl.texParameteri(WebGLContext.TEXTURE_CUBE_MAP, WebGLContext.TEXTURE_MIN_FILTER, minFifter);
				gl.texParameteri(WebGLContext.TEXTURE_CUBE_MAP, WebGLContext.TEXTURE_MAG_FILTER, magFifter);
				gl.texParameteri(WebGLContext.TEXTURE_CUBE_MAP, WebGLContext.TEXTURE_WRAP_S, WebGLContext.CLAMP_TO_EDGE);
				gl.texParameteri(WebGLContext.TEXTURE_CUBE_MAP, WebGLContext.TEXTURE_WRAP_T, WebGLContext.CLAMP_TO_EDGE);
			}
			(preTarget && preTexture) && (WebGLContext.bindTexture(gl, preTarget, preTexture));
			for (i = 0; i < 6; i++) {
				_images[i].onload = null;//统一清理回调事件
				_images[i] = null;
			}
			
			if (isPOT)
				memorySize = w * h * 4 * (1 + 1 / 3) * _texCount;//使用mipmap则在原来的基础上增加1/3
			else
				memorySize = w * h * 4 * _texCount;
			_recreateLock = false;
		}
		
		override protected function recreateResource():void {
			if (_srcs == null)
				return;
			
			_needReleaseAgain = false;
			if (!_images[0]) {
				_recreateLock = true;
				startCreate();
				var _this:TextureCube = this;
				
				for (var i:int = 0; i < _texCount; i++) {
					_images[i] = new Browser.window.Image();
					_images[i].crossOrigin = "";
					
					var index:int = i;
					_images[index].onload = function():void {
						var j:int;
						if (_this._needReleaseAgain)//异步处理，加载完后可能，如果强制释放资源存在已被释放的风险
						{
							for (j = 0; j < _texCount; j++)
								if (!_this._images[j].complete)
									return;
							
							_this._needReleaseAgain = false;
							
							for (j = 0; j < _texCount; j++) {
								_this._images[j].onload = null;
								_this._images[j] = null;
							}
							return;
						}
						
						for (j = 0; j < _texCount; j++)
							if (!_this._images[j].complete)
								return;
						
						_this._createWebGlTexture();
						_this.completeCreate();//处理创建完成后相关操作
					};
					_images[i].src = _srcs[i];
				}
			} else {
				if (_recreateLock) {
					return;
				}
				startCreate();
				_createWebGlTexture();
				completeCreate();//处理创建完成后相关操作
			}
		}
		
		override protected function detoryResource():void {
			if (_recreateLock) {
				_needReleaseAgain = true;
			}
			if (_source) {
				WebGL.mainContext.deleteTexture(_source);
				_source = null;
				memorySize = 0;
			}
		}
	
	}

}
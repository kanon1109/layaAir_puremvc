package laya.d3.graphics {
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.math.Matrix4x4;
	import laya.d3.shader.ShaderDefines3D;
	import laya.d3.utils.Utils3D;
	import laya.utils.Stat;
	import laya.webgl.WebGLContext;
	import laya.webgl.shader.Shader;
	import laya.webgl.utils.Buffer2D;
	
	/**
	 * @private
	 * <code>DynamicBatch</code> 类用于动态批处理。
	 */
	public class DynamicBatch implements IRenderable {//TODO:可不继承自IRender
		public static var maxVertexCount:int = 20000;//TODO:应该以浮点个数或者尺寸计算
		public static var maxIndexCount:int = 40000;
		public static const maxCombineTriangleCount:int = 50;
		
		public var _vertexDeclaration:VertexDeclaration;
		private var _vertexDatas:Float32Array;
		private var _indexDatas:Uint16Array;
		private var _vertexBuffer:VertexBuffer3D;
		private var _indexBuffer:IndexBuffer3D;
		private var _currentCombineVertexCount:int;
		private var _currentCombineIndexCount:int;
		
		private var _combineRenderElements:Vector.<RenderElement>;
		private var _materials:Vector.<BaseMaterial>;
		private var _materialToRenderElementsOffsets:Vector.<int>;
		private var _merageElements:Vector.<RenderElement>;
		
		private var _combineRenderElementPool:Vector.<RenderElement>;
		private var _combineRenderElementPoolIndex:int;
		
		public function get indexOfHost():int {
			return 0;
		}
		
		public function get _vertexBufferCount():int {
			return 1;
		}
		
		public function get triangleCount():int {
			return _indexBuffer.indexCount / 3;
		}
		
		public function get combineRenderElementsCount():int {
			return _combineRenderElements.length;
		}
		
		public function _getVertexBuffer(index:int = 0):VertexBuffer3D {
			if (index === 0)
				return _vertexBuffer;
			else
				return null;
		}
		
		public function _getIndexBuffer():IndexBuffer3D {
			return _indexBuffer;
		}
		
		public function DynamicBatch(vertexDeclaration:VertexDeclaration) {
			_currentCombineVertexCount = 0;
			_currentCombineIndexCount = 0;
			
			_combineRenderElements = new Vector.<RenderElement>();
			_materialToRenderElementsOffsets = new Vector.<int>();
			_materials = new Vector.<BaseMaterial>();
			_merageElements = new Vector.<RenderElement>();
			
			_combineRenderElementPool = new Vector.<RenderElement>();
			_combineRenderElementPoolIndex = 0;
			
			_vertexDeclaration = vertexDeclaration;
		}
		
		private function _testTangent(state:RenderState):void {
			//var vb:VertexBuffer3D = _vertexBuffer;
			//var vertexDeclaration:VertexDeclaration = vb.vertexDeclaration;
			//var material:BaseMaterial = state.renderElement._material;
			//if (material.normalTexture && !vertexDeclaration.shaderAttribute[VertexElementUsage.TANGENT0]) {
				////是否放到事件触发。
				//var vertexDatas:Float32Array = vb.getData();
				//var newVertexDatas:Float32Array = Utils3D.generateTangent(vertexDatas, vertexDeclaration.vertexStride / 4, vertexDeclaration.shaderAttribute[VertexElementUsage.POSITION0][4] / 4, vertexDeclaration.shaderAttribute[VertexElementUsage.TEXTURECOORDINATE0][4] / 4, _indexBuffer.getData());
				//vertexDeclaration = Utils3D.getVertexTangentDeclaration(vertexDeclaration.getVertexElements());
				//
				//var newVB:VertexBuffer3D = VertexBuffer3D.create(vertexDeclaration, WebGLContext.STATIC_DRAW);
				//newVB.setData(newVertexDatas);
				//vb.dispose();
				//_vertexBuffer = newVB;
			//}
		}
		
		private function _getCombineRenderElementFromPool():RenderElement {
			var renderElement:RenderElement = _combineRenderElementPool[_combineRenderElementPoolIndex++];
			return renderElement || (_combineRenderElementPool[_combineRenderElementPoolIndex - 1] = new RenderElement());
		}
		
		private function _getRenderElement():void {
			if (!_vertexDatas) {
				_vertexDatas = new Float32Array(_vertexDeclaration.vertexStride / 4 * maxVertexCount);
				_indexDatas = new Uint16Array(maxIndexCount);
				_vertexBuffer = VertexBuffer3D.create(_vertexDeclaration, maxVertexCount, WebGLContext.DYNAMIC_DRAW);
				_indexBuffer = IndexBuffer3D.create(IndexBuffer3D.INDEXTYPE_USHORT, maxIndexCount, WebGLContext.DYNAMIC_DRAW);
			}
			
			_merageElements.length = 0;
			var curMerVerCount:int = 0;
			var curIndexCount:int = 0;
			for (var i:int = 0, n:int = _combineRenderElements.length; i < n; i++) {
				var renderElement:RenderElement = _combineRenderElements[i];
				var subVertexDatas:Float32Array = renderElement.getDynamicBatchBakedVertexs(0);
				var subIndexDatas:Uint16Array = renderElement.getBakedIndices();
				
				var indexOffset:int = curMerVerCount / (_vertexDeclaration.vertexStride / 4);
				var indexStart:int = curIndexCount;
				var indexEnd:int = indexStart + subIndexDatas.length;
				
				renderElement._batchIndexStart = indexStart;
				renderElement._batchIndexEnd = indexEnd;
				
				_indexDatas.set(subIndexDatas, curIndexCount);
				for (var k:int = indexStart; k < indexEnd; k++)
					_indexDatas[k] = indexOffset + _indexDatas[k];
				curIndexCount += subIndexDatas.length;
				
				_vertexDatas.set(subVertexDatas, curMerVerCount);
				curMerVerCount += subVertexDatas.length;
			}
			_vertexBuffer.setData(_vertexDatas);
			_indexBuffer.setData(_indexDatas);
			
			_combineRenderElementPoolIndex = 0;//归零对象池指针
			for (i = 0, n = _materials.length; i < n; i++) {
				var merageElement:RenderElement = _getCombineRenderElementFromPool();
				merageElement._type = 2;//代表DynamicBatch
				merageElement._staticBatch = null;
				merageElement.renderObj = this;
				
				var renderElementStartIndex:int = _combineRenderElements[_materialToRenderElementsOffsets[i]]._batchIndexStart;
				var renderElementEndIndex:int = (i + 1 === _materialToRenderElementsOffsets.length) ? curIndexCount : _combineRenderElements[_materialToRenderElementsOffsets[i + 1]]._batchIndexStart;
				
				merageElement._batchIndexStart = renderElementStartIndex;
				merageElement._batchIndexEnd = renderElementEndIndex;
				merageElement._material = _materials[i];
				_merageElements.push(merageElement);
			}
		}
		
		public function _addCombineRenderObjTest(renderElement:RenderElement):Boolean {
			var renderObj:IRenderable = renderElement.renderObj;
			var indexCount:int = _currentCombineIndexCount + renderObj._getIndexBuffer().indexCount;
			var vertexCount:int = _currentCombineVertexCount + renderObj._getVertexBuffer().vertexCount;
			if (vertexCount > maxVertexCount || indexCount > maxIndexCount) {
				return false;
			}
			return true;
		}
		
		public function _addCombineRenderObj(renderElement:RenderElement):void {
			var renderObj:IRenderable = renderElement.renderObj;
			_combineRenderElements.push(renderElement);
			_currentCombineIndexCount = _currentCombineIndexCount + renderObj._getIndexBuffer().indexCount;
			_currentCombineVertexCount = _currentCombineVertexCount + renderObj._getVertexBuffer().vertexCount;
		}
		
		public function _addCombineMaterial(material:BaseMaterial):void {
			_materials.push(material);
		}
		
		public function _addMaterialToRenderElementOffset(offset:int):void {
			_materialToRenderElementsOffsets.push(offset);
		}
		
		public function _clearRenderElements():void {
			_combineRenderElements.length = 0;
			_materials.length = 0;
			_materialToRenderElementsOffsets.length = 0;
			_currentCombineVertexCount = 0;
			_currentCombineIndexCount = 0;
		}
		
		public function _addToRenderQueue(scene:BaseScene):void {
			_getRenderElement();
			
			for (var i:int = 0, n:int = _materials.length; i < n; i++)
				scene.getRenderQueue(_materials[i].renderQueue)._addDynamicBatchElement(_merageElements[i]);
		}
		
		public function _beforeRender(state:RenderState):Boolean {
			//_testTangent(state);//TODO:临时
			_vertexBuffer._bind();
			_indexBuffer._bind();
			return true;
		}
		
		public function _render(state:RenderState):void {
			var indexCount:int = state._batchIndexEnd - state._batchIndexStart;
			state.context.drawElements(WebGLContext.TRIANGLES, indexCount, WebGLContext.UNSIGNED_SHORT, state._batchIndexStart * 2);
			Stat.drawCall++;
			Stat.trianglesFaces += indexCount / 3;
		}
	
	}

}
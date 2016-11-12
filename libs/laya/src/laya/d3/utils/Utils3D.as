package laya.d3.utils {
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexElement;
	import laya.d3.graphics.VertexPositionNormalColorSkinTangent;
	import laya.d3.graphics.VertexPositionNormalColorTangent;
	import laya.d3.graphics.VertexPositionNormalColorTextureSkinTangent;
	import laya.d3.graphics.VertexPositionNormalColorTextureTangent;
	import laya.d3.graphics.VertexPositionNormalTextureSkinTangent;
	import laya.d3.graphics.VertexPositionNormalTextureTangent;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.models.Mesh;
	import laya.net.Loader;
	import laya.net.URL;
	import laya.utils.Handler;
	import laya.webgl.resource.WebGLImage;
	
	/**
	 * <code>Utils3D</code> 类用于创建3D工具。
	 */
	public class Utils3D {
		/** @private */
		private static const _typeToFunO:Object = {"INT16": "writeInt16", "SHORT": "writeInt16", "UINT16": "writeUint16", "UINT32": "writeUint32", "FLOAT32": "writeFloat32", "INT": "writeInt32", "UINT": "writeUint32", "BYTE": "writeByte", "STRING": "writeUTFString"};
		
		/** @private */
		private static var _tempVector3_0:Vector3 = /*[STATIC SAFE]*/ new Vector3();
		/** @private */
		private static var _tempVector3_1:Vector3 = /*[STATIC SAFE]*/ new Vector3();
		/** @private */
		private static var _tempVector3_2:Vector3 = /*[STATIC SAFE]*/ new Vector3();
		/** @private */
		private static var _tempVector3_3:Vector3 = /*[STATIC SAFE]*/ new Vector3();
		/** @private */
		private static var _tempVector3_4:Vector3 = /*[STATIC SAFE]*/ new Vector3();
		/** @private */
		private static var _tempVector3_5:Vector3 = /*[STATIC SAFE]*/ new Vector3();
		/** @private */
		private static var _tempVector3_6:Vector3 = /*[STATIC SAFE]*/ new Vector3();
		
		/** @private */
		private static var _tempArray4_0:Float32Array = /*[STATIC SAFE]*/ new Float32Array(4);
		/** @private */
		private static var _tempArray16_0:Float32Array = /*[STATIC SAFE]*/ new Float32Array(16);
		/** @private */
		private static var _tempArray16_1:Float32Array = /*[STATIC SAFE]*/ new Float32Array(16);
		/** @private */
		private static var _tempArray16_2:Float32Array = /*[STATIC SAFE]*/ new Float32Array(16);
		/** @private */
		private static var _tempArray16_3:Float32Array =  /*[STATIC SAFE]*/ new Float32Array(16);
		
		/** @private */
		private static function _getTexturePath(path:String):String {
			var extenIndex:int = path.length - 4;
			if (path.indexOf(".dds") == extenIndex || path.indexOf(".tga") == extenIndex || path.indexOf(".exr") == extenIndex || path.indexOf(".DDS") == extenIndex || path.indexOf(".TGA") == extenIndex || path.indexOf(".EXR") == extenIndex)
				path = path.substr(0, extenIndex) + ".png";
			
			return path = URL.formatURL(path);
		}
		
		/**
		 *通过数平移、旋转、缩放值计算到结果矩阵数组,骨骼动画专用。
		 * @param tx left矩阵数组。
		 * @param ty left矩阵数组的偏移。
		 * @param tz right矩阵数组。
		 * @param qx right矩阵数组的偏移。
		 * @param qy 输出矩阵数组。
		 * @param qz 输出矩阵数组的偏移。
		 * @param qw 输出矩阵数组的偏移。
		 * @param sx 输出矩阵数组的偏移。
		 * @param sy 输出矩阵数组的偏移。
		 * @param sz 输出矩阵数组的偏移。
		 * @param outArray 结果矩阵数组。
		 * @param outOffset 结果矩阵数组的偏移。
		 */
		private static function _rotationTransformScaleSkinAnimation(tx:Number, ty:Number, tz:Number, qx:Number, qy:Number, qz:Number, qw:Number, sx:Number, sy:Number, sz:Number, outArray:Float32Array, outOffset:int):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var re:Float32Array = _tempArray16_0;
			var se:Float32Array = _tempArray16_1;
			var tse:Float32Array = _tempArray16_2;
			
			//平移
			
			//旋转
			var x2:Number = qx + qx;
			var y2:Number = qy + qy;
			var z2:Number = qz + qz;
			
			var xx:Number = qx * x2;
			var yx:Number = qy * x2;
			var yy:Number = qy * y2;
			var zx:Number = qz * x2;
			var zy:Number = qz * y2;
			var zz:Number = qz * z2;
			var wx:Number = qw * x2;
			var wy:Number = qw * y2;
			var wz:Number = qw * z2;
			
			//re[3] = re[7] = re[11] = re[12] = re[13] = re[14] = 0;
			re[15] = 1;
			re[0] = 1 - yy - zz;
			re[1] = yx + wz;
			re[2] = zx - wy;
			
			re[4] = yx - wz;
			re[5] = 1 - xx - zz;
			re[6] = zy + wx;
			
			re[8] = zx + wy;
			re[9] = zy - wx;
			re[10] = 1 - xx - yy;
			
			//缩放
			//se[4] = se[8] = se[12] = se[1] = se[9] = se[13] = se[2] = se[6] = se[14] = se[3] = se[7] = se[11] = 0;
			se[15] = 1;
			se[0] = sx;
			se[5] = sy;
			se[10] = sz;
			
			var i:int, a:Float32Array, b:Float32Array, e:Float32Array, ai0:Number, ai1:Number, ai2:Number, ai3:Number;
			
			//mul(rMat, tMat, tsMat)......................................
			for (i = 0; i < 4; i++) {
				ai0 = re[i];
				ai1 = re[i + 4];
				ai2 = re[i + 8];
				ai3 = re[i + 12];
				tse[i] = ai0;
				tse[i + 4] = ai1;
				tse[i + 8] = ai2;
				tse[i + 12] = ai0 * tx + ai1 * ty + ai2 * tz + ai3;
			}
			
			//mul(tsMat, sMat, out)..............................................
			for (i = 0; i < 4; i++) {
				ai0 = tse[i];
				ai1 = tse[i + 4];
				ai2 = tse[i + 8];
				ai3 = tse[i + 12];
				outArray[i + outOffset] = ai0 * se[0] + ai1 * se[1] + ai2 * se[2] + ai3 * se[3];
				outArray[i + outOffset + 4] = ai0 * se[4] + ai1 * se[5] + ai2 * se[6] + ai3 * se[7];
				outArray[i + outOffset + 8] = ai0 * se[8] + ai1 * se[9] + ai2 * se[10] + ai3 * se[11];
				outArray[i + outOffset + 12] = ai0 * se[12] + ai1 * se[13] + ai2 * se[14] + ai3 * se[15];
			}
		}
		
		/** @private */
		public static function _parseHierarchyProp(node:Sprite3D, prop:String, value:Array):void {
			switch (prop) {
			case "translate": 
				node.transform.localPosition = new Vector3(value[0], value[1], value[2]);
				break;
			case "rotation": 
				node.transform.localRotation = new Quaternion(value[0], value[1], value[2], value[3]);
				break;
			case "scale": 
				node.transform.localScale = new Vector3(value[0], value[1], value[2]);
				break;
			}
		}
		
		/** @private */
		public static function _parseHierarchyNode(instanceParams:Object):Sprite3D {
			if (instanceParams)
				return new MeshSprite3D(Mesh.load(instanceParams.loadPath));
			else
				return new Sprite3D();
		}
		
		/** @private */
		public static function _parseMaterial(material:StandardMaterial, prop:String, value:Array):void {
			switch (prop) {
			case "ambientColor": 
				material.ambientColor = new Vector3(value[0], value[1], value[2]);
				break;
			case "diffuseColor": 
				material.diffuseColor = new Vector3(value[0], value[1], value[2]);
				break;
			case "specularColor": 
				material.specularColor = new Vector4(value[0], value[1], value[2], value[3]);
				break;
			case "reflectColor": 
				material.reflectColor = new Vector3(value[0], value[1], value[2]);
				break;
			
			case "diffuseTexture": 
				(value.texture2D) && (Laya.loader.load(_getTexturePath(value.texture2D), Handler.create(null, function(tex:Texture2D):void {
					material.diffuseTexture = tex;
				}), null, Loader.TEXTURE2D));
				break;
			case "normalTexture": 
				(value.texture2D) && (Laya.loader.load(_getTexturePath(value.texture2D), Handler.create(null, function(tex:Texture2D):void {
					material.normalTexture = tex;
				}), null, Loader.TEXTURE2D));
				break;
			case "specularTexture": 
				(value.texture2D) && (Laya.loader.load(_getTexturePath(value.texture2D), Handler.create(null, function(tex:Texture2D):void {
					material.specularTexture = tex;
				}), null, Loader.TEXTURE2D));
				break;
			case "emissiveTexture": 
				(value.texture2D) && (Laya.loader.load(_getTexturePath(value.texture2D), Handler.create(null, function(tex:Texture2D):void {
					material.emissiveTexture = tex;
				}), null, Loader.TEXTURE2D));
				break;
			case "ambientTexture": 
				(value.texture2D) && (Laya.loader.load(_getTexturePath(value.texture2D), Handler.create(null, function(tex:Texture2D):void {
					material.ambientTexture = tex;
				}), null, Loader.TEXTURE2D));
				break;
			case "reflectTexture": 
				(value.texture2D) && (Laya.loader.load(_getTexturePath(value.texture2D), Handler.create(null, function(tex:Texture2D):void {
					material.reflectTexture = tex;
				}), null, Loader.TEXTURE2D));
				break;
			}
		}
		
		/** @private */
		public static function _computeBoneAndAnimationDatas(bones:*, curData:Float32Array, exData:Float32Array, outBonesDatas:Float32Array, outAnimationDatas:Float32Array):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var offset:int = 0;
			var matOffset:int = 0;
			
			var len:int = exData.length / 2;
			var i:int;
			var parentOffset:int;
			var boneLength:int = bones.length;
			for (i = 0; i < boneLength; offset += bones[i].keyframeWidth, matOffset += 16, i++) {
				//将旋转平移缩放合成矩阵...........................................
				Utils3D._rotationTransformScaleSkinAnimation(curData[offset + 7], curData[offset + 8], curData[offset + 9], curData[offset + 3], curData[offset + 4], curData[offset + 5], curData[offset + 6], curData[offset + 0], curData[offset + 1], curData[offset + 2], outBonesDatas, matOffset);
				
				if (i != 0) {
					parentOffset = bones[i].parentIndex * 16;
					Utils3D.mulMatrixByArray(outBonesDatas, parentOffset, outBonesDatas, matOffset, outBonesDatas, matOffset);
				}
			}
			
			for (i = 0; i < len; i += 16) {//将绝对矩阵乘以反置矩阵................................................
				Utils3D.mulMatrixByArrayFast(outBonesDatas, i, exData, len + i, outAnimationDatas, i);
			}
		}
		
		/** @private */
		public static function _computeAnimationDatas(exData:Float32Array, bonesDatas:Float32Array, outAnimationDatas:Float32Array):void {
			var len:int = exData.length / 2;
			for (var i:int = 0; i < len; i += 16) {//将绝对矩阵乘以反置矩阵................................................
				Utils3D.mulMatrixByArrayFast(bonesDatas, i, exData, len + i, outAnimationDatas, i);
			}
		}
		
		/** @private */
		public static function _computeBoneAndAnimationDatasByBindPoseMatrxix(bones:*, curData:Float32Array, inverGlobalBindPose:Vector.<Matrix4x4>, outBonesDatas:Float32Array, outAnimationDatas:Float32Array):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var offset:int = 0;
			var matOffset:int = 0;
			
			var i:int;
			var parentOffset:int;
			var boneLength:int = bones.length;
			for (i = 0; i < boneLength; offset += bones[i].keyframeWidth, matOffset += 16, i++) {
				//将旋转平移缩放合成矩阵...........................................
				Utils3D._rotationTransformScaleSkinAnimation(curData[offset + 7], curData[offset + 8], curData[offset + 9], curData[offset + 3], curData[offset + 4], curData[offset + 5], curData[offset + 6], curData[offset + 0], curData[offset + 1], curData[offset + 2], outBonesDatas, matOffset);
				
				if (i != 0) {
					parentOffset = bones[i].parentIndex * 16;
					Utils3D.mulMatrixByArray(outBonesDatas, parentOffset, outBonesDatas, matOffset, outBonesDatas, matOffset);
				}
			}
			
			var n:int = inverGlobalBindPose.length;
			for (i = 0; i < n; i++)//将绝对矩阵乘以反置矩阵................................................
			{
				var arrayOffset:Number = i * 16;
				Utils3D.mulMatrixByArrayAndMatrixFast(outBonesDatas, arrayOffset, inverGlobalBindPose[i], outAnimationDatas, arrayOffset);
			}
		}
		
		/** @private */
		public static function _computeAnimationDatasByArrayAndMatrixFast(inverGlobalBindPose:Vector.<Matrix4x4>, bonesDatas:Float32Array, outAnimationDatas:Float32Array):void {
			var n:int = inverGlobalBindPose.length;
			for (var i:int = 0; i < n; i++)//将绝对矩阵乘以反置矩阵................................................
			{
				var arrayOffset:Number = i * 16;
				Utils3D.mulMatrixByArrayAndMatrixFast(bonesDatas, arrayOffset, inverGlobalBindPose[i], outAnimationDatas, arrayOffset);
			}
		}
		
		/** @private */
		public static function _computeRootAnimationData(bones:*, curData:Float32Array, animationDatas:Float32Array):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			for (var i:int = 0, offset:int = 0, matOffset:int = 0, boneLength:int = bones.length; i < boneLength; offset += bones[i].keyframeWidth, matOffset += 16, i++)
				Utils3D.createAffineTransformationArray(curData[offset + 0], curData[offset + 1], curData[offset + 2], curData[offset + 3], curData[offset + 4], curData[offset + 5], curData[offset + 6], curData[offset + 7], curData[offset + 8], curData[offset + 9], animationDatas, matOffset);
		}
		
		/** @private */
		public static function generateTangent(vertexDatas:Float32Array, vertexStride:int, positionOffset:int, uvOffset:int, indices:Uint16Array/*还有UNIT8类型*/):Float32Array {
			const tangentElementCount:int = 3;
			var newVertexStride:int = vertexStride + tangentElementCount;
			var tangentVertexDatas:Float32Array = new Float32Array(newVertexStride * (vertexDatas.length / vertexStride));
			
			for (var i:int = 0; i < indices.length; i += 3) {
				var index1:uint = indices[i + 0];
				var index2:uint = indices[i + 1];
				var index3:uint = indices[i + 2];
				
				var position1Offset:int = vertexStride * index1 + positionOffset;
				var position1:Vector3 = _tempVector3_0;
				position1.x = vertexDatas[position1Offset + 0];
				position1.y = vertexDatas[position1Offset + 1];
				position1.z = vertexDatas[position1Offset + 2];
				
				var position2Offset:int = vertexStride * index2 + positionOffset;
				var position2:Vector3 = _tempVector3_1;
				position2.x = vertexDatas[position2Offset + 0];
				position2.y = vertexDatas[position2Offset + 1];
				position2.z = vertexDatas[position2Offset + 2];
				
				var position3Offset:int = vertexStride * index3 + positionOffset;
				var position3:Vector3 = _tempVector3_2;
				position3.x = vertexDatas[position3Offset + 0];
				position3.y = vertexDatas[position3Offset + 1];
				position3.z = vertexDatas[position3Offset + 2];
				
				var uv1Offset:int = vertexStride * index1 + uvOffset;
				var UV1X:Number = vertexDatas[uv1Offset + 0];
				var UV1Y:Number = vertexDatas[uv1Offset + 1];
				
				var uv2Offset:int = vertexStride * index2 + uvOffset;
				var UV2X:Number = vertexDatas[uv2Offset + 0];
				var UV2Y:Number = vertexDatas[uv2Offset + 1];
				
				var uv3Offset:int = vertexStride * index3 + uvOffset;
				var UV3X:Number = vertexDatas[uv3Offset + 0];
				var UV3Y:Number = vertexDatas[uv3Offset + 1];
				
				var lengthP2ToP1:Vector3 = _tempVector3_3;
				Vector3.subtract(position2, position1, lengthP2ToP1);
				var lengthP3ToP1:Vector3 = _tempVector3_4;
				Vector3.subtract(position3, position1, lengthP3ToP1);
				
				Vector3.scale(lengthP2ToP1, UV3Y - UV1Y, lengthP2ToP1);
				Vector3.scale(lengthP3ToP1, UV2Y - UV1Y, lengthP3ToP1);
				
				var tangent:Vector3 = _tempVector3_5;
				Vector3.subtract(lengthP2ToP1, lengthP3ToP1, tangent);
				
				Vector3.scale(tangent, 1.0 / ((UV2X - UV1X) * (UV3Y - UV1Y) - (UV2Y - UV1Y) * (UV3X - UV1X)), tangent);
				
				var j:int;
				for (j = 0; j < vertexStride; j++)
					tangentVertexDatas[newVertexStride * index1 + j] = vertexDatas[vertexStride * index1 + j];
				for (j = 0; j < tangentElementCount; j++)
					tangentVertexDatas[newVertexStride * index1 + vertexStride + j] = +tangent.elements[j];
				
				for (j = 0; j < vertexStride; j++)
					tangentVertexDatas[newVertexStride * index2 + j] = vertexDatas[vertexStride * index2 + j];
				for (j = 0; j < tangentElementCount; j++)
					tangentVertexDatas[newVertexStride * index2 + vertexStride + j] = +tangent.elements[j];
				
				for (j = 0; j < vertexStride; j++)
					tangentVertexDatas[newVertexStride * index3 + j] = vertexDatas[vertexStride * index3 + j];
				for (j = 0; j < tangentElementCount; j++)
					tangentVertexDatas[newVertexStride * index3 + vertexStride + j] = +tangent.elements[j];
				
					//tangent = ((UV3.Y - UV1.Y) * (position2 - position1) - (UV2.Y - UV1.Y) * (position3 - position1))/ ((UV2.X - UV1.X) * (UV3.Y - UV1.Y) - (UV2.Y - UV1.Y) * (UV3.X - UV1.X));
			}
			
			for (i = 0; i < tangentVertexDatas.length; i += newVertexStride) {
				var tangentStartIndex:int = newVertexStride * i + vertexStride;
				var t:Vector3 = _tempVector3_6;
				t.x = tangentVertexDatas[tangentStartIndex + 0];
				t.y = tangentVertexDatas[tangentStartIndex + 1];
				t.z = tangentVertexDatas[tangentStartIndex + 2];
				
				Vector3.normalize(t, t);
				tangentVertexDatas[tangentStartIndex + 0] = t.x;
				tangentVertexDatas[tangentStartIndex + 1] = t.y;
				tangentVertexDatas[tangentStartIndex + 2] = t.z;
			}
			
			return tangentVertexDatas;
		}
		
		public static function getVertexTangentDeclaration(vertexElements:Array):VertexDeclaration {
			var position:Boolean, normal:Boolean, color:Boolean, texcoord:Boolean, blendWeight:Boolean, blendIndex:Boolean;
			for (var i:int = 0; i < vertexElements.length; i++) {
				switch ((vertexElements[i] as VertexElement).elementUsage) {
				case "POSITION": 
					position = true;
					break;
				case "NORMAL": 
					normal = true;
					break;
				case "COLOR": 
					color = true;
					break;
				case "UV": 
					texcoord = true;
					break;
				case "BLENDWEIGHT": 
					blendWeight = true;
					break;
				case "BLENDINDICES": 
					blendIndex = true;
					break;
				}
			}
			var vertexDeclaration:VertexDeclaration;
			
			if (position && normal && color && texcoord && blendWeight && blendIndex)
				vertexDeclaration = VertexPositionNormalColorTextureSkinTangent.vertexDeclaration;
			else if (position && normal && texcoord && blendWeight && blendIndex)
				vertexDeclaration = VertexPositionNormalTextureSkinTangent.vertexDeclaration;
			else if (position && normal && color && blendWeight && blendIndex)
				vertexDeclaration = VertexPositionNormalColorSkinTangent.vertexDeclaration;
			else if (position && normal && color && texcoord)
				vertexDeclaration = VertexPositionNormalColorTextureTangent.vertexDeclaration;
			else if (position && normal && texcoord)
				vertexDeclaration = VertexPositionNormalTextureTangent.vertexDeclaration;
			else if (position && normal && color)
				vertexDeclaration = VertexPositionNormalColorTangent.vertexDeclaration;
			
			return vertexDeclaration;
		}
		
		/**
		 * 根据四元数旋转三维向量。
		 * @param	source 源三维向量。
		 * @param	rotation 旋转四元数。
		 * @param	out 输出三维向量。
		 */
		public static function transformVector3ArrayByQuat(sourceArray:Float32Array, sourceOffset:int, rotation:Quaternion, outArray:Float32Array, outOffset:int):void {
			var re:Float32Array = rotation.elements;
			
			var x:Number = sourceArray[sourceOffset], y:Number = sourceArray[sourceOffset + 1], z:Number = sourceArray[sourceOffset + 2], qx:Number = re[0], qy:Number = re[1], qz:Number = re[2], qw:Number = re[3],
			
			ix:Number = qw * x + qy * z - qz * y, iy:Number = qw * y + qz * x - qx * z, iz:Number = qw * z + qx * y - qy * x, iw:Number = -qx * x - qy * y - qz * z;
			
			outArray[outOffset] = ix * qw + iw * -qx + iy * -qz - iz * -qy;
			outArray[outOffset + 1] = iy * qw + iw * -qy + iz * -qx - ix * -qz;
			outArray[outOffset + 2] = iz * qw + iw * -qz + ix * -qy - iy * -qx;
		}
		
		/**
		 *通过数组数据计算矩阵乘法。
		 * @param leftArray left矩阵数组。
		 * @param leftOffset left矩阵数组的偏移。
		 * @param rightArray right矩阵数组。
		 * @param rightOffset right矩阵数组的偏移。
		 * @param outArray 输出矩阵数组。
		 * @param outOffset 输出矩阵数组的偏移。
		 */
		public static function mulMatrixByArray(leftArray:Float32Array, leftOffset:int, rightArray:Float32Array, rightOffset:int, outArray:Float32Array, outOffset:int):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var i:int, ai0:Number, ai1:Number, ai2:Number, ai3:Number;
			
			if (outArray === rightArray) {
				rightArray = _tempArray16_3;
				for (i = 0; i < 16; ++i) {
					rightArray[i] = outArray[outOffset + i];
				}
				rightOffset = 0;
			}
			
			for (i = 0; i < 4; i++) {
				ai0 = leftArray[leftOffset + i];
				ai1 = leftArray[leftOffset + i + 4];
				ai2 = leftArray[leftOffset + i + 8];
				ai3 = leftArray[leftOffset + i + 12];
				outArray[outOffset + i] = ai0 * rightArray[rightOffset + 0] + ai1 * rightArray[rightOffset + 1] + ai2 * rightArray[rightOffset + 2] + ai3 * rightArray[rightOffset + 3];
				outArray[outOffset + i + 4] = ai0 * rightArray[rightOffset + 4] + ai1 * rightArray[rightOffset + 5] + ai2 * rightArray[rightOffset + 6] + ai3 * rightArray[rightOffset + 7];
				outArray[outOffset + i + 8] = ai0 * rightArray[rightOffset + 8] + ai1 * rightArray[rightOffset + 9] + ai2 * rightArray[rightOffset + 10] + ai3 * rightArray[rightOffset + 11];
				outArray[outOffset + i + 12] = ai0 * rightArray[rightOffset + 12] + ai1 * rightArray[rightOffset + 13] + ai2 * rightArray[rightOffset + 14] + ai3 * rightArray[rightOffset + 15];
			}
		}
		
		/**
		 *通过数组数据计算矩阵乘法,rightArray和outArray不能为同一数组引用。
		 * @param leftArray left矩阵数组。
		 * @param leftOffset left矩阵数组的偏移。
		 * @param rightArray right矩阵数组。
		 * @param rightOffset right矩阵数组的偏移。
		 * @param outArray 结果矩阵数组。
		 * @param outOffset 结果矩阵数组的偏移。
		 */
		public static function mulMatrixByArrayFast(leftArray:Float32Array, leftOffset:int, rightArray:Float32Array, rightOffset:int, outArray:Float32Array, outOffset:int):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var i:int, ai0:Number, ai1:Number, ai2:Number, ai3:Number;
			for (i = 0; i < 4; i++) {
				ai0 = leftArray[leftOffset + i];
				ai1 = leftArray[leftOffset + i + 4];
				ai2 = leftArray[leftOffset + i + 8];
				ai3 = leftArray[leftOffset + i + 12];
				outArray[outOffset + i] = ai0 * rightArray[rightOffset + 0] + ai1 * rightArray[rightOffset + 1] + ai2 * rightArray[rightOffset + 2] + ai3 * rightArray[rightOffset + 3];
				outArray[outOffset + i + 4] = ai0 * rightArray[rightOffset + 4] + ai1 * rightArray[rightOffset + 5] + ai2 * rightArray[rightOffset + 6] + ai3 * rightArray[rightOffset + 7];
				outArray[outOffset + i + 8] = ai0 * rightArray[rightOffset + 8] + ai1 * rightArray[rightOffset + 9] + ai2 * rightArray[rightOffset + 10] + ai3 * rightArray[rightOffset + 11];
				outArray[outOffset + i + 12] = ai0 * rightArray[rightOffset + 12] + ai1 * rightArray[rightOffset + 13] + ai2 * rightArray[rightOffset + 14] + ai3 * rightArray[rightOffset + 15];
			}
		}
		
		/**
		 *通过数组数据计算矩阵乘法,rightArray和outArray不能为同一数组引用。
		 * @param leftArray left矩阵数组。
		 * @param leftOffset left矩阵数组的偏移。
		 * @param rightMatrix right矩阵。
		 * @param outArray 结果矩阵数组。
		 * @param outOffset 结果矩阵数组的偏移。
		 */
		public static function mulMatrixByArrayAndMatrixFast(leftArray:Float32Array, leftOffset:int, rightMatrix:Matrix4x4, outArray:Float32Array, outOffset:int):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var i:int, ai0:Number, ai1:Number, ai2:Number, ai3:Number;
			var rightMatrixE:Float32Array = rightMatrix.elements;
			var m11:Number = rightMatrixE[0], m12:Number = rightMatrixE[1], m13:Number = rightMatrixE[2], m14:Number = rightMatrixE[3];
			var m21:Number = rightMatrixE[4], m22:Number = rightMatrixE[5], m23:Number = rightMatrixE[6], m24:Number = rightMatrixE[7];
			var m31:Number = rightMatrixE[8], m32:Number = rightMatrixE[9], m33:Number = rightMatrixE[10], m34:Number = rightMatrixE[11];
			var m41:Number = rightMatrixE[12], m42:Number = rightMatrixE[13], m43:Number = rightMatrixE[14], m44:Number = rightMatrixE[15];
			var ai0LeftOffset:Number = leftOffset;
			var ai1LeftOffset:Number = leftOffset + 4;
			var ai2LeftOffset:Number = leftOffset + 8;
			var ai3LeftOffset:Number = leftOffset + 12;
			var ai0OutOffset:Number = outOffset;
			var ai1OutOffset:Number = outOffset + 4;
			var ai2OutOffset:Number = outOffset + 8;
			var ai3OutOffset:Number = outOffset + 12;
			
			for (i = 0; i < 4; i++) {
				ai0 = leftArray[ai0LeftOffset + i];
				ai1 = leftArray[ai1LeftOffset + i];
				ai2 = leftArray[ai2LeftOffset + i];
				ai3 = leftArray[ai3LeftOffset + i];
				outArray[ai0OutOffset + i] = ai0 * m11 + ai1 * m12 + ai2 * m13 + ai3 * m14;
				outArray[ai1OutOffset + i] = ai0 * m21 + ai1 * m22 + ai2 * m23 + ai3 * m24;
				outArray[ai2OutOffset + i] = ai0 * m31 + ai1 * m32 + ai2 * m33 + ai3 * m34;
				outArray[ai3OutOffset + i] = ai0 * m41 + ai1 * m42 + ai2 * m43 + ai3 * m44;
			}
		}
		
		/**
		 *通过数平移、旋转、缩放值计算到结果矩阵数组。
		 * @param tX left矩阵数组。
		 * @param tY left矩阵数组的偏移。
		 * @param tZ right矩阵数组。
		 * @param qX right矩阵数组的偏移。
		 * @param qY 输出矩阵数组。
		 * @param qZ 输出矩阵数组的偏移。
		 * @param qW 输出矩阵数组的偏移。
		 * @param sX 输出矩阵数组的偏移。
		 * @param sY 输出矩阵数组的偏移。
		 * @param sZ 输出矩阵数组的偏移。
		 * @param outArray 结果矩阵数组。
		 * @param outOffset 结果矩阵数组的偏移。
		 */
		public static function createAffineTransformationArray(tX:Number, tY:Number, tZ:Number, rX:Number, rY:Number, rZ:Number, rW:Number, sX:Number, sY:Number, sZ:Number, outArray:Float32Array, outOffset:int):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var x2:Number = rX + rX, y2:Number = rY + rY, z2:Number = rZ + rZ;
			var xx:Number = rX * x2, xy:Number = rX * y2, xz:Number = rX * z2, yy:Number = rY * y2, yz:Number = rY * z2, zz:Number = rZ * z2;
			var wx:Number = rW * x2, wy:Number = rW * y2, wz:Number = rW * z2;
			
			outArray[outOffset + 0] = (1 - (yy + zz)) * sX;
			outArray[outOffset + 1] = (xy + wz) * sX;
			outArray[outOffset + 2] = (xz - wy) * sX;
			outArray[outOffset + 3] = 0;
			outArray[outOffset + 4] = (xy - wz) * sY;
			outArray[outOffset + 5] = (1 - (xx + zz)) * sY;
			outArray[outOffset + 6] = (yz + wx) * sY;
			outArray[outOffset + 7] = 0;
			outArray[outOffset + 8] = (xz + wy) * sZ;
			outArray[outOffset + 9] = (yz - wx) * sZ;
			outArray[outOffset + 10] = (1 - (xx + yy)) * sZ;
			outArray[outOffset + 11] = 0;
			outArray[outOffset + 12] = tX;
			outArray[outOffset + 13] = tY;
			outArray[outOffset + 14] = tZ;
			outArray[outOffset + 15] = 1;
		}
		
		/**
		 * 通过矩阵转换一个三维向量数组到另外一个归一化的三维向量数组。
		 * @param	source 源三维向量所在数组。
		 * @param	sourceOffset 源三维向量数组偏移。
		 * @param	transform  变换矩阵。
		 * @param	result 输出三维向量所在数组。
		 * @param	resultOffset 输出三维向量数组偏移。
		 */
		public static function transformVector3ArrayToVector3ArrayCoordinate(source:Float32Array, sourceOffset:int, transform:Matrix4x4, result:Float32Array, resultOffset:int):void {
			var vectorElem:Float32Array = _tempArray4_0;
			
			//var coordinateElem:Float32Array = coordinate.elements;
			var coordinateX:Number = source[sourceOffset + 0];
			var coordinateY:Number = source[sourceOffset + 1];
			var coordinateZ:Number = source[sourceOffset + 2];
			
			var transformElem:Float32Array = transform.elements;
			
			vectorElem[0] = (coordinateX * transformElem[0]) + (coordinateY * transformElem[4]) + (coordinateZ * transformElem[8]) + transformElem[12];
			vectorElem[1] = (coordinateX * transformElem[1]) + (coordinateY * transformElem[5]) + (coordinateZ * transformElem[9]) + transformElem[13];
			vectorElem[2] = (coordinateX * transformElem[2]) + (coordinateY * transformElem[6]) + (coordinateZ * transformElem[10]) + transformElem[14];
			vectorElem[3] = 1.0 / ((coordinateX * transformElem[3]) + (coordinateY * transformElem[7]) + (coordinateZ * transformElem[11]) + transformElem[15]);
			
			//var resultElem:Float32Array = result.elements;
			result[resultOffset + 0] = vectorElem[0] * vectorElem[3];
			result[resultOffset + 1] = vectorElem[1] * vectorElem[3];
			result[resultOffset + 2] = vectorElem[2] * vectorElem[3];
		}
		
		/**
		 * 转换3D坐标系统到2D坐标系统，以像素为单位,通常用于正交投影下的3D坐标（（0，0）在屏幕中心）到2D屏幕坐标（（0，0）在屏幕左上角）的转换。
		 * @param	source 源坐标。
		 * @param	out 输出坐标。
		 */
		public static function convert3DCoordTo2DScreenCoord(source:Vector3, out:Vector3):void {
			var se:Array = source.elements;
			var oe:Array = out.elements;
			oe[0] = -RenderState.clientWidth / 2 + se[0];
			oe[1] = RenderState.clientHeight / 2 - se[1];
			oe[2] = se[2];
		}
	
	}

}
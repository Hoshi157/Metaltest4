# シェーダを使用したMetal実装

### 手順

1, シェーダプログラムの記載
* vertex, fragmentの関数と構造体を記載

2. シェーダに渡すデータを作成、Buffer作成
* floatの配列でデータを作成、MTLBufferに格納

3. パイプライン作成
①, パイプラインを作成する前にMTLRenderPipelineDescriptorを作成。
②, ディスクラプターでシェーダメソッドの設定、pixleFormatを設定。(liblryから)

4, エンコード
①, MTLRenderPassDescriptorを作成し、drawable.textureを設定
②Encordオブジェクトを作成し、
                      1, パイプライン
                      2, シェーダに渡すBuffer
                      3, Primitiveを設定

④エンキュー

# Flutter 分帧组件

## 通过分帧渲染优化由构建导致的卡顿，例如页面切换或者复杂列表快速滚动的场景。

### 使用说明
- [des] 假如现在页面由 A、B、C、D 四部分组成，每部分耗时 10ms，在页面时构建为 40ms。
  使用分帧组件  `FrameWidget` 嵌套每一个部分。页面构建时会在第一帧渲染简单的占位，
  在后续四帧内分别渲染 A、B、C、D。对于列表，在每一个 item 中嵌套 `FrameWidget`，并将 `ListView` 嵌套在 `FrameCacheWidget` 内。

***

### 构造函数：

FrameWidget ：分帧组件，将嵌套的 widget 单独一帧渲染

| 类型   | 参数名      | 是否必填 | 含义                                                         |
| ------ | ----------- | -------- | ------------------------------------------------------------ |
| Key    | key         | 否       |                                                              |
| int    | index       | 否       | 分帧组件 id，使用 FrameCacheWidget 的场景必传，FrameCacheWidget 中维护了 index 对应的 Size 信息 |
| Widget | child       | 是       | 实际需要渲染的 widget                                        |
| Widget | placeHolder | 否       | 占位 widget，尽量设置简单的占位，不传默认是 Container()      |

FrameCacheWidget：缓存子节点中，分帧组件嵌套的**实际 widget 的尺寸信息**

| 类型   | 参数名        | 是否必填 | 含义                                                   |
| ------ | ------------- | -------- | ------------------------------------------------------ |
| Key    | key           | 否       |                                                        |
| Widget | child         | 是       | 子节点中如果包含分帧组件，则缓存**实际的 widget 尺寸** |
| int    | estimateCount | 否       | 预估屏幕上子节点的数量，提高快速滚动时的响应速度       |

***


### 示例代码


示例，在listview中使用分帧

```dart
FrameCacheWidget(
    child: ListView.builder(
        cacheExtent: 500,
        itemCount: childCount,
        itemBuilder: (_, i) => FrameWidget(
        index: i,
        placeHolder: Container(
            color: i % 2 == 0 ? Colors.red : Colors.blue,
            height: 40,
            ),
            child: CustomWidget(
                color: i % 2 == 0 ? Colors.red : Colors.blue,
                index: i,
                ),
            ),
        ),
    ),
                
                
              
```
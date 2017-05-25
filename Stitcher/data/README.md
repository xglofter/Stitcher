## 模板数据

这里**模板**指的是最终生成的拼图的式样信息，包括大小尺寸，子图形的相关信息等，而 data/ 目录下的 plist 文件就是**模板数据**

最终拼图的大小 1082像素*1500像素

OUTPUT_IMG_WIDTH * OUTPUT_IMG_HEIGHT

子图形间隙 15像素

OUTPUT_GAP_WIDTH：

### 用法

通过 TemplateHelper 来读取模板数据，生成 ClipTemplate 模板

```objective-c
ClipTemplate *template = [TemplateHelper generateTemplateWithFileName:@"c01"];

```

### 模板结构

```
- Root
  - id  # 文件 id 名
  - shaple_number  # 子图形个数
  - vertex_points  # 所有顶点数据
  - edgeinsets     # 子图形到模板边界的 UIEdgeInsets 距离
```

关于 vertex_points 的具体值都是相对子图形外围框的值(0~1)，实际值需要乘以 bounds.size.width/height 

关于 edgeinsets 的具体值是相对模板的值(0~1)，实际值需要乘以 OUTPUT_IMG_WIDTH/OUTPUT_IMG_HEIGHT

值得注意的是，edgeinsets 的值需要考虑到间隙，故要看情形添加间隙，所有小数保留到千分位

一个间隙的相对值：0.014（宽） 或 0.010（高）

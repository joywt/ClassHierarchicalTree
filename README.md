ClassHierarchicalTree
=====================

在我们开始构建自定义布局前，先考虑一下是否必要这样做。`UICollectionViewFlowLayout` 类已经提供了一系列的显著特性，优化了效率，可以采用不同的方式实现不同类型的标准布局。只有在以下情况下才使用自定义布局：
 
1. 你想要的布局一点也不像网络或是一个行分割的布局，或者布局必须在多个方向上滚动。
2. 你想要经常改变所有单元格的位置，修改现有的流动布局比创建一个自定义布局麻烦。

从API来看实现自定义布局是不难的。唯一难的地方根据需求计算每个item布局中的位置，当位置信息确定了，再实现集合视图就不难了。首先需要理解它核心布局的过程。在布局过程中，collection view 会调用layout对象的一些特定方法。这些方法用来计算items的位置并向 collection view 提供它所需要的信息。除此之外其他的方法也可能会被调用，但下面的这些方法在布局过程中总是以以下顺序调用：

1. `prepareLayout` 预先计算需要提供的布局信息。
2. `collectionViewContentSize` 根据初步的计算返回整个内容区域的大小
3. `layoutAttributesForElementsInRect:` 返回指定区域中 cell 和 views 的属性。

下图说明如何运用这三个方法来生成布局信息。

![如何生成布局信息](http://7sbygq.com1.z0.glb.clouddn.com/image/collectionView/Figure 1_2.png)

[点击查看更多信息](http://lacing.me/blog/2015/01/06/uicollectionview-zhi-shi-dian-hui-ji-er-(zi-ding-yi-bu-ju-)/)

`UIUICollectionView` 自定义 `UICollectionViewLayout` 的相关知识链接如下：


运用`UICollectionViewLayout`相关知识构建一个类的层次树，效果图如下：
![类关系图](http://7sbygq.com1.z0.glb.clouddn.com/image/collectionView/Figure 1_3.jpg)

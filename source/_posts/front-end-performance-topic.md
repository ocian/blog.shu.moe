---
title: 前端性能专题
date: 2021-07-11 09:24:20
tags: 
---

整理一下听过见过的性能问题。我的前端世界本来没多少性能问题，直到交流的多了，才知道原来可以有以下这么多的问题。
<!-- more -->

## react 的性能隐患

react 是一个单纯的 DOM 操作工具。如果 react 在一次或者多次更新过程中操作了过量的 DOM，有可能使得 web 界面不能及时被更新，这就会让用户直观的感受到卡顿。这个是 react 性能问题的根源。

react 的逻辑是开发者管控状态变化，状态变化触发 DOM 更新。所以提升性能的方向可以确定为：

1. 只在必要的时候更新状态；
2. 降低状态的更新频次。

如果能够落实这两点，react 的性能还是很不错的。React 提供了 [useMemo](https://zh-hans.reactjs.org/docs/hooks-reference.html#usememo) 和 [useCallback](https://zh-hans.reactjs.org/docs/hooks-reference.html#usecallback) 来帮助控制状态的更新时机；在更新频率方面，可以用一次的所有状态更新，代替多次的逐个状态更新，这样做有助于降低状态更新过程中，[协调](https://zh-hans.reactjs.org/docs/reconciliation.html) 的运算量。

在使用 react 的前提下，性能是存在极限的，如果仍然达不到性能要求，就需要思考其他途径的解决办法了。  
我曾经遇到过一个上万条数据的列表渲染问题，他的特点是渲染时间很长，但是一个时间点的展示内容并不多。  
解决的方式比较取巧，首先模拟滚动框，保持内容高度，然后在滚动停止的时候计算出应该展示的内容，只渲染可以被用户看到的一小部分内容，隐藏所有其他的部分。这个通常被称为虚拟滚动，推荐使用 [react-window](https://github.com/bvaughn/react-window)。

再高的性能要求大概可以用 canvas 来满足。

## 浏览器加载性能

web 的世界分为服务器和客户端两个部分，相互之间通过 http 协议来通信。浏览器就是大多数人的客户端，大家通过网址访问服务器的时候，浏览器就会帮忙获取内容，然后再呈现给用户。

提升浏览器的加载性能，可以尝试降低 URI 对应资源的大小，或者提高加载速度。

### 降低资源文件大小

- 首先是 js、css 类资源，在代码当中，换行和空格可以省略；js 的变量名，可以长的替换成短的，诸如此类。通常使用 [tester](https://github.com/webpack-contrib/terser-webpack-plugin/), [cssnano](https://github.com/cssnano/cssnano) 等工具处理。
- 图片文件，可以通过压缩，显著降低图片的文件体积，同时不影响图片的展示效果。通常使用 [image-webpack-loader](https://github.com/tcoopman/image-webpack-loader#readme)
- 字体文件，可以通过 utf8 编码范围对字体文件进行拆分，比如 fontsource 的 [noto-serif-sc](https://fontsource.org/fonts/noto-serif-sc)

<!-- ### 提高加载速度

TODO -->

<!-- ## 内存泄漏

在 JavaScript 世界里面的变量，如果被使用，那么引用计数 +1；如果使用结束，那么引用计数 -1；如果引用计数归0，那就表示变量不再被需要，会被内存回收机制清除。  
如果有变量在运算逻辑上不再被需要，但是引用计数无法归 0，就不能进入内存回收机制，会在程序执行期间永远占据内存空间。  
这个就是内存泄漏的产生过程。

听说递归容易出这个问题，我自己没有见到过，我想着蓝湖打开一张设计图占掉 2G 内存应该就是泄漏了。 -->
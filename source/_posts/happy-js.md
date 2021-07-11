---
title: happy-js
date: 2021-07-11 09:21:07
tags: JavaScript
---

作为一个成熟的 JavaScript 工具人，应该学会面对超出预期的现象，理解产生麻烦的原因，整理合理不合情的情况，在反馈和反思中修改完善。
<!-- more -->

## 类型检查与拷贝

JS 的数据类型可以大致分为两种，  
一种是值类型，引用值的变量之间不会产生相互影响；  
还有一种是引用类型，变量只保存引用，可能存在相互影响。  
接下来介绍一下两种类型：

```js
// 值类型
const a = 1; // a 的值是 1
let b = a; // b 的值也是 1，a === b
b = 2; // b 的值修改成了 2，a 的值还是 1，a !== b
const c = 1; // c 的值是 1，a === c

// 引用类型
const a = {a: 1}; // a 变量保存了 {a: 1} 的引用
let b = a; // b 保存同样一份引用，两个变量 a 和 b 指向同一个对象值，b === a
b = {a: 1}; // b 指向一个新声明的变量，对象变量之间的比较，比较引用的值是否是同一个，b !== a
const c = a; // a === c
c.b = 2; // 通过变量 c 修改引用值
a; // {a: 1, c: 2}
```

在这个前提之下，拷贝分为浅拷贝和深拷贝两种。  
直接获取一个变量的对象值引用，称为浅拷贝操作，会获得一个旧对象值的新引用，任何对旧对象值本身的操作，都会体现到对象值的所有引用变量上；  
通过旧对象值生成新对象值，称为深拷贝操作，会获得一个新对象值，对其修改不会对旧对象值产生影响。

```js
// 判断一个数据是否是数组
function isArray(arr) {
  if (typeof Array.isArray === 'function') return Array.isArray(arr)
  else return {}.toString.call(arr) === '[object Array]'
}
// 深拷贝
function deepClone(source) {
  // 如果是一个数组，针对数组中的每一项递归执行深拷贝
  if (isArray(source)) return source.map((item) => deepClone(item))
  // 如果是一个对象，针对每一个 key 的 value 递归
  else if (typeof source === 'object' && source !== null) {
    const target = {}
    for (let i in source) {
      target[i] = deepClone(source[i])
    }
    return target
  }
  // 如果是其他数据类型，包含 null, undefined, number, string, boolean, bigint, symbol 不存在引用类型问题，可以直接返回
  else return source
}
```

## 日期格式化

现代浏览器对日期时间操作的支持其实很完善，为体积考虑可以尽量避免 lodash

```js
function timeFormat(timestamp, format = 'Y/M/D h:m:s') {
  const d = new Date(timestamp)
  if (d + '' === 'Invalid Date') return new Error('Invalid Date')

  const list = {
    Y: d.getFullYear(),
    M: d.getMonth() + 1,
    D: d.getDate(),
    h: d.getHours(),
    m: d.getMinutes(),
    s: d.getSeconds(),
  }

  return format.replace(/[Y|M|D|h|m|s]/g, (match) =>
    (list[match] + '').padStart(2, '0')
  )
}

console.log(timeFormat(Date.now()))
```

## 符号表达式

用在书写判断条件，或者执行顺序上面

```js
+[] // 转换为 number 类型，[] 转换结果为 0
''+[] // 转换为 string 类型，[] 转换结果为 ''
!![] // 转换为 boolean 类型，[] 结果为 true
~-1 // 按位非，~-1 结果为 0，我个人反应不过来这个
true && console.log('true') // && 在第一个表达式 bool true 的情况下执行第二个表达式
false || console.log('false') // || 在第一个表达式 bool false 的情况下执行第二个表达式
```

## 闭包

变量是存在作用域的概念的，以函数作为边界，不可以越界访问。  
可以使用这个特性控制私有变量的访问方式。

```js
const [get, up, down] = (() => {
  let start = 0
  return [
    () => start,
    () => start += 1,
    () => start -= 1,
  ]
})()
```

## this

<sup>TODO</sup>

## 循环

没见过有人不会循环，这个算基础了吧

最简单的累计循环
```js
for (let i = 0; i < 10; i += 1) {
  console.log(i)
}
```

### 遍历对象

1. for in 遍历一个对象
由于 [for in 会获取原型链上面的属性](https://bonsaiden.github.io/JavaScript-Garden/zh/#object.forinloop)，所以需要使用 `hasOwnProperty` 进行检查，或者使用 `Object.create(null)` 创建一个完全空的对象用于数据存储。
```js
const list = {a: 1, b: 2, c: 3}
for (const key in list) {
  if ({}.hasOwnProperty.call(list, key)) {
    console.log(key, list[key])
  }
}
```

2. 使用 keys 方法遍历一个对象 `Object.keys`
```js
const list = {a: 1, b: 2, c: 3}
Object.keys(list).map(key => { console.log(key, list[key]) })
```

3. for of 循环一个可迭代对象
```js
const list = [1,2,3,4]
for (const item of list) {
  console.log(item)
}
```

### 遍历数组

1. map 数组遍历，这个方法有返回值
```js
const arr = Array.from({length: 3}) // 生成长度为 3 的数组
arr.map((_, index) => index + 1)
```

2. forEach 数组遍历，这个方法没有返回值
```js
[1,2,3].forEach(console.log)
```

### 字符串

可以在字符串中，按照规则匹配相同类型的值
```js
`?a=1&b=2&c=3`.replace(/[^\?&]*=[^\?&]*/g, match => {
  const arr = match.split('=')
  console.log(`key: ${arr[0]}, value: ${arr[1]}`)
  return ''
})
```

## 正则

<sup>TODO</sup>
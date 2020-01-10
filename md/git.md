# git 分布式版本管理工具

```一般会有一个中央的仓库（也可以没有），每个开发者有一个本地的仓库，可以将代码提交到本地仓库，也可以将代码提交到中央仓库。
一般会有一个中央的仓库（也可以没有），每个开发者有一个本地的仓库，可以将代码提交到本地仓库，也可以将代码提交到中央仓库。
```

### 1. 配置 git

```git
git config --global user.name z7436
git config --global user.email Zhao_xiangshen@163.com
git config --list	查看git的所有配置

--global 代表的是全局配置
```

### 2. 获取帮助

```git
git add --help
git help add
man git-add
官方网站（中文）:https://git-scm.com/book/zh/v2
```

### 3. 创建仓库和提交

```git
git add filename 将工作区文件添加到暂存区
git rm --cached filename 将暂存区文件还原到工作区
git commit filename（提交暂存区一个文件）/-a（提交暂存区全部内容） -m "描述信息" 将暂存区文件添加到仓库中
git status
git log --stat
工作区 + 暂存区（还并没有被git管理起来） + 仓库区（已经被git管理起来）
```

![创建仓库和提交](F:\BIT\github\-\mspaint\创建仓库和提交.png)

### 4. 创建 git 远程服务器

##### 创建git账号和git用户组

```git
adduser git 添加用户名字叫git
passwd git 给git用户添加密码
groupadd git 添加用户组名字叫git
usermod -G git git 将git用户添加到git用户组
```

##### 创建git仓库(中央服务器上)

```git
mkdir dirname >>> cd dirname
git init --bare 初始化一个仓库，--bare指定当前仓库为一个裸仓库（没有工作区）
chown -R git:git dirname -R将文件目录下的所有文件的所有者更改为git:git
```

##### 克隆远程仓库

```git
假设我刚刚将git仓库部署在了中央服务器上，我的阿里云IP:47.106.14.0
git clone git@47.106.14.0:dirname
```

##### 免密输入的配置

```git
通过rsa认证，生成公钥和私钥，将公钥放到git中央服务器上
ssh-keygen -t rsa 生成秘钥对，一路按回车，根据提示找到秘钥对的存放位置id_rsa.pub和id_rsa
```

### 5. git 原理

##### git的四个区域

```git
Workspace：工作区
Index/Stage：暂存区，用于临时存放改动，实际上只是一个文件，保存即将提交的文件列表信息
Repository：仓库区（版本库），HEAD指向最新放入仓库的版本
Remote：远程仓库，托管代码的中央服务器

git add filename 工作区->暂存区
git commit filename/-a -m "" 暂存区->仓库区
git push 本地仓库区->远程仓库
git pull 远程仓库->工作区
```

![](F:\BIT\github\-\mspaint\四个区域.png)

##### git的工作流程

```git
1. 在工作区目录中添加修改文件
2. 将需要进行版本管理的文件add到暂存区
3. 将暂存区中的文件commit到git仓库
4. 本地的修改push到远程仓库，如果失败则执行第五步
5. git pull将远程仓库的修改拉去到本地，如果有冲突则需要修改冲突，回到第三步
因此，git管理的文件有三种状态：已修改（modified），已暂存（staged），已提交（committed）
```

##### 文件四种状态

```
Untracked：未跟踪，此文件在工作区文件夹中但是并没有加入到git仓库，不参与版本控制，git add ==> Staged
Unmodified：已经入库且未修改，被修改 ==> Modified，git rm ==> Untacked
Modified：文件已经入库，在工作区被修改，git add ==> Staged，git checkout丢弃修改 ==> Unmodified
Staged：暂存状态，git commit将修改同步到库中 ==> Unmodified
```

![文件的四种状态](F:\BIT\github\-\mspaint\文件的四种状态.png)

### 6. commit 相关内容详解

##### 提交

```git
git commit filename filename... -m "commit message" 提交指定修改到本地仓库
git commit -a -m "commit message"
git commit ==> 弹出vim界面编辑提交信息保存 ==> 提交到本地仓库
git commit --amend 将此次提交追加到上次的commit内容里，作为一次提交
git log --stat
```

##### git push和冲突解决

```git
git push的时候如果有冲突，需要解决冲突
1. git pull 去拉取分支下来
2. 然后会在冲突文件中记录冲突的内容，手动解决冲突
3. git commit ==> git push
```

##### git commit分支合并

```git
1. git rebase -i + 需要合并的几个分支的前一个分支的哈希值
2. 弹出一个vim编辑框，squash代表的是合并到前一个分支，保存
3. 再次弹出一个vim编辑框，这时编辑的是合并后提交的 commit message
```

##### 修改commit内容

```git
1. 如果对于最近一次的commit，少提交了内容/少提交了文件/修改错了，修改后再次提交将会有两次commit记录
   因此可以采用 git commit --amend ，将本次修改(add后)提交到上一次的commit中，作为同一次提交
   此时若将本地提交到远程仓库，需要使用 git push --force，强制提交，否则git认为本地和远程是有冲突的（因为提交纪录不同）
2. 如果对于之前的commit，想要修改commit message信息
   git rebase -i + 哈希值（想要修改commit的前一次的commit哈希值） ==> 将pick改为reword保存 ==> 弹出界面修改commit message信息后保存
   git push --force 提价到远程仓库
3. 假若某次提交的时候，少添加了几行代码
   git rebase -i + 哈希值（想要修改commit的前一次的commit哈希值）==> 将pick改为edit保存 ==> git commit --amend 修改commit message信息 ==> git rabase --continue
```

##### 查看commit内容

```
git log
git log --oneline 只显示哈希值前8位 + commit message信息
git log --oneline -5 只显示最近提交的5条记录
git log --oneline -5 --skip=100 跳过前100条记录，显示5条
```


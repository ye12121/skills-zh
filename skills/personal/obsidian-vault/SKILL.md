---
name: obsidian-vault
description: 在 Obsidian 笔记库中搜索、创建和管理笔记，使用 wikilinks 与索引笔记。当用户希望在 Obsidian 中查找、创建或组织笔记时使用。 / Search, create, and manage notes in the Obsidian vault with wikilinks and index notes. Use when user wants to find, create, or organize notes in Obsidian.
---

# Obsidian 笔记库

## 笔记库位置

`/mnt/d/Obsidian Vault/AI Research/`

根目录基本上是扁平结构。

## 命名约定

- **索引笔记（Index notes）**：聚合相关主题（例如 `Ralph Wiggum Index.md`、`Skills Index.md`、`RAG Index.md`）
- 所有笔记名采用**Title Case（首字母大写）**
- 不使用文件夹来组织——改用链接和索引笔记

## 链接

- 使用 Obsidian `[[wikilinks]]` 语法：`[[Note Title]]`
- 在笔记底部链接依赖/相关笔记
- 索引笔记本身就是 `[[wikilinks]]` 的列表

## 工作流程

### 搜索笔记

```bash
# Search by filename
find "/mnt/d/Obsidian Vault/AI Research/" -name "*.md" | grep -i "keyword"

# Search by content
grep -rl "keyword" "/mnt/d/Obsidian Vault/AI Research/" --include="*.md"
```

或直接在笔记库路径上使用 Grep/Glob 工具。

### 创建新笔记

1. 使用 **Title Case** 命名文件
2. 将内容写成一个学习单元（遵循笔记库规则）
3. 在底部添加指向相关笔记的 `[[wikilinks]]`
4. 如果属于带编号的序列，使用层级编号方案

### 查找相关笔记

在笔记库中搜索 `[[Note Title]]` 以查找反向链接：

```bash
grep -rl "\\[\\[Note Title\\]\\]" "/mnt/d/Obsidian Vault/AI Research/"
```

### 查找索引笔记

```bash
find "/mnt/d/Obsidian Vault/AI Research/" -name "*Index*"
```

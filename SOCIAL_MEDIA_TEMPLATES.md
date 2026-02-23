# Social Media Promotion Templates

## Twitter/X Posts

### Launch Announcement
```
🚀 Introducing Dev Phase Manager for @ClaudeCode!

✅ Save/restore workflow state across /clear
✅ Manage multiple phases with suspend/resume
✅ Auto-detect progress from git history
✅ Seamless superpowers integration

Never lose context again! 🎯

🔗 https://github.com/uukuguy/dev-phase-manager

#ClaudeCode #AI #DevTools #Productivity
```

### Feature Highlight 1
```
💡 Problem: Claude Code context fills up, you need to /clear, but lose all your work state.

✨ Solution: Dev Phase Manager's checkpoint system!

/checkpoint-plan → /clear → /resume-plan

Resume exactly where you left off. Magic! ✨

https://github.com/uukuguy/dev-phase-manager
```

### Feature Highlight 2
```
🔄 Working on Feature A when urgent bug appears?

With Dev Phase Manager:
1. /start-phase "Bugfix" → suspends Feature A
2. Fix the bug
3. /end-phase
4. /start-phase --resume featurea → back to Feature A!

Phase stack management FTW! 🎯

https://github.com/uukuguy/dev-phase-manager
```

### Integration Highlight
```
🤝 Dev Phase Manager + Superpowers = Perfect workflow!

/brainstorming
/writing-plans
/checkpoint-plan ← Save state
/clear ← Free up context
/resume-plan ← Restore state
/subagent-driven-development

Seamless integration, zero friction! 🚀

https://github.com/uukuguy/dev-phase-manager
```

---

## Reddit Posts

### r/ClaudeAI
```
Title: [Tool] Dev Phase Manager - Never lose your Claude Code workflow again

I built a plugin that solves a problem I kept running into: losing my work state when I need to /clear in Claude Code.

**The Problem:**
- Claude Code has context limits
- When you /clear, you lose your plan execution state
- Managing multi-phase projects is difficult
- Switching between tasks breaks your flow

**The Solution:**
Dev Phase Manager adds checkpoint and phase management:

1. **Checkpoint System**: Save your plan state before clearing
   ```
   /checkpoint-plan
   /clear
   /resume-plan  # Resume exactly where you left off
   ```

2. **Phase Stack**: Manage multiple phases with suspend/resume
   ```
   /start-phase "Feature A"
   # ... urgent bug appears ...
   /start-phase "Bugfix"  # Suspends Feature A
   # ... fix bug ...
   /end-phase
   /start-phase --resume featurea  # Back to Feature A
   ```

3. **Smart Recovery**: Auto-detects completed tasks from git history

4. **Superpowers Integration**: Works seamlessly with brainstorming/writing-plans/subagent-driven-development

**Key Features:**
- Non-invasive design (file-based state transfer)
- Idempotency checks (prevents duplicate operations)
- Graceful degradation (works even when files missing)
- MCP integration (claude-mem, memory)

**Installation:**
```bash
claude-code plugin install https://github.com/uukuguy/dev-phase-manager
```

It's open source (MIT License) and I'd love to hear your feedback!

GitHub: https://github.com/uukuguy/dev-phase-manager
Docs: https://github.com/uukuguy/dev-phase-manager/blob/main/docs/QUICK_START.md
```

### r/programming
```
Title: Built a workflow management system for Claude Code - checkpoint and phase management

I've been using Claude Code for development and kept running into the same issue: context limits forcing me to /clear and lose my work state.

So I built Dev Phase Manager - a plugin that adds checkpoint and phase management to Claude Code.

**Core Concepts:**

1. **Checkpoints**: Save/restore plan execution state
   - Saves to `.checkpoint.json` before /clear
   - Restores complete context after /clear
   - Auto-detects progress from git history

2. **Phase Stack**: Multi-phase parallel work
   - Suspend current phase to handle urgent tasks
   - Resume suspended phases with full context
   - Stack-based management (like git stash)

3. **Non-Invasive Integration**:
   - File-based state transfer (no modifications to other plugins)
   - Direct skill invocation (no namespace prefix)
   - Works alongside superpowers plugin

**Technical Highlights:**
- Pure markdown-based plugin (no runtime dependencies)
- JSON state files for persistence
- Git history parsing for progress detection
- MCP server integration (optional)

**Architecture Decision:**
I chose file-based state transfer over in-memory state to ensure:
- Clean separation from other plugins
- Persistence across sessions
- Easy debugging (human-readable JSON)
- No coupling with plugin internals

**Use Case Example:**
```bash
# Day 1: Start feature, work for hours
/start-phase "User Auth"
/brainstorming
/writing-plans
/checkpoint-plan
/clear

# Day 2: Resume seamlessly
/resume-plan
/subagent-driven-development
```

Open source (MIT): https://github.com/uukuguy/dev-phase-manager

Would love feedback on the architecture and design decisions!
```

---

## Hacker News

### Show HN Post
```
Title: Show HN: Dev Phase Manager – Context-aware workflow for Claude Code

Hi HN!

I built Dev Phase Manager, a plugin for Claude Code that adds checkpoint and phase management to handle context limits.

**The Problem:**
Claude Code (Anthropic's CLI tool) has context limits. When you need to /clear, you lose your work state - plan execution progress, current task, next steps, etc.

**The Solution:**
A checkpoint system that saves state before clearing and restores it after:

```bash
/checkpoint-plan  # Save state
/clear            # Free up context
/resume-plan      # Restore state
```

**Key Design Decisions:**

1. **File-based state transfer**: Uses JSON files instead of in-memory state
   - Pros: Persistence, debuggability, no coupling
   - Cons: Slightly slower (acceptable trade-off)

2. **Non-invasive integration**: Works alongside other plugins without modifications
   - Direct skill invocation (no namespace prefix)
   - File-based communication (no shared state)

3. **Git history parsing**: Auto-detects completed tasks
   - Parses commit messages for progress
   - Reduces manual checkpoint updates

4. **Phase stack management**: Suspend/resume multiple phases
   - Like git stash for workflows
   - Handles urgent interruptions gracefully

**Technical Stack:**
- Pure markdown (Claude Code plugin format)
- JSON for state persistence
- Git for progress detection
- Optional MCP server integration

**Challenges:**
- Parsing git history reliably (different commit message formats)
- Handling edge cases (missing files, corrupted state)
- Balancing automation vs. user control

**What I Learned:**
- File-based state is simpler than I expected
- Idempotency is crucial for user trust
- Good error messages > perfect code

GitHub: https://github.com/uukuguy/dev-phase-manager
Docs: https://github.com/uukuguy/dev-phase-manager/blob/main/docs/ARCHITECTURE.md

Happy to answer questions about the design and implementation!
```

---

## 知乎文章

### 标题
```
Claude Code 工作流增强：我是如何解决上下文丢失问题的
```

### 正文大纲
```
## 问题背景

使用 Claude Code 进行开发时，经常遇到一个问题：上下文限制。

当你在一个复杂项目中工作了几个小时，突然需要 /clear 清理上下文时，所有的工作状态都会丢失：
- 当前执行到哪个任务了？
- 下一步要做什么？
- 已经完成了哪些工作？

每次都要手动重建这些信息，非常低效。

## 解决方案

我开发了 Dev Phase Manager 插件，为 Claude Code 添加了检查点和阶段管理功能。

### 核心功能

**1. 检查点系统**

在 /clear 之前保存状态，之后恢复：

```bash
/checkpoint-plan  # 保存状态
/clear                               # 清理上下文
/resume-plan      # 恢复状态
```

**2. 阶段栈管理**

支持多阶段并行工作，可以暂停当前阶段去处理紧急任务：

```bash
/start-phase "功能 A"
# ... 工作中 ...

# 紧急 bug 出现
/start-phase "紧急修复"
# → 是否暂停功能 A？(y)
# ... 修复 bug ...
/end-phase

# 恢复功能 A
/start-phase --resume featurea
```

**3. 智能进度检测**

自动从 git 历史中解析已完成的任务，减少手动更新。

**4. Superpowers 集成**

与 superpowers 插件无缝集成：

```bash
/brainstorming                           # 讨论设计
/writing-plans                           # 编写计划
/checkpoint-plan       # 保存状态
/clear                                   # 清理上下文
/resume-plan           # 恢复状态
/subagent-driven-development             # 执行计划
```

## 技术实现

### 设计原则

**1. 非侵入式设计**

不修改其他插件，通过文件进行状态传递：
- 使用 JSON 文件保存状态
- 直接技能调用（无需命名空间前缀）
- 与其他插件完全解耦

**2. 幂等性保证**

防止重复操作：
- 检查当前状态
- 智能提示用户
- 优雅降级处理

**3. 用户友好**

清晰的提示和确认：
- 详细的操作说明
- 智能的下一步建议
- 完善的错误处理

### 技术栈

- 纯 Markdown 实现（Claude Code 插件格式）
- JSON 状态持久化
- Git 历史解析
- 可选的 MCP 服务器集成

### 核心数据结构

**检查点文件 (.checkpoint.json)**
```json
{
  "plan_file": "docs/plans/2026-02-22-feature.md",
  "current_task": 4,
  "total_tasks": 10,
  "completed_tasks": [1, 2, 3],
  "execution_mode": "subagent-driven-development",
  "timestamp": "2026-02-22T15:30:00Z"
}
```

**阶段栈文件 (.phase_stack.json)**
```json
{
  "active_phase": {
    "id": "phase2",
    "name": "紧急修复",
    "start_time": "2026-02-22T16:00:00Z"
  },
  "suspended_phases": [
    {
      "id": "phase1",
      "name": "功能 A",
      "progress": 60,
      "suspend_time": "2026-02-22T16:00:00Z"
    }
  ]
}
```

## 使用效果

### 实际案例

**场景 1：长期项目**

某个功能开发需要 3 天时间，每天工作结束前：
```bash
/checkpoint-plan
```

第二天开始工作时：
```bash
/resume-plan
```

无缝继续，节省了大量重建上下文的时间。

**场景 2：紧急中断**

正在开发功能 A（完成 60%），突然需要修复紧急 bug：
```bash
/start-phase "紧急修复"
# 自动暂停功能 A
# 修复完成后
/end-phase
/start-phase --resume featurea
# 立即恢复到 60% 的状态
```

**场景 3：上下文管理**

实现过程中上下文快满了：
```bash
/checkpoint-progress
/clear
/resume-plan
# 继续工作，状态完整保留
```

### 效率提升

- 节省时间：每次恢复节省 5-10 分钟
- 减少错误：不会忘记当前进度
- 提高专注：可以放心切换任务

## 开源与未来

### 项目信息

- **开源协议**：MIT License
- **GitHub**：https://github.com/uukuguy/dev-phase-manager
- **文档**：完整的使用指南和架构文档

### 安装使用

```bash
claude-code plugin install https://github.com/uukuguy/dev-phase-manager
```

### Roadmap

- v1.1: 进度可视化
- v1.2: 彩色终端输出
- v1.3: 阶段依赖管理
- v2.0: Web UI

### 欢迎贡献

欢迎提交 Issue 和 Pull Request！

## 总结

Dev Phase Manager 解决了 Claude Code 使用中的一个核心痛点：上下文管理。

通过检查点系统和阶段栈管理，让长期项目开发和多任务并行变得简单高效。

如果你也在使用 Claude Code，不妨试试这个插件，相信会对你的工作流有所帮助！

---

**项目地址**：https://github.com/uukuguy/dev-phase-manager

**欢迎 Star ⭐**
```

---

## LinkedIn Post

```
🚀 Excited to share my latest open-source project: Dev Phase Manager for Claude Code!

**The Challenge:**
When working with AI-powered development tools like Claude Code, context management becomes crucial. Clearing context to free up space means losing your workflow state - a frustrating experience many developers face.

**The Solution:**
I built Dev Phase Manager, a plugin that adds enterprise-grade workflow management to Claude Code:

✅ Checkpoint System - Save/restore state across context clears
✅ Phase Stack Management - Handle multiple phases with suspend/resume
✅ Smart Progress Detection - Auto-detect completed tasks from git
✅ Seamless Integration - Works with existing tools like Superpowers

**Key Technical Decisions:**
• File-based state transfer for clean separation
• Non-invasive design (no modifications to other plugins)
• Idempotency checks for reliability
• Comprehensive error handling

**Impact:**
• Saves 5-10 minutes per context restoration
• Reduces errors from lost state
• Enables multi-phase parallel work
• Improves developer productivity

**Open Source:**
Released under MIT License, welcoming contributions from the community.

🔗 GitHub: https://github.com/uukuguy/dev-phase-manager
📚 Docs: https://github.com/uukuguy/dev-phase-manager/blob/main/docs/QUICK_START.md

If you're working with AI development tools, I'd love to hear your thoughts!

#OpenSource #AI #DeveloperTools #Productivity #ClaudeCode #WorkflowManagement
```

---

## V2EX Post

```
标题: [分享创造] Dev Phase Manager - Claude Code 工作流增强插件

正文:

最近在用 Claude Code 开发时，经常遇到上下文限制的问题。/clear 之后工作状态全丢，每次都要手动重建，很烦。

于是写了个插件解决这个问题：Dev Phase Manager

**核心功能：**

1. 检查点系统
   - /clear 前保存状态
   - 之后一键恢复
   - 自动检测 git 进度

2. 阶段栈管理
   - 多阶段并行工作
   - 暂停/恢复任意阶段
   - 类似 git stash 的体验

3. 无缝集成
   - 与 superpowers 插件配合
   - 非侵入式设计
   - 直接技能调用

**技术栈：**
- 纯 Markdown 实现
- JSON 状态持久化
- Git 历史解析

**开源：**
MIT License，欢迎贡献

GitHub: https://github.com/uukuguy/dev-phase-manager

有在用 Claude Code 的朋友可以试试，欢迎反馈！
```

---

## 掘金文章

### 标题
```
Claude Code 工作流增强：打造专业的阶段管理系统
```

### 标签
```
Claude, AI工具, 开发效率, 工作流, 开源项目
```

### 正文
```
[使用 PITCH.md 的内容，添加更多技术细节和代码示例]

## 前言

作为一名开发者，我一直在寻找能提高开发效率的工具。最近在使用 Claude Code 时，发现了一个痛点：上下文管理。

本文将分享我如何通过开发 Dev Phase Manager 插件来解决这个问题。

[... 详细内容参考知乎文章大纲 ...]

## 技术亮点

### 1. 非侵入式架构

[代码示例和架构图]

### 2. 状态持久化

[JSON 数据结构和实现细节]

### 3. Git 集成

[Git 历史解析算法]

## 总结

[项目总结和展望]

---

**项目地址**：https://github.com/uukuguy/dev-phase-manager

如果觉得有用，欢迎 Star ⭐ 和贡献代码！
```

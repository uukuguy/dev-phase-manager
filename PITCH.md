# Dev Phase Manager

**Professional phase and checkpoint management for Claude Code**

---

## 🎯 One-Line Pitch

Never lose your Claude Code workflow progress again - save, clear, and resume seamlessly.

---

## 🚀 Quick Demo

```bash
# Start a phase
/dev-phase-manager:start-phase "Feature Implementation"

# Design and plan
/brainstorming
/writing-plans

# Context getting full? Save and clear!
/dev-phase-manager:checkpoint-plan
/clear

# Resume exactly where you left off
/dev-phase-manager:resume-plan
/subagent-driven-development

# Complete the phase
/dev-phase-manager:end-phase
```

---

## ✨ Why You Need This

### Problem
- Claude Code has context limits
- `/clear` loses your work state
- Managing multi-phase projects is difficult
- Switching between urgent tasks breaks flow

### Solution
- **Checkpoint System**: Save state before clearing
- **Phase Stack**: Suspend/resume multiple phases
- **Smart Recovery**: Auto-detect progress from git
- **Superpowers Integration**: Works seamlessly

---

## 📊 Key Benefits

| Before | After |
|--------|-------|
| ❌ Lose progress on /clear | ✅ Resume exactly where you left off |
| ❌ Manual context recreation | ✅ Automatic state restoration |
| ❌ Single-phase workflow | ✅ Multi-phase parallel work |
| ❌ Context switching overhead | ✅ Instant phase suspend/resume |

---

## 🎬 Use Cases

### 1. Long-Running Projects
```bash
# Day 1: Start feature
/dev-phase-manager:start-phase "User Authentication"
# ... work for hours ...
/dev-phase-manager:checkpoint-plan
/clear

# Day 2: Resume
/dev-phase-manager:resume-plan
# Continue seamlessly!
```

### 2. Urgent Interruptions
```bash
# Working on Feature A (60% done)
/dev-phase-manager:start-phase "Feature A"

# Urgent bug appears!
/dev-phase-manager:start-phase "Critical Bugfix"
# → Suspend Feature A? (y)
# ... fix bug ...
/dev-phase-manager:end-phase

# Resume Feature A
/dev-phase-manager:start-phase --resume featurea
```

### 3. Context Management
```bash
# Context getting full during implementation
/dev-phase-manager:checkpoint-progress
/clear
/dev-phase-manager:resume-plan
# Continue without losing state!
```

---

## 🏗️ Architecture Highlights

### Non-Invasive Design
- Works alongside superpowers without modifications
- File-based state transfer (clean separation)
- Namespace isolation (`dev-phase-manager:` prefix)

### Smart Features
- Auto-detect completed tasks from git history
- Idempotency checks prevent duplicate operations
- Graceful degradation when files missing
- MCP integration (claude-mem, memory)

### Production-Ready
- Comprehensive error handling
- Clear user prompts and confirmations
- Detailed documentation
- MIT License

---

## 📦 Installation

```bash
claude-code plugin install https://github.com/uukuguy/dev-phase-manager
```

---

## 📚 Documentation

- [Quick Start Guide](docs/QUICK_START.md) - 5-minute tutorial
- [Architecture](docs/ARCHITECTURE.md) - Technical deep-dive
- [Contributing](CONTRIBUTING.md) - Join the project

---

## 🌟 What Users Say

> "Finally! No more losing my work when I need to clear context."

> "The phase stack feature is a game-changer for managing multiple projects."

> "Seamless integration with superpowers - exactly what I needed."

---

## 🗺️ Roadmap

- [x] v1.0: Core checkpoint and phase management
- [ ] v1.1: Progress visualization
- [ ] v1.2: Colored terminal output
- [ ] v1.3: Phase dependency management
- [ ] v2.0: Web UI

---

## 🤝 Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/uukuguy/dev-phase-manager/issues)
- **Discussions**: [GitHub Discussions](https://github.com/uukuguy/dev-phase-manager/discussions)

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

**⭐ Star us on GitHub if you find this useful!**

https://github.com/uukuguy/dev-phase-manager
